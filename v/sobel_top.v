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
    input logic mode, // 0 for fixed threshold, 1 for adaptive threshold

    //new 
    input logic [$clog2(IMAGE_WIDTH)-1:0] lr_boundary,
    input logic [$clog2(IMAGE_WIDTH)-1:0] cr_boundary,


    //sobel output interface
    output logic edge_out,
    output logic valid_edge, 
    output logic frame_done,

    output logic [$clog2(IMAGE_WIDTH)-1:0] debug_col,
    output logic [$clog2(IMAGE_HEIGHT)-1:0] debug_row,


    //new 
    output logic [15:0]  left_count,
    output logic [15:0]  center_count,
    output logic [15:0]  right_count,
    output logic [1:0]   nav_hint,
    output logic         density_valid
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

    

    //new
    // pipelined coordinates aligned to valid_edge
    logic [$clog2(IMAGE_WIDTH)-1:0]  col_coord;
    logic [$clog2(IMAGE_HEIGHT)-1:0] row_coord;

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

    // threshold_unit #(.THRESHOLD_WIDTH(THRESHOLD_WIDTH)) tu (
    //     .clk(clk),
    //     .reset(reset),
    //     .gradient_magnitude(gradient_magnitude),
    //     .threshold_value(threshold_value),
    //     .valid_grad(valid_grad),
    //     .edge_out(edge_out),
    //     .valid_edge(valid_edge)
    // );
    threshold_unit #(
        .IMAGE_WIDTH     (IMAGE_WIDTH),
        .IMAGE_HEIGHT    (IMAGE_HEIGHT),
        .THRESHOLD_WIDTH (THRESHOLD_WIDTH)
    ) tu (
        .clk             (clk),
        .reset           (reset),
        .start_frame     (start_stream),
        .pixel_in        (pixel_stream),   // raw pixel for adaptive stats
        .valid_in        (valid_stream),   // gates adaptive statistics
        .gradient_magnitude(gradient_magnitude),
        .threshold_value (threshold_value),
        .mode            (mode),
        .valid_grad      (valid_grad),
        .edge_out        (edge_out),
        .valid_edge      (valid_edge)
    );

    coord_pipe #(
        .IMAGE_WIDTH (IMAGE_WIDTH),
        .IMAGE_HEIGHT(IMAGE_HEIGHT),
        .PIPE_DEPTH  (2)
    ) cp (
        .clk    (clk),
        .reset  (reset),
        .col_in (window_debug_col),
        .row_in (window_debug_row),
        .col_out(col_coord),
        .row_out(row_coord)
    );

    edge_density #(
        .IMAGE_WIDTH (IMAGE_WIDTH),
        .IMAGE_HEIGHT(IMAGE_HEIGHT)
    ) ed (
        .clk          (clk),
        .reset        (reset),
        .start_frame  (start_stream),
        .frame_done   (frame_done),
        .edge_out     (edge_out),
        .valid_edge   (valid_edge),
        .col_coord    (col_coord),
        .lr_boundary  (lr_boundary),
        .cr_boundary  (cr_boundary),
        .left_count   (left_count),
        .center_count (center_count),
        .right_count  (right_count),
        .nav_hint     (nav_hint),
        .density_valid(density_valid),
        .acc_left     (),
        .acc_center   (),
        .acc_right    ()
    );

endmodule
