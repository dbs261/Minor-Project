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

module LR_alt(

input CLK

);
integer c;
parameter s0 = 3'd0, s1 = 3'd1, s2 = 3'd3, s3 = 3'd2, load = 3'd4;//Gray code
parameter max_dp = 6,max_features = 6;//Fixed
parameter dps = 6, dp_bits = 4, features = 6;//inputs externally or by python
//if dps > 16, change dp_bits also
reg[2:0] PS,NS;

reg we,en,rst;

reg signed [15:0] y_cap[max_features-1:0];
reg signed [15:0] y[max_features-1:0];

reg signed[15:0] wt[max_features-1:0];


//wire signed[15:0] xyz;

//reg signed[max_features*16-1:0] ram[max_dp-1:0];
wire signed[max_features*16-1:0] temp;
//reg signed[15:0] feat[max_features-1:0];


//wire signed[15:0] P1, P2, P3, P0;
wire signed[15:0] P[max_features-1:0];
reg signed[15:0] common_p;

reg signed[15:0] A_vals[max_features-1:0];
reg signed[15:0] B_vals[max_features-1:0];

reg[dp_bits-1:0] i;//data point number
//reg[max_features-1:0] num_features;//num_features size must be same as dp[i] size (3:0). Otherwise, in dp[(num_features)*i], it will be truncated
//reg[2:0] num_dp;//Total no. of data points

//reg [15:0] error [3:0];

initial
begin
{we,en,rst}<=0;
NS <= load;

//y[0] <= 16'h0f00;//15           8.8
//y[1] <= 16'h1200;//18
//y[2] <= 16'h0f00;//15
//y[3] <= 16'h1000;//16
//y[4] <= 16'h1b00;//27
//y[5] <= 16'h1180;//17.5

//y[0] <= 16'h0f00;//15           8.8
//y[1] <= 16'h1200;//18
//y[2] <= 16'h0f00;//15
//y[3] <= 16'h1000;//16
//y[4] <= 16'h1f00;//27
//y[5] <= 16'h1380;//17.5

$readmemh("E:/Dhanush/Minor_project/Minor_project.srcs/sources_1/new/y_vals.txt",y);

//{y_cap[0],y_cap[1],y_cap[2],y_cap[3],y_cap[4],y_cap[5]}<=0;
//{y_cap[0],y_cap[1],y_cap[2],y_cap[3]}<=0;

for(c = 0;c<max_dp; c = c + 1)
begin
    y_cap[c]<=0;
end

i<=dps-1;//initialize i to the total number of data points
//num_dp<=4;

//num_features<=4;

//weights
//wt[0]<=16'h0040;//0.25          8.8
//wt[1]<=16'h0040;
//wt[2]<=16'h0040;
//wt[3]<=16'h0040;

for(c = 0;c<max_features; c = c + 1)
begin
    wt[c]<=16'h0040;
end

//wt[4]<=16'h0040;
//wt[5]<=16'h0040;

//8.8
//ram[0][0]<=16'h0200;//2         
//ram[0][1]<=16'h0400;//4
//ram[0][2]<=16'h0300;//3
//ram[0][3]<=16'h0600;//6

//ram[1][0]<=16'h0300;//3
//ram[1][1]<=16'h0400;//4
//ram[1][2]<=16'h0500;//5
//ram[1][3]<=16'h0600;//6

//ram[2][0]<=16'h0900;//9
//ram[2][1]<=16'h0100;//1
//ram[2][2]<=16'h0200;//2
//ram[2][3]<=16'h0300;//3

//ram[3][0]<=16'h0700;//7
//ram[3][1]<=16'h0800;//8
//ram[3][2]<=16'h0000;//0
//ram[3][3]<=16'h0100;//1

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
//        load:NS<=s0;
        s0:NS<=s1;
        s1:NS<=s2;
        s2:NS<=s3;
        s3:NS<=s0;
        default:NS<=s0;
    endcase
end

RAM2 r(.clk(CLK),.we(we),.en(en),.RST(rst),.addr(i),.data(temp));

always@(PS)
begin
    case(PS)
//        load:
//        begin
//            temp<=ram[i];
//        end
        s0:
        begin
//            A_vals[0]<=ram[i][15:0];// 0,1,2,3 are the features
//            A_vals[1]<=ram[i][31:16];
//            A_vals[2]<=ram[i][47:32];
//            A_vals[3]<=ram[i][63:48];
            
            for(c = 0; c<max_features;c=c+1)
            begin
                A_vals[c]<=temp[16*c+:16];
            end
            
//            A_vals[4]<=ram[i][79:64];
//            A_vals[4]<=ram[i][95:80];
            
//            B_vals[0]<=wt[0];
//            B_vals[1]<=wt[1];
//            B_vals[2]<=wt[2];
//            B_vals[3]<=wt[3];
            
            for(c = 0;c<max_features; c = c + 1)
            begin
                B_vals[c]<=wt[c];
            end
            
//            B_vals[4]<=wt[4];
//            B_vals[5]<=wt[5];
        end
        
        s1:
        begin
            y_cap[i]=P[1]+P[2]+P[3]+P[0]+P[4]+P[5];
//            y_cap[i]=P[1]+P[2]+P[3]+P[0];
            common_p=(y[i]-y_cap[i])>>>7;//(y-y^)*learning_rate

//            common_p=(ram[i][16*features+:16]-y_cap[i])>>>7;//(y-y^)*learning_rate
//            y[i]<=ram[i][16*features+:16];
//            error[i] = y[i]-y_cap[i];
        end
        
        s2:
        begin
//            B_vals[0]<=common_p;
//            B_vals[1]<=common_p;
//            B_vals[2]<=common_p;
//            B_vals[3]<=common_p;
            for(c = 0;c<max_features; c = c + 1)
            begin
                B_vals[c]<=common_p;
            end
//            B_vals[4]<=common_p;
//            B_vals[5]<=common_p;
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
//            wt[0] <= wt[0] + P[0];
//            wt[1] <= wt[1] + P[1];
//            wt[2] <= wt[2] + P[2];
//            wt[3] <= wt[3] + P[3];
            
            for(c=0;c<max_features;c = c + 1)
            begin
                wt[c] <= wt[c] + P[c];
            end
            
        end        
    endcase
end

//always@(PS)
//begin
//    case(PS)
//        s3:
//        begin
//            wt[1] <= wt[1] + P[1];

//        end        
//    endcase
//end

//always@(PS)
//begin
//    case(PS)
//        s3:
//        begin
//            wt[2] <= wt[2] + P[2];

//        end        
//    endcase
//end

//always@(PS)
//begin
//    case(PS)
//        s3:
//        begin
//            wt[3] <= wt[3] + P[3];
//        end        
//    endcase
//end

//always@(PS)
//begin
//    case(PS)
//        s3:
//        begin
//            wt[4] = wt[4] + P[4];
//        end        
//    endcase
//end

//always@(PS)
//begin
//    case(PS)
//        s3:
//        begin
//            wt[5] = wt[5] + P[5];
//        end        
//    endcase
//end
endmodule
