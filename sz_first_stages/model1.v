/*QX, CAAD, BU
* 1st order model
* 12 cycles for output prediction data;
* 24 cycles for output absolute error
*/

module model1(
	rst,
	clk,
	proceed1,
	proceed2,
	data_in,
	error,
	real_error,
	data_out
);

parameter IN_WIDTH=32;
parameter OUT_WIDTH=2;
input wire clk, rst;
input wire [IN_WIDTH-1:0] proceed1,proceed2;
input wire [IN_WIDTH-1:0] data_in;
output wire [IN_WIDTH-1:0] data_out, error,real_error;
wire [IN_WIDTH-1:0] e_temp,p,data_in14;
reg [IN_WIDTH-1:0] proceed1_1, proceed2_2,in; 




//1st order model; not fully parameterized
always @ (posedge clk) begin
	if (rst) begin
		proceed1_1 = 'b0;
		proceed2_2 = 'b0;
		in= 'b0;
	end
	else begin
		in= data_in;
		proceed1_1 = proceed1;
		proceed2_2 = {proceed2[31] , proceed2[30:23] + 8'b1, proceed2[22:0]};   //proceed*2  , 1 cycle
	end	
end

	
// compute p[1]: p[1] = 2*proceed[2] - proceed[1]
fpaddsub sub0(
	.add_sub('b0), //add:1
	.clock(clk),
	.dataa(proceed2_2),
	.datab(proceed1_1),
	.result(p));	

//compute error error= p-in(in is stored for 12 cycles; but the shift cycle+1)
shift #(32,13) sft14(
	.rst(rst),
	.clk(clk),
	.data(in),
	.q(data_in14)
);
	
fpaddsub sub1(
	.add_sub('b0), //add:1
	.clock(clk),
	.dataa(p),
	.datab(data_in14),
	.result(e_temp));	
fpabs abs0(
	.data(e_temp),
	.result(error));

assign real_error = e_temp;
assign data_out = p;
endmodule