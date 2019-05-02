`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2019 12:00:21 PM
// Design Name: 
// Module Name: fpabs
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


module fpabs(
    input [31:0] data,
    output [31:0] result
    );
    
floating_point_0 kernel (
      .s_axis_a_tvalid('b1),            // input wire s_axis_a_tvalid
      .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
      .s_axis_a_tdata(data),              // input wire [31 : 0] s_axis_a_tdata
      .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
      .m_axis_result_tready('b1),  // input wire m_axis_result_tready
      .m_axis_result_tdata(result)    // output wire [31 : 0] m_axis_result_tdata
    );
endmodule
