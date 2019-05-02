/*qx, CAAD, BU, 12072018*/
/*stream in horizontally, fit vertically for filling in pipelne bubbles
* each row:128points
*/

module sz_inner(
	rst,
	clk,
	data_in,
    enable, //new added to tell the pipelines the data is here
	data_out,
	data_out_valid,
	phase2_data_out,
	phase2_valid,
	phase3_data_out,  //62 th cycle
	phase3_valid
);

parameter TYPE='b00;   //00:float; 01:double; 10: int; 11: float 
parameter IN_WIDTH= 32; 
parameter OUT_WIDTH=2;
parameter XDIM=128;   //has to be parameterizable for the number of cycle regions
parameter XBITS=7;
parameter QUANT=13;
parameter ROW = 1000;
//parameter ERROR = 0.0001;  //absolute error
//stream data in; having a FIFO/buffer to store
input wire rst,clk,enable;
input wire [IN_WIDTH-1:0] data_in;
output wire [OUT_WIDTH-1:0] data_out;
output wire [(QUANT+2):0] phase2_data_out;
output wire [IN_WIDTH-1:0] phase3_data_out;
output wire phase2_valid,phase3_valid,data_out_valid; 

wire [OUT_WIDTH-1:0] encode;
wire [QUANT:0] quant_encode;   //higher two bits for fitting code, lower 8 for quantization code
wire [IN_WIDTH-1:0] p1[XDIM-1:0],p2[XDIM-1:0],p3[XDIM-1:0]; 
wire [IN_WIDTH-1:0] proceed1,proceed2,proceed3,prediction, data,data_in5;
wire [IN_WIDTH-1:0] real_error;
wire [XDIM-1:0] move2, move; 
wire [XDIM-1:0] move1;
wire need_quant;
//stream data from the three rows' buffer; get into the fitting model: a lot of shift buffers
// data_in goes to different row each cycle; till the end of the row  (row has a width); default 50>49

genvar i;
generate //1 cycle delay; no delay
	for (i=0; i<=XDIM-1; i=i+1) begin: buffer
     row_buffer #(32, 4) rb(
			.rst(rst),
			.clk(clk),
			.move(move[i]), //every 43 cycles, move high for one cycle
			.data(data),
			.q1(p1[i]),
			.q2(p2[i]),
			.q3(p3[i])  //closet to the current p4
		);
	end 
endgenerate

integer row;
reg [6:0] counter;

assign data= (row<3)?data_in:prediction;


