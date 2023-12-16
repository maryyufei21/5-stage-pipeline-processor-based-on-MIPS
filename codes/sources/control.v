`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/26 21:09:53
// Design Name: 
// Module Name: control
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


module control(
    input [5:0] Opcode,
    input [5:0] Funct,
    output Jump,
    output Branch,
    output [2:0] BranchOp,
    output RegWrite          ,
    output RegDst   ,
    output MemRead           ,
    output MemWrite          ,
    output [2 -1:0] MemtoReg ,
    output ALUSrc1           ,
    output ALUSrc2           ,
    output ExtOp             ,
    output LuOp              ,
    output [4 -1:0] ALUOp   
         
    );

//Opcode
parameter R = 6'h0;
parameter lw = 6'h23;
parameter sw = 6'h2b;
parameter lui = 6'h0f;
parameter addi = 6'h08;
parameter addiu = 6'h09;
parameter andi = 6'h0c;
parameter slti = 6'h0a;
parameter sltiu = 6'h0b;  
parameter beq   = 6'h04;      
parameter bne   = 6'h05;
parameter blez  = 6'h06;
parameter bgtz  = 6'h07;
parameter bltz  = 6'h01;
parameter j     = 6'h02;  
parameter jal   = 6'h03;

//Funct
parameter add   = 6'h20;   
parameter addu  = 6'h21;   
parameter sub   = 6'h22;   
parameter subu  = 6'h23;   
parameter AND   = 6'h24;   
parameter OR    = 6'h25;   
parameter XOR   = 6'h26;  
parameter NOR   = 6'h27; 
parameter sll   = 6'h0;    
parameter srl   = 6'h02;  
parameter sra   = 6'h03;  
parameter slt   = 6'h2a; 
parameter sltu  = 6'h2b;   
parameter jr    = 6'h08;   
parameter jalr  = 6'h09;  

assign Jump = ((Opcode==R&&(Funct==jr||Funct==jalr))||Opcode==j||Opcode==jal);
assign Branch = (Opcode==beq||Opcode==bne||Opcode==blez||Opcode==bgtz||Opcode==bltz);
assign BranchOp = (Opcode==beq)?3'b000:
                (Opcode==bne)?3'b001:
                (Opcode==blez)?3'b010:
                (Opcode==bgtz)?3'b011:
                (Opcode==bltz)?3'b100:3'b111;
  
assign ExtOp = (Opcode == andi)?0:1;
assign LuOp = (Opcode == lui)?1:0;
assign ALUSrc1 = (Opcode==R && (Funct==sll || Funct==srl || Funct==sra))?1:0;
assign ALUSrc2 = (Opcode==R || Opcode==beq || Opcode==bne )?0:1;
assign ALUOp[2:0] = 
		(Opcode == 6'h00)? 3'b010: 
		(Opcode == 6'h04 || Opcode == 6'h05)? 3'b001: 
		(Opcode == 6'h0c)? 3'b100: 
		(Opcode == 6'h0a || Opcode == 6'h0b)? 3'b101: 
		(Opcode == 6'h1c)? 3'b110:
		3'b000;
assign ALUOp[3] = Opcode[0];
assign RegDst = (Opcode==R)?1:0;
assign MemWrite = (Opcode==sw)?1:0;
assign MemRead = (Opcode==lw)?1:0;
assign MemtoReg = (Opcode==jal || Opcode==R&& Funct==jalr)?2'b10:
        (Opcode==lw)?2'b01:
        2'b00;
assign RegWrite = ~(Opcode==sw||Opcode==beq||Opcode==bne||(Opcode==R&&Funct==jr)
        ||Opcode==blez||Opcode==bgtz||Opcode==bltz||Opcode==jal||(Opcode==R&&Funct==jalr));


endmodule
