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
    parameter MAX_DP = 6,MAX_FEATURES = 8, //Fixed
    ADDR_WIDTH = 3,//inputs externally or by python
    MAX_DATA_WIDTH = 16*(MAX_FEATURES+1), NUM_MULT = MAX_FEATURES
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
    parameter INIT = 3'd6, MUL_YCAP = 3'd0, ER_CALC = 3'd1, MUL_WT = 3'd3, WT_UP = 3'd2, IDLE = 3'd4, LOAD_WT=3'd5;//Gray code
    // make another state where the weights are updated to ram
    wire fin;
    //if dps > 16, change ADDR_WIDTH also
    reg[2:0] PS,NS;
    reg[1:0] PS_MUL_YCAP, NS_MUL_YCAP;

    /*
        NOTE: Remember to change reg sizes while varying max value
    */
    reg[5:0] epochs, TOTAL_EPOCHS;//max 128 epochs
    reg[2:0] DPS;
    reg[2:0] NUM_FEATURES;
    //reg rst;
    //reg en,we;

    reg signed [15:0] y_cap[MAX_DP-1:0];
    reg signed [15:0] y[MAX_DP-1:0];

    reg signed[15:0] wt[MAX_FEATURES:0];// max_features + 1 constant

    wire signed[15:0] P[NUM_MULT-1:0];// Products of multiplier, num = max_features
    reg signed[15:0] common_p;

    reg signed[15:0] A_vals[NUM_MULT-1:0]; // temp var for feeding to multiplier
    reg signed[15:0] B_vals[NUM_MULT-1:0];


    initial
    begin
        //{rst,we}<=0;
        //en<=1;
        NS <= IDLE;
        epochs<=0;
        DPS<=6;
        TOTAL_EPOCHS<=30;
        NUM_FEATURES<=6;

        // for(c = 0;c<MAX_DP; c = c + 1)
        // begin
        //     y_cap[c]<=0;
        // end

        // addr<=0;//initialize addr to the total number of data points

    end    
//One multiplier per feature
    genvar gen_i;
    generate
        for(gen_i=0;gen_i<NUM_MULT;gen_i = gen_i+1)
        begin
            bw_mul sm0(.a(A_vals[gen_i]),.b(B_vals[gen_i]),.p(P[gen_i]));            
        end
    endgenerate

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
            IDLE: NS <= (fin)?IDLE:INIT;
            INIT: NS <= LOAD_WT;
            LOAD_WT: NS <= MUL_YCAP;
            MUL_YCAP: NS <= ER_CALC;
            ER_CALC:NS <= MUL_WT;
            MUL_WT:NS <= WT_UP;
            WT_UP: NS <= (fin)?IDLE:MUL_YCAP;
            default: NS <= IDLE;
        endcase
    end



    always@(PS)
    begin
        case(PS)
            IDLE:
            begin
    //            en<=(fin)?0:1;
    //            we<=(fin)?1:0;
    //              i<=(fin)?'hz:0;
                // assign temp to zz here as long as serial in is working.
                addr <= 0;
                // epochs <= 0;
            end

            INIT:
            begin
                //init wt to 0
                for(c=0;c<=MAX_FEATURES;c=c+1)
                    wt[c]<=0;

                //init ycap to 0
                for(c=0;c<MAX_DP;c=c+1)
                    y_cap[c]<=0;

                //init y to 0
                for(c=0;c<MAX_DP;c=c+1)
                    y[c]<=0;

                //init A and B to 0
                for(c=0;c<NUM_MULT;c=c+1)
                    A_vals[c]<=0;
                for(c=0;c<NUM_MULT;c=c+1)
                    B_vals[c]<=0; 
            end
            
            LOAD_WT:
            begin
                for(c = 0;c<=MAX_FEATURES; c = c + 1)
                begin
    //                wt[c]<=temp[16*c+:16];
                    wt[c] <= temp[(MAX_FEATURES+1)*16-16*(c+1)+:16];
                end
                addr <= addr + 1;
            end
            MUL_YCAP:
            begin

                y[addr-1]<=temp[(MAX_FEATURES+1)*16-16+:16];

                //Do not change limit
                for(c = 1; c<=MAX_FEATURES;c=c+1)//A holds datapoints
                begin
    //                A_vals[c-1]<=temp[16*c+:16];
                    A_vals[c-1]<=temp[(MAX_FEATURES+1)*16-16*(c+1)+:16];
                end

                //Do not change limit
                for(c = 1;c<=MAX_FEATURES; c = c + 1)//B holds weights
                begin
                    B_vals[c-1]<=wt[c];
                end
                
            end
            
            ER_CALC:
            begin
                y_cap[addr-1] = wt[0];
                for(c = 0;c<MAX_FEATURES;c = c + 1)
                begin
                    y_cap[addr-1] = y_cap[addr-1] + P[c];
                end
    //            y_cap[i-1]=wt[0]+P[1]+P[2]+P[3]+P[0]+P[4]+P[5];
    //            y_cap[i]=P[1]+P[2]+P[3]+P[0];
    //            common_p=(y[i]-y_cap[i])>>>7;//(y-y^)*learning_rate
                common_p=(y[addr-1]-y_cap[addr-1])>>>7;//(y-y^)*learning_rate


            end
            
            MUL_WT:
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
            
            WT_UP:
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
            WT_UP:
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
    assign fin_final = (fin & PS==IDLE)?1:0;
    assign temp = fin_final?{wt[0],wt[1],wt[2],wt[3],wt[4],wt[5],wt[6],wt[7]}:'hz;

    //assign temp = (fin & PS==IDLE)?0:'hz;
    //assign en = (fin & PS==IDLE)?0:1;
    //assign we = (fin & PS==IDLE)?1:0;
endmodule
// Fix wt[0] change
//remove either error[] or y[]. Not needed, may reduce area