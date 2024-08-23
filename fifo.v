module fifo #(parameter DATALEN = 8, parameter ADDRLEN = 4,parameter DEPTH = 8)(
	input wclk,
	input rclk,
	input rrst_n,
	input wrst_n,
	input winc,
	input rinc,
	input [DATALEN-1:0]wdata,
	output full_o,
	output empty_o,
	output [DATALEN-1:0]rdata	
);
	wire [ADDRLEN-2:0]waddr;
	wire [ADDRLEN-2:0]raddr;
	wire [ADDRLEN-1:0]wptr;
	wire [ADDRLEN-1:0]rptr;
	wire [ADDRLEN-1:0]sync_wptr;
	wire [ADDRLEN-1:0]syn_rptr;
	
	dpram #(DATALEN, ADDRLEN, DEPTH) DPRAM(
		.wclk(wclk),
		.wdata(wdata),
		.wclken(winc&&~full_o),
		.waddr(waddr), 
		.raddr(raddr), 
		.rdata(rdata)
);	

	writecontrol #(ADDRLEN) WRITECONTROL(
		.wclk(wclk),
		.wrst_n(wrst_n),
		.winc_i(winc),
		.syn_rptr_i(syn_rptr), 
		.full_o(full_o),
		.waddr_o(waddr),
		.wptr_o(wptr)
);

	readcontrol #(ADDRLEN) READCONTROL(
		.rclk(rclk),
		.rrst_n(rrst_n),
		.sync_wptr_i(sync_wptr),
		.rinc(rinc),
		.raddr_o(raddr),
		.rptr_o(rptr),
		.empty_o(empty_o)
);

	synchronizer #(ADDRLEN ) SYNCHRONIZER(
		.rptr(rptr),
		.rclk(rclk),
		.rrst_n(rrst_n),
		.sync_wptr(sync_wptr),
		.wptr(wptr),
		.wclk(wclk),
		.wrst_n(wrst_n),
		.sync_rptr(syn_rptr)
);

endmodule 