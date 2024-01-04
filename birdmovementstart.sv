
/*
	Christopher Lam
	EE271A
	12/7
	Lab 6
	bird movement module
	
	This module controls the bird movement. since the bird moves only up or down on one row of the display module outputs up should move it up otherwise the bird should fall constantly. 
*/

module birdmovementstart (clock, reset, up, out, die, start);

	input logic clock, reset, up, die, start; //logic for pause and resets
	
	output logic [15:0] out; //16 bit out for row where bird moves
	
	logic [9:0] count; //logic for count to slow down logic
	
	
	//counter to use to slow down logic for this module
	always_ff @(posedge clock) begin
		if(reset)
			count <= 10'b0000000000;
			
		else if (count == 10'b1111111111)
			count <= 10'b0000000000;
		
		else
			count <= count + 10'b0000000001;
	end
	
	//resets should move bird back to start position
	always_ff @(posedge clock) begin
		if (reset)
		out <= 16'b0000000100000000;
		
		else if (die)
		
		out <= 16'b0000000100000000;
		
		else if (start) begin //when unpaused start the movements

				if (count == 10'b1111111111) begin //when count reaches a certain point move to next state, mainly to slow down the logic and actually see it on the display
		
					if (up) begin
						out <= out >> 1; //when up shift the bit or the bird to the right of the row effectively moving the bird up
						out[15] <= 0; //make the empty last bit 0
					end
			
					else begin
						out <= out << 1; //when up shift the bit or the bird to the left of the row effectively moving the bird down
						out[0] <= 0; //make the empty first bit 0
					end
		
				end
		end
	
	end
	
endmodule 

module birdmovementstart_testbench(); //testbench for bird movement

	logic clock, reset, up;
	
	logic [15:0] out;
	
	logic down;
	
	birdmovementstart dut(.clock, .reset, .up, .out); //ten bit module device under test
	
	parameter clock_period = 100;
		
			initial begin
				clock <= 0;
				forever #(clock_period /2) clock <= ~clock; //every 100/2 period flip the bit of the clock set by DE1_SoC
					
			end 
			
			initial begin 
			
			reset <= 1;	up <= 1; @(posedge clock); //no inputs except for reset and up so just put @ posedge clock to continue cycles.
			reset <= 0;	@(posedge clock);
							@(posedge clock);//bird should be flying up
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
							@(posedge clock);
			$stop;
		end
		
endmodule 