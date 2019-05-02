/*QX, CAAD, BU
*/

module row_buffer(
	rst,
	clk,
	move, //every 49 cycles, move high for one cycle
	data,
	q1,
	q2,
	q3  //closet to the current p4
);


parameter WIDTH=32;
parameter DEPTH=4;

input wire rst,clk,move;
input wire [WIDTH-1:0] data;
output wire [WIDTH-1:0] q1, q2, q3;

/* Using for-loop */
reg [WIDTH-1:0] FIFO [0:DEPTH-1];
genvar i;

generate
for(i=DEPTH-1; i > 0; i = i-1) 
	begin: shifing
	always@(posedge clk)
		if(rst) begin
			FIFO[i] <= 'b0;
		end
		else if (move) begin
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
	else begin
		FIFO[0] <= data;
	end
	end


assign q1= FIFO[DEPTH-1];
assign q2= FIFO[DEPTH-2];
assign q3= FIFO[DEPTH-3];  
	 
endmodule