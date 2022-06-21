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
//https://stackoverflow.com/questions/17778418/what-is-and
//Possible multiple driver issue with B_val
module LR
#(
parameter MAX_DP = 6,MAX_FEATURES = 6, //Fixed
DPS = 6, DP_BITS = 4, FEATURES = 6, TOTAL_EPOCHS = 15//inputs externally or by python
)
(
input CLK,
input signed[(MAX_FEATURES+1)*16-1:0] temp, //temp variable for output data of RAM = dp + y
output fin
//wt, features, dps, total_epochs
);
integer c;
parameter s0 = 3'd0, s1 = 3'd1, s2 = 3'd3, s3 = 3'd2, idle = 3'd4;//Gray code
// make another state where the weights are updated to ram

//if dps > 16, change dp_bits also
reg[2:0] PS,NS;

reg[5:0] epochs;//max 128 epochs
reg we,en,rst;

reg signed [15:0] y_cap[MAX_DP-1:0];
reg signed [15:0] y[MAX_DP-1:0];

reg signed[15:0] wt[MAX_FEATURES:0];// max_features + 1 constant




wire signed[15:0] P[MAX_FEATURES-1:0];// Products of multiplier, num = max_features
reg signed[15:0] common_p;

reg signed[15:0] A_vals[MAX_FEATURES-1:0]; // temp var for feeding to multiplier
reg signed[15:0] B_vals[MAX_FEATURES-1:0];

reg[DP_BITS-1:0] i;//data point number

RAM2 r(.we(we),.oe(en),.RST(rst),.addr(i),.data(temp));

initial
begin
{we,rst}<=0;
en<=1;
NS <= idle;
epochs<=0;

//$readmemh("E:/Dhanush/Minor_project/Minor_project.srcs/sources_1/new/y_vals.txt",y);


for(c = 0;c<MAX_DP; c = c + 1)
begin
    y_cap[c]<=0;
end

i<=DPS-1;//initialize i to the total number of data points

for(c = 0;c<=MAX_FEATURES; c = c + 1)
begin
    wt[c]<=16'h0040;
end

//$readmemh("E:/Dhanush/Minor_project/Minor_project.srcs/sources_1/new/data_points.txt",ram);

//ram[0]<=64'h0600_0300_0400_0200;
//ram[1]<=64'h0600_0500_0400_0300;
//ram[2]<=64'h0300_0200_0100_0900;
//ram[3]<=64'h0100_0000_0800_0700;

end    


bw_mul sm0(.a(A_vals[0]),.b(B_vals[0]),.p(P[0]));
bw_mul sm1(.a(A_vals[1]),.b(B_vals[1]),.p(P[1]));
bw_mul sm2(.a(A_vals[2]),.b(B_vals[2]),.p(P[2]));
bw_mul sm3(.a(A_vals[3]),.b(B_vals[3]),.p(P[3]));
bw_mul sm4(.a(A_vals[4]),.b(B_vals[4]),.p(P[4]));
bw_mul sm5(.a(A_vals[5]),.b(B_vals[5]),.p(P[5]));

always@(CLK)
begin
    PS<=NS;
end

always@(PS)
begin
    case(PS)
        idle:NS<=(fin)?idle:s0;
        s0:NS<=s1;
        s1:NS<=s2;
        s2:NS<=s3;
        s3:NS<=(fin)?idle:s0;
        default:NS<=idle;
    endcase
end

assign fin = (epochs==TOTAL_EPOCHS)?1:0;

always@(PS)
begin
    case(PS)
        idle:
        begin
            
        end
        s0:
        begin
//            A_vals[0]<=ram[i][15:0];// 0,1,2,3 are the features
//            A_vals[1]<=ram[i][31:16];
//            A_vals[2]<=ram[i][47:32];
//            A_vals[3]<=ram[i][63:48];
            y[i]<=temp[15:0];
            //Do not change limit
            for(c = 1; c<=MAX_FEATURES;c=c+1)
            begin
                A_vals[c-1]<=temp[16*c+:16];
            end
            
//            B_vals[0]<=wt[0];
//            B_vals[1]<=wt[1];
//            B_vals[2]<=wt[2];
//            B_vals[3]<=wt[3];

            //Do not change limit
            for(c = 1;c<=MAX_FEATURES; c = c + 1)
            begin
                B_vals[c-1]<=wt[c];
            end
            
        end
        
        s1:
        begin
            y_cap[i]=wt[0]+P[1]+P[2]+P[3]+P[0]+P[4]+P[5];
//            y_cap[i]=P[1]+P[2]+P[3]+P[0];
//            common_p=(y[i]-y_cap[i])>>>7;//(y-y^)*learning_rate
            common_p=(y[i]-y_cap[i])>>>7;//(y-y^)*learning_rate


        end
        
        s2:
        begin
//            B_vals[0]<=common_p;
//            B_vals[1]<=common_p;
//            B_vals[2]<=common_p;
//            B_vals[3]<=common_p;

            //Do not change limit
            for(c = 0;c<MAX_FEATURES; c = c + 1)
            begin
                B_vals[c]<=common_p;
            end

        end
        
        s3:
        begin
            if(i==0)
            begin
                epochs<=epochs+1;
                i <= DPS-1;
            end
            else
            begin
                i <= i - 1;
            end 

        end
    endcase
end

always@(PS)
begin
    case(PS)
        s3:
        begin
//            wt[0] <= wt[0] + P[0];
//            wt[1] <= wt[1] + P[1];
//            wt[2] <= wt[2] + P[2];
//            wt[3] <= wt[3] + P[3];
            wt[0]<=wt[0]+common_p;
            //Do not change limit
            for(c=1;c<=MAX_FEATURES;c = c + 1)
            begin
                wt[c] <= wt[c] + P[c-1];
            end
            
        end        
    endcase
end

endmodule
// Fix wt[0] change