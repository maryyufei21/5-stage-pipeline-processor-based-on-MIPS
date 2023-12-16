`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 10:53:33
// Design Name: 
// Module Name: mux2_1wb
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


module mux3_1wb(
WB_ALUout,WB_MemReadData,select,WB_RegDatain
    );
input [31:0] WB_ALUout,WB_MemReadData;
input [1:0] select;
output [31:0] WB_RegDatain;

assign WB_RegDatain = (select==2'b00)?WB_ALUout:
                    (select==2'b01)?WB_MemReadData:32'd0;


endmodule
