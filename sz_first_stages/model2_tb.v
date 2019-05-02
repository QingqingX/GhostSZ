`timescale 1 ns / 100 ps

module model2_tb;
reg rst;
reg clk;
reg [31:0]  proceed1;
reg [31:0]  proceed2;
reg [31:0]  proceed3;
reg [31:0]  data_in;
wire [31:0] error, real_error;
wire [31:0] data_out;



model2 model(
	rst,
	clk,
	proceed1,
	proceed2,
	proceed3,
	data_in,
	error,
	real_error,
	data_out
);

always #1 clk=~clk;

initial begin
	clk=0;
	rst=1;
#11 rst=0;
	//1.5; 1.6; 1.3 in: 1.71   ;; 11th cycle input; 83th cycle output 
	proceed1= 32'h3fc00000;
	proceed2= 32'h3fcccccd;
	proceed3= 32'h3fa66666;
	data_in = 32'h3fdae148;
#2  //1.6, 1.5, 1.7 ; in:1.3
	proceed1= 32'h3fcccccd;
	proceed2= 32'h3fc00000;
	proceed3= 32'h3fd9999a;
	data_in = 32'h3fa66666;
#2  //1.3, 1.6; 1.5 in 1.7
	proceed1= 32'h3fa66666;
	proceed2= 32'h3fcccccd;
	proceed3= 32'h3fc00000;
	data_in = 32'h3fd9999a;	
	
#160 rst=1;
#20 $stop;
end

	
	


endmodule