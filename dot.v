module dot(
	input CLOCK, 
	input go, 
	input [9:0]sw, 
	input resetn, 
	
	input move_left,move_right,jump,
	
	output [7:0]x, 
	output [6:0]y, 
	output [2:0]colour, 
	output writeEn,
	
	output [7:0]score_current
	);

	
   wire ld_x, ld_y;

	wire [2:0] colour_load;
	wire [7:0] x_load;
	wire [6:0] y_load;

	wire enable_frame, enable_erase, enable_counter, colour_erase_enable, count_x_enable;
	wire done_plot;
	
	wire reset_counter, reset_load;
	
	datapath5 d0(
				.clk(CLOCK),
				.resetn(resetn),
				.count_x_enable(count_x_enable),
				.x(x_load),
				.y(y_load),
				.colour(colour_load),
				.x_out(x),
				.y_out(y),
				.colour_out(colour),
				.done_plot(done_plot)
				);

    // Instansiate FSM control
    control5 c0(
				.clk(CLOCK),
				.resetn(resetn),
				.go(go),
				.enable_erase(enable_erase),
				.done_plot(done_plot),
				.ld_x(ld_x),
				.ld_y(ld_y),
				.reset_counter(reset_counter),
				.enable_counter(enable_counter),
				.writeEn(writeEn),
				.colour_erase_enable(colour_erase_enable),
				.reset_load(reset_load),
				.count_x_enable(count_x_enable)
	);

	load5 l0(
		.move_left(move_left),
		.move_right(move_right),
		.jump(jump),
		
		
		.clk(CLOCK),
		.reset(reset_load),
		.colour_in(3'b011),
		.colour_erase_enable(colour_erase_enable),
		.ld_x(ld_x),
		.ld_y(ld_y),
		.x(x_load),
		.y(y_load),
		.colour(colour_load),
		.score_current(score_current)
	);

	delay_counter5 dc(
			.enable(enable_counter),
			.clk(CLOCK),
			.resetn(reset_counter),
			.enable_frame(enable_frame)
	);

	frame_counter5 f0(
			.enable(enable_frame),
			.clk(CLOCK),
			.resetn(reset_counter),
			.enable_out(enable_erase)
	);

	
endmodule

//

module control5(
	input clk,
   input resetn,
   input go,
	input enable_erase,
	input done_plot,

   output reg ld_x, ld_y,
	output reg reset_counter, enable_counter,
	output reg writeEn,
	output reg colour_erase_enable,
	output reg reset_load,
	output reg count_x_enable
    );

    reg [2:0] current_state, next_state; 
    
    localparam  RESET = 4'd0,
				RESET_WAIT = 4'd1,
				PLOT = 4'd2,
				RESET_COUNTER = 4'd3,
				COUNT = 4'd4,
				ERASE = 4'd5,
				UPDATE = 4'd6;
    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
					RESET: next_state = go ? RESET_WAIT : RESET; // Loop in current state until value is input
					RESET_WAIT: next_state = go ? RESET_WAIT : PLOT; // Loop in current state until go signal goes low
					PLOT: next_state = done_plot ? RESET_COUNTER : PLOT;
					RESET_COUNTER : next_state = COUNT;
					COUNT: next_state = enable_erase ? ERASE : COUNT; 
					ERASE: next_state = done_plot ? UPDATE : ERASE; 
					UPDATE: next_state = PLOT;
					default: next_state = RESET;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_x = 1'b0;
        ld_y = 1'b0;
		writeEn = 1'b0;
		reset_counter = 1'b1;
		reset_load = 1'b1;
		enable_counter = 1'b0;
		colour_erase_enable = 1'b0;
		count_x_enable = 1'b0;

        case (current_state)
            RESET: begin 
				reset_counter = 1'b0;
				reset_load = 1'b0;
			end
			PLOT: begin
				count_x_enable = 1'b1;
				writeEn = 1'b1;
			end
			RESET_COUNTER: 
				reset_counter = 1'b0;
			COUNT: enable_counter = 1'b1;
			ERASE: begin
				colour_erase_enable = 1'b1;
				count_x_enable = 1'b1;
				writeEn = 1'b1;
			end
			UPDATE: begin
				ld_x = 1'b1;
				ld_y = 1'b1;
			end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= RESET;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath5(
	input clk,
	input resetn,
	input count_x_enable,
	input [7:0] x,
	input [6:0] y,
	input [2:0] colour,
	output [7:0] x_out,
	output [6:0] y_out,
	output [2:0] colour_out,
	output reg done_plot
	);

	reg [1:0] count_x, count_y;

	wire enable_y;
	
	always @(*)
	begin
		if (count_x == 2'b11 && count_y == 2'b11)
			done_plot = 1'b1;
		else
			done_plot = 1'b0;
	end
	
	// counter for x
	always @(posedge clk) begin
		if (!resetn) 
			count_x <= 2'b00;
		else if (count_x_enable)
			count_x <= count_x + 2'b01;
	end	
	
	assign enable_y = (count_x == 2'b11) ? 1 : 0;
	
	// counter for y
	always @(posedge clk) begin
		if (!resetn)
			count_y <= 2'b00;
		else if (enable_y)
			count_y <= count_y + 2'b01;
	end

	assign x_out = x + count_x;
	assign y_out = y + count_y;
	assign colour_out = colour;
    
endmodule



module delay_counter5(enable, clk, resetn, enable_frame);
	input enable, clk, resetn;
	output enable_frame;
	reg [22:0] counter;
	  
	  assign enable_frame = (counter == 0) ? 1 : 0;
	  
	  always @(posedge clk)
	  begin
	       if (!resetn)
			      counter <= 53332;
			  else if (enable == 1'b1)
			  begin
					if (counter == 22'd0)
						counter <= 53332;
					else
						counter <= counter - 1'b1;
				end
	  end
endmodule

module frame_counter5(enable, clk, resetn, enable_out);
	input enable, clk, resetn;
	output enable_out;
	
	reg [2:0] frames;
	
	assign enable_out= (frames == 3'b111) ? 1 : 0;
	
	always @ (posedge clk)
	begin	
		if (!resetn)
			frames <= 0;
		else if (enable == 1'b1)
		begin 
			if (frames == 3'b111)
				frames <= 0;
			else
			frames <= frames + 1;
			end
	end
endmodule



module load5(move_left, move_right, jump, clk, reset, colour_in, colour_erase_enable, ld_x, ld_y,  x, y, colour,score_current);
	input move_left;
	input move_right;
	input jump;
	

	input clk, reset; 
	input [2:0] colour_in;
	input colour_erase_enable;
	input ld_x, ld_y;
	output reg [7:0] x;
	initial x = 8'd78;
	output reg [6:0] y;
	initial y = 7'd105;
	output reg [2:0] colour;
	
	output reg [7:0] score_current;
	initial score_current = 0;
	
	reg jump_reg;
	initial jump_reg = 0;
	                                                                               
//	reg vertical, horizontal;
	
	always @ (posedge clk)
	begin
		if (!reset) 
			begin
			x <= 8'd78;  
			end
		else 
		begin
			if (ld_x) 
				begin
					if ((move_left == 1) && (move_right == 0)) 
						if( x != 0 )
							x <= x - 1;
					if ((move_left == 0) && (move_right == 1))
						if( x != 156 )
							x <= x + 1;
				end		
		end
    end
	
	always @ (posedge clk)
	begin
	   if (!reset)
		begin
		   y <= 7'd108;
			score_current <= 8'd0;
		end
		else if (ld_y)
		begin

			if ( (jump == 1) && (jump_reg == 0))
				begin
				jump_reg = 1;
				
				score_current <= score_current + 8'd1;
				
				if ( y > 20 )
					y <= y - 20;
				else
					y <= 7'd105;
				end
			else if ( (jump == 0) && (jump_reg == 1))
			begin
				jump_reg = 0;
			end

				
		end
	end
				
				

	
	always @(*)
	begin
	    if (colour_erase_enable)
		    colour <= 3'b000;
	    else
		    colour <= colour_in;
	end
endmodule
