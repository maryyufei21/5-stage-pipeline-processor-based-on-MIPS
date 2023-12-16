module IF_ID_reg(clk,reset,IF_PCadd4,IF_Inst,
flush,flushB,stall,ID_PCadd4,ID_Inst);

input clk,reset;
input [31:0] IF_PCadd4,IF_Inst;
input stall,flush,flushB;

output reg [31:0] ID_Inst;
output reg [31:0] ID_PCadd4;

always @ (posedge clk)
begin
    if(reset)
    begin
        ID_Inst<=32'd0;
        ID_PCadd4<=32'd0;
    end
    else
    begin
       if(flush || flushB)
       begin
        ID_Inst<=32'd0;
        ID_PCadd4<=32'd0;
       end
       else if(stall)
       begin
        ID_Inst<=ID_Inst;
        ID_PCadd4<=ID_PCadd4;
       end
       else
       begin
        ID_Inst<=IF_Inst;
        ID_PCadd4<=IF_PCadd4;
       end
    end
end
endmodule