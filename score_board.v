module score_board(
	input plus_1,
	input resetn,
	input CLK,
	output reg [7:0] score
	);
	
	initial score = 8'b00000000;
	
	
	always @(posedge CLK or posedge plus_1 or negedge resetn)
	begin
	   if (!resetn)
		score <= 8'b00000000;
		if (plus_1 == 1)
		score <= score + 1;
	end

endmodule
