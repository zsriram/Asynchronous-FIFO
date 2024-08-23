module readcontrol #(parameter ADDRLEN = 4)(
    input rclk,
    input rrst_n,
    input [ADDRLEN-1:0] sync_wptr_i, // synchronized write pointer 
    input rinc,
    
    output reg [ADDRLEN-2:0] raddr_o,
    output wire [ADDRLEN-1:0] rptr_o,
    output reg empty_o
);
    //reg [ADDRLEN-1:0] binraddr;
    reg [ADDRLEN-1:0] binrptr;
    reg [ADDRLEN-1:0] binrptrnext;
    reg [ADDRLEN-1:0] grayrptrnext;

    // empty logic 
    always @(posedge rclk or negedge rrst_n) begin
        if (~rrst_n) begin
            empty_o <= 1;
        end
        else begin
            if (grayrptrnext == sync_wptr_i) begin
                empty_o <= 1;
            end
            else begin
                empty_o <= 0;
            end
        end
    end

    //rptr next logic 
    integer i;
    always @(posedge rclk or negedge rrst_n) begin
        if (~rrst_n) begin
            binrptr <= 0;
           // binrptrnext <= 0;
            //binraddr <= 0;
            //raddr_o <= 0;
   		   //grayrptrnext <= 0;
		   //binrptr <= 0;
        end
        else begin
            
				if (rinc && ~empty_o) begin
                //binraddr <= binraddr + rinc;
                //binrptr <= binraddr;
                //binrptrnext <= binraddr + rinc;
                //binrptr <= binrptr + (rinc&&~empty_o);
				binrptr <= binrptr + 1;
				//binrptr <= binrptrnext;
				//for (i = ADDRLEN-1; i >= 0; i = i-1) begin
                 //   if (i == ADDRLEN-1) begin
                 //       grayrptrnext[ADDRLEN-1] <= binrptrnext[ADDRLEN-1];
                 //   end
                 //   else begin
                 //       grayrptrnext[i] <= binrptrnext[i] ^ binrptrnext[i+1];
                  //  end
                //end
                raddr_o <= binrptr[ADDRLEN-2:0];
				end
				else begin
					//binrptr <= binraddr;
					binrptr <= binrptr;
					//binrptrnext <= binrptr + 1;
					raddr_o <= binrptr[ADDRLEN-2:0];
				end
			
			binrptrnext <= binrptr + 1;
			//raddr_o <= binrptr[ADDRLEN-2:0];
			grayrptrnext <= (binrptrnext>>1)^binrptrnext;
			
			
			//for (i = ADDRLEN-1; i >= 0; i = i-1) begin
				//if (i == ADDRLEN-1) begin
					//grayrptrnext[ADDRLEN-1] <= binrptrnext[ADDRLEN-1];
				//end
				//else begin
					//grayrptrnext[i] <= binrptrnext[i] ^ binrptrnext[i+1];
				//end
			//end
        end
    end
	
	//always@(posedge rclk or negedge rrst_n) begin
		//if(~rrst_n) begin
		//grayrptrnext <= 0;
		//end
		//else begin
		//	for (i = ADDRLEN-1; i >= 0; i = i-1) begin
		//		if (i == ADDRLEN-1) begin
		//			grayrptrnext[ADDRLEN-1] <= binrptrnext[ADDRLEN-1];
		//		end
		//		else begin
		//			grayrptrnext[i] <= binrptrnext[i] ^ binrptrnext[i+1];
		//		end
		//	end
		//end
			
	//end
    // generating gray read pointer 
    bintogray #(ADDRLEN) B2G2(
        .clk(rclk),
        .binptr(binrptr),
        .grayptr(rptr_o)
    );
endmodule