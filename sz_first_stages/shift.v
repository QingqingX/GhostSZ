/*QX, CAAD, BU
* shift buffer (shift register
* configure depth
* for things input immediately after reset, if you want to store for 12 cycles; then set depth=13
* for signals inputed long after reset, f you want to store for 12 cycles; then set depth=12
*/
module shift(
	rst,
	clk,
	data,
	q
);


parameter WIDTH=32;
parameter DEPTH=14;

input wire rst,clk;
input wire [WIDTH-1:0] data;
output wire [WIDTH-1:0] q;

/* Using for-loop */
reg [WIDTH-1:0] FIFO [0:DEPTH-1];
genvar i;

generate
for(i=DEPTH-1; i > 0; i = i-1) 
	begin: shifing
	always@(posedge clk)
		if(rst)
			begin
			FIFO[i] <= 'b0;
			end
		else
			begin
			FIFO[i] <= FIFO[i-1];
			end
	end
endgenerate

always@(posedge clk)	
	begin
	if(rst)
		begin
		FIFO[0] <= 'b0;
		end
	else
		begin
		FIFO[0] <= data;
		end
	end


assign q= FIFO[DEPTH-1];
	 
endmodule