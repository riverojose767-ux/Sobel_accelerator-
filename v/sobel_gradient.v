module sobel_gradient (
    input logic clk,
    input logic reset,
    input logic [7:0] p1, p2, p3,
    input logic [7:0] p4, p5, p6,
    input logic [7:0] p7, p8, p9,
    input logic valid_window,

    output logic valid_grad,
    output logic [10:0] gradient_magnitude
);
    logic signed [10:0] Gx;
    logic signed [10:0] Gy;
    logic [10:0] abs_Gx;
    logic [10:0] abs_Gy; 
    logic [12:0] sum; // To hold the sum of abs_Gx and abs_Gy

    always_comb begin
        // Calculate Gx and Gy using the Sobel operator
        Gx =($signed({1'b0,p3}) + ($signed({1'b0,p6}) <<< 1) + $signed({1'b0,p9}))
                - ($signed({1'b0,p1}) + ($signed({1'b0,p4}) <<< 1) + $signed({1'b0,p7}));

        Gy = ($signed({1'b0,p1}) + ($signed({1'b0,p2}) <<< 1) + $signed({1'b0,p3}))
                - ($signed({1'b0,p7}) + ($signed({1'b0,p8}) <<< 1) + $signed({1'b0,p9}));

        // Calculate absolute values
        if (Gx < 0) 
            abs_Gx = -Gx;
        else 
            abs_Gx = Gx;

        if (Gy < 0) 
            abs_Gy = -Gy;
        else 
            abs_Gy = Gy;

        // Calculate gradient magnitude using L1 norm
        sum = abs_Gx + abs_Gy;
    end
    always_ff @(posedge clk) begin
        if (reset) begin
            gradient_magnitude <= 0;
            valid_grad <= 0;
        end else begin
            valid_grad <= valid_window; // Default to not valid
            
            if (valid_window) begin
                if (sum > 13'd2047) // Cap the gradient magnitude to 255
                    gradient_magnitude <= 11'd2047; // Max value for 11 bits
                else
                    gradient_magnitude <= sum[10:0]; // Take the lower 11 bits of the sum
            end else begin
                gradient_magnitude <= 0; // Output zero when the window is not valid
                //valid_grad <= 0; // Output is not valid when the input window is not valid
            end
        end
    end
   
endmodule
