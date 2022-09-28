`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.06.2022 10:48:54
// Design Name: 
// Module Name: Serial_in
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


module Serial_in#
(         //Depends on no. of datapoints
parameter ADDR_WIDTH = 3, MAX_FEATURES = 7, MAX_DATA_WIDTH = 16*(MAX_FEATURES+1),
 NUM_DP = 6, NUM_FEATURES = 6, NUM_DATA_WIDTH = 16*(NUM_FEATURES+1) //16*6 bit storage
)
(
    input ser, CLK,
    output done,C0,
    output reg we, en, RST,//
    output reg[ADDR_WIDTH-1:0] addr_reg,
    output [MAX_DATA_WIDTH-1:0] data
    );

//reg we, en, RST;
//wire [ADDR_WIDTH-1:0] addr;
//wire [DATA_WIDTH-1:0] data;

//reg [FULL*NUM_DP-1:0] full_data;
reg [MAX_DATA_WIDTH-1:0] shift_reg;
reg[6:0] counter;//256 bit counter
//reg [ADDR_WIDTH-1:0] addr_reg;
reg reg_done;
//initial
//begin
//CLK = 0;
//forever
//    #1 CLK = ~CLK;
//end

//RAM2 r(we, en, RST, addr_reg, data);


initial
begin
//    $readmemh("E:/Dhanush/Minor_project/Minor_project.srcs/sources_1/new/full.txt",mem);
    {RST}<=0;//
    en<=1;
    we<=0;
    counter<=NUM_DATA_WIDTH-1;
    shift_reg<=0;
    reg_done<=0;
    addr_reg<=-1;
end



always@(posedge CLK)
begin
if(done==0)
begin

    
    if(addr_reg==NUM_DP && counter == NUM_DATA_WIDTH-1)//NUM_DP actual + 1 for initial weights
    begin
        reg_done<=1;
        we<=0;
    end   
    else
    begin
        shift_reg[counter] <= ser;
        if(C0)
        begin
        
            counter<=NUM_DATA_WIDTH-1;
            if(addr_reg!=NUM_DP)
            begin
                we<=1;//
                addr_reg<=addr_reg+1;
            end
        end
        else
        begin
            we<=0;//
            counter <= counter - 1;
        end
    end
end
else
begin
//    shift_reg<=0;
//    addr_reg<='hz;
end
end

//always@(posedge CLK)
//begin
//if(done==0)
//begin 
//    if(C0)
//    begin
//        if(addr_reg!=NUM_DP)
//        begin
//            we<=1;
////            addr_reg<=addr_reg+1;
//        end
//    end
//    else
//    begin
//        we<=0;
////        counter <= counter - 1;
//    end
//end
//end

assign done = reg_done;
//assign done = 0;
assign C0 = (counter==0);
//assign data = (done==0)?shift_reg:'hz;
assign data = shift_reg;
//assign addr = addr_reg;
endmodule
