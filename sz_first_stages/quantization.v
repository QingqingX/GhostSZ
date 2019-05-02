/*qx, CAAD, BU, 01012019
***49 cycles 
*/
`define ERROR2 'h3951b717   //-04e 0.0002

module quantization(
	rst,
	clk,
	error,
	predict_in, 
	encode_in, //01: model0; 10: model1: 11: model2
	in_valid,
//	data_out,
	encode_out,
	quant_code,  //01: model0; 10: model1: 11: model2
	prediction_out,
	out_valid
);

parameter TYPE='b00;   //00:float; 01:double; 10: int; 11: float 
parameter WIDTH= 32; 
parameter OUT_WIDTH=2;
parameter QUANT=13;
//parameter ERROR = 0.0001;  //absolute error
wire [WIDTH-1:0] data_in,dram_in,dram_out,res0;

input wire [WIDTH-1:0] error, predict_in;
input wire rst,clk, in_valid;
input wire [OUT_WIDTH-1:0] encode_in;
output wire [QUANT:0] quant_code;
output wire [WIDTH-1:0] prediction_out;
output wire [OUT_WIDTH-1:0] encode_out;
output wire out_valid;
wire [OUT_WIDTH-1:0] encode_in54, encode_out6;
//output wire [WIDTH-1:0] data_out;


//math: e/EB ; 20 cycles

div div0(
	clk,
	error,
	`ERROR2,
	res0);

	
wire [15:0] result0;
wire [QUANT:0] code_out;
wire overflow0;
wire underflow0;
wire cannot_quant;
wire [QUANT:0] res_out;


//float2int; 6 cycles 
conv conv0(
	clk,
	res0,
	overflow0,
	result0,
	underflow0);

//multiply and add;  prediction- 2error_bound*step is the new prediction result
wire [WIDTH-1:0] res_tmp, pred, res_flt;
//convert step to float ; 5 cycles ; 31th cycle
conv_fix2flt conv1(
    clk,
    {result0[13], 18'b0,result0[12:0]},
    res_flt
    );

mult mult0(     //8 cycles
    rst,
    clk,
    res_flt,
    `ERROR2,
    res_tmp   //39th cycle
    );	

shift #(32,38) sft3(
	.rst(rst),
	.clk(clk),
	.data(predict_in),   //39th cycles
	.q(pred)   
);	

sub_fast sub(   //10 cycles   49th cycle
        clk,
        pred,
        res_tmp,
        prediction_out
        );

//encode_in needs to be buffered for 13 cycles

shift #(2,26) sft0(
	.rst(rst),
	.clk(clk),
	.data(encode_in),   //26th cycle
	.q(encode_in54)   
);	
	
/*	
mux4 mux0(
    .aclr(rst),
    .clock(clk),
	.data0x({tmp0,overflow0,underflow0}),  // this is useless here 
	.data1x({tmp0,overflow0,underflow0}),
	.data2x({tmp1,overflow1,underflow1}),
	.data3x({tmp2,overflow2,underflow2}),
	.sel(encode_in54),
	.result(res_out));

assign cannot_quant=(res_out[1:0]!= 'b00); 
*/
 
assign cannot_quant=({overflow0,underflow0}!= 'b00);  //26th cycle
assign encode_out6=(cannot_quant)? 'b00: encode_in54;  //26th cycle
wire in_valid_tmp, out_valid6;
shift #(1,6) sft1(
	.rst(rst),
	.clk(clk),
	.data(in_valid),   //13cycles
	.q(in_valid_tmp)   
);	

//6th cycle
assign out_valid6 = in_valid_tmp && (~cannot_quant);   // both the input 13 cycles ago needs quant && current quant does not overflow

//delay the valid signals for 9 cycles
shift #(OUT_WIDTH,23) sft2(
	.rst(rst),
	.clk(clk),
	.data(encode_out6),   //13cycles
	.q(encode_out)   
);	
shift #(1,23) sft4(
	.rst(rst),
	.clk(clk),
	.data(out_valid6),   //13cycles
	.q(out_valid)   
);	

shift #(QUANT+1,23) sft5(
	.rst(rst),
	.clk(clk),
	.data(result0[QUANT:0]),   //13cycles
	.q(quant_code)   
);

endmodule








