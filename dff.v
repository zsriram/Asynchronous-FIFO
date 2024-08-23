module dff (
	input clk, 
	input rst_n,
	input data,
	output reg q
);


always@(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		q <= 1'b0;
	end
	
	else begin
		q <= data;
	end
	
end


endmodule