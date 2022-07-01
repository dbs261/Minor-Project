`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2022 23:59:24
// Design Name: 
// Module Name: signed_mult_16
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


module signed_mult_16(
    input signed [15:0] A,
    input signed [15:0] B,
    output reg signed [15:0] C
    );
wire signed[31:0] C_wire;
//wire signed[15:0] C_wire;
//initial
//begin
//    C<=0;
//end

assign C_wire = A*B;
//bw_mul mul1(A,B,C_wire);  
//assign C = C_wire[23:8];

always@(A,B)
begin
    C = C_wire[23:8];
//    C <= C_wire;
end

endmodule
