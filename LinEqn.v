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


module LinEqn(

input CLK

);
parameter s0 = 3'd0, s1 = 3'd1, s2 = 3'd3, s3 = 3'd2;//Gray code
parameter max_dp = 4,max_features = 4,dp_bits = 4;//Fixed
parameter dps = 4, features = 4;//variable, sent by py

reg[2:0] PS,NS;

reg signed [15:0] y_cap[max_features-1:0];
reg signed [15:0] y[max_features-1:0];

reg signed[15:0] wt[max_features-1:0];
reg signed[15:0] wt_temp[max_features-1:0];
wire signed[15:0] wt_wire[max_features-1:0];
//wire signed[15:0] xyz;

reg signed[15:0] ram[max_dp-1:0][max_features-1:0];
reg signed[15:0] feat[max_features-1:0];
reg signed[15:0] feat_temp[max_features-1:0];

wire signed[15:0] P1, P2, P3, P0, P4, P5, P6, P7;
reg signed[15:0] common_p;


reg[dp_bits-1:0] i;//data point number
//reg[max_features-1:0] num_features;//num_features size must be same as dp[i] size (3:0). Otherwise, in dp[(num_features)*i], it will be truncated
//reg[2:0] num_dp;//Total no. of data points

initial
begin

NS <= s0;

y[0] <= 16'h0f00;//15           8.8
y[1] <= 16'h1200;//18
y[2] <= 16'h0f00;//15
y[3] <= 16'h1000;//16

{y_cap[0],y_cap[1],y_cap[2],y_cap[3]}<=0;

i<=dps-1;//initialize i to the total number of data points
//num_dp<=4;

//num_features<=4;

//weights
wt[0]<=16'h0040;//0.25          8.8
wt[1]<=16'h0040;
wt[2]<=16'h0040;
wt[3]<=16'h0040;

//8.8
ram[0][0]<=16'h0200;//2         
ram[0][1]<=16'h0400;//4
ram[0][2]<=16'h0300;//3
ram[0][3]<=16'h0600;//6

ram[1][0]<=16'h0300;//3
ram[1][1]<=16'h0400;//4
ram[1][2]<=16'h0500;//5
ram[1][3]<=16'h0600;//6

ram[2][0]<=16'h0900;//9
ram[2][1]<=16'h0100;//1
ram[2][2]<=16'h0200;//2
ram[2][3]<=16'h0300;//3

ram[3][0]<=16'h0700;//7
ram[3][1]<=16'h0800;//8
ram[3][2]<=16'h0000;//0
ram[3][3]<=16'h0100;//1


end    


bw_mul sm0(.a(feat[0]),.b(wt_temp[0]),.p(P0));
bw_mul sm1(.a(feat[1]),.b(wt_temp[1]),.p(P1));
bw_mul sm2(.a(feat[2]),.b(wt_temp[2]),.p(P2));
bw_mul sm3(.a(feat[3]),.b(wt_temp[3]),.p(P3));

bw_mul sm4(.a(common_p),.b(feat_temp[0]),.p(P4));
bw_mul sm5(.a(common_p),.b(feat_temp[1]),.p(P5));
bw_mul sm6(.a(common_p),.b(feat_temp[2]),.p(P6));
bw_mul sm7(.a(common_p),.b(feat_temp[3]),.p(P7));

always@(CLK)
begin
    PS<=NS;
end

always@(PS)
begin
    case(PS)
        s0:NS<=s1;
        s1:NS<=s2;
        s2:NS<=s3;
        s3:NS<=s0;
        default:NS<=s0;
    endcase
end

always@(PS)
begin
    case(PS)
        s0:
        begin
            feat[0]<=ram[i][0];
            feat[1]<=ram[i][1];
            feat[2]<=ram[i][2];
            feat[3]<=ram[i][3];
            
            wt_temp[0]<=wt[0];
            wt_temp[1]<=wt[1];
            wt_temp[2]<=wt[2];
            wt_temp[3]<=wt[3];
        end
        
        s1:
        begin
            y_cap[i]<=P1+P2+P3+P0;
        end
        
        s2:
        begin
            common_p<=(y[i]-y_cap[i])>>>7;//(y-y^)*learning_rate
            feat_temp[0]<=feat[0];
            feat_temp[1]<=feat[1];
            feat_temp[2]<=feat[2];
            feat_temp[3]<=feat[3];
        end
        
        s3:
        begin
            if(i==0)
            begin
                i = dps-1;
            end
            else
            begin
                i = i - 1;
            end 

        end
    endcase
end

always@(PS)
begin
    case(PS)
        s3:
        begin
            wt[0] = wt[0] + P4;
        end        
    endcase
end

always@(PS)
begin
    case(PS)
        s3:
        begin
            wt[1] = wt[1] + P5;

        end        
    endcase
end

always@(PS)
begin
    case(PS)
        s3:
        begin
            wt[2] = wt[2] + P6;

        end        
    endcase
end

always@(PS)
begin
    case(PS)
        s3:
        begin
            wt[3] = wt[3] + P7;
        end        
    endcase
end


endmodule
