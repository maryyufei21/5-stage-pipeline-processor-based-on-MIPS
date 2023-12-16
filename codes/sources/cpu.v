`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 11:46:15
// Design Name: 
// Module Name: cpu
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


module cpu(
clk,reset,BCDout
    );
input clk;
input reset;
output [11:0] BCDout;


wire [31:0] IF_pc_in;
wire [31:0] IF_pc_add4;
wire [31:0] IF_pc_out_addr;//in other words, pc_next
wire flush;
wire flushB;
wire stall;
wire [31:0] IF_Instruction;
wire [31:0] ID_pc_add4;
wire [31:0] ID_Instruction;

wire ID_Jump;
wire ID_Branch;
wire [2:0] ID_BranchOp;
wire ID_RegWrite;
wire ID_RegDst;
wire ID_MemRead;
wire ID_MemWrite;
wire [1:0] ID_MemtoReg;
wire ID_ALUSrc1;
wire ID_ALUSrc2;
wire ID_ExtOp;
wire ID_LuOp;
wire [3:0] ID_ALUOp;
wire [5:0] ID_Opcode;
wire [5:0] ID_Funct;
wire [4:0] ID_shamt;

wire [31:0] WB_Write_data;
reg [31:0] ID_Data1;
reg [31:0] ID_Data2;
wire [31:0] ID_Data1pre;
wire [31:0] ID_Data2pre;
wire [4:0] ID_rd;
wire [31:0] ID_immediate;
wire [4:0] ID_rs;
wire [4:0] ID_rt;
wire jumpandlink_write;

wire [4:0] Ex_rs,Ex_rt;//used for forwarding 'unit'
wire Ex_MemRead,Ex_MemWrite,Ex_RegWrite,Ex_Branch,Ex_ALUSrc1,Ex_ALUSrc2;
wire [1:0] Ex_MemtoReg;
wire [2:0] Ex_BranchOp;
wire [3:0] Ex_ALUOp;
wire [4:0] Ex_rd,Ex_shamt;
wire [5:0] Ex_Funct;
wire [5:0] Ex_Opcode;
wire [31:0] Ex_immediate,Ex_PCadd4,Ex_Data1,Ex_Data2;

wire [31:0] Ex_Branchpc;
wire [31:0] Ex_Data_or_Forward1,Ex_Data_or_Forward2;
wire [31:0] Ex_ALUin1,Ex_ALUin2;
wire [31:0] MEM_ALUout;
wire [31:0] WB_ALUout;
reg [1:0] Forward1,Forward2;//need hazard unit to judge

wire [31:0] Ex_ALUout;
wire [4:0] Ex_ALUCtl;
wire Ex_ALU_sign;
wire Ex_ALUz;

wire MEM_RegWrite,MEM_MemWrite,MEM_zero,MEM_MemRead;
wire [1:0] MEM_MemtoReg;
wire [31:0] MEM_Branchpc,MEM_Data2;
wire [4:0] MEM_rd;
wire [31:0] MEM_PCadd4;
wire [31:0] MEM_MemReadData;

wire WB_RegWrite;
wire [1:0] WB_MemtoReg;
wire [4:0] WB_rd;
wire [31:0] WB_MemReadData,WB_PCadd4;
wire WB_MemWrite;

wire flagbeq;
wire flagbne;
wire flagblez;
wire flagbgtz;
wire flagbltz;

assign flagbeq = (Ex_Branch) && (Ex_BranchOp == 3'b000 && Ex_ALUz) ;
assign flagbne = (Ex_Branch) && (Ex_BranchOp == 3'b001 && Ex_ALUz == 0);
assign flagblez = (Ex_Branch) && (Ex_BranchOp == 3'b010 && Ex_Data1 <= 0);
assign flagbgtz = (Ex_Branch) && (Ex_BranchOp == 3'b011 && Ex_Data1>0);
assign flagbltz = (Ex_Branch) && (Ex_BranchOp == 3'b100 && Ex_Data1<0);

// always @(reset or posedge clk)
// begin
//     if(reset)
//     begin
//     flagbeq<=0;
//     flagbne<=0;
//     flagblez<=0;
//     flagbgtz<=0;
//     flagbltz<=0;
//     end
//     else
//     begin
//         flagbeq = (Ex_Branch) && (Ex_BranchOp == 3'b000 && Ex_ALUz) ;
//         flagbne = (Ex_Branch) && (Ex_BranchOp == 3'b001 && Ex_ALUz == 0);
//         flagblez = (Ex_Branch) && (Ex_BranchOp == 3'b010 && Ex_Data1 <= 0);
//         flagbgtz = (Ex_Branch) && (Ex_BranchOp == 3'b011 && Ex_Data1>0);
//         flagbltz = (Ex_Branch) && (Ex_BranchOp == 3'b100 && Ex_Data1<0);
//     end
// end

//control signals used for jump and branch instructions
wire [1:0] IF_PCSrc;

//-------------------------------------stage1-------------------------------------
//-------------------------------------IF-------------------------------------

assign IF_pc_in = (IF_PCSrc==2'b01)?Ex_Branchpc://pc_in mux
                  (IF_PCSrc==2'b10)?{IF_pc_add4[31:28],ID_Instruction[25:0],2'b0}:
                  (IF_PCSrc==2'b11)?ID_Data1pre:
                  IF_pc_add4;

pc program_counter(reset,clk,IF_pc_in,IF_pc_out_addr,stall,flush);
assign IF_pc_add4 = IF_pc_out_addr+32'd4;

InstructionMemory instruction_memory(IF_pc_out_addr,IF_Instruction);

//IF/ID registers
IF_ID_reg if_id_registers(clk,reset,IF_pc_add4,
        IF_Instruction,flush,flushB,stall,ID_pc_add4,ID_Instruction);


//-------------------------------------stage2-------------------------------------
//-------------------------------------ID-------------------------------------
assign ID_Opcode = ID_Instruction[31:26];
assign ID_Funct = ID_Instruction[5:0];
assign ID_shamt = ID_Instruction[10:6];
assign ID_rs = ID_Instruction[25:21];
assign ID_rt = ID_Instruction[20:16];
assign ID_rd = (ID_RegDst)?ID_Instruction[15:11]:ID_Instruction[20:16];

control control_unit(ID_Opcode,ID_Funct,
    ID_Jump,ID_Branch,ID_BranchOp,ID_RegWrite,ID_RegDst,ID_MemRead,
    ID_MemWrite,ID_MemtoReg,ID_ALUSrc1,ID_ALUSrc2,ID_ExtOp,ID_LuOp,
    ID_ALUOp);


parameter jal = 6'h03;
parameter R = 6'h0;
parameter jalr = 6'h09;
parameter j = 6'h02;

assign jumpandlink_write = (ID_Opcode==jal||(ID_Opcode==R&&ID_Funct==jalr))?1:0;

registerFile register_file(reset,clk,WB_RegWrite,ID_rs,
    ID_rt,WB_rd,WB_Write_data,ID_Data1pre,ID_Data2pre,
    ID_pc_add4,jumpandlink_write);

//1.read after write: 
always @(*)
//if readAddr==writeAddr, directly read from writeData
begin
    if(ID_rs==WB_rd && WB_RegWrite && WB_rd!=0) ID_Data1 = WB_Write_data;
    else ID_Data1 = ID_Data1pre;
end
always @(*)
//if readAddr==writeAddr, directly read from writeData
begin
    if(ID_rt==WB_rd && WB_RegWrite && WB_rd!=0) ID_Data2 = WB_Write_data;
    else ID_Data2 = ID_Data2pre;
end

//2.load-use hazard process unit
// always @(*)
// begin
//     if((ID_rs == Ex_rd || ID_rt == Ex_rd) && Ex_MemtoReg == 2'b01 && 
//         Ex_rd!=0 && Ex_RegWrite==1) stall = 1;
// end

// always @(posedge clk)
// begin
//     if(reset) stall <=0;
//     else
//     begin
//     if(stall==0)
//         begin
//         if((ID_rs == Ex_rd || ID_rt == Ex_rd) && Ex_MemtoReg == 2'b01 && 
//             Ex_rd!=0 && Ex_RegWrite==1) stall = 1;
//         else stall = 0;
//         end
//     else if(stall==1) stall<=0;
//     end
// end

assign stall = ((ID_rs == Ex_rd || ID_rt == Ex_rd) && Ex_MemtoReg == 2'b01 && 
                Ex_rd!=0 && Ex_RegWrite==1);

//3.jump:jal,j,jalr,jr and branch

assign flush = ID_Jump;
assign flushB = (flagbeq || flagbne || flagblez || flagbgtz || flagbltz);
// always @(*)
// begin
//     if(ID_Jump) flush = 1;
// end
// always @(posedge clk)
// begin
//     if(reset) 
//         begin
//             flush <= 1'b0;
//         end
//     else 
//     begin
//     if(flush==0) 
//     begin
//         if(ID_Jump) flush = 1'b1;
//         else flush = 1'b0;
//     end
//     else if(flush==1) 
//     begin
//         flush <= 1'b0;
//     end
//     end
// end

// always @(*)
// begin
//     flagbeq = (Ex_Branch) && (Ex_BranchOp == 3'b000 && Ex_ALUz) ;
//     flagbne = (Ex_Branch) && (Ex_BranchOp == 3'b001 && Ex_ALUz == 0);
//     flagblez = (Ex_Branch) && (Ex_BranchOp == 3'b010 && Ex_Data1 <= 0);
//     flagbgtz = (Ex_Branch) && (Ex_BranchOp == 3'b011 && Ex_Data1>0);
//     flagbltz = (Ex_Branch) && (Ex_BranchOp == 3'b100 && Ex_Data1<0);
//     if (flagbeq || flagbne || flagblez || flagbgtz || flagbltz)flushB = 1'b1;
//     else flushB = 1'b0;
// end

// always @(posedge clk)
// begin
//     if(reset) 
//     begin
//         flushB <= 0;
//     end
//     else
//     begin
//     if(flushB==0)
//         begin
//             if (flagbeq || flagbne || flagblez 
//             || flagbgtz || flagbltz)flushB = 1'b1;
//             else flushB = 1'b0;
//         end
//     else if(flushB==1) 
//         begin
//             flushB<=0;
//         end
//     end
// end

// always @(*)
// begin
//     //000 beq; 001 bne; 010 blez; 011 bgtz; 100 bltz;
//     if(Ex_Branch)
//     begin
//         if(Ex_BranchOp == 3'b000) if(Ex_ALUz) flushB = 1;
//         else if(Ex_BranchOp == 3'b001) if(Ex_ALUz==1'b0) flushB = 1;
//         //need more alu stuff: no! compare directly
//         else if(Ex_BranchOp == 3'b010) if(Ex_Data1<=0) flushB = 1;
//         else if(Ex_BranchOp == 3'b011) if(Ex_Data1>0) flushB = 1;
//         else if(Ex_BranchOp == 3'b100) if(Ex_Data1<0) flushB = 1;
//     end
// end

//((Ex_ALUz && Ex_Opcode==6'h4)||(~Ex_ALUz &&Ex_Opcode==6'h5))

assign IF_PCSrc = (Ex_Branch && flushB)?2'b01:
        (ID_Opcode==6'h02||ID_Opcode==6'h03)?2'b10:
        ((ID_Opcode==6'h0&&ID_Funct==6'h08)||(ID_Opcode==6'h0&&ID_Funct==6'h09))?2'b11:
        2'b00;


immExtension immediate_extension(ID_ExtOp,ID_LuOp,ID_Instruction[15:0],
    ID_immediate);


//ID/EX registers
ID_EX_reg id_ex_register (clk,reset,flush,flushB,stall,ID_MemRead,ID_MemWrite,
    ID_MemtoReg,ID_RegWrite,ID_Branch,ID_BranchOp,ID_ALUSrc1,ID_ALUSrc2,
    ID_ALUOp,ID_rd,ID_immediate,ID_pc_add4,ID_rs,ID_rt,ID_Opcode,
    Ex_MemRead,Ex_MemWrite,Ex_MemtoReg,Ex_RegWrite,
    Ex_Branch,Ex_BranchOp,Ex_ALUSrc1,Ex_ALUSrc2,Ex_ALUOp,
    Ex_rd,Ex_immediate,Ex_PCadd4,Ex_rs,Ex_rt,Ex_Opcode,
    ID_Data1,ID_Data2,ID_shamt,ID_Funct,
    Ex_Data1,Ex_Data2,Ex_shamt,Ex_Funct
    );


//-------------------------------------stage3-------------------------------------
//-------------------------------------Ex-------------------------------------
always @(*) //EX/MEM hazard &MEM/WB hazard forwarding unit
begin
    if(reset)
    begin
        Forward1 = 2'b00;
    end
    else 
    begin
        if (MEM_RegWrite && MEM_rd!=0 && MEM_rd == Ex_rs) Forward1 = 2'b10;
        else if((WB_RegWrite) && WB_rd!=0 && WB_rd == Ex_rs
          && ((MEM_rd!=Ex_rs)||~MEM_RegWrite)) Forward1 = 2'b01;
        else Forward1 = 2'b00;
    end
end
always @(*) //EX/MEM hazard &MEM/WB hazard forwarding unit
begin
    if(reset)
    begin
        Forward2 = 2'b00;
    end
    else 
    begin
        if (MEM_RegWrite && MEM_rd!=0 && MEM_rd == Ex_rt) Forward2 = 2'b10;
        else if(WB_RegWrite && WB_rd!=0 && WB_rd == Ex_rt
          && ((MEM_rd!=Ex_rt)||~MEM_RegWrite) && Ex_Opcode==6'b000000) Forward2 = 2'b01;
        else Forward2 = 2'b00;
    end
end

assign Ex_Branchpc = Ex_PCadd4+Ex_immediate*4;

// assign Ex_shamt_or_data1 = (Ex_ALUSrc1)?Ex_shamt:Ex_Data1;
// assign Ex_imm_or_data2 = (Ex_ALUSrc2)?Ex_immediate:Ex_Data2;
// mux4_1 mux_aluin1(Ex_shamt_or_data1,MEM_ALUout,WB_Write_data,Ex_ALUin1,Forward1);
// mux4_1 mux_aluin2(Ex_imm_or_data2,MEM_ALUout,WB_Write_data,Ex_ALUin2,Forward2);

mux4_1 mux_aluin1(Ex_Data1,MEM_ALUout,WB_Write_data,Ex_Data_or_Forward1,Forward1);
mux4_1 mux_aluin2(Ex_Data2,MEM_ALUout,WB_Write_data,Ex_Data_or_Forward2,Forward2);
// assign Ex_Data_or_Forward1 = (Forward1 == 00)?Ex_Data1:
//                             (Forward1 == 01)?WB_Write_data:
//                             (Forward1 == 10)?MEM_ALUout:32'h0;
// assign Ex_Data_or_Forward2 = (Forward2 == 00)?Ex_Data2:
//                             (Forward2 == 01)?WB_Write_data:
//                             (Forward2 == 10)?MEM_ALUout:32'h0;             
assign Ex_ALUin1 = (Ex_ALUSrc1)?Ex_shamt:Ex_Data_or_Forward1;
assign Ex_ALUin2 = (Ex_ALUSrc2)?Ex_immediate:Ex_Data_or_Forward2;


ALUControl alucontrol(Ex_ALUOp,Ex_Funct,Ex_ALUCtl,Ex_ALU_sign);
ALU alu(Ex_ALUin1,Ex_ALUin2,Ex_ALUCtl,Ex_ALU_sign,Ex_ALUout,Ex_ALUz);

//EX/MEM registers
EX_MEM_reg ex_mem_registers(clk,reset,Ex_RegWrite,Ex_MemtoReg,Ex_MemWrite,
    Ex_MemRead,Ex_Branchpc,Ex_ALUz,Ex_ALUout,Ex_Data2,Ex_rd,Ex_PCadd4,
    MEM_RegWrite,MEM_MemtoReg,MEM_MemWrite,MEM_MemRead,
    MEM_Branchpc,MEM_zero,MEM_ALUout,MEM_Data2,MEM_rd,MEM_PCadd4);


//-------------------------------------stage4-------------------------------------
//--------------------------------------MEM--------------------------------------
dataMemory data_memory(reset,clk,MEM_MemRead,MEM_MemWrite,
    MEM_ALUout,MEM_Data2,MEM_MemReadData,BCDout);

//MEM/WB registers
MEM_WB_reg mem_wb_registers(clk,reset,MEM_RegWrite,MEM_MemtoReg,
    MEM_ALUout,MEM_MemReadData,MEM_rd,MEM_PCadd4,MEM_MemWrite,
    WB_RegWrite,WB_MemtoReg,WB_ALUout,WB_MemReadData,WB_rd,WB_PCadd4,WB_MemWrite);


//-------------------------------------stage5-------------------------------------
//--------------------------------------WB--------------------------------------
mux3_1wb mux_memory2register(WB_ALUout,WB_MemReadData,
    WB_MemtoReg,WB_Write_data);

endmodule
