
// module sobel_tb;

//     initial begin
//         $fsdbDumpfile("waveform.fsdb");
//         $fsdbDumpvars();
//     end

//     localparam IMAGE_WIDTH  = 5;
//     localparam IMAGE_HEIGHT = 5;
//     localparam THRESHOLD_WIDTH = 11;
// //    localparam EXPECTED_OUTPUTS = 9; // (5-2)*(5-2)
//     localparam EXPECTED_OUTPUTS = (IMAGE_WIDTH-2)*(IMAGE_HEIGHT-2);

//     logic clk;
//     logic reset;

//     logic [7:0] pixel_in;
//     logic valid_in;
//     logic start_frame;

//     logic [THRESHOLD_WIDTH-1:0] threshold_value;

//     logic edge_out;
//     logic valid_edge;
//     logic frame_done;

//     logic [$clog2(IMAGE_WIDTH)-1:0]  debug_col;
//     logic [$clog2(IMAGE_HEIGHT)-1:0] debug_row;

//     integer input_count;
//     integer output_count;
//     integer edge_count;

//     sobel_top #(
//         .IMAGE_WIDTH(IMAGE_WIDTH),
//         .IMAGE_HEIGHT(IMAGE_HEIGHT),
//         .THRESHOLD_WIDTH(THRESHOLD_WIDTH)
//     ) dut (
//         .clk(clk),
//         .reset(reset),

//         .pixel_in(pixel_in),
//         .valid_in(valid_in),
//         .start_frame(start_frame),

//         .threshold_value(threshold_value),

//         .edge_out(edge_out),
//         .valid_edge(valid_edge),
//         .frame_done(frame_done),

//         .debug_col(debug_col),
//         .debug_row(debug_row)
//     );

//     //--------------------------------
//     // CLOCK
//     //--------------------------------
//     initial begin
//         clk = 1'b0;
//         forever #5 clk = ~clk;
//     end

//     //--------------------------------
//     // SEND ONE PIXEL
//     //--------------------------------
//     task send_pixel(input logic [7:0] pix);
//     begin
//         @(negedge clk);
//         pixel_in = pix;
//         valid_in = 1'b1;
//         input_count = input_count + 1;

//         @(posedge clk);

//         $display("INPUT #%0d: pixel=%0d time=%0t",
//                  input_count, pix, $time);
//     end
//     endtask

//     //--------------------------------
//     // OUTPUT MONITOR
//     //--------------------------------
//     always @(posedge clk) begin
//         if (!reset && valid_edge) begin
//             output_count = output_count + 1;

//             if (edge_out)
//                 edge_count = edge_count + 1;

//             $display("OUTPUT #%0d: edge_out=%0b row=%0d col=%0d time=%0t",
//                      output_count,
//                      edge_out,
//                      debug_row,
//                      debug_col,
//                      $time);
//         end
//     end

//     //--------------------------------
//     // DEBUG MONITOR
//     //--------------------------------
//     always @(posedge clk) begin
//         if (!reset) begin
//             $display("DBG time=%0t valid_in=%0b pixel=%0d row=%0d col=%0d valid_edge=%0b edge_out=%0b frame_done=%0b",
//                      $time,
//                      valid_in,
//                      pixel_in,
//                      debug_row,
//                      debug_col,
//                      valid_edge,
//                      edge_out,
//                      frame_done);
//         end
//     end

//     //--------------------------------
//     // MAIN TEST
//     //--------------------------------
//     initial begin
//         input_count  = 0;
//         output_count = 0;
//         edge_count   = 0;

//         reset = 1'b1;
//         pixel_in = 8'd0;
//         valid_in = 1'b0;
//         start_frame = 1'b0;

//         threshold_value = 11'd50;

//         $display("\n==============================");
//         $display("Starting Sobel Top Testbench");
//         $display("==============================");

//         repeat (10) @(posedge clk);
//         reset = 1'b0;

//         $display("Reset released at time %0t", $time);

//         repeat (3) @(posedge clk);

