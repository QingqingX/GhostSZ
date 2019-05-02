/*QX, CAAD, BU
* 2nd order model
* 36 cycles for output prediction data;
* 36 cycles for output absolute error
*/

module model2(
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

parameter IN_WIDTH=32;
parameter OUT_WIDTH=2;
input wire clk, rst;
input wire [IN_WIDTH-1:0] proceed1,proceed2, proceed3;
input wire [IN_WIDTH-1:0] data_in;
output wire [IN_WIDTH-1:0] data_out, error,real_error;
wire [IN_WIDTH-1:0] proceed2_3,proceed3_3, e_temp,p, p1,p2, p2_14, proceed1_1_28;
reg [IN_WIDTH-1:0] proceed1_1, proceed2_1, proceed2_2, proceed3_2,proceed3_1, in; 




//1st order model; not fully parameterized
always @ (posedge clk) begin
	if (rst) begin
		proceed2_1 = 'b0;
		proceed1_1 = 'b0;
		proceed2_2 = 'b0;
		proceed3_2 = 'b0;
		proceed3_1 = 'b0;
		in= 'b0;
	end
	else begin
		in= data_in;
		proceed2_1 = proceed2;
		proceed1_1 = proceed1;
		proceed3_1 = proceed3;
		proceed2_2 = {proceed2[31] , proceed2[30:23] + 8'b1, proceed2[22:0]};   //proceed*2  , 1 cycle
		proceed3_2 = {proceed3[31] , proceed3[30:23] + 8'b1, proceed3[22:0]};   //proceed*2  , 1 cycle
	end	
end
//2nd order model compute p[2] = 3*proceed[2] - 3*proceed[1] + proceed[0];


// computes proceed*3
fpaddsub add0(
	.add_sub('b1), //add:1
	.clock(clk),
	.dataa(proceed2_2),
	.datab(proceed2_1),
	.result(proceed2_3));
	
fpaddsub add1(
	.add_sub('b1), //add:1
	.clock(clk),
	.dataa(proceed3_2),
	.datab(proceed3_1),
	.result(proceed3_3));
	
// compute p[2] = 3*proceed[2] - 3*proceed[1]; this appears in adder_cycle*2
fpaddsub sub0(
	.add_sub('b0), //add:1
	.clock(clk),
	.dataa(proceed3_3),
	.datab(proceed2_3),
	.result(p));	


// optimization: doing error at the same time p2= proceed[0] - in


fpaddsub sub2(
	.add_sub('b0), //add:1
	.clock(clk),
	.dataa(proceed1_1),
	.datab(in),
	.result(p2));

shift #(32,12) sft14(
	.rst(rst),
	.clk(clk),
	.data(p2),
	.q(p2_14)
);

fpaddsub add2(
	.add_sub('b1), //add:1
	.clock(clk),
	.dataa(p),
	.datab(p2_14),
	.result(e_temp));
	
	
//compute dataout; store for 12*2+ 1 cycles
shift #(32,25) sft28(
	.rst(rst),
	.clk(clk),
	.data(proceed1_1),
	.q(proceed1_1_28)
);
fpaddsub add3(
	.add_sub('b1), //add:1
	.clock(clk),
	.dataa(p),
	.datab(proceed1_1_28),
	.result(p1));	
	
fpabs abs0(
	.data(e_temp),
	.result(error));

assign real_error = e_temp;
assign data_out = p1;
endmodule