module sobel_top #(
    parameter IMAGE_WIDTH = 128,
    parameter IMAGE_HEIGHT = 128,
    parameter THRESHOLD_WIDTH = 11
)
(
    input logic clk,
    input logic reset,

    //pixel input interface
    input logic [7:0] pixel_in,
    input logic valid_in,
    input logic start_frame, 
    

    input logic [THRESHOLD_WIDTH-1:0] threshold_value,


    //sobel output interface
    output logic edge_out,
    output logic valid_edge, 
    output logic frame_done,

    output logic [$clog2(IMAGE_WIDTH)-1:0] debug_col,
    output logic [$clog2(IMAGE_HEIGHT)-1:0] debug_row
);

    logic [7:0] pixel_stream;
    logic valid_stream;
    logic start_stream;
    logic [7:0] p1, p2, p3, p4, p5, p6, p7, p8, p9;
    logic valid_window;
    logic [10:0] gradient_magnitude;
    logic valid_grad;

    logic [$clog2(IMAGE_WIDTH)-1:0]  input_debug_col;
    logic [$clog2(IMAGE_HEIGHT)-1:0] input_debug_row;

    logic [$clog2(IMAGE_WIDTH)-1:0]  window_debug_col;
    logic [$clog2(IMAGE_HEIGHT)-1:0] window_debug_row;

    assign debug_col = window_debug_col;
    assign debug_row = window_debug_row;


    line_buffer #(.IMAGE_WIDTH(IMAGE_WIDTH), .IMAGE_HEIGHT(IMAGE_HEIGHT)) lb (
        .clk(clk),
        .reset(reset),
        .pixel_in(pixel_stream),
        .valid_in(valid_stream),
        .start_frame(start_stream),
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .valid_window(valid_window),
        .debug_col(window_debug_col),
        .debug_row(window_debug_row)
    );

    image_input #(.IMAGE_WIDTH(IMAGE_WIDTH), .IMAGE_HEIGHT(IMAGE_HEIGHT)) img_in (
        .clk(clk),
        .reset(reset),
        .start(start_frame),
        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .pixel_out(pixel_stream),
        .valid_out(valid_stream),
        .start_frame(start_stream), 
        .done(frame_done),
        .debug_col(input_debug_col),
        .debug_row(input_debug_row)
    );
    sobel_gradient sg ( 
        .clk(clk),
        .reset(reset),
        .p1(p1), .p2(p2), .p3(p3),
        .p4(p4), .p5(p5), .p6(p6),
        .p7(p7), .p8(p8), .p9(p9),
        .valid_window(valid_window),
        .valid_grad(valid_grad),
        .gradient_magnitude(gradient_magnitude)
    );

    threshold_unit #(.THRESHOLD_WIDTH(THRESHOLD_WIDTH)) tu (
        .clk(clk),
        .reset(reset),
        .gradient_magnitude(gradient_magnitude),
        .threshold_value(threshold_value),
        .valid_grad(valid_grad),
        .edge_out(edge_out),
        .valid_edge(valid_edge)
    );

endmodule
