`define ERROR 'h38d1b717   //-04e 0.0001
/********************************
* QX, CAAD, BU, 12/2018
* Out of order processing next element
* The critical loop is 43 cycles for prediction result. 42 cycles for the encode
* Thus using this to avoid data dependancy.
*********************************/

module fit_1d_ooo(
	 rst,
	 clk,
	 data_in, //calculate 4
	 proceed1,
	 proceed2,
	 proceed3,
	 real_error,
	 prediction,
	 real_predict,
	 data_out,
	 encode_phase2   // this is the cloest model to the original data, regardless of the Errorbound; //01: model0; 10: model1: 11: model2
);

parameter IN_WIDTH=32;
parameter OUT_WIDTH=2;
input wire clk, rst;
input wire [IN_WIDTH-1:0] data_in;
output wire  [OUT_WIDTH-1:0] data_out;
output wire [IN_WIDTH-1:0] prediction, real_predict, real_error;
input wire [31:0]  proceed1, proceed2, proceed3;
output wire [OUT_WIDTH-1:0] encode_phase2;

wire [IN_WIDTH-1:0] proceed2_2, proceed1_2, e_temp,e_temp14,error_abs;
wire [IN_WIDTH-1:0] error0_28, error0_31, error1_31, error1_28, error2_42, error1_42, out1_14, out2_42, error0_42;
wire [IN_WIDTH-1:0] real_error1_28,real_error2_42,real_error1_42,real_error0_42;
wire [IN_WIDTH-1:0] error_stage1_42,error_stage1_45, error2_45, out1_48, out2_48;
wire [IN_WIDTH-1:0] real_error42, out,error [2^OUT_WIDTH-1:0];
reg [IN_WIDTH-1:0] proceed [2^OUT_WIDTH-1:0]; 
//wire rst;//triggers models after 3 cycles, 
reg [OUT_WIDTH-1:0] p,e [2^OUT_WIDTH-1:0];
wire cmp_0lessthan1, cmp_1lessthan2,not_predict, cmp_1lessthan2_48, cmp_0lessthan1_48, cmp_0lessthan2, cmp_0lessthan2_48;
wire [IN_WIDTH-1:0] error_stage1,error_stage2,data_in_48, proceed3_48;
reg [IN_WIDTH-1:0]  in, proceed3_1;
//proceding value; first 3 cycles; store original values 



//assign rst = reset;
/**************DFF to avoid metastability**************/
always @ (posedge clk) begin
	if (rst) begin
		in= 'b0;
		proceed3_1 <= 'b0;
	end
	else begin
		in= data_in;
		proceed3_1 <= proceed3;
	end	
end

//assign data_out= data_out_t;
//0 order model;12 cycle error; 0 cycle predict: p[0] = proceed[2];
//compute error
fpaddsub sub0(
	.add_sub('b0), //add:1
	.clock(clk),
	.dataa(proceed3_1),
	.datab(in),
	.result(e_temp));	
fpabs abs0(
	.data(e_temp),
	.result(e_temp14));
//wait for 12 cycles; compare with 1st order's error
shift #(32,12) sft0(
	.rst(rst),
	.clk(clk),
	.data(e_temp14),
	.q(error0_28)   //24th cycle
);
//comp takes 3 cycles
shift #(32,3) sft1(
	.rst(rst),
	.clk(clk),
	.data(error0_28),
	.q(error0_31)   //27th cycle
);
shift #(32,3) sft2(
	.rst(rst),
	.clk(clk),
	.data(error1_28),
	.q(error1_31)   //27th cycle
);

shift #(32,24) sft14(
	.rst(rst),
	.clk(clk),
	.data(e_temp),
	.q(real_error0_42)    //36th cycle
);

shift #(32,12) sft15(
	.rst(rst),
	.clk(clk),
	.data(real_error1_28),
	.q(real_error1_42)    //36th cycle
);

comp cmp0(
	//.aclr(rst),
	.clock(clk),
	.dataa(error0_28),
	.datab(error1_28),
	.alb(cmp_0lessthan1)); //a<b 1   3cycles; 27th cycle
assign error_stage1= cmp_0lessthan1 ? error0_31:error1_31;  //27th cycle


model1 md1(
	.rst(rst),
	.clk(clk),
	.proceed1(proceed2),
	.proceed2(proceed3),
	.data_in(data_in),
	.error(error1_28),
	.real_error(real_error1_28),   //24th cycle
	.data_out(out1_14)     //12th cycle
);

model2 md2(
	.rst(rst),
	.clk(clk),
	.proceed1(proceed1),
	.proceed2(proceed2),
	.proceed3(proceed3),
	.data_in(data_in),
	.error(error2_42),
	.real_error(real_error2_42),  //36th cycle
	.data_out(out2_42)     //36th cycle
);

//wait for 9 cycles; the winner of first comparison compares with new error
shift #(32,9) sft3(
	.rst(rst),
	.clk(clk),
	.data(error_stage1),
	.q(error_stage1_42)     
);
comp cmp1(
	//.aclr(rst),
	.clock(clk),
	.dataa(error_stage1_42),
	.datab(error2_42),
	.alb(cmp_1lessthan2)); //a<b 1  this takes 3 cycles;39th cycle

shift #(32,12) sft12(
	.rst(rst),
	.clk(clk),
	.data(error0_28),
	.q(error0_42)
);
	
comp cmp2(
	//.aclr(rst),
	.clock(clk),
	.dataa(error0_42),
	.datab(error2_42),
	.alb(cmp_0lessthan2)); //a<b 1  ;39th cycle
	
shift #(32,3) sft4(
	.rst(rst),
	.clk(clk),
	.data(error_stage1_42),
	.q(error_stage1_45)  //;39th cycle
);
shift #(32,3) sft5(
	.rst(rst),
	.clk(clk),
	.data(error2_42),
	.q(error2_45)    //;39th cycle
);
assign error_stage2= (cmp_1lessthan2 | cmp_0lessthan2)? error_stage1_45:error2_45;

//comprare with absolute error
fpabs abs1(
	.data(error_stage2),   //39th
	.result(error_abs));
comp cmp3(
	//.aclr(rst),
	.clock(clk),
	.dataa(`ERROR),
	.datab(error_abs),  //39th
	.alb(not_predict)); //a<b 1  42th cycle

