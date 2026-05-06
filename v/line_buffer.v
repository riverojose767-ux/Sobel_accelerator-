
module line_buffer #(
    parameter IMAGE_WIDTH  = 128,
    parameter IMAGE_HEIGHT = 128
)(
    input  logic clk,
    input  logic reset,
    input  logic [7:0] pixel_in,
    input  logic valid_in,
    input  logic start_frame,

    output logic [7:0] p1, p2, p3,
    output logic [7:0] p4, p5, p6,
    output logic [7:0] p7, p8, p9,

    output logic valid_window,
    output logic [$clog2(IMAGE_WIDTH)-1:0]  debug_col,
    output logic [$clog2(IMAGE_HEIGHT)-1:0] debug_row
);

    // Store the previous two rows
    logic [7:0] line1 [0:IMAGE_WIDTH-1];
    logic [7:0] line2 [0:IMAGE_WIDTH-1];

    // Column and row counters
    logic [$clog2(IMAGE_WIDTH)-1:0]  col_count;
    logic [$clog2(IMAGE_HEIGHT)-1:0] row_count;

    // Shift registers for the 3x3 window (your original names)
    logic [7:0] top_prev1, top_prev2;
    logic [7:0] middle_prev1, middle_prev2;
    logic [7:0] bottom_prev1, bottom_prev2;

    // registered captures of line buffer reads so the window
    // sees a stable value rather than a combinational read that chases
    // col_count as it increments in the same always_ff block.
    logic [7:0] top_current;
    logic [7:0] middle_current;
    logic [7:0] bottom_current;

    assign debug_col = col_count;
    assign debug_row = row_count;

    integer i;
    always_ff @(posedge clk) begin
        if (reset) begin
            col_count    <= 0;
            row_count    <= 0;
            valid_window <= 0;
            p1 <= 0; p2 <= 0; p3 <= 0;
            p4 <= 0; p5 <= 0; p6 <= 0;
            p7 <= 0; p8 <= 0; p9 <= 0;
            top_prev1    <= 0; top_prev2    <= 0;
            middle_prev1 <= 0; middle_prev2 <= 0;
            bottom_prev1 <= 0; bottom_prev2 <= 0;
            top_current    <= 0;
            middle_current <= 0;
            bottom_current <= 0;
            for (i = 0; i < IMAGE_WIDTH; i++) begin
                line1[i] <= 0;
                line2[i] <= 0;
            end

        end else if (start_frame) begin
            col_count    <= 0;
            row_count    <= 0;
            valid_window <= 0;
            top_prev1    <= 0; top_prev2    <= 0;
            middle_prev1 <= 0; middle_prev2 <= 0;
            bottom_prev1 <= 0; bottom_prev2 <= 0;
            top_current    <= 0;
            middle_current <= 0;
            bottom_current <= 0;

        end else if (valid_in) begin

            // ----------------------------------------------------------------
            // register the line buffer reads this cycle so the
            // window assignment next cycle sees stable, col_count-consistent
            // values — not a combinational read racing against col_count.
            // ----------------------------------------------------------------
            top_current    <= line1[col_count];
            middle_current <= line2[col_count];
            bottom_current <= pixel_in;

            // Assemble the 3x3 window from the registered values
            p1 <= top_prev2;    p2 <= top_prev1;    p3 <= top_current;
            p4 <= middle_prev2; p5 <= middle_prev1; p6 <= middle_current;
            p7 <= bottom_prev2; p8 <= bottom_prev1; p9 <= bottom_current;

            // Valid only once 2 full rows and 2 columns have been buffered
            if (row_count >= 2 && col_count >= 2)
                valid_window <= 1;
            else
                valid_window <= 0;

            // Shift the column history for next cycle
            top_prev2    <= top_prev1;
            top_prev1    <= top_current;
            middle_prev2 <= middle_prev1;
            middle_prev1 <= middle_current;
            bottom_prev2 <= bottom_prev1;
            bottom_prev1 <= bottom_current;

            // Update line buffers after reading them
            line1[col_count] <= line2[col_count];
            line2[col_count] <= pixel_in;

            // ----------------------------------------------------------------
            // do NOT clear shift registers at end of row.
            // The tail pixels of row N are the left-column neighbours for
            // the first valid windows of row N+1 — zeroing them corrupts
            // every row boundary in the output.
            // ----------------------------------------------------------------
            if (col_count == IMAGE_WIDTH - 1) begin
                col_count <= 0;
                row_count <= (row_count == IMAGE_HEIGHT - 1) ? 0 : row_count + 1;
            end else begin
                col_count <= col_count + 1;
            end

        end else begin
            valid_window <= 0;
        end
    end

endmodule