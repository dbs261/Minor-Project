`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2022 14:39:17
// Design Name: 
// Module Name: Mult_4bit
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


module Mult_4bit(
    input [3:0] X,
    input [3:0] Y,
    output [7:0] Z
    );

wire X0Y0, X0Y1, X0Y2, X0Y3, X1Y0, X1Y1, X1Y2, X1Y3, X2Y0, X2Y1, X2Y2, X2Y3, X3Y0, X3Y1, X3Y2, X3Y3;    
wire c03, c10, c11, c12, c13, c20, c21, c22, c23, c30, c31, c32, c33;
wire z10, z11, z12, z13, z20, z21, z22, z23, z30, z31, z32, z33, z34; 
wire c4,c5,c6,c7;
wire z4,z5,z6,z7;

assign X0Y0 = X[0]&Y[0];
assign X0Y1 = X[0]&Y[1];
assign X0Y2 = X[0]&Y[2];
assign X0Y3 = ~(X[0]&Y[3]);
assign X1Y0 = X[1]&Y[0];
assign X1Y1 = X[1]&Y[1];
assign X1Y2 = X[1]&Y[2];
assign X1Y3 = ~(X[1]&Y[3]);
assign X2Y0 = X[2]&Y[0];
assign X2Y1 = X[2]&Y[1];
assign X2Y2 = X[2]&Y[2];
assign X2Y3 = ~(X[2]&Y[3]);
assign X3Y0 = ~(X[3]&Y[0]);
assign X3Y1 = ~(X[3]&Y[1]);
assign X3Y2 = ~(X[3]&Y[2]);
assign X3Y3 = X[3]&Y[3];


assign c03 = 1;
HA h10(X0Y1,X1Y0,c10,z10);
HA h11(X1Y1,X2Y0,c11,z11);
HA h12(X2Y1,X3Y0,c12,z12);
HA h13(X3Y1,c03,c13,z13);

FA f20(X0Y2,z11,c10,c20,z20);
FA f21(X1Y2,z12,c11,c21,z21);
FA f22(X2Y2,z13,c12,c22,z22);
HA h23(X3Y2,c13,c23,z23);

FA f30(X0Y3,z21,c20,c30,z30);
FA f31(X1Y3,z22,c21,c31,z31);
FA f32(X2Y3,z23,c22,c32,z32);
HA h33(X3Y3,c23,c33,z33);

assign z34 =1;
HA h4(z31,c30,c4,Z[4]);
FA f5(z32,c31,c4,c5,Z[5]);
FA f6(z33,c32,c5,c6,Z[6]);
FA f7(z34,c33,c6,c7,Z[7]);

assign Z[0] = X0Y0;
assign Z[1] = z10;
assign Z[2] = z20;
assign Z[3] = z30;

endmodule
