`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 09:56:15
// Design Name: 
// Module Name: mux4_1
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


module mux4_1(
IDEx,ExMEM,MEMWB,source_out,select
    );
input [31:0] IDEx,MEMWB,ExMEM;
input [1:0] select;
output [31:0] source_out;

assign source_out = (select==2'b00)?IDEx:
                    (select==2'b01)?MEMWB:
                    (select==2'b10)?ExMEM:32'h0;

endmodule
