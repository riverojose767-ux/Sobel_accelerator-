// ============================================================================
// edge_density.v   (FINAL)
// ----------------------------------------------------------------------------
// Per-frame L/C/R edge-density accumulator for drone navigation summaries.
//
// Behavior:
//   * Three counters (left / center / right) accumulate `edge_out` bits
//     during a frame, partitioned by the pipelined column coordinate.
//   * Counters reset on `start_frame`.
//   * `frame_done` arrives when the last *input* pixel is consumed, but
//     several edge bits are still in flight (sobel_gradient + threshold_unit
//     latency). To capture them, we delay the latch by FRAME_DONE_DELAY
//     cycles so the accumulators integrate the full frame before snapshot.
//   * On the delayed frame_done, live counters are latched into output
//     registers and `density_valid` pulses for one cycle.
//   * A 2-bit `nav_hint` is produced combinationally from the latched
//     counts using comparators only (no divider, no DSP).
//   * Live accumulator values are also exposed (acc_*) for debug /
//     waveform inspection. They will be optimized out at synthesis time
//     if nothing downstream uses them.
//
// Region partitioning:
//   * Programmable via `lr_boundary` (left/center split) and
//     `cr_boundary` (center/right split).
//   * A pixel at column c falls in:
//         left   if c <  lr_boundary
//         center if lr_boundary <= c < cr_boundary
//         right  if c >= cr_boundary
//   * Out-of-window pixels are excluded because we gate on `valid_edge`
//     (true only for the 126x126 interior at 128x128).
//
// nav_hint encoding:
//   2'b00  CENTER clearest  -> go straight
//   2'b01  LEFT   clearest  -> drift left
//   2'b10  RIGHT  clearest  -> drift right
//   2'b11  CLUTTERED        -> all regions dense (stop / slow)
// ============================================================================
module edge_density #(
    parameter IMAGE_WIDTH       = 128,
    parameter IMAGE_HEIGHT      = 128,
    parameter COUNT_WIDTH       = 16,
    // Drain margin for in-flight edges after frame_done.
    // line_buffer is upstream of frame_done so 0 needed there;
    // sobel_gradient = 1, threshold_unit = 1, edge_density input reg = 1,
    // plus 1 cycle of safety = 4.
    parameter FRAME_DONE_DELAY  = 4,
    // CLUTTER_THRESHOLD: if all three region counts exceed this, the
    // frame is declared "cluttered". Default ~50% of a single region's
    // theoretical max; tune per scene at the testbench.
    parameter CLUTTER_THRESHOLD = 16'd2646
)(
    input  logic                            clk,
    input  logic                            reset,

    // pipeline taps
    input  logic                            start_frame,
    input  logic                            frame_done,
    input  logic                            edge_out,
    input  logic                            valid_edge,
    input  logic [$clog2(IMAGE_WIDTH)-1:0]  col_coord,

    // programmable region boundaries (column indices)
    input  logic [$clog2(IMAGE_WIDTH)-1:0]  lr_boundary,
    input  logic [$clog2(IMAGE_WIDTH)-1:0]  cr_boundary,

    // per-frame outputs (latched; valid for one cycle when density_valid=1,
    // held until next frame_done)
    output logic [COUNT_WIDTH-1:0]          left_count,
    output logic [COUNT_WIDTH-1:0]          center_count,
    output logic [COUNT_WIDTH-1:0]          right_count,
    output logic [1:0]                      nav_hint,
    output logic                            density_valid,

    // debug taps (live, in-flight accumulators; sample any time)
    output logic [COUNT_WIDTH-1:0]          acc_left,
    output logic [COUNT_WIDTH-1:0]          acc_center,
    output logic [COUNT_WIDTH-1:0]          acc_right
);

    // ------------------------------------------------------------------------
    // Live (in-flight) accumulators
    // ------------------------------------------------------------------------
    logic [COUNT_WIDTH-1:0] left_acc, center_acc, right_acc;

    assign acc_left   = left_acc;
    assign acc_center = center_acc;
    assign acc_right  = right_acc;

    // Region select for the current edge pixel. Comparators only, no DSP.
    logic in_left, in_center, in_right;
    always_comb begin
        in_left   = (col_coord <  lr_boundary);
        in_center = (col_coord >= lr_boundary) && (col_coord < cr_boundary);
        in_right  = (col_coord >= cr_boundary);
    end

    // Accumulation
    always_ff @(posedge clk) begin
        if (reset) begin
            left_acc   <= '0;
            center_acc <= '0;
            right_acc  <= '0;
        end else if (start_frame) begin
            left_acc   <= '0;
            center_acc <= '0;
            right_acc  <= '0;
        end else if (valid_edge && edge_out) begin
            // Exactly one of in_left/in_center/in_right is true.
            if (in_left)   left_acc   <= left_acc   + 1'b1;
            if (in_center) center_acc <= center_acc + 1'b1;
            if (in_right)  right_acc  <= right_acc  + 1'b1;
        end
    end

    // ------------------------------------------------------------------------
    // Delay frame_done so accumulators capture all in-flight edges
    // before the latch fires.
    // ------------------------------------------------------------------------
    logic [FRAME_DONE_DELAY-1:0] frame_done_pipe;
    always_ff @(posedge clk) begin
        if (reset) frame_done_pipe <= '0;
        else       frame_done_pipe <= {frame_done_pipe[FRAME_DONE_DELAY-2:0],
                                       frame_done};
    end
    wire frame_done_latched = frame_done_pipe[FRAME_DONE_DELAY-1];

    // ------------------------------------------------------------------------
    // Latch on delayed frame_done
    // ------------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (reset) begin
            left_count    <= '0;
            center_count  <= '0;
            right_count   <= '0;
            density_valid <= 1'b0;
        end else if (frame_done_latched) begin
            left_count    <= left_acc;
            center_count  <= center_acc;
            right_count   <= right_acc;
            density_valid <= 1'b1;
        end else begin
            density_valid <= 1'b0;
            // left_count / center_count / right_count hold last frame value
        end
    end

    // ------------------------------------------------------------------------
    // nav_hint — pure combinational compare logic on latched counts
    // ------------------------------------------------------------------------
    logic cluttered;
    logic left_min, center_min, right_min;

    always_comb begin
        cluttered = (left_count   > CLUTTER_THRESHOLD) &&
                    (center_count > CLUTTER_THRESHOLD) &&
                    (right_count  > CLUTTER_THRESHOLD);

        // "Clearest" = minimum edge count.
        // Tie-break: prefer center > left > right (go straight when possible).
        center_min = (center_count <= left_count) && (center_count <= right_count);
        left_min   = (left_count   <  center_count) && (left_count   <= right_count);
        right_min  = (right_count  <  center_count) && (right_count  <  left_count);

        if (cluttered)        nav_hint = 2'b11;
        else if (center_min)  nav_hint = 2'b00;
        else if (left_min)    nav_hint = 2'b01;
        else if (right_min)   nav_hint = 2'b10;
        else                  nav_hint = 2'b00;  // safe default
    end

endmodule