//         //--------------------------------
//         // START FRAME
//         //--------------------------------
//         @(negedge clk);
//         start_frame = 1'b1;

//         @(negedge clk);
//         start_frame = 1'b0;

//         $display("start_frame pulse sent at time %0t", $time);

//         //--------------------------------
//         // STREAM IMAGE
//         //--------------------------------
//         $display("\nStreaming %0d x %0d image...", IMAGE_WIDTH, IMAGE_HEIGHT);

//         // Image:
//         //
//         // 0 0 255 255 255
//         // 0 0 255 255 255
//         // 0 0 255 255 255
//         // 0 0 255 255 255
//         // 0 0 255 255 255
//         //
//         // This creates a strong vertical edge.

//         // Row 0
//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd255);

//         // Row 1
//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd255);

//         // Row 2
//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd255);

//         // Row 3
//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd255);

//         // Row 4
//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd255);

//         @(negedge clk);
//         valid_in = 1'b0;
//         pixel_in = 8'd0;

//         $display("Finished streaming image at time %0t", $time);

//         repeat (30) @(posedge clk);

//         //--------------------------------
//         // SUMMARY
//         //--------------------------------
//         $display("\n==============================");
//         $display("Simulation Summary");
//         $display("==============================");

//         $display("Total input pixels  = %0d", input_count);
//         $display("Total valid outputs = %0d", output_count);
//         $display("Total edge pixels   = %0d", edge_count);
//         $display("Expected outputs    = %0d", EXPECTED_OUTPUTS);

//         if (input_count == IMAGE_WIDTH * IMAGE_HEIGHT)
//             $display("PASS: Input count correct");
//         else
//             $display("FAIL: Input count incorrect");

//         if (output_count == EXPECTED_OUTPUTS)
//             $display("PASS: Output count correct");
//         else
//             $display("FAIL: Output count incorrect");

//         if (edge_count > 0)
//             $display("PASS: Edge detected");
//         else
//             $display("FAIL: No edge detected");

//         $finish;
//     end

// endmodule


// module sobel_tb;

//     initial begin
//         $fsdbDumpfile("waveform.fsdb");
//         $fsdbDumpvars();
//     end

//     localparam IMAGE_WIDTH  = 5;
//     localparam IMAGE_HEIGHT = 5;
//     localparam THRESHOLD_WIDTH = 11;
// //    localparam EXPECTED_OUTPUTS = 9; // (5-2)*(5-2)
//     localparam EXPECTED_OUTPUTS = (IMAGE_WIDTH-2)*(IMAGE_HEIGHT-2);

//     logic clk;
//     logic reset;

//     logic [7:0] pixel_in;
//     logic valid_in;
//     logic start_frame;

//     logic [THRESHOLD_WIDTH-1:0] threshold_value;

//     logic edge_out;
//     logic valid_edge;
//     logic frame_done;

//     logic [$clog2(IMAGE_WIDTH)-1:0]  debug_col;
//     logic [$clog2(IMAGE_HEIGHT)-1:0] debug_row;

//     integer input_count;
//     integer output_count;
//     integer edge_count;

//     sobel_top #(
//         .IMAGE_WIDTH(IMAGE_WIDTH),
//         .IMAGE_HEIGHT(IMAGE_HEIGHT),
//         .THRESHOLD_WIDTH(THRESHOLD_WIDTH)
//     ) dut (
//         .clk(clk),
//         .reset(reset),

//         .pixel_in(pixel_in),
//         .valid_in(valid_in),
//         .start_frame(start_frame),

//         .threshold_value(threshold_value),

//         .edge_out(edge_out),
//         .valid_edge(valid_edge),
//         .frame_done(frame_done),

//         .debug_col(debug_col),
//         .debug_row(debug_row)
//     );

//     bsg_nonsynth_clock_gen #(
//         .cycle_time_p(15000)
//     ) clk_gen (
//         .o(clk)
//     );

//     bsg_nonsynth_clk_watcher clk_watch (
//         .clk_i(clk)
//     );

