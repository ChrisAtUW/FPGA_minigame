
/*
	Christopher Lam
	EE271A
	12/7
	Lab 6
	birdwin module
	
	This module controls the win conditions and logic for the player. When he killed the bird or wins. Outputs single bit logic for win and die scenerios.  
*/

module birdwin(clock, reset, r1, g1, win, die, treespass);

	input logic [15:0] r1, g1; //16 bit logic for rows where the bird moves and trees meet
	
	input logic clock, reset, treespass; //single bit logic
	
	output logic win, die; //output win or died
	
	logic [9:0] count; //logic for counter
	
	enum{S0, S1, S2} ps, ns; //declare states
	
	always_comb begin
		case (ps)
		
			S0: if ((r1 & g1) != 0) ns = S1; //collision logic, if 16 bit bird array AND with tree when it meets bird does not equal zero then they have collided. 
					else if (r1 == 16'b0000000000000000) ns = S1; // or if bird falls off map die
						else if (treespass == 1) ns = S2;//if everything else is ok and the trees have passed then player won
							else ns = S0; 
			S1: ns = S0;
			
			S2: ns = S0;
			
			
		endcase
		
		//declare which states represent when the player has died and won
		case (ps)
		
		S0: die = 0;
		S1: die = 1;
		S2: die = 0;
		
		endcase
		
		case(ps)
		
		S0: win = 0;
		S1: win = 0;
		S2: win = 1; 
		
		endcase
		
	end
	
	//counter to use to slow down logic for this module
	always_ff @(posedge clock) begin
		if(reset)
			count <= 10'b0000000000;
			
		else if (count == 10'b1111111111)
			count <= 10'b0000000000;
		
		else
			count <= count + 10'b0000000001;
	end
	
	always_ff @(posedge clock) begin
		if (reset)
			ps <= S0;
		else if (count == 10'b1111111111) begin //when count reaches a certain point move to next state, mainly to slow down the logic and actually see it on the display
			ps <= ns;
		end
	end
	
endmodule 

module birdwin_testbench(); //testbench for bird movement
	
	logic [15:0] r1, g1; //16 bit logic for rows where the bird moves and trees meet
	
	logic clock, reset, treespass; //single bit logic
	
	logic win, die;
	
	birdwin dut(.clock, .reset, .r1, .g1, .win, .die, .treespass); //ten bit module device under test
	
	parameter clock_period = 100;
		
			initial begin
				clock <= 0;
				forever #(clock_period /2) clock <= ~clock; //every 100/2 period flip the bit of the clock set by DE1_SoC
					
			end 
			
			initial begin 
			
			reset <= 1;	@(posedge clock); //input current state of birdmovement and green row where it meets bird
			reset <= 0;	@(posedge clock);
							r1 <= 16'b0000000100000000; @(posedge clock);//bird passed the tree
							g1 <= 16'b1111110001111111; @(posedge clock);
							@(posedge clock);
							r1 <= 16'b0001000000000000; @(posedge clock);//bird crashed
							g1 <= 16'b1111110001111111; @(posedge clock);
							@(posedge clock);
					reset <= 1;	@(posedge clock);//reset
					reset <= 0;	@(posedge clock);
							@(posedge clock);
							r1 <= 16'b0000000100000000; @(posedge clock); //bird goes through tree and all trees have passed
							g1 <= 16'b1111110001111111;@(posedge clock);
							treespass <= 1; @(posedge clock);
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