// module threshold_unit #(
//     parameter THRESHOLD_WIDTH = 11
// ) (
//     input logic clk,
//     input logic reset, 
//     input logic [THRESHOLD_WIDTH-1:0] gradient_magnitude,
//     input logic valid_grad,
//     input logic [THRESHOLD_WIDTH-1:0] threshold_value,

//     output logic edge_out,
//     output logic valid_edge
// );


//     always_ff @(posedge clk) begin
//         if (reset) begin
//             edge_out   <= 0;
//             valid_edge <= 0;
//         end else begin
//             valid_edge <= valid_grad;
//             // compute edge_out combinationally so it aligns with valid_edge
//             edge_out <= (gradient_magnitude > threshold_value) ? 1'b1 : 1'b0;
//         end
//     end
// endmodule 

module threshold_unit #(
    parameter IMAGE_HEIGHT = 128,
    parameter IMAGE_WIDTH = 128,
    parameter THRESHOLD_WIDTH = 11
) (
    input logic clk,
    input logic reset, 
    input logic start_frame,
    input logic [7:0] pixel_in,
    input logic valid_in,
    input logic [THRESHOLD_WIDTH-1:0] gradient_magnitude,
    input logic [THRESHOLD_WIDTH-1:0] threshold_value,
    input logic valid_grad,
    input logic mode,

    output logic edge_out,
    output logic valid_edge
);

logic [7:0] adaptive_thresh;

adaptive_threshold #(
    .IMAGE_HEIGHT(IMAGE_HEIGHT),
    .IMAGE_WIDTH(IMAGE_WIDTH)
) adapt (
    .clk(clk),
    .reset(reset),
    .pixel_in(pixel_in),
    .start_frame(start_frame),
    .valid_in(valid_in),
    .threshold_out(adaptive_thresh)
);

//threshold selection 
// mode = 1: use adaptive threshold, mode = 0: use fixed threshold

logic [THRESHOLD_WIDTH-1:0] threshold_sel;

assign threshold_sel = mode ? {{(THRESHOLD_WIDTH-8){1'b0}}, adaptive_thresh} : threshold_value;
assign edge_out   = valid_grad ? (gradient_magnitude >= threshold_sel) : 1'b0;
assign valid_edge = valid_grad;


endmodule
    
