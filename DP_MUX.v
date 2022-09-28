`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.09.2022 00:33:16
// Design Name: 
// Module Name: DP_MUX
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


module DP_MUX#(MAX_FEATURES = 8, NUM_MULTS = 4, QUART = MAX_FEATURES/NUM_MULTS)
(
    input[QUART-2:0] sel,
    input[16*MAX_FEATURES-1:0] temp,
    output[16*NUM_MULTS-1:0] out
);

assign out = (sel)?temp[63:0]:temp[127:64];

endmodule
