`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/22 23:11:57
// Design Name: 
// Module Name: top
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


module top(
clk,reset,BCDout
    );
    input clk,reset;
    output [11:0] BCDout;
    reg clk_for_cpu;
    reg count;
    always @(posedge clk)
    begin
        if(reset)
            begin
                clk_for_cpu <= 1'b0;
                count <= 1'b0;
            end
        else
            if(count == 0) count <= 1'b1;
            else if(count == 1)
            begin
                clk_for_cpu <= ~clk_for_cpu;
                count <= 1'b0;
            end
    end
    cpu mycpu(clk_for_cpu,reset,BCDout);
endmodule
