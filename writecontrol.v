/*module writecontrol #(parameter ADDRLEN = 4)(
	input wclk,
	input wrst_n,
	input winc_i,
	input [ADDRLEN-1:0] syn_rptr_i, //synchronized read pointer
	
	output reg full_o,
	output reg [ADDRLEN-2:0] waddr_o,
	output wire [ADDRLEN-1:0] wptr_o
);
	
	reg [ADDRLEN-1:0] binwptrnext;
	reg [ADDRLEN-1:0] binwptr;
	reg [ADDRLEN-1:0] graywptrnext;
	reg full_internal;
	reg [ADDRLEN-1:0]binwaddr; //binary address 
	
	//full logic
	always@(posedge wclk or negedge wrst_n) begin
		if(~wrst_n) begin
			full_internal <= 0;
			full_o <= full_internal;
		end
		
		else begin 
			if((syn_rptr_i[ADDRLEN-1] ==~graywptrnext[ADDRLEN-1] )&&(syn_rptr_i[ADDRLEN-2] ==~graywptrnext[ADDRLEN-2])&&(syn_rptr_i[ADDRLEN-3:0]==graywptrnext[ADDRLEN-3:0])) begin
				full_internal <= 1;
				full_o <= full_internal;
			end
			
			else begin
				full_internal <= 0;
				full_o <= full_internal;
			end 
		end 
	end
	
	//next wptr logic	
	integer i;
	always@(posedge wclk or negedge wrst_n) begin
		if(~wrst_n) begin
			binwaddr <= 0;
			waddr_o <= 0;
			graywptrnext <= 0;
			binwptrnext <= 0;
		end
		
		else begin
			if(winc_i && ~full_internal) begin
				binwaddr <= binwaddr + winc_i;
				binwptr <= binwaddr;
				binwptrnext <= binwptr + winc_i;	
				for (i=ADDRLEN-1;i>=0;i=i-1) begin
					if(i == ADDRLEN-1) begin
						graywptrnext[ADDRLEN-1] <= binwptrnext[ADDRLEN-1];
					end
					else begin
						graywptrnext[i] <= binwptrnext[i] ^ (binwptrnext[i+1]);
					end 
				end
				waddr_o <= binwaddr[ADDRLEN-2:0]; //all bits except the MSB will be a part of waddr_o
			end
			else begin
				binwaddr <= binwaddr;
				binwptr <= binwaddr;
				binwptrnext <= binwptr + winc_i;
				for (i=ADDRLEN-1;i>=0;i=i-1) begin
					if(i == ADDRLEN-1) begin
						graywptrnext[ADDRLEN-1] <= binwptrnext[ADDRLEN-1];
					end
					else begin
						graywptrnext[i] <= binwptrnext[i] ^ (binwptrnext[i+1]);
					end 
				end
				waddr_o <= binwaddr[ADDRLEN-2:0];
			end
		end
	end
	
	//wptrnext 
	//binaddr in gray code
	//instantiating the bintogray module
	
	bintogray #(ADDRLEN) B2G1(
	.clk(wclk),
	.rst_n(wrst_n),
	.binptr(binwptr),
	.grayptr(wptr_o)
	);

endmodule */

module writecontrol #(parameter ADDRLEN = 4)(
    input wclk,
    input wrst_n,
    input winc_i,
    input [ADDRLEN-1:0] syn_rptr_i, // synchronized read pointer 
    
    output reg full_o,
    output reg [ADDRLEN-2:0] waddr_o,
    output wire [ADDRLEN-1:0] wptr_o
);
    
    reg [ADDRLEN-1:0] binwptrnext;
    reg [ADDRLEN-1:0] binwptr;
    reg [ADDRLEN-1:0] graywptrnext;
    reg [ADDRLEN-1:0] binwaddr; // binary address 
    
    //full logic 
    always @(posedge wclk or negedge wrst_n) begin
        if (~wrst_n) begin
            full_o <= 0;
        end
        else begin 
            //if ((syn_rptr_i[ADDRLEN-1] == ~graywptrnext[ADDRLEN-1]) &&
                //(syn_rptr_i[ADDRLEN-2] == ~graywptrnext[ADDRLEN-2]) &&
                //(syn_rptr_i[ADDRLEN-3:0] == graywptrnext[ADDRLEN-3:0])) begin
			if (syn_rptr_i == {~graywptrnext[ADDRLEN-1:ADDRLEN-2],graywptrnext[ADDRLEN-3:0]}) begin
                full_o <= 1;
            end
            else begin
                full_o <= 0;
            end 
        end 
    end
    
    //next wptr logic 
    integer i;
    always @(posedge wclk or negedge wrst_n) begin
        if (~wrst_n) begin
            //binwaddr <= 0;
            //waddr_o <= 0;
            //graywptrnext <= 0;
            binwptr <= 0;
        end
        else begin
            if (winc_i && ~full_o) begin
                //binwaddr <= binwaddr + winc_i;
                //binwptr <= binwaddr;
                //binwptrnext <= binwaddr + winc_i;
				binwptr <= binwptr + 1;
				//binwptr <= binwptrnext;
                //for (i = ADDRLEN-1; i >= 0; i = i-1) begin
                 //   if (i == ADDRLEN-1) begin
                   //    graywptrnext[ADDRLEN-1] <= binwptrnext[ADDRLEN-1];
                    //end
                    //else begin
                      //  graywptrnext[i] <= binwptrnext[i] ^ binwptrnext[i+1];
                    //end 
               // end
                waddr_o <= binwptr[ADDRLEN-2:0];
            end
            else begin
                //binwptr <= binwaddr;
                binwptr <= binwptr;
                waddr_o <= binwptr[ADDRLEN-2:0];
            end
			binwptrnext <= binwptr + 1;
			for (i = ADDRLEN-1; i >= 0; i = i-1) begin
                if (i == ADDRLEN-1) begin
                    graywptrnext[ADDRLEN-1] <= binwptrnext[ADDRLEN-1];
                end
                else begin
                    graywptrnext[i] <= binwptrnext[i] ^ binwptrnext[i+1];
                end 
            end
        end
    end
    
    // generating gray write pointer 
    bintogray #(ADDRLEN) B2G1(
        .clk(wclk),
        .binptr(binwptr),
        .grayptr(wptr_o)
    );

endmodule 


/*module writecontrol #(parameter ADDRLEN = 4)(
	input wclk, wrst_n,
	input winc_i,
	input [ADDRLEN-1:0] syn_rptr_i,
	output reg [ADDRLEN-2:0]waddr_o,
	output reg [ADDRLEN-1:0]wptr_o,
	output reg full_o
);
	reg 
	reg wfull;
	reg graywptrnext;
	
	//condition for full
	assign wptrnext = 
	assign full_internal = (syn_rptr_i == {~graywptrnext[ADDRLEN-1:ADDRLEN-2],graywptrnext[ADDRLEN-3:0]}); */
	
