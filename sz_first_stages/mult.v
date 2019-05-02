`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2019 12:21:38 PM
// Design Name: 
// Module Name: mult
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


module mult(
    input rst,
    input clk,
    input [31:0] a,
    input [31:0] b,
    output [31:0] res
    );
    
floating_point_4 mult_core (
      .aclk(clk),                                  // input wire aclk
      .s_axis_a_tvalid('b1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(a),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tvalid('b1),            // input wire s_axis_b_tvalid
      .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
      .s_axis_b_tdata(b),              // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready('b1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(res)    // output wire [31 : 0] m_axis_result_tdata
    );
    
endmodule
