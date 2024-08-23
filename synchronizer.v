/*module synchronizer #(parameter ADDRLEN = 4)(
	//read domain inputs
	input [ADDRLEN-1:0]rptr,
	input rclk,
	input rrst_n,
	//outputs into the read domain
	output [ADDRLEN-1:0]sync_wptr,
	//write domain inputs 
	input [ADDRLEN-1:0]wptr,
	input wclk,
	input wrst_n,
	//outputs into the write domain 
	output [ADDRLEN-1:0]sync_rptr
);
	
	wire q1; 
	wire q2;
	
	//synchronizing wptr
	dff DFF1(
	.clk(rclk), 
	.rst_n(rrst_n),
	.data(wptr),
	.q(q1)
);
	
	dff DFF2(
	.clk(rclk), 
	.rst_n(rrst_n),
	.data(q1),
	.q(sync_wptr)
);

	//synchronizing rptr
	dff DFF3(
	.clk(wclk), 
	.rst_n(wrst_n),
	.data(rptr),
	.q(q2)
);

	dff DFF4(
	.clk(wclk), 
	.rst_n(wrst_n),
	.data(q2),
	.q(sync_rptr)
);

endmodule */

/*module synchronizer #(parameter ADDRLEN = 4)(
    // Read domain inputs
    input [ADDRLEN-1:0] rptr,
    input               rclk,
    input               rrst_n,
    // Outputs into the read domain
    output [ADDRLEN-1:0] sync_wptr,
    // Write domain inputs
    input [ADDRLEN-1:0] wptr,
    input               wclk,
    input               wrst_n,
    // Outputs into the write domain
    output [ADDRLEN-1:0] sync_rptr
);

    // Generate synchronizing flip-flops for each bit of wptr
    genvar i;
    generate
        for (i = 0; i < ADDRLEN; i = i + 1) begin: sync_wptr_bits
            wire q1, q2;
            dff DFF1(
                .clk(rclk),
                .rst_n(rrst_n),
                .data(wptr[i]),
                .q(q1)
            );

            dff DFF2(
                .clk(rclk),
                .rst_n(rrst_n),
                .data(q1),
                .q(sync_wptr[i])
            );
        end
    endgenerate

    // Generate synchronizing flip-flops for each bit of rptr
    generate
        for (i = 0; i < ADDRLEN; i = i + 1) begin: sync_rptr_bits
            wire q1, q2;
            dff DFF3(
                .clk(wclk),
                .rst_n(wrst_n),
                .data(rptr[i]),
                .q(q1)
            );

            dff DFF4(
                .clk(wclk),
                .rst_n(wrst_n),
                .data(q1),
                .q(sync_rptr[i])
            );
        end
    endgenerate

endmodule*/

/*module synchronizer #(parameter ADDRLEN = 4)(
    // Read domain inputs
    input [ADDRLEN-1:0] rptr,
    input               rclk,
    input               rrst_n,
    // Outputs into the read domain
    output [ADDRLEN-1:0] sync_wptr,
    // Write domain inputs
    input [ADDRLEN-1:0] wptr,
    input               wclk,
    input               wrst_n,
    // Outputs into the write domain
    output [ADDRLEN-1:0] sync_rptr
);

    // Generate synchronizing flip-flops for each bit of wptr
    genvar i;
    generate
        for (i = 0; i < ADDRLEN; i = i + 1) begin: sync_wptr_bits
            reg q1, q2;
            always @(posedge rclk or negedge rrst_n) begin
                if (~rrst_n) begin
                    q1 <= 1'b0;
                    q2 <= 1'b0;
                end
                else begin
                    q1 <= wptr[i];
                    q2 <= q1;
                end
            end
            assign sync_wptr[i] = q2;
        end
    endgenerate

    // Generate synchronizing flip-flops for each bit of rptr
    generate
        for (i = 0; i < ADDRLEN; i = i + 1) begin: sync_rptr_bits
            reg q1, q2;
            always @(posedge wclk or negedge wrst_n) begin
                if (~wrst_n) begin
                    q1 <= 1'b0;
                    q2 <= 1'b0;
                end
                else begin
                    q1 <= rptr[i];
                    q2 <= q1;
                end
            end
            assign sync_rptr[i] = q2;
        end
    endgenerate

endmodule*/

module synchronizer #(parameter ADDRLEN = 4)(
    // Read domain inputs
    input [ADDRLEN-1:0] rptr,
    input               rclk,
    input               rrst_n,
    // Outputs into the read domain
    output reg [ADDRLEN-1:0] sync_wptr,
    // Write domain inputs
    input [ADDRLEN-1:0] wptr,
    input               wclk,
    input               wrst_n,
    // Outputs into the write domain
    output reg [ADDRLEN-1:0] sync_rptr
);

    // Synchronize wptr to the read clock domain
    reg [ADDRLEN-1:0] q1_wptr, q2_wptr;
    integer i;
    always @(posedge rclk or negedge rrst_n) begin
        if (~rrst_n) begin
            q1_wptr <= 0;
            q2_wptr <= 0;
            //sync_wptr <= 0;
        end
        else begin
            for (i = 0; i < ADDRLEN; i = i + 1) begin
                q1_wptr[i] <= wptr[i];
                q2_wptr[i] <= q1_wptr[i];
                sync_wptr[i] <= q2_wptr[i];
            end
        end
    end

    // Synchronize rptr to the write clock domain
    reg [ADDRLEN-1:0] q1_rptr, q2_rptr;
    always @(posedge wclk or negedge wrst_n) begin
        if (~wrst_n) begin
            q1_rptr <= 0;
            q2_rptr <= 0;
           // sync_rptr <= 0;
        end
        else begin
            for (i = 0; i < ADDRLEN; i = i + 1) begin
                q1_rptr[i] <= rptr[i];
                q2_rptr[i] <= q1_rptr[i];
                sync_rptr[i] <= q2_rptr[i];
            end
        end
    end

endmodule


