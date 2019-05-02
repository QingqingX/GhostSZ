`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/02/2019 03:50:40 PM
// Design Name:
// Module Name: mux45
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


module mux64(
	input aclr,
	input clock,
	input [31:0] data0x,
	input [31:0] data10x,
	input [31:0] data11x,
	input [31:0] data12x,
	input [31:0] data13x,
    input [31:0] data14x,
	input [31:0] data15x,
	input [31:0] data16x,
	input [31:0] data17x,
	input [31:0] data18x,
	input [31:0] data19x,
	input [31:0] data1x,
	input [31:0] data20x,
	input [31:0] data21x,
	input [31:0] data22x,
	input [31:0] data23x,
	input [31:0] data24x,
	input [31:0] data25x,
	input [31:0] data26x,
	input [31:0] data27x,
	input [31:0] data28x,
	input [31:0] data29x,
	input [31:0] data2x,
	input [31:0] data30x,
	input [31:0] data31x,
	input [31:0] data32x,
	input [31:0] data33x,
	input [31:0] data34x,
	input [31:0] data35x,
	input [31:0] data36x,
	input [31:0] data37x,
	input [31:0] data38x,
	input [31:0] data39x,
	input [31:0] data3x,
	input [31:0] data40x,
	input [31:0] data41x,
	input [31:0] data42x,
	input [31:0] data43x,
	input [31:0] data44x,
	input [31:0] data45x,
	input [31:0] data46x,
	input [31:0] data47x,
	input [31:0] data48x,
	input [31:0] data49x,
	input [31:0] data50x,
    input [31:0] data51x,
    input [31:0] data52x,
    input [31:0] data53x,
    input [31:0] data54x,
    input [31:0] data55x,
    input [31:0] data56x,
    input [31:0] data57x,
    input [31:0] data58x,
    input [31:0] data59x,
    input [31:0] data60x,
    input [31:0] data61x,
    input [31:0] data62x,
    input [31:0] data63x,
	input [31:0] data4x,
	input [31:0] data5x,
	input [31:0] data6x,
	input [31:0] data7x,
	input [31:0] data8x,
	input [31:0] data9x,
	input [5:0] sel,
	output [31:0] result
    );
    
wire [31:0] res0,res1,res2,res3,res4,res5,res6,res7,res8,res9,res10,res11,res12,res13,res14,res15;
wire [31:0] res00, res01, res_10, res_11;


mux4 mux0(
.aclr(aclr),
.clock(clock),
.data0x(data0x),
.data1x(data1x),
.data2x(data2x),
.data3x(data3x),
.sel(sel[1:0]),
.result(res0)
);

mux4 mux1(
.aclr(aclr),
.clock(clock),
.data0x(data4x),
.data1x(data5x),
.data2x(data6x),
.data3x(data7x),
.sel(sel[1:0]),
.result(res1)
);

mux4 mux2(
.aclr(aclr),
.clock(clock),
.data0x(data8x),
.data1x(data9x),
.data2x(data10x),
.data3x(data11x),
.sel(sel[1:0]),
.result(res2)
);

mux4 mux3(
.aclr(aclr),
.clock(clock),
.data0x(data12x),
.data1x(data13x),
.data2x(data14x),
.data3x(data15x),
.sel(sel[1:0]),
.result(res3)
);

mux4 mux4(
.aclr(aclr),
.clock(clock),
.data0x(data16x),
.data1x(data17x),
.data2x(data18x),
.data3x(data19x),
.sel(sel[1:0]),
.result(res4)
);

mux4 mux5(
.aclr(aclr),
.clock(clock),
.data0x(data20x),
.data1x(data21x),
.data2x(data22x),
.data3x(data23x),
.sel(sel[1:0]),
.result(res5)
);

mux4 mux6(
.aclr(aclr),
.clock(clock),
.data0x(data24x),
.data1x(data25x),
.data2x(data26x),
.data3x(data27x),
.sel(sel[1:0]),
.result(res6)
);

mux4 mux7(
.aclr(aclr),
.clock(clock),
.data0x(data28x),
.data1x(data29x),
.data2x(data30x),
.data3x(data31x),
.sel(sel[1:0]),
.result(res7)
);

mux4 mux8(
.aclr(aclr),
.clock(clock),
.data0x(data31x),
.data1x(data32x),
.data2x(data33x),
.data3x(data34x),
.sel(sel[1:0]),
.result(res8)
);

mux4 mux9(
.aclr(aclr),
.clock(clock),
.data0x(data35x),
.data1x(data36x),
.data2x(data37x),
.data3x(data38x),
.sel(sel[1:0]),
.result(res9)
);

mux4 mux10(
.aclr(aclr),
.clock(clock),
.data0x(data40x),
.data1x(data41x),
.data2x(data42x),
.data3x(data43x),
.sel(sel[1:0]),
.result(res10)
);

mux4 mux11(
.aclr(aclr),
.clock(clock),
.data0x(data44x),
.data1x(data45x),
.data2x(data46x),
.data3x(data47x),
.sel(sel[1:0]),
.result(res11)
);

mux4 mux12(
.aclr(aclr),
.clock(clock),
.data0x(data48x),
.data1x(data49x),
.data2x(data50x),
.data3x(data51x),
.sel(sel[1:0]),
.result(res12)
);

mux4 mux13(
.aclr(aclr),
.clock(clock),
.data0x(data52x),
.data1x(data53x),
.data2x(data54x),
.data3x(data55x),
.sel(sel[1:0]),
.result(res13)
);

mux4 mux14(
.aclr(aclr),
.clock(clock),
.data0x(data56x),
.data1x(data57x),
.data2x(data58x),
.data3x(data59x),
.sel(sel[1:0]),
.result(res14)
);

mux4 mux15(
.aclr(aclr),
.clock(clock),
.data0x(data60x),
.data1x(data61x),
.data2x(data62x),
.data3x(data63x),
.sel(sel[1:0]),
.result(res15)
);
mux4 mux00(
        .aclr(aclr),
        .clock(clock),
        .data0x(res0),
        .data1x(res1),
        .data2x(res2),
        .data3x(res3),
        .sel(sel[3:2]),
        .result(res00)
        );
 
mux4 mux01(
        .aclr(aclr),
        .clock(clock),
        .data0x(res4),
        .data1x(res5),
        .data2x(res6),
        .data3x(res7),
        .sel(sel[3:2]),
        .result(res01)
        ); 
          
mux4 mux_10(
        .aclr(aclr),
        .clock(clock),
        .data0x(res8),
        .data1x(res9),
        .data2x(res10),
        .data3x(res11),
        .sel(sel[3:2]),
        .result(res_10)
        );

mux4 mux_11(
        .aclr(aclr),
        .clock(clock),
        .data0x(res12),
        .data1x(res13),
        .data2x(res14),
        .data3x(res15),
        .sel(sel[3:2]),
        .result(res_11)
        );
        
              
mux4 mux000(
        .aclr(aclr),
        .clock(clock),
        .data0x(res00),
        .data1x(res01),
        .data2x(res_10),
        .data3x(res_11),  //this is not used 
        .sel(sel[5:4]),
        .result(result)
        );
endmodule
