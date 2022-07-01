`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.05.2022 02:46:08
// Design Name: 
// Module Name: acc
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


module acc(
    input [15:0] P,
    output reg[15:0] value
    );
//reg[15:0] val;
//assign value = val;

initial
begin
    value<=0;
end

always@(P)
begin
    value = value + P;
end
endmodule