//     initial begin 
//         reset = 1'b1;
//         pixel_in = 8'd0;
//         valid_in = 1'b0;
//         start_frame = 1'b0;
//         threshold_value = 11'd50;

//         input_count  = 0;
//         output_count = 0;
//         edge_count   = 0;

//         repeat (10) @(posedge clk);
//         reset = 1'b0;
//         repeat (3) @(posedge clk);
//         $display("Reset released at time %0t", $time);
//     end 

//     task send_pixel(input logic [7:0] pix);
//         begin
//             @(negedge clk);
//             pixel_in = pix;
//             valid_in = 1'b1;
//             input_count = input_count + 1;
//         end 
//     endtask

//     task stop_pixel;
//         begin
//             @(negedge clk);
//             valid_in = 1'b0;
//             pixel_in = 8'd0;
//         end
//     endtask

//         initial begin
//         @(negedge reset);

//         @(negedge clk);
//         start_frame = 1'b1;

//         send_pixel(8'd0);
//         start_frame = 1'b0;

//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd0);

//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd0);

//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd0);

//         send_pixel(8'd0);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd255);
//         send_pixel(8'd0);

//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd0);
//         send_pixel(8'd0);

//         stop_pixel();

//         $display("Finished sending image frame.");
//     end

//         always @(posedge clk) begin
//         if (valid_edge) begin
//             output_count = output_count + 1;

//             if (edge_out)
//                 edge_count = edge_count + 1;

//             $display("Edge output at (%0d,%0d) = %0d",
//                      debug_col, debug_row, edge_out);
//         end
//     end

//         initial begin
//         @(posedge frame_done);

//         repeat (20) @(posedge clk);

//         $display("Input pixels sent  = %0d", input_count);
//         $display("Valid edge outputs = %0d", output_count);
//         $display("Edges detected     = %0d", edge_count);

//         if (input_count != IMAGE_WIDTH * IMAGE_HEIGHT) begin
//             $display("FAIL: Expected %0d input pixels, got %0d",
//                      IMAGE_WIDTH * IMAGE_HEIGHT, input_count);
//             $finish;
//         end

//         if (output_count != EXPECTED_OUTPUTS) begin
//             $display("FAIL: Expected %0d valid edge outputs, got %0d",
//                      EXPECTED_OUTPUTS, output_count);
//             $finish;
//         end

//         $display("PASS: sobel_top testbench completed successfully.");
//         $finish;
//     end

// endmodule

