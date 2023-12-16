`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/26 20:26:43
// Design Name: 
// Module Name: immExtension
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


module immExtension(
ExtOp,LuiOp,immediate_in,immediate_out
    );
input ExtOp;//extOp为1是有符号，为0是无符号
input LuiOp;//LuiOp为1即指令为lui，拓展结果为立即数后面跟16个0
input [15:0] immediate_in;
output [31:0] immediate_out;

wire [31:0] imm_temp;
//有无符号拓展中间结果
assign imm_temp = {ExtOp?{16{immediate_in[15]}}:16'h0000,immediate_in};
assign immediate_out = LuiOp?{immediate_in,16'h0000}:imm_temp;
endmodule
