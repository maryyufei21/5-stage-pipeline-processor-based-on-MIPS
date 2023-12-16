`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/26 21:54:13
// Design Name: 
// Module Name: dataMemory
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

module dataMemory(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data  ,
	output reg [11:0] BCDout
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 512;
	parameter RAM_SIZE_BIT  = 9;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];
	wire [8:0] address;
	assign address = Address[RAM_SIZE_BIT + 1:2];

	// read data from RAM_data as Read_data
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)
		if (reset)
		begin
			RAM_data[0]<=32'h6;
			RAM_data[1]<=32'h0;
			RAM_data[2]<=32'h9;
			RAM_data[3]<=32'h3;
			RAM_data[4]<=32'h6;
			RAM_data[5]<=32'hffffffff;
			RAM_data[6]<=32'hffffffff;
			for(i=7;i<33;i=i+1)
				RAM_data[i]<=32'h00000000;
			RAM_data[33]<=32'h9;
			RAM_data[34]<=32'h0;
			RAM_data[35]<=32'hffffffff;
			RAM_data[36]<=32'h3;
			RAM_data[37]<=32'h4;
			RAM_data[38]<=32'h1;
			for(i=39;i<65;i=i+1)
				RAM_data[i]<=32'h00000000;
			RAM_data[65]<=32'h3;
			RAM_data[66]<=32'hffffffff;
			RAM_data[67]<=32'h0;
			RAM_data[68]<=32'h2;
			RAM_data[69]<=32'hffffffff;
			RAM_data[70]<=32'h5;
			for(i=71;i<97;i=i+1)
				RAM_data[i]<=32'h00000000;
			RAM_data[97]<=32'h6;
			RAM_data[98]<=32'h3;
			RAM_data[99]<=32'h2;
			RAM_data[100]<=32'h0;
			RAM_data[101]<=32'h6;
			RAM_data[102]<=32'hffffffff;
			for(i=103;i<129;i=i+1)
				RAM_data[i]<=32'h00000000;
			RAM_data[129]<=32'hffffffff;
			RAM_data[130]<=32'h4;
			RAM_data[131]<=32'hffffffff;
			RAM_data[132]<=32'h6;
			RAM_data[133]<=32'h0;
			RAM_data[134]<=32'h2;
			for(i=135;i<161;i=i+1)
				RAM_data[i]<=32'h00000000;
			RAM_data[161]<=32'hffffffff;
			RAM_data[162]<=32'h1;
			RAM_data[163]<=32'h5;
			RAM_data[164]<=32'hffffffff;
			RAM_data[165]<=32'h2;
			for(i=166;i<512;i=i+1)
				RAM_data[i]<=32'h00000000;
		end	
		else if (MemWrite)
		begin
		if(Address[31:28]==4'h4)
		begin
			BCDout<=Write_data[11:0];
		end
		else
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
endmodule

