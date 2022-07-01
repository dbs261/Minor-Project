`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2022 01:25:07
// Design Name: 
// Module Name: sigmoid
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sigmoid(
    input signed [15:0] x,
    output signed [15:0] Y
    );

wire signed[15:0] exp, denom;

assign exp = 16'h0100-x+(x**2)/2-(x**3)/6+(x**4)/24-(x**5)/120;
assign denom = 1+exp;
assign Y = 1/denom;

endmodule
