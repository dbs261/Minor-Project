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

reg signed [15:0] y_cap[3:0];
reg signed [15:0] y[3:0];
//reg[15:0] learning_rate;
reg signed[15:0] wt[3:0];
//wire signed[15:0] w_t[3:0];

reg signed[15:0] dp[15:0];
reg CLK,wea;
wire signed[15:0] P1, P2, P3, P0, P4, P5, P6, P7;
reg signed[15:0] common_p;
reg[1:0] i;
reg[1:0] num_features;
//assign weights[0] = wt[0];
//assign weights[1] = wt[1];
//assign weights[2] = wt[2];
//assign weights[3] = wt[3];

//reg signed[15:0] dina;
//reg[15:0] addra;
//wire signed[15:0] douta;

assign clk = CLK;
//assign w_t[0] = wt[0];
//assign w_t[1] = wt[1];
//assign w_t[2] = wt[2];
//assign w_t[3] = wt[3];

//assign clk = y;

//blk_mem_gen_0 bram (
//  .clka(CLK),    // input wire clka
//  .wea(wea),      // input wire [0 : 0] wea write enable
//  .addra(addra),  // input wire [4 : 0] addra
//  .dina(dina),    // input wire [15 : 0] dina
//  .douta(douta)  // output wire [15 : 0] douta
//);

initial
begin
y[0] <= 16'h3c00;//15
y[1] <= 16'h3c00;//15
y[2] <= 16'h3c00;//15
y[3] <= 16'h3c00;//15
//y[1] <= 16'h4800;//18
//y[2] <= 16'h3c00;//15
//y[3] <= 16'h4000;//16
{y_cap[0],y_cap[1],y_cap[2],y_cap[3]}<=0;
i<=0;
num_features<=3;
//learning_rate<=16'h0010; //0.015625

dp[0]<=16'h0800;//2
dp[1]<=16'h1000;//4
dp[2]<=16'h0c00;//3
dp[3]<=16'h1800;//6

dp[4]<=16'h0800;//2
dp[5]<=16'h1000;//4
dp[6]<=16'h0c00;//3
dp[7]<=16'h1800;//6

dp[8]<=16'h0800;//2
dp[9]<=16'h1000;//4
dp[10]<=16'h0c00;//3
dp[11]<=16'h1800;//6

dp[12]<=16'h0800;//2
dp[13]<=16'h1000;//4
dp[14]<=16'h0c00;//3
dp[15]<=16'h1800;//6

//dp[4]<=16'h0c00;//3
//dp[5]<=16'h1000;//4
//dp[6]<=16'h1400;//5
//dp[7]<=16'h4000;//6

//dp[8]<=16'h2400;//9
//dp[9]<=16'h0400;//1
//dp[10]<=16'h0800;//2
//dp[11]<=16'h0c00;//3

//dp[12]<=16'h1c00;//7
//dp[13]<=16'h2000;//8
//dp[14]<=16'h0000;//0
//dp[15]<=16'h0400;//1
    
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
  .A(dp[(num_features+1)*i]),      // input wire [15 : 0] A
  .B(wt[0]),      // input wire [15 : 0] B
  .P(P0)      // output wire [15 : 0] P
);

mult_gen_0 m1 (
  .CLK(CLK),  // input wire CLK
  .A(dp[(num_features+1)*i+1]),      // input wire [15 : 0] A
  .B(wt[1]),      // input wire [15 : 0] B
  .P(P1)      // output wire [15 : 0] P
);

mult_gen_0 m2 (
  .CLK(CLK),  // input wire CLK
  .A(dp[(num_features+1)*i+2]),      // input wire [15 : 0] A
  .B(wt[2]),      // input wire [15 : 0] B
  .P(P2)      // output wire [15 : 0] P
);

mult_gen_0 m3 (
  .CLK(CLK),  // input wire CLK
  .A(dp[(num_features+1)*i+3]),      // input wire [15 : 0] A
  .B(wt[3]),      // input wire [15 : 0] B
  .P(P3)      // output wire [15 : 0] P
);

//assign y_out = P0 + P1 + P2 + P3;

always@(P1,P2,P3,P0)
begin
    y_cap[i]<=P1+P2+P3+P0;
    common_p<=(y[i]-P1-P2-P3-P0)>>7;//(y-y^)*learning_rate, 
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
  .B(dp[(num_features+1)*i]),      // input wire [15 : 0] B
  .P(P4)      // output wire [15 : 0] P
);

mult_gen_0 m5 (
  .CLK(~CLK),  // input wire CLK
  .A(common_p),      // input wire [15 : 0] A
  .B(dp[(num_features+1)*i+1]),      // input wire [15 : 0] B
  .P(P5)      // output wire [15 : 0] P
);

mult_gen_0 m6 (
  .CLK(~CLK),  // input wire CLK
  .A(common_p),      // input wire [15 : 0] A
  .B(dp[(num_features+1)*i+2]),      // input wire [15 : 0] B
  .P(P6)      // output wire [15 : 0] P
);

mult_gen_0 m7 (
  .CLK(~CLK),  // input wire CLK
  .A(common_p),      // input wire [15 : 0] A
  .B(dp[(num_features+1)*i+3]),      // input wire [15 : 0] B
  .P(P7)      // output wire [15 : 0] P
);

always@(negedge clk)
begin
    i = i + 1;
end

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
