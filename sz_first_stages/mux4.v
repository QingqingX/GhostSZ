`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2019 12:46:32 PM
// Design Name: 
// Module Name: mux4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 1 cycle delay
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux4(
    input aclr,
    input clock,
    input [31:0] data0x,
    input [31:0] data1x,
    input [31:0] data2x,
    input [31:0] data3x,
    input [1:0] sel,
    output [31:0] result
    );
reg [31:0] tmp_result; 
always @ (posedge clock) begin

       case(sel)
        2'b00: tmp_result <= data0x;
        2'b01: tmp_result <= data1x;
        2'b10: tmp_result <= data2x;
        2'b11: tmp_result <= data3x;
        default: tmp_result <= data0x;
       endcase
   
end  


assign result = tmp_result;

endmodule
