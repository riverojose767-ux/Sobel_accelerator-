module threshold_unit #(
    parameter THRESHOLD_WIDTH = 11
) (
    input logic clk,
    input logic reset, 
    input logic [THRESHOLD_WIDTH-1:0] gradient_magnitude,
    input logic valid_grad,
    input logic [THRESHOLD_WIDTH-1:0] threshold_value,

    output logic edge_out,
    output logic valid_edge
);


    always_ff @(posedge clk) begin
        if (reset) begin
            edge_out   <= 0;
            valid_edge <= 0;
        end else begin
            valid_edge <= valid_grad;
            // compute edge_out combinationally so it aligns with valid_edge
            edge_out <= (gradient_magnitude > threshold_value) ? 1'b1 : 1'b0;
        end
    end
endmodule 

    // always_ff@(posedge clk) begin 
    //     if (reset) begin
    //         edge_out <= 0;
    //         valid_edge <= 0;
    //     end else begin 
    //         valid_edge <= valid_grad; // Default to not valid
    //         if (valid_grad) begin
    //             if (gradient_magnitude > threshold_value) begin
    //                 edge_out <= 1;
    //             end else begin
    //                 edge_out <= 0;
    //             end
    //         end else begin
    //             edge_out <= 0; // Output zero when the input gradient is not valid
    //             //valid_edge <= 0; // Output is not valid when the input gradient is no
    //         end 
    //     end
    // end