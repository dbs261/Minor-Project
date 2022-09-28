`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2022 00:45:33
// Design Name: 
// Module Name: main
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


module main(
    input CLK, ser,
    output done
    );
parameter ADDR_WIDTH = 3, MAX_FEATURES = 7, MAX_DATA_WIDTH = 16*(MAX_FEATURES+1), NUM_DP = 6; //width = num_features + 1 for y values
reg we, oe, rst;
wire we1, oe1, rst1;
//wire we, oe, rst;//
//change to reg later
parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3=3'd3, idle = 3'd4;
wire lr_done, C0;
reg lr_enable;
wire[ADDR_WIDTH-1:0]  i_ser, i_lr;
reg[ADDR_WIDTH-1:0] i;
wire[MAX_DATA_WIDTH-1:0] temp, temp_ser, temp_lr;
reg[2:0] coun;
reg[2:0] PS,NS;
reg load_weight;

RAM2 r(.we(we),.oe(oe),.RST(rst),.addr(i),.data(temp));
//LR l(.CLK(CLK),.temp(temp), .fin_final(lr_done), .i(i),.we(we),.en(oe),.rst(rst));
LR l(.CLK(CLK),.temp(temp_lr), .fin_final(lr_done), .i(i_lr),.enable(lr_enable));
Serial_in s(.ser(ser), .CLK(CLK), .done(done), .C0(C0),.we(we1), .en(oe1), .RST(rst1), .addr_reg(i_ser),.data(temp_ser));
//Serial_in s(.ser(ser), .CLK(CLK), .done(done), .C0(C0), .addr_reg(i),.data(temp));


////////////////////////////////////////////////////
initial
begin
load_weight<=0;
    NS <= S2;
    rst<=0;
    we<=0;
    oe<=1;
    lr_enable<=0;
end

always@(CLK)
begin
    PS<=NS;
end

always@(PS,lr_done, done)
begin
    case(PS)
        idle:
        begin
            NS<=S2;
        end
        S2:
        begin
            NS<=done?S3:S2;
        end
        S3:NS<=S0;
        S0:NS<=(lr_done)?S1:S0;
        S1:NS<=S1;
        default:NS<=S2;
    endcase
end

assign temp = (load_weight==0)?((lr_enable==0)?temp_ser:'hz):temp_lr;
//assign temp = (lr_enable==0)?temp_ser:'hz;

assign temp_lr = (load_weight==0)?((lr_enable==0)?'hz:temp):'hz;


always@(PS, we1, i_ser, i_lr)
begin
    case(PS)
        idle:
        begin
            rst<=1;
        end
        S2:
        begin
            rst<=0;
            i<=i_ser;
            we<=we1;
        end
        S3:
        begin
            lr_enable<=1;/////////change to 1
        end
        S0:
        begin
            i<=i_lr;
            we<=0;
            oe<=1;
        end
        S1:
        begin
            // How to vary address here?
            // Make address zz after fin_final in lr module.
            load_weight<=1;
            i<=i_lr;
            we<=1;
            oe<=0;
        end
    endcase
end



endmodule
