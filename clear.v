module clear(
	input go,
	input resetn,
	input crashing_signal,
	input [2:0] current_state_ob,
	input CLK,
	
	output reg resetn_mod
	);
	initial resetn_mod = 1;
	
	always@(posedge CLK)
	begin
	if (resetn_mod == 1)
	begin
		if (current_state_ob === 4'd6 && resetn === 0)
		begin
			 resetn_mod <= 0;
		end
		else if( current_state_ob === 4'd6 && crashing_signal === 0) 
		begin
			resetn_mod <= 0;
		end
		else 
		begin
			 resetn_mod <= 1;
		end
	end
	else 
		begin
		if(go === 1) resetn_mod <= 1;
		end
		
	end

endmodule