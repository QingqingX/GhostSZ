`timescale 1 ns / 100 ps

module fit_1d_tb;
reg rst;
reg clk;
reg [31:0]  data_in, proceed1, proceed2, proceed3;
wire [1:0] data_out;
wire [31:0] prediction;


fit_1d_ooo ft(
	 rst,
	 clk,
	 data_in,
	 proceed1,
	 proceed2,
	 proceed3,
	 prediction,
	 data_out
);

always #1 clk=~clk;

initial begin
	clk=0;
	rst=1;
#13 rst=0;
	//1.5; 1.6, 1.3, 1.4, 1.5, 1.71,1.6
	data_in= 32'h3e6ee632;  //0.233300
	proceed1= 32'h3e702c81; //0.23454477, 0.234521, 0.234341,
	proceed2= 32'h3e702646;  
	proceed3= 32'h3e6ff716;
#2	data_in= 32'h3fa66666;  //1.3
	proceed1= 32'h3fdae148; //1.71, 1.6, 1.4,
	proceed2= 32'h3fe66666;
	proceed3= 32'h3fcccccd;

	
#160 rst=1;
#20 $stop;
end

	
	


endmodule