module sobel_tb;

    initial begin
        $fsdbDumpfile("waveform.fsdb");
        $fsdbDumpvars();
    end

    localparam IMAGE_WIDTH  = 128;
    localparam IMAGE_HEIGHT = 128;
    localparam THRESHOLD_WIDTH = 11;
    localparam EXPECTED_OUTPUTS = (IMAGE_WIDTH-2)*(IMAGE_HEIGHT-2);

    logic clk;
    logic reset;

    logic [7:0] pixel_in;
    logic valid_in;
    logic start_frame;

    logic [THRESHOLD_WIDTH-1:0] threshold_value;

    logic edge_out;
    logic valid_edge;
    logic frame_done;

    logic [$clog2(IMAGE_WIDTH)-1:0]  debug_col;
    logic [$clog2(IMAGE_HEIGHT)-1:0] debug_row;

    integer infile;
    integer outfile;
    integer pixel_value;

    integer input_count;
    integer output_count;
    integer edge_count;

    sobel_top #(
        .IMAGE_WIDTH(IMAGE_WIDTH),
        .IMAGE_HEIGHT(IMAGE_HEIGHT),
        .THRESHOLD_WIDTH(THRESHOLD_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),

        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .start_frame(start_frame),

        .threshold_value(threshold_value),

        .edge_out(edge_out),
        .valid_edge(valid_edge),
        .frame_done(frame_done),

        .debug_col(debug_col),
        .debug_row(debug_row)
    );

    bsg_nonsynth_clock_gen #(
        .cycle_time_p(15000)
    ) clk_gen (
        .o(clk)
    );

    bsg_nonsynth_clk_watcher clk_watch (
        .clk_i(clk)
    );

    initial begin
        infile = $fopen("input_pixels.txt", "r");
        outfile = $fopen("edge_output.txt", "w");

        if (infile == 0) begin
            $display("ERROR: Could not open input_pixels.txt");
            $finish;
        end

        if (outfile == 0) begin
            $display("ERROR: Could not open edge_output.txt");
            $finish;
        end

        reset = 1'b1;
        pixel_in = 8'd0;
        valid_in = 1'b0;
        start_frame = 1'b0;
        threshold_value = 11'd80;

        input_count  = 0;
        output_count = 0;
        edge_count   = 0;

        repeat (10) @(posedge clk);
        reset = 1'b0;
        repeat (3) @(posedge clk);

        $display("Reset released at time %0t", $time);

        @(negedge clk);
        start_frame = 1'b1;

        for (input_count = 0; input_count < IMAGE_WIDTH * IMAGE_HEIGHT; input_count = input_count + 1) begin
            if ($fscanf(infile, "%d\n", pixel_value) != 1) begin
                $display("ERROR: Not enough pixels in input_pixels.txt");
                $finish;
            end

            pixel_in = pixel_value[7:0];
            valid_in = 1'b1;

            @(negedge clk);
            start_frame = 1'b0;
        end

        valid_in = 1'b0;
        pixel_in = 8'd0;

        $display("Finished sending image frame.");

        // @(posedge frame_done);

        repeat (400) @(posedge clk);

        $display("Input pixels sent  = %0d", input_count);
        $display("Valid edge outputs = %0d", output_count);
        $display("Edges detected     = %0d", edge_count);

        if (input_count != IMAGE_WIDTH * IMAGE_HEIGHT) begin
            $display("FAIL: Expected %0d input pixels, got %0d",
                     IMAGE_WIDTH * IMAGE_HEIGHT, input_count);
            $finish;
        end

        if (output_count != EXPECTED_OUTPUTS - 1) begin
            $display("FAIL: Expected %0d valid edge outputs, got %0d",
                     EXPECTED_OUTPUTS, output_count);
            $finish;
        end

        $display("PASS: sobel_top image-file testbench completed successfully.");

        $fclose(infile);
        $fclose(outfile);

        $finish;
    end
    logic valid_edge_d;
    logic edge_out_d;

    always @(posedge clk) begin
        valid_edge_d <= valid_edge;
        edge_out_d   <= edge_out;
    end

    always @(posedge clk) begin
        if (!reset && valid_edge_d) begin
            output_count = output_count + 1;

            if (edge_out_d) begin
                edge_count = edge_count + 1;
            end

            $fwrite(outfile, "%0d\n", edge_out_d);

            $display("Edge output at (%0d,%0d) = %0d",
                    debug_col, debug_row, edge_out_d);

            $display("grad=%0d edge=%0d at (%0d,%0d)", 
                    dut.gradient_magnitude, edge_out_d, debug_col, debug_row);
        end
    end

    always @(posedge clk) begin
        if (!reset && (valid_edge || dut.valid_grad || dut.valid_window)) begin
            $display("t=%0t valid_window=%0b valid_grad=%0b valid_edge=%0b edge_out=%0b grad=%0d col=%0d row=%0d",
                $time, dut.valid_window, dut.valid_grad, 
                valid_edge, edge_out,
                dut.gradient_magnitude, debug_col, debug_row);
        end
    end

endmodule



 // always @(posedge clk) begin
    //     if (!reset && valid_edge) begin
    //         output_count = output_count + 1;

    //         if (edge_out) begin
    //             edge_count = edge_count + 1;
    //         end

    //         $fwrite(outfile, "%0d\n", edge_out);

    //         $display("Edge output at (%0d,%0d) = %0d",
    //                  debug_col, debug_row, edge_out);

    //         $display("grad=%0d edge=%0d at (%0d,%0d)", 
    //       dut.gradient_magnitude, edge_out, debug_col, debug_row);
    //     end
    // end