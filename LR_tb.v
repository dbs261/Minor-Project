`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2022 23:22:32
// Design Name: 
// Module Name: LR_tb
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


module LR_tb();

//wire[15:0] xyzw[3:0];
//wire[15:0] xyz;
//LR ll(xyz);
wire CLK;
//reg[15:0] A, B;
//wire[15:0] P;

//initial
//begin
//CLK = 0;
//forever
//    #1 CLK = ~CLK;
//end

LR lr1(CLK);
//mult_gen_0 your_instance_name (
//  .CLK(CLK),  // input wire CLK
//  .A(A),      // input wire [15 : 0] A
//  .B(B),      // input wire [15 : 0] B
//  .P(P)      // output wire [15 : 0] P
//);

initial
begin

//A = 16'd0; B = 16'd3;
//#1 A = 16'd4;
//#2 A = -16'd4;
//#2 B = -16'd2;
//#2 A = 16'd3;



#20 $finish;
end

endmodule
