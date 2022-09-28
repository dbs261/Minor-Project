`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2022 00:08:11
// Design Name: 
// Module Name: signed_mult_16_tb
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


module signed_mult_16_tb();

reg signed [15:0] A,B;
wire signed [15:0] C;
//reg CLK;

//initial
//begin
//CLK = 0;
//forever
//    #1 CLK = ~CLK;
//end

//signed_mult_16 sm16(CLK,A,B,C);
signed_mult_16 sm16(A,B,C);


initial
begin

A = 16'h0000; B = 16'h0300;
#1 A = 16'h0400;
#2 A = -16'h0400;
#2 B = -16'h0200;
#2 A = 16'h0300;

#100 $finish;
end

endmodule