always @ (posedge clk) begin
	if (rst) begin
		counter <= {7{1'b1}};		
	end else if (enable) begin
		counter <= counter + 7'd1;		
	end else begin
	    counter <= counter;
	end
end

always @ (posedge clk) begin
	if (rst) begin
        row = 0;
    end else if (enable &&(counter == {7{1'b1}})) begin
        row = row + 1;
    end
end
    
assign move1 = 'b1 << counter;


assign move = move1;

wire [6:0] sel;
assign sel= counter;

//mux has 4 cycles delay; this means there should be 3 bubbles before the 3th row's data_in


mux128 mux1(
	.aclr(rst),
	.clock(clk),
	.data0x(p1[0]),
	.data10x(p1[10]),
	.data11x(p1[11]),
	.data12x(p1[12]),
	.data13x(p1[13]),
	.data14x(p1[14]),
	.data15x(p1[15]),
	.data16x(p1[16]),
	.data17x(p1[17]),
	.data18x(p1[18]),
	.data19x(p1[19]),
	.data1x(p1[1]),
	.data20x(p1[20]),
	.data21x(p1[21]),
	.data22x(p1[22]),
	.data23x(p1[23]),
	.data24x(p1[24]),
	.data25x(p1[25]),
	.data26x(p1[26]),
	.data27x(p1[27]),
	.data28x(p1[28]),
	.data29x(p1[29]),
	.data2x(p1[2]),
	.data30x(p1[30]),
	.data31x(p1[31]),
	.data32x(p1[32]),
	.data33x(p1[33]),
	.data34x(p1[34]),
	.data35x(p1[35]),
	.data36x(p1[36]),
	.data37x(p1[37]),
	.data38x(p1[38]),
	.data39x(p1[39]),
	.data3x(p1[3]),
	.data40x(p1[40]),
    .data41x(p1[41]),
    .data42x(p1[42]),
    .data43x(p1[43]),
    .data44x(p1[44]),    
    .data45x(p1[45]),
    .data46x(p1[46]),
    .data47x(p1[47]),
    .data48x(p1[48]),
    .data49x(p1[49]),
	.data50x(p1[50]),
    .data51x(p1[51]),
    .data52x(p1[52]),
    .data53x(p1[53]),
    .data54x(p1[54]),    
    .data55x(p1[55]),
    .data56x(p1[56]),
    .data57x(p1[57]),
    .data58x(p1[58]),
    .data59x(p1[59]),
	.data60x(p1[60]),
    .data61x(p1[61]),
    .data62x(p1[62]),
    .data63x(p1[63]),
	.data4x(p1[4]),
	.data5x(p1[5]),
	.data6x(p1[6]),
	.data7x(p1[7]),
	.data8x(p1[8]),
	.data9x(p1[9]),
	
	.data0y(p1[64]),
    .data10y(p1[74]),
    .data11y(p1[75]),
    .data12y(p1[76]),
    .data13y(p1[77]),
    .data14y(p1[78]),
    .data15y(p1[79]),
    .data16y(p1[80]),
    .data17y(p1[81]),
    .data18y(p1[82]),
    .data19y(p1[83]),
    .data1y(p1[65]),
    .data20y(p1[84]),
    .data21y(p1[85]),
    .data22y(p1[86]),
    .data23y(p1[87]),
    .data24y(p1[88]),
    .data25y(p1[89]),
    .data26y(p1[90]),
    .data27y(p1[91]),
    .data28y(p1[92]),
    .data29y(p1[93]),
    .data2y(p1[66]),
    .data30y(p1[94]),
    .data31y(p1[95]),
    .data32y(p1[96]),
    .data33y(p1[97]),
    .data34y(p1[98]),
    .data35y(p1[99]),
    .data36y(p1[100]),
    .data37y(p1[101]),
    .data38y(p1[102]),
    .data39y(p1[103]),
    .data3y(p1[67]),
    .data40y(p1[104]),
    .data41y(p1[105]),
    .data42y(p1[106]),
    .data43y(p1[107]),
    .data44y(p1[108]),    
    .data45y(p1[109]),
    .data46y(p1[110]),
    .data47y(p1[111]),
    .data48y(p1[112]),
    .data49y(p1[113]),
    .data50y(p1[114]),
    .data51y(p1[115]),
    .data52y(p1[116]),
    .data53y(p1[117]),
    .data54y(p1[118]),    
    .data55y(p1[119]),
    .data56y(p1[120]),
    .data57y(p1[121]),
    .data58y(p1[122]),
    .data59y(p1[123]),
    .data60y(p1[124]),
    .data61y(p1[125]),
    .data62y(p1[126]),
    .data63y(p1[127]),
    .data4y(p1[68]),
    .data5y(p1[69]),
    .data6y(p1[70]),
    .data7y(p1[71]),
    .data8y(p1[72]),
    .data9y(p1[73]),
	.sel(sel),
	.result(proceed1));
	

mux128 mux2(
	.aclr(rst),
	.clock(clk),
	.data0x(p2[0]),
	.data10x(p2[10]),
	.data11x(p2[11]),
	.data12x(p2[12]),
	.data13x(p2[13]),
	.data14x(p2[14]),
	.data15x(p2[15]),
	.data16x(p2[16]),
	.data17x(p2[17]),
	.data18x(p2[18]),
	.data19x(p2[19]),
	.data1x(p2[1]),
	.data20x(p2[20]),
	.data21x(p2[21]),
	.data22x(p2[22]),
	.data23x(p2[23]),
	.data24x(p2[24]),
	.data25x(p2[25]),
	.data26x(p2[26]),
	.data27x(p2[27]),
	.data28x(p2[28]),
	.data29x(p2[29]),
	.data2x(p2[2]),
	.data30x(p2[30]),
	.data31x(p2[31]),
	.data32x(p2[32]),
	.data33x(p2[33]),
	.data34x(p2[34]),
	.data35x(p2[35]),
	.data36x(p2[36]),
	.data37x(p2[37]),
	.data38x(p2[38]),
	.data39x(p2[39]),
	.data3x(p2[3]),
	.data40x(p2[40]),
	.data41x(p2[41]),
	.data42x(p2[42]),
	.data43x(p2[43]),
	.data44x(p2[44]),
	.data45x(p2[45]),
    .data46x(p2[46]),
    .data47x(p2[47]),
    .data48x(p2[48]),
    .data49x(p2[49]),
    .data50x(p2[50]),
    .data51x(p2[51]),
    .data52x(p2[52]),
    .data53x(p2[53]),
    .data54x(p2[54]),    
    .data55x(p2[55]),
    .data56x(p2[56]),
    .data57x(p2[57]),
    .data58x(p2[58]),
    .data59x(p2[59]),
    .data60x(p2[60]),
    .data61x(p2[61]),
    .data62x(p2[62]),
    .data63x(p2[63]),
	.data4x(p2[4]),
	.data5x(p2[5]),
	.data6x(p2[6]),
	.data7x(p2[7]),
	.data8x(p2[8]),
	.data9x(p2[9]),
	
    .data0y(p2[64]),
    .data10y(p2[74]),
    .data11y(p2[75]),
    .data12y(p2[76]),
    .data13y(p2[77]),
    .data14y(p2[78]),
    .data15y(p2[79]),
    .data16y(p2[80]),
    .data17y(p2[81]),
    .data18y(p2[82]),
    .data19y(p2[83]),
    .data1y(p2[65]),
    .data20y(p2[84]),
    .data21y(p2[85]),
    .data22y(p2[86]),
    .data23y(p2[87]),
    .data24y(p2[88]),
    .data25y(p2[89]),
    .data26y(p2[90]),
    .data27y(p2[91]),
    .data28y(p2[92]),
    .data29y(p2[93]),
    .data2y(p2[66]),
    .data30y(p2[94]),
    .data31y(p2[95]),
    .data32y(p2[96]),
    .data33y(p2[97]),
    .data34y(p2[98]),
    .data35y(p2[99]),
    .data36y(p2[100]),
    .data37y(p2[101]),
    .data38y(p2[102]),
    .data39y(p2[103]),
    .data3y(p2[67]),
    .data40y(p2[104]),
    .data41y(p2[105]),
    .data42y(p2[106]),
    .data43y(p2[107]),
    .data44y(p2[108]),    
    .data45y(p2[109]),
    .data46y(p2[110]),
    .data47y(p2[111]),
    .data48y(p2[112]),
    .data49y(p2[113]),
    .data50y(p2[114]),
    .data51y(p2[115]),
    .data52y(p2[116]),
    .data53y(p2[117]),
    .data54y(p2[118]),    
    .data55y(p2[119]),
    .data56y(p2[120]),
    .data57y(p2[121]),
    .data58y(p2[122]),
    .data59y(p2[123]),
    .data60y(p2[124]),
    .data61y(p2[125]),
    .data62y(p2[126]),
    .data63y(p2[127]),
    .data4y(p2[68]),
    .data5y(p2[69]),
    .data6y(p2[70]),
    .data7y(p2[71]),
    .data8y(p2[72]),
    .data9y(p2[73]),
	.sel(sel),
	.result(proceed2));
	
mux128 mux3(
	.aclr(rst),
	.clock(clk),
	.data0x(p3[0]),
	.data10x(p3[10]),
	.data11x(p3[11]),
	.data12x(p3[12]),
	.data13x(p3[13]),
	.data14x(p3[14]),
	.data15x(p3[15]),
	.data16x(p3[16]),
	.data17x(p3[17]),
	.data18x(p3[18]),
	.data19x(p3[19]),
	.data1x(p3[1]),
	.data20x(p3[20]),
	.data21x(p3[21]),
	.data22x(p3[22]),
	.data23x(p3[23]),
	.data24x(p3[24]),
	.data25x(p3[25]),
	.data26x(p3[26]),
	.data27x(p3[27]),
	.data28x(p3[28]),
	.data29x(p3[29]),
	.data2x(p3[2]),
	.data30x(p3[30]),
	.data31x(p3[31]),
	.data32x(p3[32]),
	.data33x(p3[33]),
	.data34x(p3[34]),
	.data35x(p3[35]),
	.data36x(p3[36]),
	.data37x(p3[37]),
	.data38x(p3[38]),
	.data39x(p3[39]),
	.data3x(p3[3]),
	.data40x(p3[40]),
	.data41x(p3[41]),
	.data42x(p3[42]),
	.data43x(p3[43]),
	.data44x(p3[44]),
	.data45x(p3[45]),
    .data46x(p3[46]),
    .data47x(p3[47]),
    .data48x(p3[48]),
    .data49x(p3[49]),
    .data50x(p3[50]),
    .data51x(p3[51]),
    .data52x(p3[52]),
    .data53x(p3[53]),
    .data54x(p3[54]),    
    .data55x(p3[55]),
    .data56x(p3[56]),
    .data57x(p3[57]),
    .data58x(p3[58]),
    .data59x(p3[59]),
    .data60x(p3[60]),
    .data61x(p3[61]),
    .data62x(p3[62]),
    .data63x(p3[63]),
	.data4x(p3[4]),
	.data5x(p3[5]),
	.data6x(p3[6]),
	.data7x(p3[7]),
	.data8x(p3[8]),
	.data9x(p3[9]),
	
	.data0y(p3[64]),
    .data10y(p3[74]),
    .data11y(p3[75]),
    .data12y(p3[76]),
    .data13y(p3[77]),
    .data14y(p3[78]),
    .data15y(p3[79]),
    .data16y(p3[80]),
    .data17y(p3[81]),
    .data18y(p3[82]),
    .data19y(p3[83]),
    .data1y(p3[65]),
    .data20y(p3[84]),
    .data21y(p3[85]),
    .data22y(p3[86]),
    .data23y(p3[87]),
    .data24y(p3[88]),
    .data25y(p3[89]),
    .data26y(p3[90]),
    .data27y(p3[91]),
    .data28y(p3[92]),
    .data29y(p3[93]),
    .data2y(p3[66]),
    .data30y(p3[94]),
    .data31y(p3[95]),
    .data32y(p3[96]),
    .data33y(p3[97]),
    .data34y(p3[98]),
    .data35y(p3[99]),
    .data36y(p3[100]),
    .data37y(p3[101]),
    .data38y(p3[102]),
    .data39y(p3[103]),
    .data3y(p3[67]),
    .data40y(p3[104]),
    .data41y(p3[105]),
    .data42y(p3[106]),
    .data43y(p3[107]),
    .data44y(p3[108]),    
    .data45y(p3[109]),
    .data46y(p3[110]),
    .data47y(p3[111]),
    .data48y(p3[112]),
    .data49y(p3[113]),
    .data50y(p3[114]),
    .data51y(p3[115]),
    .data52y(p3[116]),
    .data53y(p3[117]),
    .data54y(p3[118]),    
    .data55y(p3[119]),
    .data56y(p3[120]),
    .data57y(p3[121]),
    .data58y(p3[122]),
    .data59y(p3[123]),
    .data60y(p3[124]),
    .data61y(p3[125]),
    .data62y(p3[126]),
    .data63y(p3[127]),
    .data4y(p3[68]),
    .data5y(p3[69]),
    .data6y(p3[70]),
    .data7y(p3[71]),
    .data8y(p3[72]),
    .data9y(p3[73]),
	.sel(sel),
	.result(proceed3));
	
/*******************Out of Order Fitting*********************/
//hold data_in for 5 cycles for calculating
shift #(32,4) sft0(
	.rst(rst),
	.clk(clk),
	.data(data_in),
	.q(data_in5)   //28cycle
);

//this takes 44 cycles!!!
wire [IN_WIDTH-1:0] prediction_tmp, prediction_fit, real_predict;
wire encode_valid; 
//430 cycles since the first data came 

wire finish;

assign finish = (row == ROW); 
assign encode_valid = ( ~(rst| (row<3)|(row==3 && counter<45)) ) && (~finish); //430 cycles after the first data, and 45 cycles after the last data
assign data_out_valid = encode_valid;
fit_1d_ooo #(.IN_WIDTH(IN_WIDTH), .OUT_WIDTH(OUT_WIDTH)) fit0(rst| (row<3)|(row==3 && counter<3), 
	clk, 
	data_in5, 
	proceed1, 
	proceed2, 
	proceed3, 
	real_error, 
	prediction_tmp, 
	real_predict,   //44th cycle
	data_out,  // this is the encode; 00 cannot predict
	encode);

//extend the fitting pipeline (quant takes49 but one cycle earlier than pred_fit) to match with prediction_quant
shift #(32,48) sft1(
	.rst(rst),
	.clk(clk),
	.data(prediction_tmp),
	.q(prediction_fit)   //28cycle
);
//calculating new 


/*******************Quantization, takes 49 cycles******************************/
assign need_quant = (data_out=='b0) && (~rst); 
wire quant_valid;
wire [IN_WIDTH-1:0] prediction_quant;
wire [OUT_WIDTH-1:0] encode_out,data_out49;
quantization quant0(
	rst,
	clk,
	real_error,    //43 cycles
	real_predict,  //the closest predicion; 44cycles
	encode,        //43 cycles
	need_quant, // needs quant
	encode_out,  //00: cannot fit or quant 
	quant_encode,  //14 bits
	prediction_quant, // new prediction
	quant_valid   //quant is used and isn't overflow
);

/****************hold the prediction result for quantization;
*****************if cannot quant, use the original
************************************************************/
wire [IN_WIDTH-1:0] prediction_out;

wire need_quant13;

shift #(1,13) needquant(
	.rst(rst),
	.clk(clk),
	.data(need_quant),   //48cycles
	.q(need_quant13)   
);	

shift #(2,49) encode_fromfit(
	.rst(rst),
	.clk(clk),
	.data(data_out),   //48cycles
	.q(data_out49)   
);
wire [IN_WIDTH-1:0] data_in96;

shift #(32,92) datain(
	.rst(rst),
	.clk(clk),
	.data(data_in5),
	.q(data_in96)   //28cycle
);
assign prediction_out =(data_out49!='b00) ? prediction_fit : (quant_valid ? prediction_quant : data_in96);
assign phase2_valid = quant_valid/*phase1 fails and quant not overflow*/;
assign phase2_data_out= {encode_out, quant_encode};
assign phase3_valid = (~phase2_valid)&&(encode_out=='b00); /*both phase1 & phase2 fail*/ //62th cycle
assign phase3_data_out= data_in96;  //original data


shift #(32,32) predata(
	.rst(rst),
	.clk(clk),
	.data(prediction_out),
	.q(prediction)   //64cycle
);

endmodule








