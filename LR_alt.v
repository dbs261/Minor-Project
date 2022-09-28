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

module LR
#(
    parameter MAX_DP = 6,MAX_FEATURES = 6, //Fixed
    DPS = 6, ADDR_WIDTH = 3, NUM_FEATURES = 6, TOTAL_EPOCHS = 30,//inputs externally or by python
    MAX_DATA_WIDTH = 16*(MAX_FEATURES+1)
)
(
    input CLK,
    inout signed[MAX_DATA_WIDTH-1:0] temp, //temp variable for output data of RAM = dp + y
    output fin_final,
    output reg[ADDR_WIDTH-1:0] addr,//data point number
    input enable
    //output reg we, en, rst
    // features, dps, total_epochs
);

    integer c;
    parameter s0 = 3'd0, s1 = 3'd1, s2 = 3'd3, s3 = 3'd2, idle = 3'd4, load_wt=3'd5;//Gray code
    // make another state where the weights are updated to ram
    wire fin;
    //if dps > 16, change ADDR_WIDTH also
    reg[2:0] PS,NS;

    reg[5:0] epochs;//max 128 epochs
    //reg rst;
    //reg en,we;

    reg signed [15:0] y_cap[MAX_DP-1:0];
    reg signed [15:0] y[MAX_DP-1:0];

    reg signed[15:0] wt[MAX_FEATURES:0];// max_features + 1 constant

    wire signed[15:0] P[MAX_FEATURES-1:0];// Products of multiplier, num = max_features
    reg signed[15:0] common_p;

    reg signed[15:0] A_vals[MAX_FEATURES-1:0]; // temp var for feeding to multiplier
    reg signed[15:0] B_vals[MAX_FEATURES-1:0];

    //RAM2 r(.we(we),.oe(en),.RST(rst),.addr(i),.data(temp));

    initial
    begin
        //{rst,we}<=0;
        //en<=1;
        NS <= idle;
        epochs<=0;

        //$readmemh("E:/Dhanush/Minor_project/Minor_project.srcs/sources_1/new/y_vals.txt",y);


        for(c = 0;c<MAX_DP; c = c + 1)
        begin
            y_cap[c]<=0;
        end

        addr<=0;//initialize addr to the total number of data points

        //for(c = 0;c<=MAX_FEATURES; c = c + 1)
        //begin
        //    wt[c]<=16'h0040;
        //end

        //$readmemh("E:/Dhanush/Minor_project/Minor_project.srcs/sources_1/new/data_points.txt",ram);

        //ram[0]<=64'h0600_0300_0400_0200;
        //ram[1]<=64'h0600_0500_0400_0300;
        //ram[2]<=64'h0300_0200_0100_0900;
        //ram[3]<=64'h0100_0000_0800_0700;

    end    
