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
    input CLK
    );
parameter ADDR_WIDTH = 4, MAX_FEATURES = 6, DATA_WIDTH = 16*(MAX_FEATURES+1); //width = num_features + 1 for y values
reg we, oe, rst;
//change to reg later
parameter S0 = 2'd0, S1 = 2'd1;
wire lr_done;

wire[ADDR_WIDTH-1:0] i;
wire[DATA_WIDTH-1:0] temp;

reg[2:0] PS,NS;


RAM2 r(.we(we),.oe(oe),.RST(rst),.addr(i),.data(temp));
//LR l(.CLK(CLK),.temp(temp), .fin_final(lr_done), .i(i),.we(we),.en(oe),.rst(rst));
LR l(.CLK(CLK),.temp(temp), .fin_final(lr_done), .i(i));

initial
begin
    NS <= S0;
    rst<=0;
    we<=0;
    oe<=1;
end

always@(CLK)
begin
    PS<=NS;
end

always@(PS,lr_done)
begin
    case(PS)
        S0:NS<=(lr_done)?S1:S0;
        S1:NS<=S1;
        default:NS<=S0;
    endcase
end

always@(PS)
begin
    case(PS)
        S0:
        begin
            we<=0;
            oe<=1;
        end
        S1:
        begin
            // How to vary address here?
            // Make address zz after fin_final in lr module.
            
            we<=1;
            oe<=0;
        end
    endcase
end
assign i = (PS==S1)?0:'hz;
//assign rst = 0;
//assign we = (lr_done)?1:0;
//assign oe = (lr_done)?0:1;



endmodule
