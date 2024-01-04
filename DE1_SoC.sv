
//Christopher Lam, 12/7, EE271A, Lab 6, DE1_SoC module

/*
	Module that integrates all FMS and logic together. It outputs the score count on HEX displays 1,2, and 3 as well as outputs arrays to then display on the provided LED driver.
	Overall, this module is intended to upload to a FPGA board where a sort of flappy bird game is displayed. 
	
	Game Rules and description:
	
	inputs:
	-Press Key 3 to go up once, hold to continue going up.
	-Flip Switch 0 off to pause the game and on to resume.
	-Flip Switch 9 on and then back to off to reset.
	
	Description:
	Control your bird to fly between the trees, try not to bump into the trees otherwise you die. You will also die if your bird falls off the map.
	Once you make it to the otherside of all the trees you will win and your score will increment and display on the HEX displays. 
	When you win the trees reset for the next round, but your bird and score will still be in the same place. 
	If you die, your score and everything will reset. 
	
*/

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_1); //DE1_SoC for electronic version of tug of war
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; //output on HEX display 
	output logic [9:0] LEDR;//output on LEDR's 9-0
	input logic [3:0] KEY; // Active low property and Reset switch for key 0
	input logic [9:0] SW;//input switches for fsm
	output logic [35:0] GPIO_1;
	
	logic [31:0] clk; //32 bit logic for clock
	
	logic [15:0][15:0] redout; // 16x16 array of red LEDs
   logic [15:0][15:0] greenout; //16x16 array of green LEDs
	
	parameter clockspeed = 14; //clockspeed chosen for the clockdivider module
	
	logic reset, up, win, die, treespass; //single bit logic for modules
	
	logic [15:0] movementR16, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15, g16; //16 bit logic for LED rows
	logic [15:0] tree1, tree2, tree3; //16 bit logic for tree generation
	
	//tree sizes adjust to change the tree holes
	assign tree1 = 16'b1111110000111111;
	assign tree2 = 16'b1100001111111111;
	assign tree3 = 16'b1111111100001111;
	
	//use this if you want to test the counter easier
	//assign tree1 = 16'b1000000000000001;
	//assign tree2 = 16'b1000000000000001;
	//assign tree3 = 16'b1000000000000001;
	
	assign reset = SW[9]; // Reset when SW[9] is pressed
	
	//instiate the clock divider module
	clock_divider clkdiv(.clock(CLOCK_50), .divided_clocks(clk));	
	
	
	/*
	call the birdmovementstart module, this module processes the logic for the birds movements, it takes in key 3 and switch 0 and die as input and outputs 
	and outputs and array corresponding to the birds movements. 
	*/
	birdmovementstart R16(.clock(clk[clockspeed]), .reset(reset), .up(~KEY[3]), .out(movementR16), .die(die), .start(SW[0]));
	
	/*
	Call the trees module, this module generates the tree movement towards the bird, outputs array corresponding to the green LED rows and the tree movement. 
	different output for this module is treespass that lets the birdwin module know when all the trees have passed. 
	*/
		
	trees grntree1(.clock(clk[clockspeed]), .reset(reset), .start(SW[0]), .treein(tree1), .treein2(tree2), .treein3(tree3), .treespass(treespass), .win(win), .die(die), .g1(g1), .g2(g2), .g3(g3), .g4(g4), .g5(g5), .g6(g6), .g7(g7), .g8(g8), .g9(g9), .g10(g10), .g11(g11), .g12(g12), .g13(g13), .g14(g14), .g15(g15), .g16(g16));
	
	/*
	call ledlights module, this module forms the array to input into the LED driver for display on an FPGA board. Takes in all the rows that we have modified for display. 
	*/
	
	
	ledlights array(.RST(reset), .row16(movementR16), .g1(g1), .g2(g2), .g3(g3), .g4(g4), .g5(g5), .g6(g6), .g7(g7), .g8(g8), .g9(g9), .g10(g10), .g11(g11), .g12(g12), .g13(g13), .g14(g14), .g15(g15), .g16(g16), .RedPixels(redout), .GrnPixels(greenout));
	
	/*
	call birdwin module, this module controls all the logic for when a player wins, dies, or falls of the map. takes in treespass logic to know when all the trees have passed the bird. 
	*/
	
	
	birdwin conditions(.clock(clk[clockspeed]), .reset(reset), .r1(movementR16), .g1(g4), .win(win), .die(die), .treespass(treespass));
	
	/*
	call LEDDriver module that was given to us, I'm still unsure of how it works but it works...
	*/
	
	LEDDriver driver(.GPIO_1(GPIO_1), .RedPixels(redout), .GrnPixels(greenout), .EnableCount(1), .CLK(clk[clockspeed]), .RST(reset));

	/*
	call wincounter module, This module controls the count for whenever a player wins, it increments the players score upon a win and resets it when a player dies or they reset the game. 
	*/
	
	wincounter count(.clock(clk[clockspeed]), .reset(reset), .win(win), .die(die), .hex1(HEX1), .hex2(HEX2), .hex3(HEX3));
	
	//HEX 0, 4, and 7 are unused so assigned them to be blank
	assign HEX0 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
endmodule

module DE1_SoC_testbench();//testbench for DE1_SoC, manually assign sequence for fsm test

	logic CLOCK_50; // 50MHz clock
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;//declare HEX logic
	logic [9:0] LEDR;//declare LEDR Logic
	logic [3:0] KEY; // Active low property and key logic
	logic [9:0] SW;//declare Switch Logic
		
		DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);//values going through testbench
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin //similar to FSM testbench module, manually set inputs for test sequence
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50; //every 100/2 period flip the bit of the clock. 
					
		end //initial
		
		initial begin
		
			SW[9] <= 1;         	 			  			@(posedge CLOCK_50); //reset 
			SW[9] <= 0; KEY[3]<=0;   SW[8:0]<=0; @(posedge CLOCK_50); //set reset to zero and all other switches to zero and key 3
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
							 KEY[3]<=0;  SW[0]<=1; 		@(posedge CLOCK_50);//set switch 0 to equal 1 to pause
							 KEY[3]<=0; 					@(posedge CLOCK_50);	
							 KEY[3]<=0; 					@(posedge CLOCK_50);
							 KEY[3]<=0; 					@(posedge CLOCK_50);
																@(posedge CLOCK_50);	
																@(posedge CLOCK_50);	
																@(posedge CLOCK_50);	
							KEY[3]<=0;   					 @(posedge CLOCK_50);
							KEY[3]<=0; 	SW[0]<=0;		@(posedge CLOCK_50);//unpause and let the game run
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);	
							KEY[3]<=1;   					 @(posedge CLOCK_50);//press key 3 once to make the bird fly up one
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);	
							KEY[3]<=0; 						@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
																@(posedge CLOCK_50);
							SW[9] <= 1;						@(posedge CLOCK_50); //reset
							SW[9] <= 0;						@(posedge CLOCK_50);
																@(posedge CLOCK_50);
							KEY[3]<=0;   SW[0]<=1; 		@(posedge CLOCK_50); //pause the game again
							KEY[3]<=0;    					@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=1; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 						@(posedge CLOCK_50);	
							KEY[3]<=0; 						@(posedge CLOCK_50);
							KEY[3]<=0; 					@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															@(posedge CLOCK_50);
															
														  
			$stop; //end simulation							
							
		end //initial
		
endmodule		