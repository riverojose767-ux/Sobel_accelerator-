`include "bsg_defines.v"

module adaptive_threshold #(
    parameter IMAGE_HEIGHT = 128,
    parameter IMAGE_WIDTH = 128
) (
    input logic clk,
    input logic reset, 
    input logic [7:0] pixel_in,
    input logic start_frame,
    input logic valid_in,

    output logic [7:0] threshold_out
);

    logic [$clog2(IMAGE_HEIGHT)-1:0] row;
    logic [$clog2(IMAGE_WIDTH)-1:0] col;

    logic [2:0] block_row;
    logic [2:0] block_col;
    
    assign block_row = row[2:0];
    assign block_col = col[2:0];

    wire block_start = (block_row == 0) && (block_col == 0) && valid_in;
    wire block_end = (block_row == 7) && (block_col == 7) && valid_in;

    logic [7:0] block_max;
    logic [7:0] block_min;
    logic [7:0] block_threshold;
    assign threshold_out = block_threshold;


    always_ff @(posedge clk) begin
        if (reset) begin
            col <= 0;
            row <= 0;
            block_max <= 0;
            block_min <= 8'hFF;
            block_threshold <= 0;
        end else if (start_frame) begin
            col <= 0;
            row <= 0;
            block_max <= 0;
            block_min <= 8'hFF;
        end else if (valid_in) begin 
            if (block_start) begin
                block_max <= pixel_in;
                block_min <= pixel_in;
            end else begin 
                if (pixel_in > block_max) block_max <= pixel_in;
                if (pixel_in < block_min) block_min <= pixel_in;
            end
            if (block_end) begin
                block_threshold <= (block_max + block_min + 1) >> 1; // simple average for threshold
            end
            if (col == IMAGE_WIDTH - 1) begin
                col <= 0;
                row <= (row == IMAGE_HEIGHT - 1) ? 0 : row + 1;
            end else begin
                col <= col + 1;
            end
        end 
        
    end
endmodule 
