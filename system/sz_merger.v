/***********************************************
Pingpong buffer for storing output from sz
each buffer has three sub-buffers, anyone is full,
then tell lz77 to start getting from these three buffers;
meanwhile, input gets stored in the other three sub-buffers.
***********************************************/
module sz_merger(
clk,
rst,
data_out,
data_out_valid,
phase2_out,
phase2_valid,
phase3_out,
phase3_valid,
data_to_gzip,
data_to_gzip_valid,
gzip_read
);
input wire clk, rst;
input wire gzip_read, data_out_valid, phase2_valid, phase3_valid;
input wire [1:0] data_out;
input wire [15:0] phase2_out;
input wire [31:0] phase3_out;
output wire [63:0] data_to_gzip;
output wire data_to_gzip_valid;

//three buffers are all n-in-64-out
wire full00, full01,full02, full10, full11, full12;
wire buffer0_full, buffer1_full;//swap buffers; and allow 
assign buffer0_full = (full00 | full01 | full02);
assign buffer1_full = (full10 | full11 | full12); 
reg select0, select1;
//when selecting to write into buffer0, always select to read from buffer1
always @ (posedge clk) begin
	if (rst) begin
		select0 = 'b1;
		select1 = 'b0;
	end
	else if (buffer0_full | buffer1_full) begin
		select1 = ~select1;
		select0 = ~select0;
	end
end
//for the selected buffer0 or 1,
// drain one by one

wire read0, read00, read01, read02;
wire empty00, empty01, empty02;
wire read1, read10, read11, read12;
wire empty10, empty11, empty12;
wire [63:0] out00, out01, out02;
wire [63:0] out10, out11, out12;
assign read00 = read0&& (~empty00);
assign read01 = read0&& (~read00) && (~empty01);
assign read02 = read0&& (~read00) && (~read01) && (~empty02);
assign read10 = read1&& (~empty10);
assign read11 = read1&& (~read10) && (~empty11);
assign read12 = read1&& (~read10) && (~read11) && (~empty12);

//if any of the buffers are full 
encode_fifo encode_fifo(
    .clk(ap_clk),
    .srst(ap_rst),
    .wr_rst_busy(),
    .rd_rst_busy(),
    .din(data_out),
    .full(full00),   //output to upper stream and lower stream
    .wr_en(data_out_valid & select0),
    .dout(out00),
    .empty(empty00),//output
    .rd_en(read00&gzip_read)  //from lz77
);
fifo_16in_64out phase2_fifo(
    .clk(ap_clk),
    .srst(ap_rst),
    .wr_rst_busy(),
    .rd_rst_busy(),
    .din(phase2_data_out),
    .full(full01),
    .wr_en(phase2_valid & select0),
    .dout(out01),
    .empty(empty01),
    .rd_en(read01&gzip_read)
);

fifo_32in_64out phase3_fifo(
    .clk(ap_clk),
    .srst(ap_rst),
    .wr_rst_busy(),
    .rd_rst_busy(),
    .din(phase3_data_out),
    .full(full02),
    .wr_en(phase3_valid & select0),
    .dout(out02),
    .empty(empty02),
    .rd_en(read02&gzip_read)
);

////////second set
encode_fifo encode_fifo1(
    .clk(ap_clk),
    .srst(ap_rst),
    .wr_rst_busy(),
    .rd_rst_busy(),
    .din(data_out),
    .full(full10),   //output to upper stream and lower stream
    .wr_en(data_out_valid & select1),
    .dout(out10),
    .empty(empty10),//output
    .rd_en(read10&gzip_read)  //from lz77
);
fifo_16in_64out phase2_fifo1(
    .clk(ap_clk),
    .srst(ap_rst),
    .wr_rst_busy(),
    .rd_rst_busy(),
    .din(phase2_data_out),
    .full(full11),
    .wr_en(phase2_valid & select1),
    .dout(out11),
    .empty(empty11),
    .rd_en(read11&gzip_read)
);

fifo_32in_64out phase3_fifo1(
    .clk(ap_clk),
    .srst(ap_rst),
    .wr_rst_busy(),
    .rd_rst_busy(),
    .din(phase3_data_out),
    .full(full12),
    .wr_en(phase3_valid & select0),
    .dout(out12),
    .empty(empty12),
    .rd_en(read12&gzip_read)
);

wire [63:0] data_from_buffer0, data_from_buffer1; 
wire data_from_buffer0_valid, data_from_buffer1_valid;

assign data_from_buffer0 = (~empty00)?out00 : ((~empty01)? out01 : out02);
assign data_from_buffer0_valid = ~(empty00&&empty01&&empty02);
assign data_from_buffer1 = (~empty10)?out10 : ((~empty11)? out11 : out12);
assign data_from_buffer1_valid = ~(empty10&&empty11&&empty12);
assign data_to_gzip = (select0? data_from_buffer0 : data_from_buffer1); 
assign data_to_gzip_valid = select0? data_from_buffer0_valid : data_from_buffer1_valid;

endmodule
