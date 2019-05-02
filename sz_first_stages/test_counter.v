`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2019 01:32:07 PM
// Design Name: 
// Module Name: test_counter
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


module test_counter(
    input clk,
    input rst,
    output [6:0] data
    );
    
reg [6:0] counter;
    
    assign data= counter;
    
    
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            counter <= {7{1'b1}};        
        end else begin
            counter <= counter + 7'd1;        
        end
    end
       
endmodule