//one multiplier per feature
    genvar gen_i;
    generate
        for(gen_i=0;gen_i<MAX_FEATURES;gen_i = gen_i+1)
        begin
            bw_mul sm0(.a(A_vals[gen_i]),.b(B_vals[gen_i]),.p(P[gen_i]));            
        end
    endgenerate

    // bw_mul sm0(.a(A_vals[0]),.b(B_vals[0]),.p(P[0]));
    // bw_mul sm1(.a(A_vals[1]),.b(B_vals[1]),.p(P[1]));
    // bw_mul sm2(.a(A_vals[2]),.b(B_vals[2]),.p(P[2]));
    // bw_mul sm3(.a(A_vals[3]),.b(B_vals[3]),.p(P[3]));
    // bw_mul sm4(.a(A_vals[4]),.b(B_vals[4]),.p(P[4]));
    // bw_mul sm5(.a(A_vals[5]),.b(B_vals[5]),.p(P[5]));
    // bw_mul sm6(.a(A_vals[6]),.b(B_vals[6]),.p(P[6]));
    //bw_mul sm7(.a(A_vals[7]),.b(B_vals[7]),.p(P[7]));
    //bw_mul sm8(.a(A_vals[8]),.b(B_vals[8]),.p(P[8]));
    //bw_mul sm9(.a(A_vals[9]),.b(B_vals[9]),.p(P[9]));
    //bw_mul sm10(.a(A_vals[10]),.b(B_vals[10]),.p(P[10]));
    //bw_mul sm11(.a(A_vals[11]),.b(B_vals[11]),.p(P[11]));
    //bw_mul sm12(.a(A_vals[12]),.b(B_vals[12]),.p(P[12]));
    //bw_mul sm13(.a(A_vals[13]),.b(B_vals[13]),.p(P[13]));
    //bw_mul sm14(.a(A_vals[14]),.b(B_vals[14]),.p(P[14]));
    //bw_mul sm15(.a(A_vals[15]),.b(B_vals[15]),.p(P[15]));

    always@(CLK)
    begin
        if(enable==1)
        begin
            PS<=NS;
        end
    end
    //assign temp = 'hz;

    always@(PS)
    begin
        case(PS)
            idle:NS<=(fin)?idle:load_wt;
            load_wt:NS<=s0;
            s0:NS<=s1;
            s1:NS<=s2;
            s2:NS<=s3;
            s3:NS<=(fin)?idle:s0;
            default:NS<=idle;
        endcase
    end



    always@(PS)
    begin
        case(PS)
            idle:
            begin
    //            en<=(fin)?0:1;
    //            we<=(fin)?1:0;
    //              i<=(fin)?'hz:0;
                // assign temp to zz here as long as serial in is working.
                addr<=0;
            end
            
            load_wt:
            begin
                for(c = 0;c<=MAX_FEATURES; c = c + 1)
                begin
    //                wt[c]<=temp[16*c+:16];
                    wt[c]<=temp[(NUM_FEATURES+1)*16-16*(c+1)+:16];
                end
                addr<=addr+1;
            end
            s0:
            begin

                y[addr-1]<=temp[(NUM_FEATURES+1)*16-16+:16];

                //Do not change limit
                for(c = 1; c<=MAX_FEATURES;c=c+1)
                begin
    //                A_vals[c-1]<=temp[16*c+:16];
                    A_vals[c-1]<=temp[(NUM_FEATURES+1)*16-16*(c+1)+:16];
                end

                //Do not change limit
                for(c = 1;c<=MAX_FEATURES; c = c + 1)
                begin
                    B_vals[c-1]<=wt[c];
                end
                
            end
            
            s1:
            begin
                y_cap[addr-1] = wt[0];
                for(c = 0;c<MAX_DP;c = c + 1)
                begin
                    y_cap[addr-1] = y_cap[addr-1] + P[c];
                end
    //            y_cap[i-1]=wt[0]+P[1]+P[2]+P[3]+P[0]+P[4]+P[5];
    //            y_cap[i]=P[1]+P[2]+P[3]+P[0];
    //            common_p=(y[i]-y_cap[i])>>>7;//(y-y^)*learning_rate
                common_p=(y[addr-1]-y_cap[addr-1])>>>7;//(y-y^)*learning_rate


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
                if(addr==DPS)
                begin
                    epochs<=epochs+1;
                    addr <= 1;
                end
                else
                begin
                    addr <= addr + 1;
                end 

            end
        endcase
    end

    assign fin = (epochs==TOTAL_EPOCHS)?1:0;
    //assign fin = 0;
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
    assign fin_final = (fin & PS==idle)?1:0;
    assign temp = fin_final?{wt[0],wt[1],wt[2],wt[3],wt[4],wt[5],wt[6],wt[7]}:'hz;

    //assign temp = (fin & PS==idle)?0:'hz;
    //assign en = (fin & PS==idle)?0:1;
    //assign we = (fin & PS==idle)?1:0;
endmodule
// Fix wt[0] change