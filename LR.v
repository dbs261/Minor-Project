`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2022 22:15:34
// Design Name: 
// Module Name: LR
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


module LR(
//output[15:0] weights[3:0]
output clk
//input clk, input[7:0] A, B,
//output[7:0] P
    );
//wire[15:0] y_out;    

reg signed [15:0] y,y_cap;
reg[15:0] learning_rate;
reg signed[15:0] wt[3:0];
//wire signed[15:0] w_t[3:0];

reg signed[15:0] dp[3:0];
reg CLK;
wire signed[15:0] P1, P2, P3, P0, P4, P5, P6, P7;
reg signed[15:0] common_p;
//assign weights[0] = wt[0];
//assign weights[1] = wt[1];
//assign weights[2] = wt[2];
//assign weights[3] = wt[3];

assign clk = CLK;
//assign w_t[0] = wt[0];
//assign w_t[1] = wt[1];
//assign w_t[2] = wt[2];
//assign w_t[3] = wt[3];

//assign clk = y;

initial
begin
y <= 16'h3c00;
y_cap<=0;

learning_rate<=16'h0010; //0.015625

dp[0]<=16'h0800;//2
dp[1]<=16'h1000;//4
dp[2]<=16'h0c00;//3
dp[3]<=16'h1800;//6
    
wt[0]<=16'h0100;//0.25
wt[1]<=16'h0100;
wt[2]<=16'h0100;
wt[3]<=16'h0100;

//wt[0]<=16'h0400;
//wt[1]<=16'h0400;
//wt[2]<=16'h0400;
//wt[3]<=16'h0400;
end    

initial
begin
CLK = 0;
    forever
        #1 CLK = ~CLK;
end

mult_gen_0 m0 (
  .CLK(CLK),  // input wire CLK
  .A(dp[0]),      // input wire [15 : 0] A
  .B(wt[0]),      // input wire [15 : 0] B
  .P(P0)      // output wire [15 : 0] P
);

mult_gen_0 m1 (
  .CLK(CLK),  // input wire CLK
  .A(dp[1]),      // input wire [15 : 0] A
  .B(wt[1]),      // input wire [15 : 0] B
  .P(P1)      // output wire [15 : 0] P
);

mult_gen_0 m2 (
  .CLK(CLK),  // input wire CLK
  .A(dp[2]),      // input wire [15 : 0] A
  .B(wt[2]),      // input wire [15 : 0] B
  .P(P2)      // output wire [15 : 0] P
);

mult_gen_0 m3 (
  .CLK(CLK),  // input wire CLK
  .A(dp[3]),      // input wire [15 : 0] A
  .B(wt[3]),      // input wire [15 : 0] B
  .P(P3)      // output wire [15 : 0] P
);

//assign y_out = P0 + P1 + P2 + P3;

always@(P1,P2,P3,P0)
begin
    y_cap<=P1+P2+P3+P0;
    common_p<=(y-P1-P2-P3-P0)>>7;//(y-y^)*learning_rate, 
end

//mult_gen_0 m4 (
//  .CLK(~CLK),  // input wire CLK
//  .A(learning_rate),      // input wire [15 : 0] A
//  .B(y-y_cap),      // input wire [15 : 0] B
//  .P(common_p)      // output wire [15 : 0] P
//);

mult_gen_0 m4 (
  .CLK(~CLK),  // input wire CLK
  .A(common_p),      // input wire [15 : 0] A
  .B(dp[0]),      // input wire [15 : 0] B
  .P(P4)      // output wire [15 : 0] P
);

mult_gen_0 m5 (
  .CLK(~CLK),  // input wire CLK
  .A(common_p),      // input wire [15 : 0] A
  .B(dp[1]),      // input wire [15 : 0] B
  .P(P5)      // output wire [15 : 0] P
);

mult_gen_0 m6 (
  .CLK(~CLK),  // input wire CLK
  .A(common_p),      // input wire [15 : 0] A
  .B(dp[2]),      // input wire [15 : 0] B
  .P(P6)      // output wire [15 : 0] P
);

mult_gen_0 m7 (
  .CLK(~CLK),  // input wire CLK
  .A(common_p),      // input wire [15 : 0] A
  .B(dp[3]),      // input wire [15 : 0] B
  .P(P7)      // output wire [15 : 0] P
);

//always@(P4,P5,P6,P7)
//begin
//wt[0] <=w_t[0] + P4;
//wt[1] <=w_t[1] + P5;
//wt[2] <=w_t[2] + P6;
//wt[3] <=w_t[3] + P7;
//end

//acc a1(P4, wt[0]);
//acc a2(P5, wt[1]);
//acc a3(P6, wt[2]);
//acc a4(P7, wt[3]);

always@(P4)
begin
    wt[0] = wt[0] + P4;
end

always@(P5)
begin
    wt[1] = wt[1] + P5;
end

always@(P6)
begin
    wt[2] = wt[2] + P6;
end

always@(P7)
begin
    wt[3] = wt[3] + P7;
end

endmodule
