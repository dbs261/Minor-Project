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
    MAX_DATA_WIDTH = 16*(MAX_FEATURES+1), NUM_MULT = 4, QUART = MAX_FEATURES/NUM_MULT
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
    wire[15:0] FA_4ip_out;

    FA_4ip fa4ip1(.a(P[0]), .b(P[1]), .c(P[2]), .d(P[3]), .out(FA_4ip_out));

    reg[QUART-1-1:0] quarters;
    wire[16*NUM_MULT-1:0] DP_MUX_out;

    DP_MUX dpmux1(.sel(quarters), .temp(temp[MAX_DATA_WIDTH-16-1:0]), .out(DP_MUX_out));

    reg signed[15:0] wt_temp[NUM_MULT-1:0];
    wire signed[15:0] FA_2ip_out_0,FA_2ip_out_1,FA_2ip_out_2,FA_2ip_out_3;

    FA_2ip fa2ip1(.a(wt_temp[0]), .b(P[0]), .out(FA_2ip_out_0));
    FA_2ip fa2ip2(.a(wt_temp[1]), .b(P[1]), .out(FA_2ip_out_1));
    FA_2ip fa2ip3(.a(wt_temp[2]), .b(P[2]), .out(FA_2ip_out_2));
    FA_2ip fa2ip4(.a(wt_temp[3]), .b(P[3]), .out(FA_2ip_out_3));

    integer c;
    // parameter INIT = 3'd6, MUL_YCAP = 3'd0, ER_CALC = 3'd1, MUL_WT = 3'd3, WT_UP = 3'd2, IDLE = 3'd4, LOAD_WT=3'd5;//Gray code
    parameter IDLE = 4'd4, INIT = 4'd6, LOAD_WT=4'd5, MUL_WT = 4'd3, WT_UP = 4'd2;//Gray code
    parameter  MUL_YCAP = 4'd0, ER_CALC = 4'd1, CALC_CP = 4'd7, BUF = 4'd8, POST_WT_UP = 4'd9;
    parameter WT_UP2 = 4'd10;
    // NOTE: ADD WT_UP3 AND 4 FOR 16 FEATURES
    wire fin;
    //if dps > 16, change ADDR_WIDTH also
    reg[3:0] PS,NS;
    // reg[1:0] PS_MYEC, NS_MYEC;

    /*
        NOTE: Remember to change reg sizes while varying max value
    */
    reg[5:0] epochs, TOTAL_EPOCHS;//max 128 epochs
    reg[2:0] DPS;
    reg[2:0] NUM_FEATURES;
    
    // reg quarters;

    //reg rst;
    //reg en,we;

    reg signed [15:0] y_cap[MAX_DP-1:0];
    reg signed [15:0] y[MAX_DP-1:0];
    reg signed [15:0] ACC;

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

        // NS_MYEC <= MUL_YCAP;
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
    // always@(CLK)
    // begin
    //     if(PS==MYEC)
    //     begin
    //         PS_MYEC<=NS_MYEC;
    //     end
    // end

    always@(PS)
    begin
        case(PS)
            // IDLE: NS <= (fin)?IDLE:INIT;
            // INIT: NS <= LOAD_WT;
            // LOAD_WT: NS <= MUL_YCAP;
            // MUL_YCAP: NS <= ER_CALC;
            // ER_CALC:NS <= MUL_WT;
            // MUL_WT:NS <= WT_UP;
            // WT_UP: NS <= (fin)?IDLE:MUL_YCAP;
            // default: NS <= IDLE;
            IDLE: NS <= (fin)?IDLE:INIT;
            INIT: NS <= LOAD_WT;
            LOAD_WT: NS <= MUL_YCAP;
            MUL_YCAP: NS <= ER_CALC;
            ER_CALC:NS <= (quarters==QUART-1)?CALC_CP:MUL_YCAP;
            CALC_CP: NS <= BUF;
            BUF: NS <= MUL_WT;
            MUL_WT:NS <=  (quarters==QUART-1)?WT_UP2:WT_UP;
            WT_UP: NS <=  MUL_WT;
            WT_UP2: NS <= POST_WT_UP;
            POST_WT_UP: NS <= (fin)?IDLE:MUL_YCAP;
            default: NS <= IDLE;
        endcase
    end

    // always@(PS_MYEC)
    // begin
    //     case(PS_MYEC)
    //         MUL_YCAP: NS_MYEC <= ER_CALC;
    //         ER_CALC : NS_MYEC <= MUL_YCAP;
    //         default : NS_MYEC <= MUL_YCAP;
    //     endcase
    // end


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
                quarters <= 0;
                
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
                ACC <= 0;

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
                // for(c = 1; c<=NUM_MULT;c=c+1)//A holds datapoints
                // begin
                    //A_vals[c-1]<=temp[16*c+:16];
                    // A_vals[c-1]<=temp[(MAX_FEATURES+1)*16-16*(c+1)+:16];
                // end
                {A_vals[0], A_vals[1], A_vals[2], A_vals[3]} <= DP_MUX_out;

                //Do not change limit
                for(c = 1;c<=NUM_MULT; c = c + 1)//B holds weights
                begin
                    B_vals[c-1]<=wt[c + NUM_MULT*quarters];
                end
            end

            ER_CALC :
            begin
                // y_cap[addr-1] = wt[0];

                //Replace for loop and P[c] using FA_4ip
                // for(c = 0;c<NUM_MULT;c = c + 1)
                // begin
                //     y_cap[addr-1] = y_cap[addr-1] + P[c];
                // end

                // y_cap[addr-1] = wt[0];
                // y_cap[addr-1] <= y_cap[addr-1] + FA_4ip_out;
                ACC <= ACC + FA_4ip_out;

    //            y_cap[i-1]=wt[0]+P[1]+P[2]+P[3]+P[0]+P[4]+P[5];
    //            y_cap[i]=P[1]+P[2]+P[3]+P[0];
    //            common_p=(y[i]-y_cap[i])>>>7;//(y-y^)*learning_rate
                // common_p=(y[addr-1]-y_cap[addr-1])>>>7;//(y-y^)*learning_rate
                quarters <= quarters + 1;
            end

            CALC_CP:
            begin
                common_p <= (y[addr-1]-ACC-wt[0])>>>7;//(y-y^)*learning_rate
                y_cap[addr-1] <= ACC+wt[0];
                //MUST RESET ACC to 0
            end
            
            BUF:
            begin
                ACC<=0;
                //Do not change limit
                for(c = 0;c<NUM_MULT; c = c + 1)
                begin
                    B_vals[c]<=common_p;
                end
                wt[0]<=wt[0]+common_p;
                quarters <= 0;
            end

            MUL_WT:
            begin
                //change A_vals
                {A_vals[0], A_vals[1], A_vals[2], A_vals[3]} <= DP_MUX_out;
                for(c = 0;c<NUM_MULT; c = c + 1)
                begin
                    wt_temp[c] = wt[c + NUM_MULT*quarters];
                end
            end
            WT_UP:
            begin
    //            wt[0] <= wt[0] + P[0];
    //            wt[1] <= wt[1] + P[1];
    //            wt[2] <= wt[2] + P[2];
    //            wt[3] <= wt[3] + P[3];
                // wt[0]<=wt[0]+common_p;

                //Do not change limit
                // for(c=1;c<=NUM_MULT;c = c + 1)
                // begin
                //     wt[c] <= wt[c] + P[c-1];
                // end

                wt[1] <= FA_2ip_out_0;
                wt[2] <= FA_2ip_out_1;
                wt[3] <= FA_2ip_out_2;
                wt[4] <= FA_2ip_out_3;

                quarters <= quarters + 1;
                
            end   
            WT_UP2:
            begin
                
                wt[5] <= FA_2ip_out_0;
                wt[6] <= FA_2ip_out_1;
                wt[7] <= FA_2ip_out_2;
                wt[8] <= FA_2ip_out_3;

                quarters <= quarters + 1;
            end
            POST_WT_UP:
            begin
                quarters <= 0;
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
    // always@(PS)
    // begin
    //     case(PS)
    //         WT_UP:
    //         begin
    // //            wt[0] <= wt[0] + P[0];
    // //            wt[1] <= wt[1] + P[1];
    // //            wt[2] <= wt[2] + P[2];
    // //            wt[3] <= wt[3] + P[3];
    //             wt[0]<=wt[0]+common_p;
    //             //Do not change limit
    //             for(c=1;c<=MAX_FEATURES;c = c + 1)
    //             begin
    //                 wt[c] <= wt[c] + P[c-1];
    //             end
                
    //         end        
    //     endcase
    // end
    assign fin_final = (fin & PS==IDLE)?1:0;
    assign temp = fin_final?{wt[0],wt[1],wt[2],wt[3],wt[4],wt[5],wt[6],wt[7],wt[8]}:'hz;
    // assign temp = fin_final?wt:'hz;
    //assign temp = (fin & PS==IDLE)?0:'hz;
    //assign en = (fin & PS==IDLE)?0:1;
    //assign we = (fin & PS==IDLE)?1:0;
endmodule
// Fix wt[0] change
//remove either error[] or y[]. Not needed, may reduce area