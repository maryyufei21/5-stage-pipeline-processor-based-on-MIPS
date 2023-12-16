module MEM_WB_reg(
clk,reset,
MEM_RegWrite,MEM_MemtoReg,MEM_ALUout,MEM_MemReadData,MEM_rd,MEM_PCadd4,MEM_MemWrite,
WB_RegWrite,WB_MemtoReg,WB_ALUout,WB_MemReadData,WB_rd,WB_PCadd4,WB_MemWrite
);
input clk,reset;
input MEM_RegWrite;
input [1:0] MEM_MemtoReg;
input [31:0] MEM_ALUout,MEM_MemReadData;
input [4:0] MEM_rd;
input [31:0] MEM_PCadd4;
input MEM_MemWrite;

output reg WB_RegWrite;
output reg [1:0] WB_MemtoReg;
output reg [31:0] WB_ALUout,WB_MemReadData;
output reg [4:0] WB_rd;
output reg [31:0] WB_PCadd4;
output reg WB_MemWrite;

always @(posedge clk)
begin
    if(reset)
    begin
        WB_RegWrite<=0;
        WB_MemtoReg<=2'b00;
        WB_ALUout<=32'h0000;
        WB_MemReadData<=32'h0000;
        WB_rd<=32'h0000;
        WB_PCadd4<=32'h0000;
        WB_MemWrite<=1'b0;
    end
    else
    begin
        WB_RegWrite<=MEM_RegWrite;
        WB_MemtoReg<=MEM_MemtoReg;
        WB_ALUout<=MEM_ALUout;
        WB_MemReadData<=MEM_MemReadData;
        WB_rd<=MEM_rd;
        WB_PCadd4<=MEM_PCadd4;
        WB_MemWrite<=MEM_MemWrite;
    end
end

endmodule