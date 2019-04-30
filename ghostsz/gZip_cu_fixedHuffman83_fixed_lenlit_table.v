// ==============================================================
// File generated on Fri Apr 26 14:37:04 UTC 2019
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3.op (64-bit)
// SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1 ns / 1 ps
module gZip_cu_fixedHuffman83_fixed_lenlit_table_rom (
addr0, ce0, q0, addr1, ce1, q1, clk);

parameter DWIDTH = 9;
parameter AWIDTH = 9;
parameter MEM_SIZE = 264;

input[AWIDTH-1:0] addr0;
input ce0;
output reg[DWIDTH-1:0] q0;
input[AWIDTH-1:0] addr1;
input ce1;
output reg[DWIDTH-1:0] q1;
input clk;

reg [DWIDTH-1:0] ram[0:MEM_SIZE-1];

initial begin
    $readmemh("./gZip_cu_fixedHuffman83_fixed_lenlit_table_rom.dat", ram);
end



always @(posedge clk)  
begin 
    if (ce0) 
    begin
        q0 <= ram[addr0];
    end
end



always @(posedge clk)  
begin 
    if (ce1) 
    begin
        q1 <= ram[addr1];
    end
end



endmodule

`timescale 1 ns / 1 ps
module gZip_cu_fixedHuffman83_fixed_lenlit_table(
    reset,
    clk,
    address0,
    ce0,
    q0,
    address1,
    ce1,
    q1);

parameter DataWidth = 32'd9;
parameter AddressRange = 32'd264;
parameter AddressWidth = 32'd9;
input reset;
input clk;
input[AddressWidth - 1:0] address0;
input ce0;
output[DataWidth - 1:0] q0;
input[AddressWidth - 1:0] address1;
input ce1;
output[DataWidth - 1:0] q1;



gZip_cu_fixedHuffman83_fixed_lenlit_table_rom gZip_cu_fixedHuffman83_fixed_lenlit_table_rom_U(
    .clk( clk ),
    .addr0( address0 ),
    .ce0( ce0 ),
    .q0( q0 ),
    .addr1( address1 ),
    .ce1( ce1 ),
    .q1( q1 ));

endmodule

