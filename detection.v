module detection(
	input go,
	input [7:0] x_lane0,
	input [6:0] y_lane0,
	
	input [7:0] x_lane1,
	input [6:0] y_lane1,
	
	
	input [7:0] x_lane2,
	input [6:0] y_lane2,
	
	
	input [7:0] x_lane3,
	input [6:0] y_lane3,
		
	input [7:0] x_lane4,
	input [6:0] y_lane4,
	
	
	input [7:0] x_dot,
	input [6:0] y_dot,
	
	input CLK,
	
	output reg resetn

);	
	
	initial resetn = 1;


	reg [2:0] x_lane;
	initial x_lane = 2'd0;
	
	always @(*)
	begin
		if(y_dot > 100 && y_dot < 120) x_lane = 5;
		else if(y_dot > 80 && y_dot < 100) x_lane = 0;
		else if(y_dot > 60 && y_dot < 80)  x_lane = 1;
		else if(y_dot > 40 && y_dot < 60)  x_lane = 2;
		else if(y_dot > 20 && y_dot < 40)  x_lane = 3;
		else if(y_dot > 0  && y_dot < 20)  x_lane = 4;
		else x_lane = 5;
	end
	
	always @(posedge CLK)
	begin
	
	if(resetn === 1)
	begin
		case(x_lane)
			0: begin
					if ((x_dot > (x_lane0 - 6'd2)) & (x_dot < (x_lane0 + 6'd2))) resetn <= 0;
				end
			1: begin
					if ((x_dot > (x_lane1 - 6'd2)) & (x_dot < (x_lane1 + 6'd2))) resetn <= 0;
				end
			2: begin
					if ((x_dot > (x_lane2 - 6'd2)) & (x_dot < (x_lane2 + 6'd2))) resetn <= 0;
				end
			3: begin
					if ((x_dot > (x_lane3 - 6'd2)) & (x_dot < (x_lane3 + 6'd2))) resetn <= 0;
				end
			4: begin
					if ((x_dot > (x_lane4 - 6'd2)) & (x_dot < (x_lane4 + 6'd2))) resetn <= 0;
				end

			default: resetn <= 1;
		endcase
	end
	else 
		begin
		if(go === 1) resetn <= 1;
		end
		
	end
	
	
	
endmodule
	