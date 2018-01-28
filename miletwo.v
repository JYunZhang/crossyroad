module miletwo
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
      KEY,
      SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		
		HEX0,
		HEX1,
		
		LEDR
		);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	output   [9:0] LEDR;//	output [9:0] LEDR;
	
	output[6:0] HEX0;
	output[6:0] HEX1;
	

	
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire  [2:0] colour;
	wire  [7:0] x;
	wire  [6:0] y;
	
	reg [2:0] colour_o;
	reg [7:0] x_o;
	reg [6:0] y_o;

	wire [7:0] x1;
	wire [7:0] x2;
	wire [7:0] x3;
	wire [7:0] x4;
	wire [7:0] x6;//ob5
	wire [6:0] y1;
	wire [6:0] y2;
	wire [6:0] y3;
	wire [6:0] y4;
	wire [6:0] y6;//ob5
	wire [2:0] colour1;
	wire [2:0] colour2;
	wire [2:0] colour3;
	wire [2:0] colour4;
	wire [2:0] colour6;//ob5
	
	wire [7:0] x5;// for the dot
	wire [6:0] y5;//dot
	wire [2:0] colour5;//dot
	
	wire [6:0]CLOCK_mod6;
	wire [6:0]writeEn;
	
	reg writeEnVGA;
	
	wire succeed_from_dot;
	
	assign LEDR[9] = ~succeed_from_dot;
	
	assign LEDR[1] = crashing_signal;
	
	assign LEDR[8] = resetn;
	
	
	wire [7:0] score_current;
	
	wire crashing_signal;
	
	wire [2:0] current_state_ob1, current_state_ob2, current_state_ob3, current_state_ob4, current_state_ob0;
	
	
	wire resetn_mod,resetn_mod0,resetn_mod1,resetn_mod2,resetn_mod3,resetn_mod4;
	
	assign resetn_mod = &{resetn_mod0,resetn_mod1,resetn_mod2,resetn_mod3,resetn_mod4};
	
	wire resetn;
	
	assign resetn = & {KEY[0] ,crashing_signal, resetn_mod};
	assign LEDR[0] = resetn;

	wire go;
	assign go = ~KEY[1];
	
	assign LEDR[7] = resetn_mod;
	
	clear c0(
				.go(go),
				.resetn(resetn),
				.current_state_ob(current_state_ob0),
				.crashing_signal(crashing_signal),
				.CLK(CLOCK_50),
				.resetn_mod(resetn_mod0)
				);
	
	clear c1(
				.go(go),
				.resetn(resetn),
				.current_state_ob(current_state_ob1),
				.crashing_signal(crashing_signal),
				.CLK(CLOCK_50),
				.resetn_mod(resetn_mod1)
				);	
	clear c2(
				.go(go),
				.resetn(resetn),
				.current_state_ob(current_state_ob2),
				.crashing_signal(crashing_signal),
				.CLK(CLOCK_50),
				.resetn_mod(resetn_mod2)
				);		
	clear c3(
				.go(go),
				.resetn(resetn),
				.current_state_ob(current_state_ob3),
				.crashing_signal(crashing_signal),
				.CLK(CLOCK_50),
				.resetn_mod(resetn_mod3)
				);	
	clear c4(
				.go(go),
				.resetn(resetn),
				.current_state_ob(current_state_ob4),
				.crashing_signal(crashing_signal),
				.CLK(CLOCK_50),
				.resetn_mod(resetn_mod4)
				);	
				
				
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEnVGA),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK)
			);
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "4lines.mif";
		
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
	always @(*)
	begin
		if (writeEn[0] == 1'b1) 
							begin
							x_o = x1; 
							y_o = y1; 
							colour_o = colour1;
							writeEnVGA = 1'b1;
							end
		else if(writeEn[1] == 1'b1)
							begin
							x_o = x2; 
							y_o = y2; 
							colour_o = colour2;
							writeEnVGA = 1'b1;
							end
		else if(writeEn[2] == 1'b1)
							begin
							x_o = x3; 
							y_o = y3; 
							colour_o = colour3;
							writeEnVGA = 1'b1;
							end
		else if(writeEn[3] == 1'b1)
							begin
							x_o = x4; 
							y_o = y4; 
							colour_o = colour4;
							writeEnVGA = 1'b1;
							end
		else if(writeEn[4] == 1'b1) //dot
							begin
							x_o = x5; 
							y_o = y5; 
							colour_o = colour5;
							writeEnVGA = 1'b1;
							end
		else if(writeEn[5] == 1'b1) //OB5
							begin
							x_o = x6; 
							y_o = y6; 
							colour_o = colour6;
							writeEnVGA = 1'b1;
							end
		else
					begin
					x_o = 0;
					y_o = 0; 
					colour_o = 0;
					writeEnVGA = 1'b0;
					end	
	end
	assign x = x_o;
	assign y = y_o;
	assign colour = colour_o;
		
	ob0 o1(
			        .CLOCK(CLOCK_mod6[0]),
					  .go(go),
					  .sw(SW[9:0]),
					  .resetn(resetn_mod0),
					  .x(x1),
					  .y(y1),
					  .colour(colour1),
					  .writeEn(writeEn[0]),
					  .current_state(current_state_ob0)
					  );
					  
	ob2 o2(
			        .CLOCK(CLOCK_mod6[1]),
					  .go(go),
					  .sw(SW[9:0]),
					  .resetn(resetn_mod1),
					  .x(x2),
					  .y(y2),
					  .colour(colour2),
					  .writeEn(writeEn[1]),
					  .current_state(current_state_ob1)
					  );
	ob3 o3(
			        .CLOCK(CLOCK_mod6[2]),
					  .go(go),
					  .sw(SW[9:0]),
					  .resetn(resetn_mod2),
					  .x(x3),
					  .y(y3),
					  .colour(colour3),
					  .writeEn(writeEn[2]),
					  .current_state(current_state_ob2)
					  );
	ob4 o4(
			        .CLOCK(CLOCK_mod6[3]),
					  .go(go),
					  .sw(SW[9:0]),
					  .resetn(resetn_mod3),
					  .x(x4),
					  .y(y4),
					  .colour(colour4),
					  .writeEn(writeEn[3]),
					  .current_state(current_state_ob3)
					  );
	ob5 o5(
			        .CLOCK(CLOCK_mod6[5]),
					  .go(go),
					  .sw(SW[9:0]),
					  .resetn(resetn_mod4),
					  .x(x6),
					  .y(y6),
					  .colour(colour6),
					  .writeEn(writeEn[5]),
					  .current_state(current_state_ob4)
					  );
					  
	dot dot0(
			        .CLOCK(CLOCK_mod6[4]),
					  .go(go),
					  .sw(SW[9:0]),
					  .resetn(resetn),
					  .move_left(SW[2]),
					  .move_right(SW[0]),
					  .jump(KEY[3]),
					  .x(x5),
					  .y(y5),
					  .colour(colour5),
					  .writeEn(writeEn[4]),
					  .score_current(score_current)
					  );

	detection d0(
							.go(go),
							.x_lane0(x1),
							.y_lane0(y1),
	
							.x_lane1(x2),
							.y_lane1(y2),
	
	
							.x_lane2(x4),
							.y_lane2(y4),
	
	
							.x_lane3(x3),
							.y_lane3(x3),
							
							.x_lane4(x6),
							.y_lane4(y6),
	
	
							.x_dot(x5),

							.y_dot(y5),
	
							.CLK(CLOCK_50),
							.resetn(crashing_signal)
							);
							
	hexdecoder h0(
							.c(score_current[3:0]),
							.h(HEX0)
							);
							
	hexdecoder h1(
							.c(score_current[7:4]),
							.h(HEX1)
							);
	
					  
	modulo_clock0 clk1(
		.CLOCK(CLOCK_50),
		.resetn(resetn),
		.CLK_mod6(CLOCK_mod6)
	);
	
	
endmodule


module modulo_clock0(
	input CLOCK,
	input resetn,
	output reg [6:0]CLK_mod6
	);
	
	reg [2:0] counter;
	initial counter = 0;
	
	always @(posedge CLOCK) begin
	if (counter == 3'b111)
			counter <= 3'b000;
		else
			counter <= counter + 3'b001;
	end
	
	always @(*)
	begin
		case(counter)
			3'b110 : CLK_mod6 <= 7'b0000001;
			3'b001 : CLK_mod6 <= 7'b0000010;
			3'b010 : CLK_mod6 <= 7'b0000100;
			3'b011 : CLK_mod6 <= 7'b0001000;
			3'b100 : CLK_mod6 <= 7'b0010000;
			3'b101 : CLK_mod6 <= 7'b0100000;
			default: CLK_mod6 <= 7'b1000000;
		endcase
	end
	

endmodule
		