`timescale 1ns / 1ps

module FA_4ip(input [15:0] a,b,c,d, output[15:0] out);

    assign out = a+b+c+d;

endmodule