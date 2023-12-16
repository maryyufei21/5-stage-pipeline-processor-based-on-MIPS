`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/01 19:55:48
// Design Name: 
// Module Name: ID_EX_reg
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


module ID_EX_reg(
clk,reset,flush,flushB,stall,
ID_MemRead,ID_MemWrite,ID_MemtoReg,ID_RegWrite,
ID_Branch,ID_BranchOp,ID_ALUSrc1,ID_ALUSrc2,ID_ALUOp,
ID_rd,ID_immediate,ID_PCadd4,ID_rs,ID_rt,ID_Opcode,
Ex_MemRead,Ex_MemWrite,Ex_MemtoReg,Ex_RegWrite,
Ex_Branch,Ex_BranchOp,Ex_ALUSrc1,Ex_ALUSrc2,Ex_ALUOp,
Ex_rd,Ex_immediate,Ex_PCadd4,Ex_rs,Ex_rt,Ex_Opcode,
ID_Data1,ID_Data2,ID_shamt,ID_Funct,
Ex_Data1,Ex_Data2,Ex_shamt,Ex_Funct
    );

input clk,reset,flush,flushB,stall;
input ID_MemRead,ID_MemWrite,ID_RegWrite,ID_Branch,
        ID_ALUSrc1,ID_ALUSrc2;
input [1:0] ID_MemtoReg;
input [2:0] ID_BranchOp;
input [3:0] ID_ALUOp;
input [4:0] ID_rd,ID_shamt,ID_rs,ID_rt;
input [5:0] ID_Opcode;
input [5:0] ID_Funct;
input [31:0] ID_immediate,ID_PCadd4,ID_Data1,ID_Data2;

output reg Ex_MemRead,Ex_MemWrite,Ex_RegWrite,Ex_Branch,
        Ex_ALUSrc1,Ex_ALUSrc2;
output reg [1:0] Ex_MemtoReg;
output reg [2:0] Ex_BranchOp;
output reg [3:0] Ex_ALUOp;
output reg [4:0] Ex_rd,Ex_shamt,Ex_rs,Ex_rt;
output reg [5:0] Ex_Opcode;
output reg [5:0] Ex_Funct;
output reg [31:0] Ex_immediate,Ex_PCadd4,Ex_Data1,Ex_Data2;

always @(posedge clk)
begin
    if(reset)
    begin
        Ex_MemRead<=1'b0;
        Ex_MemWrite<=1'b0;
        Ex_RegWrite<=1'b0;
        Ex_Branch<=1'b0;
        Ex_ALUSrc1<=1'b0;
        Ex_ALUSrc2<=1'b0;
        Ex_MemtoReg<=2'b0;
        Ex_BranchOp<=3'b0;
        Ex_ALUOp<=4'b0;
        Ex_rd<=5'b0;
        Ex_immediate<=32'h0000;
        Ex_PCadd4<=32'h0000;
        Ex_Data1<=32'h0000;
        Ex_Data2<=32'h0000;
        Ex_shamt<=5'b00000;
        Ex_Funct<=6'd0;
        Ex_rs<=5'd0;
        Ex_rt<=5'd0;
        Ex_Opcode<=6'd0;
    end
    else if(flush || flushB)
    begin
        Ex_MemRead<=1'b0;
        Ex_MemWrite<=1'b0;
        Ex_RegWrite<=1'b0;
        Ex_Branch<=1'b0;
        Ex_ALUSrc1<=1'b0;
        Ex_ALUSrc2<=1'b0;
        Ex_MemtoReg<=2'b0;
        Ex_BranchOp<=3'b0;
        Ex_ALUOp<=4'b0;
        Ex_rd<=5'b0;
        Ex_immediate<=32'h0000;
        Ex_PCadd4<=32'h0000;
        Ex_Data1<=32'h0000;
        Ex_Data2<=32'h0000;
        Ex_shamt<=5'd0;
        Ex_Funct<=6'd0;
        Ex_rs<=5'd0;
        Ex_rt<=5'd0;
        Ex_Opcode<=6'd0;
    end
    else if(stall)
    begin
        Ex_MemRead<=1'b0;
        Ex_MemWrite<=1'b0;
        Ex_RegWrite<=1'b0;
        Ex_Branch<=1'b0;
        Ex_ALUSrc1<=1'b0;
        Ex_ALUSrc2<=1'b0;
        Ex_MemtoReg<=2'b0;
        Ex_BranchOp<=3'b0;
        Ex_ALUOp<=4'b0;
        Ex_rd<=5'b0;
        Ex_immediate<=32'h0000;
        Ex_PCadd4<=32'h0000;
        Ex_Data1<=32'h0000;
        Ex_Data2<=32'h0000;
        Ex_shamt<=5'd0;
        Ex_Funct<=6'd0;
        Ex_rs<=5'd0;
        Ex_rt<=5'd0;
        Ex_Opcode<=6'd0;
    end
    else
    begin
        Ex_MemRead<=ID_MemRead;
        Ex_MemWrite<=ID_MemWrite;
        Ex_RegWrite<=ID_RegWrite;
        Ex_Branch<=ID_Branch;
        Ex_ALUSrc1<=ID_ALUSrc1;
        Ex_ALUSrc2<=ID_ALUSrc2;
        Ex_MemtoReg<=ID_MemtoReg;
        Ex_BranchOp<=ID_BranchOp;
        Ex_ALUOp<=ID_ALUOp;
        Ex_rd<=ID_rd;
        Ex_immediate<=ID_immediate;
        Ex_PCadd4<=ID_PCadd4;
        Ex_Data1<=ID_Data1;
        Ex_Data2<=ID_Data2;
        Ex_shamt<=ID_shamt;
        Ex_Funct<=ID_Funct;
        Ex_rs<=ID_rs;
        Ex_rt<=ID_rt;
        Ex_Opcode<=ID_Opcode;
    end
end
endmodule
