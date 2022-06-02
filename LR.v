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

input CLK

    );
    

reg signed [15:0] y_cap[3:0];
reg signed [15:0] y[3:0];

reg signed[15:0] wt[3:0];
//wire signed[15:0] xyz;

reg signed[15:0] dp[15:0];
wire signed[15:0] P1, P2, P3, P0, P4, P5, P6, P7;
reg signed[15:0] common_p;

reg[3:0] i;//data point number
reg[3:0] num_features;//num_features size must be same as dp[i] size (3:0). Otherwise, in dp[(num_features)*i], it will be truncated
reg[2:0] num_dp;//Total no. of data points
//assign clk = CLK;

//blk_mem_gen_0 bram (
//  .clka(CLK),    // input wire clka
//  .wea(wea),      // input wire [0 : 0] wea write enable
//  .addra(addra),  // input wire [4 : 0] addra
//  .dina(dina),    // input wire [15 : 0] dina
//  .douta(douta)  // output wire [15 : 0] douta
//);
//assign xyz = dp[num_features*i];
initial
begin

y[0] <= 16'h0f00;//15           8.8
y[1] <= 16'h1200;//18
y[2] <= 16'h0f00;//15
y[3] <= 16'h1000;//16

{y_cap[0],y_cap[1],y_cap[2],y_cap[3]}<=0;

i<=3;//initialize i to the total number of data points
num_features<=4;
num_dp<=4;



//8.8
dp[0]<=16'h0200;//2         
dp[1]<=16'h0400;//4
dp[2]<=16'h0300;//3
dp[3]<=16'h0600;//6

dp[4]<=16'h0300;//3
dp[5]<=16'h0400;//4
dp[6]<=16'h0500;//5
dp[7]<=16'h0600;//6

dp[8]<=16'h0900;//9
dp[9]<=16'h0100;//1
dp[10]<=16'h0200;//2
dp[11]<=16'h0300;//3

dp[12]<=16'h0700;//7
dp[13]<=16'h0800;//8
dp[14]<=16'h0000;//0
dp[15]<=16'h0100;//1

//weights
wt[0]<=16'h0040;//0.25          8.8
wt[1]<=16'h0040;
wt[2]<=16'h0040;
wt[3]<=16'h0040;
end    

signed_mult_16 sm0(.CLK(CLK),.A(dp[(num_features)*i]  ),.B(wt[0]),.C(P0));
signed_mult_16 sm1(.CLK(CLK),.A(dp[(num_features)*i+1]),.B(wt[1]),.C(P1));
signed_mult_16 sm2(.CLK(CLK),.A(dp[(num_features)*i+2]),.B(wt[2]),.C(P2));
signed_mult_16 sm3(.CLK(CLK),.A(dp[(num_features)*i+3]),.B(wt[3]),.C(P3));

//signed_mult_16 sm0(.A(dp[(num_features)*i]  ),.B(wt[0]),.C(P0));
//signed_mult_16 sm1(.A(dp[(num_features)*i+1]),.B(wt[1]),.C(P1));
//signed_mult_16 sm2(.A(dp[(num_features)*i+2]),.B(wt[2]),.C(P2));
//signed_mult_16 sm3(.A(dp[(num_features)*i+3]),.B(wt[3]),.C(P3));

//mult_gen_0 m0 (
//  .CLK(CLK),  // input wire CLK
//  .A(dp[(num_features)*i]),      // input wire [15 : 0] A
//  .B(wt[0]),      // input wire [15 : 0] B
//  .P(P0)      // output wire [15 : 0] P
//);

//mult_gen_0 m1 (
//  .CLK(CLK),  // input wire CLK
//  .A(dp[(num_features)*i+1]),      // input wire [15 : 0] A
//  .B(wt[1]),      // input wire [15 : 0] B
//  .P(P1)      // output wire [15 : 0] P
//);

//mult_gen_0 m2 (
//  .CLK(CLK),  // input wire CLK
//  .A(dp[(num_features)*i+2]),      // input wire [15 : 0] A
//  .B(wt[2]),      // input wire [15 : 0] B
//  .P(P2)      // output wire [15 : 0] P
//);

//mult_gen_0 m3 (
//  .CLK(CLK),  // input wire CLK
//  .A(dp[(num_features)*i+3]),      // input wire [15 : 0] A
//  .B(wt[3]),      // input wire [15 : 0] B
//  .P(P3)      // output wire [15 : 0] P
//);

//assign y_out = P0 + P1 + P2 + P3;

always@(P1,P2,P3,P0)
begin
    y_cap[i]<=P1+P2+P3+P0;
//    common_p<=(y[i]-P1-P2-P3-P0)>>>7;//(y-y^)*learning_rate, 
end

always@(y_cap[i])
begin
    common_p<=(y[i]-y_cap[i])>>>7;//(y-y^)*learning_rate
end

signed_mult_16 sm4(.CLK(~CLK),.A(common_p),.B(dp[(num_features)*i]  ),.C(P4));
signed_mult_16 sm5(.CLK(~CLK),.A(common_p),.B(dp[(num_features)*i]+1),.C(P5));
signed_mult_16 sm6(.CLK(~CLK),.A(common_p),.B(dp[(num_features)*i]+2),.C(P6));
signed_mult_16 sm7(.CLK(~CLK),.A(common_p),.B(dp[(num_features)*i]+3),.C(P7));

//signed_mult_16 sm4(.A(common_p),.B(dp[(num_features)*i]  ),.C(P4));
//signed_mult_16 sm5(.A(common_p),.B(dp[(num_features)*i]+1),.C(P5));
//signed_mult_16 sm6(.A(common_p),.B(dp[(num_features)*i]+2),.C(P6));
//signed_mult_16 sm7(.A(common_p),.B(dp[(num_features)*i]+3),.C(P7));

//mult_gen_0 m4 (
//  .CLK(~CLK),  // input wire CLK
//  .A(common_p),      // input wire [15 : 0] A
//  .B(dp[(num_features)*i]),      // input wire [15 : 0] B
//  .P(P4)      // output wire [15 : 0] P
//);

//mult_gen_0 m5 (
//  .CLK(~CLK),  // input wire CLK
//  .A(common_p),      // input wire [15 : 0] A
//  .B(dp[(num_features)*i+1]),      // input wire [15 : 0] B
//  .P(P5)      // output wire [15 : 0] P
//);

//mult_gen_0 m6 (
//  .CLK(~CLK),  // input wire CLK
//  .A(common_p),      // input wire [15 : 0] A
//  .B(dp[(num_features)*i+2]),      // input wire [15 : 0] B
//  .P(P6)      // output wire [15 : 0] P
//);

//mult_gen_0 m7 (
//  .CLK(~CLK),  // input wire CLK
//  .A(common_p),      // input wire [15 : 0] A
//  .B(dp[(num_features)*i+3]),      // input wire [15 : 0] B
//  .P(P7)      // output wire [15 : 0] P
//);

always@(negedge CLK)
begin
    if(i==0)
    begin
        i = 3;
    end
    else
    begin
        i = i - 1;
    end
    
//    i = (~i)?3:i-1;
    
end


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
