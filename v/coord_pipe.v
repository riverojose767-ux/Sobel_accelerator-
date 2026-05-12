
// coord_pipe.sv
// ----------------------------------------------------------------------------
// Pipelines (col, row) coordinates so they arrive aligned with `valid_edge`.
//
// Why this exists:
//   line_buffer exposes debug_col/debug_row when it produces its 3x3 window.
//   The window then traverses:
//       sobel_gradient  (1 cycle)
//       threshold_unit  (1 cycle)
//   So edge_out / valid_edge lag the line_buffer's coordinates by 2 cycles.
//   This shim simply delays the coordinates by the matching latency so
//   downstream consumers (edge_density) see (col,row) that actually
//   correspond to the edge_out bit currently on the wire.
//
// Parameterized on PIPE_DEPTH so it tracks any future pipeline stage adds.
// ============================================================================
module coord_pipe #(
    parameter IMAGE_WIDTH  = 128,
    parameter IMAGE_HEIGHT = 128,
    parameter PIPE_DEPTH   = 2     // sobel_gradient + threshold_unit
)(
    input  logic                               clk,
    input  logic                               reset,
    input  logic [$clog2(IMAGE_WIDTH)-1:0]     col_in,
    input  logic [$clog2(IMAGE_HEIGHT)-1:0]    row_in,
    output logic [$clog2(IMAGE_WIDTH)-1:0]     col_out,
    output logic [$clog2(IMAGE_HEIGHT)-1:0]    row_out
);

    logic [$clog2(IMAGE_WIDTH)-1:0]  col_pipe [0:PIPE_DEPTH-1];
    logic [$clog2(IMAGE_HEIGHT)-1:0] row_pipe [0:PIPE_DEPTH-1];

    integer i;
    always_ff @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < PIPE_DEPTH; i++) begin
                col_pipe[i] <= '0;
                row_pipe[i] <= '0;
            end
        end else begin
            col_pipe[0] <= col_in;
            row_pipe[0] <= row_in;
            for (i = 1; i < PIPE_DEPTH; i++) begin
                col_pipe[i] <= col_pipe[i-1];
                row_pipe[i] <= row_pipe[i-1];
            end
        end
    end

    assign col_out = col_pipe[PIPE_DEPTH-1];
    assign row_out = row_pipe[PIPE_DEPTH-1];

endmodule

