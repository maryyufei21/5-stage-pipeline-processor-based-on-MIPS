`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/26 19:54:29
// Design Name: 
// Module Name: registerFile
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

//�Ĵ�����֧����д�������?

module registerFile(
	input  reset                    , 
	input  clk                      ,
	input  RegWrite                 , //дʹ��
	input  [5 -1:0]  Read_register1 , 
	input  [5 -1:0]  Read_register2 , 
	input  [5 -1:0]  Write_register , //д��Ĵ���?
	input  [32 -1:0] Write_data     , //д������
	output [32 -1:0] Read_data1     , //op1
	output [32 -1:0] Read_data2     , //op2
	input [31:0] write_pc_plus4, 
	input jumpandlink_write
);

	// RF_data is an array of 32 32-bit registers
	// here RF_data[0] is not defined because RF_data[0] identically equal to 0
	reg [31:0] RF_data[31:1];
	
	// read data from RF_data as Read_data1 and Read_data2
	assign Read_data1 = (Read_register1 == 5'b00000)? 32'h00000000: RF_data[Read_register1];
	assign Read_data2 = (Read_register2 == 5'b00000)? 32'h00000000: RF_data[Read_register2];
	
	integer i;
	
	// write Wrtie_data to RF_data at clock posedge
	always @(posedge reset or posedge clk)
	begin
		if (reset)
			for (i = 1; i < 32; i = i + 1)
			begin
				RF_data[i] <= 32'h00000000;
				RF_data[29] <= 32'hfc;//sp��ʼλ��
			end
		else if (RegWrite && (Write_register != 5'b00000))
			RF_data[Write_register] <= Write_data;
		else if (jumpandlink_write)
			RF_data[31]<=write_pc_plus4;
    end

	
endmodule
			