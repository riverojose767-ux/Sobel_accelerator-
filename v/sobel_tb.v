// module sobel_tb;

//     initial begin
//         $fsdbDumpfile("waveform.fsdb");
//         $fsdbDumpvars();
//     end

//     localparam IMAGE_WIDTH  = 128;
//     localparam IMAGE_HEIGHT = 128;
//     localparam THRESHOLD_WIDTH = 11;
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

//     integer infile;
//     integer outfile;
//     integer pixel_value;

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
//         infile = $fopen("input_pixels.txt", "r");
//         outfile = $fopen("edge_output.txt", "w");

//         if (infile == 0) begin
//             $display("ERROR: Could not open input_pixels.txt");
//             $finish;
//         end

//         if (outfile == 0) begin
//             $display("ERROR: Could not open edge_output.txt");
//             $finish;
//         end

//         reset = 1'b1;
//         pixel_in = 8'd0;
//         valid_in = 1'b0;
//         start_frame = 1'b0;
//         threshold_value = 11'd130;

//         input_count  = 0;
//         output_count = 0;
//         edge_count   = 0;

//         repeat (10) @(posedge clk);
//         reset = 1'b0;
//         repeat (3) @(posedge clk);

//         $display("Reset released at time %0t", $time);

//         repeat (10)@(posedge clk);
//         start_frame = 1'b1;
//         valid_in = 1'b0;
//         pixel_in = 8'd0;

//         repeat (10) @(posedge clk);
//         start_frame = 1'b0;

//         for (input_count = 0; input_count < IMAGE_WIDTH * IMAGE_HEIGHT; input_count = input_count + 1) begin
//             if ($fscanf(infile, "%d\n", pixel_value) != 1) begin
//                 $display("ERROR: Not enough pixels in input_pixels.txt");
//                 $finish;
//             end

//             pixel_in = pixel_value[7:0];
//             valid_in = 1'b1;

//             @(posedge clk);
//             start_frame = 1'b0;
//         end

//         valid_in = 1'b0;
//         pixel_in = 8'd0;

//         $display("Finished sending image frame.");

//         // @(posedge frame_done);

//         repeat (1000) @(posedge clk);

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

//         $display("PASS: sobel_top image-file testbench completed successfully.");

//         $fclose(infile);
//         $fclose(outfile);

//         $finish;
//     end
//     logic valid_edge_d;
//     logic edge_out_d;

//     always @(posedge clk) begin
//         valid_edge_d <= valid_edge;
//         edge_out_d   <= edge_out;
//     end

//     always @(posedge clk) begin
//         if (!reset && valid_edge_d === 1'b1 && (edge_out_d === 1'b0 || edge_out_d === 1'b1)) begin
//             output_count = output_count + 1;

//             if (edge_out_d) begin
//                 edge_count = edge_count + 1;
//             end

//             $fwrite(outfile, "%0d\n", edge_out_d);
            

//             $display("Edge output at (%0d,%0d) = %0d",
//                     debug_col, debug_row, edge_out_d);

//             $display("grad=%0d edge=%0d at (%0d,%0d)", 
//                     dut.gradient_magnitude, edge_out_d, debug_col, debug_row);
//         end
//     end

