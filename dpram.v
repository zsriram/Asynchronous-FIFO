module dpram #(	parameter DATALEN = 8, /*size of the data*/
								parameter ADDRLEN= 4, /*size of the address*/
								parameter DEPTH = 8/*Depth of FIFO*/) (
	//write domain signals
	input wclk,
	input [DATALEN-1:0] wdata,
	input wclken,
	input [ADDRLEN-2:0]waddr, 
	
	//read domain signals, no clk signal because the raddr signal is already read clock controlled
	input [ADDRLEN-2:0]raddr, 
	output reg [DATALEN-1:0]rdata
);	



reg [DATALEN-1:0] mem [0:DEPTH-1];

//write domain
always@(posedge wclk) begin
	if(wclken) begin
		mem[waddr] <= wdata;
	end
end

//read domain
always@(*) begin
	rdata <= mem[raddr];
end

endmodule