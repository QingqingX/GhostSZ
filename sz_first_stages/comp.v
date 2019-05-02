`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2019 04:17:21 PM
// Design Name: 
// Module Name: comp
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


module comp(
    input clock,
    input [31:0] dataa,
    input [31:0] datab,
    output alb
    );

wire [7:0] temp_result;
floating_point_1 core (
      .aclk(clock),                                  // input wire aclk
      .s_axis_a_tvalid('b1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(dataa),              // input wire [31 : 0] s_axis_a_tdata
      .s_axis_b_tvalid('b1),            // input wire s_axis_b_tvalid
      .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
      .s_axis_b_tdata(datab),              // input wire [31 : 0] s_axis_b_tdata
      .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready('b1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(temp_result)    // output wire [7 : 0] m_axis_result_tdata
    );
assign alb=temp_result[0];  //less than is 1; then the second bit from right

endmodule
