`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2022 12:35:54
// Design Name: 
// Module Name: CLA_32bit
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


module CLA_32bit(
    input [31:0] A,
    input [31:0] B,
    input c0,
    output Cout,
    output [31:0] Sum
    );
wire c1,c2,c3,c4,c5,c6,c7;  
CLA_4bit cla0(.A(A[3:0]),.B(B[3:0]),.Cin(c0),.Cout(c1),.Sum(Sum[3:0]));
CLA_4bit cla1(.A(A[7:4]),.B(B[7:4]),.Cin(c1),.Cout(c2),.Sum(Sum[7:4]));
CLA_4bit cla2(.A(A[11:8]),.B(B[11:8]),.Cin(c2),.Cout(c3),.Sum(Sum[11:8]));
CLA_4bit cla3(.A(A[15:12]),.B(B[15:12]),.Cin(c3),.Cout(c4),.Sum(Sum[15:12]));
CLA_4bit cla4(.A(A[19:16]),.B(B[19:16]),.Cin(c4),.Cout(c5),.Sum(Sum[19:16]));
CLA_4bit cla5(.A(A[23:20]),.B(B[23:20]),.Cin(c5),.Cout(c6),.Sum(Sum[23:20]));
CLA_4bit cla6(.A(A[27:24]),.B(B[27:24]),.Cin(c6),.Cout(c7),.Sum(Sum[27:24]));
CLA_4bit cla7(.A(A[31:28]),.B(B[31:28]),.Cin(c7),.Cout(Cout),.Sum(Sum[31:28]));

endmodule
