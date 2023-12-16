`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/26 19:15:14
// Design Name: 
// Module Name: pc
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

//用于给出指令在指令储存器中的地址，且当发生数据冒险stall时，需要保持PC寄存器不变。
//当需要flush是将pc_out输出0

module pc(
reset,clk,pc_in,pc_out,stall,flush
    );
input reset;
input clk;
input flush;
input stall;
output reg [31:0] pc_out;
input [31:0] pc_in;
always @(posedge reset or posedge clk)
begin
if(reset)    pc_out<=32'h00400000;
//else if(flush)   pc_out<=32'h0;
else if(stall)   pc_out<=pc_out;
else pc_out<=pc_in;
end


endmodule
