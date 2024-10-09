/*module bintogray #(parameter ADDRLEN = 4)(
	input clk,//can be either wclk or rclk depending on where this module is instantiated
	input rst_n,
	input [ADDRLEN-1:0] binptr, //the pointer can be either rptr or wptr depending on where this module is instantiated 
	output reg [ADDRLEN-1:0] grayptr
);

	always@(posedge clk or negedge rst_n) begin
			if(~rst_n) begin
				grayptr[ADDRLEN-1:0] <= 0;
			end
			
			else begin
				grayptr[ADDRLEN-1] <= binptr[ADDRLEN-1];
				grayptr[ADDRLEN-2] <= (binptr[ADDRLEN-1]^binptr[ADDRLEN-2]);
				grayptr[ADDRLEN-3] <= (binptr[ADDRLEN-2]^binptr[ADDRLEN-3]);
				grayptr[ADDRLEN-4] <= (binptr[ADDRLEN-3]^binptr[ADDRLEN-4]);
			end
	end 
endmodule*/


/*module bintogray #(parameter ADDRLEN = 4)(
    input clk,
    input rst_n,
    input [ADDRLEN-1:0] binptr,
    output reg [ADDRLEN-1:0] grayptr
);

    genvar i;

    generate
        
        for (i = 0; i < ADDRLEN; i = i + 1) begin : gray_loop
            if (i == ADDRLEN-1) begin
                assign grayptr[ADDRLEN-1] = binptr[ADDRLEN-1];
            end
            else begin
                assign grayptr[i] = binptr[i+1] ^ binptr[i];
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            grayptr <= 0;
        end
    end

endmodule*/

module bintogray #(parameter ADDRLEN = 4)(
    input clk,
    input [ADDRLEN-1:0] binptr,
    output reg [ADDRLEN-1:0] grayptr
);

    integer i;

    always @(posedge clk) begin
        grayptr[ADDRLEN-1] <= binptr[ADDRLEN-1];
        for (i = ADDRLEN-2; i >= 0; i = i - 1) begin
            grayptr[i] <= binptr[i+1] ^ binptr[i];
        end
    end

endmodule

