module EX_MEM_reg(
clk,reset,
Ex_RegWrite,Ex_MemtoReg,Ex_MemWrite,Ex_MemRead,
Ex_Branchpc,Ex_zero,Ex_ALUout,Ex_DataB,Ex_rd,Ex_PCadd4,
MEM_RegWrite,MEM_MemtoReg,MEM_MemWrite,MEM_MemRead,
MEM_Branchpc,MEM_zero,MEM_ALUout,MEM_DataB,MEM_rd,MEM_PCadd4
);

input clk,reset;
input Ex_RegWrite,Ex_MemWrite,Ex_MemRead,Ex_zero;
input [1:0] Ex_MemtoReg;
input [31:0] Ex_Branchpc,Ex_ALUout,Ex_DataB;
input [4:0] Ex_rd;
input [31:0] Ex_PCadd4;

output reg MEM_RegWrite,MEM_MemWrite,MEM_MemRead,MEM_zero;
output reg [1:0] MEM_MemtoReg;
output reg [31:0] MEM_Branchpc,MEM_ALUout,MEM_DataB;
output reg [4:0] MEM_rd;
output reg [31:0] MEM_PCadd4;

always @(posedge clk)
begin
    if(reset)
    begin
        MEM_RegWrite<=0;
        MEM_MemWrite<=0;
        MEM_MemRead<=0;
        MEM_zero<=0;
        MEM_MemtoReg<=2'b00;
        MEM_Branchpc<=32'h0000;
        MEM_ALUout<=32'h0000;
        MEM_DataB<=32'h0000;
        MEM_rd<=5'b00000;
        MEM_PCadd4<=32'h0000;
    end
    else
    begin
        MEM_RegWrite<=Ex_RegWrite;
        MEM_MemWrite<=Ex_MemWrite;
        MEM_MemRead<=Ex_MemRead;
        MEM_zero<=Ex_zero;
        MEM_MemtoReg<=Ex_MemtoReg;
        MEM_Branchpc<=Ex_Branchpc;
        MEM_ALUout<=Ex_ALUout;
        MEM_DataB<=Ex_DataB;
        MEM_rd<=Ex_rd;
        MEM_PCadd4<=Ex_PCadd4;
    end
end

endmodule