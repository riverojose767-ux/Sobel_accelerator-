module image_input #(
    parameter IMAGE_WIDTH  = 128,
    parameter IMAGE_HEIGHT = 128
)(
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  logic [7:0] pixel_in,
    input  logic valid_in,

    output logic [7:0] pixel_out,
    output logic       valid_out,
    output logic       start_frame,
    output logic       done,

    output logic [$clog2(IMAGE_WIDTH)-1:0]  debug_col,
    output logic [$clog2(IMAGE_HEIGHT)-1:0] debug_row
);
    
    localparam int total_pixels = IMAGE_WIDTH * IMAGE_HEIGHT;
    localparam int count_width = $clog2(total_pixels + 1); // +1 to account for the zero-based count

    logic [count_width-1:0] pixel_count;
    logic processing;

    always_ff @(posedge clk) begin
        if (reset) begin
            pixel_count <= 0;
            pixel_out <= 0;
            processing <= 0;
            valid_out <= 0;
            start_frame <= 0;
            debug_col <= 0;
            debug_row <= 0; 
            done <= 0;
        end else begin 
            valid_out <= 0; // Default to not valid
            start_frame <= 0; // Default to not starting frame
            done <= 0; // Default to not done
            if (start) begin
                processing <= 1; // Start processing when start is asserted
                start_frame <= 1; // Signal the start of a new frame
                pixel_count <= 0; // Reset pixel count at the start of a new frame
                debug_col <= 0; // Reset debug column
                debug_row <= 0; // Reset debug row
            end 
            if (processing && valid_in) begin
                pixel_out <= pixel_in; // Output the current pixel
                valid_out <= 1; // Signal that the output pixel is valid
                if (pixel_count == total_pixels - 1) begin
                    done <= 1; // Signal done when the last pixel is processed
                    processing <= 0; // Stop processing after the last pixel
                    pixel_count <= 0; // Reset pixel count for the next frame
                    debug_col <= 0; // Reset debug column
                    debug_row <= 0; // Reset debug row
                end else begin
                    pixel_count <= pixel_count + 1; // Increment pixel count
                    if (debug_col == IMAGE_WIDTH - 1) begin
                        debug_col <= 0; // Reset column at the end of the row
                        debug_row <= debug_row + 1; // Move to the next row
                    end else begin
                        debug_col <= debug_col + 1; // Move to the next column
                    end
                end 
            end
        end
     end 
     
endmodule 
