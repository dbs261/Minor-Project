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


module Serial_inp#(
parameter ADDR_WIDTH = 3,//3 
parameter MAX_FEATURES = 6,//6
parameter DATA_WIDTH = 16*(MAX_FEATURES+1), //width = num_features + 1 for y values
//parameter DEPTH = 1024,      //Num_data points
parameter DEPTH = 6//6      //Num_data points
)
(
        input [11:0] num_dp,
        input [3:0] feat,
        input ser,
        input CLK,
        input RST,
        // output oe,
        // output we,
        output [11:0] addr,
        output [191:0] data,
        output done
    );
    parameter NUM_DP = 5; //16*6 bit storage
//    reg reg_oe = 0;
//    reg reg_we = 0;
    reg reg_done = 0;
    // wire [ADDR_WIDTH-1:0] addr;
    // wire [DATA_WIDTH-1:0] data;
    reg [DATA_WIDTH-1:0] shift_reg;
    reg [8:0] counter ;//256 bit counter
    reg [ADDR_WIDTH-1:0] addr_reg;

    // RAM2 r(0, 1, RST, addr, data);
//    reg check;

    always@(CLK) begin
        // if(done==0) begin
        if(RST) begin
            addr_reg <= -1;
            shift_reg <= 0;
//            reg_we <= 0;
//            reg_oe <= 0;
            reg_done <= 0;
            counter <= 0;
        end
        else if (done != 1) begin
//            check<=0;
            shift_reg[counter] <= ser;
            if(counter == ((feat+1)*16)-1) begin
//                check <= 1;
                counter <= 0;
                addr_reg <= addr_reg + 1;
                $display("%h -> %b", shift_reg , shift_reg, $time);
            end
            else
                counter <= counter + 1;
            // end
            if (addr_reg == num_dp - 1) begin
                reg_done <= 1;
            end
        end
        else begin
//            reg_we = 'hz;
//            reg_oe = 'hz;
        end
    end

    assign data = (done == 1) ? 'hz : shift_reg;
    // assign we = (reg_done == 1) ? 'hz : reg_we;
    // assign oe = (reg_done == 1) ? 'hz : reg_oe;
    assign done = reg_done;
    assign addr = addr_reg;

endmodule