//output the results to data_out: 2bits
shift #(1,15) sft6(
	.rst(rst),
	.clk(clk),
	.data(cmp_0lessthan1),   //comp result from27 to 42
	.q(cmp_0lessthan1_48)
);

shift #(1,3) sft7(
	.rst(rst),
	.clk(clk),
	.data(cmp_1lessthan2),   //comp result from39 to 42
	.q(cmp_1lessthan2_48)
);

shift #(1,3) sft13(
	.rst(rst),
	.clk(clk),
	.data(cmp_0lessthan2),   //comp result from39 to 42
	.q(cmp_0lessthan2_48)
);

assign real_error42=(encode_phase2=='b01) ? real_error0_42 : ((encode_phase2=='b10) ? real_error1_42 :real_error2_42);

shift #(32,6) sft_realerror(
	.rst(rst),
	.clk(clk),
	.data(real_error42),   //comp result from39 to 42
	.q(real_error)
);


//comparing the error from three models and the error bound; and decide which model to use
//01: model0; 10: model1: 11: model2
assign encode_phase2 = {((~cmp_0lessthan1_48& cmp_1lessthan2_48) | (~cmp_1lessthan2_48 & ~cmp_0lessthan2_48)), 
						((cmp_0lessthan1_48& cmp_1lessthan2_48&cmp_0lessthan2_48) | (~cmp_1lessthan2_48 & ~cmp_0lessthan2_48))};
						
assign data_out = {~not_predict&encode_phase2[1],
						~not_predict&encode_phase2[0]};  //42th cycl
//assign real_predict = (encode_phase2=='b01)? proceed3_48 : ((encode_phase2=='b10)? out1_48 : out2_48); //44 cycle
mux4 mx1(
	.aclr(rst),
	.clock(clk),
	.data0x(data_in_48),
	.data1x(proceed3_48),
	.data2x(out1_48),
	.data3x(out2_48),
	.sel(encode_phase2),
	.result(real_predict));  //44 cycle
	
shift #(32,43) sft8(
	.rst(rst),
	.clk(clk),
	.data(data_in),   //comp result from0 to 42
	.q(data_in_48)
);
shift #(32,43) sf9(
	.rst(rst),
	.clk(clk),
	.data(proceed3),   //comp result from0 to 42
	.q(proceed3_48)
);
shift #(32,30) sf10(
	.rst(rst),
	.clk(clk),
	.data(out1_14),   //comp result from12 to 42
	.q(out1_48)
);
shift #(32,6) sf11(
	.rst(rst),
	.clk(clk),
	.data(out2_42),   //comp result from36 to 42
	.q(out2_48)
);

//select predict result based on which model used
//take 1 cyle; 423th cycle ; dataout come at 43 th cycle
mux4 mx0(
	.aclr(rst),
	.clock(clk),
	.data0x(data_in_48),
	.data1x(proceed3_48),
	.data2x(out1_48),
	.data3x(out2_48),
	.sel(data_out),
	.result(prediction));

endmodule