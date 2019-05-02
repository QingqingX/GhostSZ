`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2019 03:58:21 PM
// Design Name: 
// Module Name: conv
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


module conv(
    input clk,
    input [31:0] data,
    output overflow,
    output [15:0] result,
    output underflow
    );
assign underflow = 'b0; //this is not used     
floating_point_3 core (
      .aclk(clk),                                  // input wire aclk
      .s_axis_a_tvalid('b1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(data),              // input wire [31 : 0] s_axis_a_tdata
      .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready('b1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(result),    // output wire [31 : 0] m_axis_result_tdata
      .m_axis_result_tuser(overflow)    // output wire [0 : 0] m_axis_result_tuser
    );    

endmodule