//     always @(posedge clk) begin
//         if (!reset && (valid_edge || dut.valid_grad || dut.valid_window)) begin
//             $display("t=%0t valid_window=%0b valid_grad=%0b valid_edge=%0b edge_out=%0b grad=%0d col=%0d row=%0d",
//                 $time, dut.valid_window, dut.valid_grad, 
//                 valid_edge, edge_out,
//                 dut.gradient_magnitude, debug_col, debug_row);
//         end
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

    localparam LEFT_END   = IMAGE_WIDTH / 3;
    localparam CENTER_END = (IMAGE_WIDTH * 2) / 3;

    logic clk;
    logic reset;

    logic [7:0]              pixel_in;
    logic                    valid_in;
    logic                    start_frame;

    logic [THRESHOLD_WIDTH-1:0] threshold_value;
    logic                       mode;        // 0=fixed  1=adaptive

    logic edge_out;
    logic valid_edge;
    logic frame_done;

    logic [$clog2(IMAGE_WIDTH)-1:0]  debug_col;
    logic [$clog2(IMAGE_HEIGHT)-1:0] debug_row;

    // NEW — edge density outputs (not checked in this testbench, but visible in waveform)
    logic [15:0] left_count, center_count, right_count;
    logic [1:0]  nav_hint;
    logic        density_valid;
    logic [$clog2(IMAGE_WIDTH)-1:0] lr_boundary;
    logic [$clog2(IMAGE_WIDTH)-1:0] cr_boundary;

    

    integer infile;
    integer outfile;
    integer pixel_value;

    integer input_count;
    integer output_count;
    integer edge_count;

    // -------------------------------------------------------------------------
    // DUT
    // -------------------------------------------------------------------------

    sobel_top #(
        .IMAGE_WIDTH     (IMAGE_WIDTH),
        .IMAGE_HEIGHT    (IMAGE_HEIGHT),
        .THRESHOLD_WIDTH (THRESHOLD_WIDTH)
    ) dut (
        .clk            (clk),
        .reset          (reset),

        .pixel_in       (pixel_in),
        .valid_in       (valid_in),
        .start_frame    (start_frame),

        .threshold_value(threshold_value),
        .mode           (mode),            // NEW — adaptive/fixed select

        .edge_out       (edge_out),
        .valid_edge     (valid_edge),
        .frame_done     (frame_done),

        .debug_col      (debug_col),
        .debug_row      (debug_row),

        // NEW — edge density outputs (not checked in this testbench, but visible in waveform)
        .lr_boundary  (lr_boundary),
        .cr_boundary  (cr_boundary),
        .left_count   (left_count),
        .center_count (center_count),
        .right_count  (right_count),
        .nav_hint     (nav_hint),
        .density_valid(density_valid)
    );

    // -------------------------------------------------------------------------
    // Clock and watcher
    // -------------------------------------------------------------------------

    bsg_nonsynth_clock_gen #(
        .cycle_time_p(15000)
    ) clk_gen (
        .o(clk)
    );

    bsg_nonsynth_clk_watcher clk_watch (
        .clk_i(clk)
    );

    // -------------------------------------------------------------------------
    // Stimulus
    // -------------------------------------------------------------------------

    initial begin
        infile  = $fopen("input_pixels.txt", "r");
        outfile = $fopen("edge_output.txt",  "w");

        if (infile == 0) begin
            $display("ERROR: Could not open input_pixels.txt");
            $finish;
        end

        if (outfile == 0) begin
            $display("ERROR: Could not open edge_output.txt");
            $finish;
        end

        // --- initialise inputs ---
        reset           = 1'b1;
        pixel_in        = 8'd0;
        valid_in        = 1'b0;
        start_frame     = 1'b0;
        threshold_value = 11'd130;   // used only when mode=0
        mode            = 1'b1;      // 1 = adaptive threshold
                                     // set to 0 to use fixed threshold_value

        lr_boundary = LEFT_END;
        cr_boundary = CENTER_END;

        input_count  = 0;
        output_count = 0;
        edge_count   = 0;

        $display("============================================================");
        $display("SOBEL EDGE DETECTION TESTBENCH START");
        $display("============================================================");
        $display("Image size                  = %0d x %0d", IMAGE_WIDTH, IMAGE_HEIGHT);
        $display("Total input pixels expected = %0d", IMAGE_WIDTH * IMAGE_HEIGHT);
        $display("Expected valid edge outputs = %0d", EXPECTED_OUTPUTS);
        $display("Mode                        = %s", mode ? "ADAPTIVE THRESHOLD" : "FIXED THRESHOLD");
        $display("Fixed threshold value       = %0d", threshold_value);
        $display("");
        $display("Density region boundaries:");
        $display("  LEFT   region: col < %0d", lr_boundary);
        $display("  CENTER region: %0d <= col < %0d", lr_boundary, cr_boundary);
        $display("  RIGHT  region: col >= %0d", cr_boundary);
        $display("");
        $display("Coordinate meaning:");
        $display("  debug_col/debug_row show the Sobel window coordinate.");
        $display("  coord_pipe delays coordinates so edge_density sees coordinates aligned with valid_edge.");
        $display("============================================================");


        // --- reset sequence ---
        repeat (10) @(posedge clk);
        reset = 1'b0;
        repeat (3)  @(posedge clk);

        // $display("Reset released at time %0t", $time);
        // $display("Mode: %s", mode ? "ADAPTIVE" : "FIXED");
        // $display("Density boundaries: left < %0d, center < %0d, right >= %0d",
        //          lr_boundary, cr_boundary, cr_boundary);

        // --- start frame pulse ---
        repeat (10) @(posedge clk);
        start_frame = 1'b1;
        valid_in    = 1'b0;
        pixel_in    = 8'd0;

        repeat (10) @(posedge clk);
        start_frame = 1'b0;

        // --- stream pixels ---
        for (input_count = 0;
             input_count < IMAGE_WIDTH * IMAGE_HEIGHT;
             input_count = input_count + 1)
        begin
            if ($fscanf(infile, "%d\n", pixel_value) != 1) begin
                $display("ERROR: Not enough pixels in input_pixels.txt");
                $finish;
            end

            pixel_in = pixel_value[7:0];
            valid_in = 1'b1;

            @(posedge clk);
            start_frame = 1'b0;
        end

        valid_in = 1'b0;
        pixel_in = 8'd0;

        $display("Finished sending image frame.");

        repeat (1000) @(posedge clk);

        // $display("Input pixels sent  = %0d", input_count);
        // $display("Valid edge outputs = %0d", output_count);
        // $display("Edges detected     = %0d", edge_count);

        $display("============================================================");
        $display("SOBEL EDGE DETECTION TESTBENCH SUMMARY");
        $display("============================================================");
        $display("Image size                  = %0d x %0d", IMAGE_WIDTH, IMAGE_HEIGHT);
        $display("Input pixels sent           = %0d", input_count);
        $display("Expected input pixels       = %0d", IMAGE_WIDTH * IMAGE_HEIGHT);
        $display("Expected valid edge outputs = %0d", EXPECTED_OUTPUTS);
        $display("Counted valid edge outputs  = %0d", output_count);
        $display("Edges detected              = %0d", edge_count);
        $display("Mode                        = %s", mode ? "ADAPTIVE THRESHOLD" : "FIXED THRESHOLD");
        $display("");
        $display("Final edge density counts:");
        $display("  LEFT   count = %0d", left_count);
        $display("  CENTER count = %0d", center_count);
        $display("  RIGHT  count = %0d", right_count);
        $display("  nav_hint     = %02b", nav_hint);
        $display("");
        $display("nav_hint meaning:");
        $display("  00 = center clearest, go straight");
        $display("  01 = left clearest, drift left");
        $display("  10 = right clearest, drift right");
        $display("  11 = cluttered, slow/stop");
        $display("============================================================");


        if (input_count != IMAGE_WIDTH * IMAGE_HEIGHT) begin
            $display("FAIL: Expected %0d input pixels, got %0d",
                     IMAGE_WIDTH * IMAGE_HEIGHT, input_count);
            $finish;
        end

        if (output_count != EXPECTED_OUTPUTS) begin
            $display("FAIL: Expected %0d valid edge outputs, got %0d",
                     EXPECTED_OUTPUTS, output_count);
            $finish;
        end

        // $display("PASS: sobel_top adaptive threshold testbench completed.");
        // $display("Mode: %s", mode ? "ADAPTIVE" : "FIXED");
        // $display("Density boundaries: left < %0d, center < %0d, right >= %0d", lr_boundary, cr_boundary, cr_boundary);
        $display("PASS: expected valid edge outputs = counted valid edge outputs.");
        $display("PASS: %0d = %0d", EXPECTED_OUTPUTS, output_count);
        $display("PASS: sobel_top adaptive threshold + edge density testbench completed.");


        $fclose(infile);
        $fclose(outfile);

        $finish;
    end

    // -------------------------------------------------------------------------
    // Output capture — one extra delay stage to align with registered outputs
    // -------------------------------------------------------------------------

    logic valid_edge_d;
    logic edge_out_d;

    always @(posedge clk) begin
        valid_edge_d <= valid_edge;
        edge_out_d   <= edge_out;
    end

    always @(posedge clk) begin
        if (!reset && valid_edge_d === 1'b1 &&
            (edge_out_d === 1'b0 || edge_out_d === 1'b1))
        begin
            output_count = output_count + 1;

            if (edge_out_d)
                edge_count = edge_count + 1;

            $fwrite(outfile, "%0d\n", edge_out_d);

            // $display("Edge output at (%0d,%0d) = %0d",
            //          debug_col, debug_row, edge_out_d);

            // $display("grad=%0d threshold=%0d edge=%0d at (%0d,%0d)",
            //          dut.gradient_magnitude,
            //          dut.tu.threshold_sel,   // shows which threshold was applied
            //          edge_out_d,
            //          debug_col, debug_row);
        end
    end

    // -------------------------------------------------------------------------
    // Pipeline visibility display
    // -------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!reset && (valid_edge || dut.valid_grad || dut.valid_window)) begin
            // $display("t=%0t valid_window=%0b valid_grad=%0b valid_edge=%0b edge_out=%0b grad=%0d adaptive_thresh=%0d col=%0d row=%0d",
            //     $time,
            //     dut.valid_window,
            //     dut.valid_grad,
            //     valid_edge,
            //     edge_out,
            //     dut.gradient_magnitude,
            //     dut.tu.adapt.threshold_out,  // live adaptive threshold value
            //     debug_col,
            //     debug_row);
        end
    end

    // always @(posedge clk) begin
    //     if (density_valid) begin
    //         $display("DENSITY: left=%0d center=%0d right=%0d nav_hint=%02b",
    //                 left_count, center_count, right_count, nav_hint);
    //     end
    // end

    always @(posedge clk) begin
        if (density_valid) begin
            $display("============================================================");
            $display("EDGE DENSITY ANALYSIS VALID");
            $display("============================================================");

            $display("Image partition summary:");
            $display("  LEFT region   : col < %0d", lr_boundary);
            $display("  CENTER region : %0d <= col < %0d",
                    lr_boundary, cr_boundary);
            $display("  RIGHT region  : col >= %0d", cr_boundary);

            $display("");

            $display("Accumulated edge counts:");
            $display("  LEFT   edges = %0d", left_count);
            $display("  CENTER edges = %0d", center_count);
            $display("  RIGHT  edges = %0d", right_count);

            $display("");

            $display("Navigation decision:");
            case (nav_hint)
                2'b00:
                    $display("  nav_hint = 00 -> CENTER clearest -> GO STRAIGHT");

                2'b01:
                    $display("  nav_hint = 01 -> LEFT clearest -> DRIFT LEFT");

                2'b10:
                    $display("  nav_hint = 10 -> RIGHT clearest -> DRIFT RIGHT");

                2'b11:
                    $display("  nav_hint = 11 -> SCENE CLUTTERED -> SLOW/STOP");

                default:
                    $display("  nav_hint = XX -> UNKNOWN");
            endcase

            $display("============================================================");
        end
    end

endmodule