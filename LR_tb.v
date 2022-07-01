`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2022 23:22:32
// Design Name: 
// Module Name: LR_tb
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


module LR_tb();
parameter ADDR_WIDTH = 3, MAX_FEATURES = 7, MAX_DATA_WIDTH = 16*(MAX_FEATURES+1), NUM_DP = 6,
NUM_FEATURES = 6, NUM_DATA_WIDTH = 16*(NUM_FEATURES+1); //16*6 bit storage

reg ser, CLK;
reg[MAX_DATA_WIDTH-1:0] full_data[NUM_DP-1+1:0];
wire done;
reg[6:0] counter;//256 bit counter
reg [ADDR_WIDTH-1:0] addr_reg;

initial
begin
    $readmemh("E:/Dhanush/Minor_project/Minor_project.srcs/sources_1/new/data_points.txt",full_data);
//        fd = $fopen("E:/Dhanush/Minor_project/Minor_project.srcs/sources_1/new/data_points.mem", "r");
    
    ser<=full_data[0][NUM_DATA_WIDTH-1];
//    done<=0;
    counter<=NUM_DATA_WIDTH-2;
    addr_reg<=0;
    forever
    begin
        @(posedge CLK)
        begin
            if(done==0)
            begin
                ser<=full_data[addr_reg][counter];
            end
            else
            begin
                ser<=0;
            end
//            if((addr_reg == NUM_DP)&&(counter == 0))
//            begin
//                done<=1;
//            end
            if(counter==0)
            begin
                counter<=NUM_DATA_WIDTH-1;
                addr_reg<=addr_reg+1;
            end
            else
            begin
                counter<=counter-1;
            end
        end
    end
end

initial
begin
CLK = 0;
forever
    #1 CLK = ~CLK;
end

//LR lr1(CLK);
//assign done = 0;
main m(CLK, ser, done);


initial
begin
#2000 $finish;
end

endmodule
