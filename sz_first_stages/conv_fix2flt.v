`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2019 03:55:31 PM
// Design Name: 
// Module Name: conv_fix2flt
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


module conv_fix2flt(
    input clk,
    input [31:0] a,
    output [31:0] res
    );
    
floating_point_6 core (
      .aclk(clk),                                  // input wire aclk
      .s_axis_a_tvalid('b1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(a),              // input wire [31 : 0] s_axis_a_tdata
      .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready('b1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(res)    // output wire [31 : 0] m_axis_result_tdata
    );
    
endmodule
