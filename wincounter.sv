
/*
	Christopher Lam
	EE271A
	12/7
	Lab 6
	wincounter module
	
	This module controls the counter for the win score. It takes in the win signal and outputs 3 7 bit numbers to display on HEX displays. When the player resets or dies then the score resets as well.
*/

module wincounter(clock, reset, win, die, hex1, hex2, hex3);

	input logic clock, reset, win, die; //declare single bit logic
	
	output logic [6:0] hex1, hex2, hex3; //declare 7 bit output logic
	
	logic [3:0] hex1count, hex2count, hex3count; //declare 4 bit logic for count, for count to reach 9 need 4 bits. 
	logic [9:0] count; //declare 10 bit logic for counter
	
	always_ff @(posedge clock) begin
		
		if (reset | die) begin //if reset or die then reset the count
			hex1count <= 4'b0000;
			hex2count <= 4'b0000;
			hex3count <= 4'b0000;
		end
		
		else if (count == 10'b1111111111) begin //when count reaches a certain point move to next state, mainly to slow down the logic and actually see it on the display
			if (win) begin //if player win begin the count
				hex1count <= hex1count + 4'b0001;
			
				if (hex1count == 4'b1010) begin //once hex1 reaches 10 then hex 2 begin count 
					hex2count <= hex2count + 4'b0001;
				
					if (hex2count == 4'b1010) begin //once hex 2 reaches 10 then hex 3 begin count
						hex3count <= hex3count + 4'b0001;
					end
				
				end
				
			end
			
		end
		
	end
	
	//sort of like decoder, translate 4 bit count to 7 bit number to display on hex display
	always_comb begin
		case(hex1count)
		
		4'b0000: hex1 = 7'b1000000;//0
		4'b0001: hex1 = 7'b1111001;//1
		4'b0010: hex1 = 7'b0100100;//2
		4'b0011: hex1 = 7'b0110000;//3
		4'b0100: hex1 = 7'b0011001;//4
		4'b0101: hex1 = 7'b0010010;//5
		4'b0110: hex1 = 7'b0000010;//6
		4'b0111: hex1 = 7'b1111000;//7
		4'b1000: hex1 = 7'b0000000;//8
		4'b1001: hex1 = 7'b0010000;//9
		default: hex1 = 7'b1111111;//nothing
		
		endcase
		
		case(hex2count)
		
		4'b0000: hex2 = 7'b1000000;//0
		4'b0001: hex2 = 7'b1111001;//1
		4'b0010: hex2 = 7'b0100100;//2
		4'b0011: hex2 = 7'b0110000;//3
		4'b0100: hex2 = 7'b0011001;//4
		4'b0101: hex2 = 7'b0010010;//5
		4'b0110: hex2 = 7'b0000010;//6
		4'b0111: hex2 = 7'b1111000;//7
		4'b1000: hex2 = 7'b0000000;//8
		4'b1001: hex2 = 7'b0010000;//9
		default: hex2 = 7'b1111111;//nothing
		
		endcase
		
		case(hex3count)
		
		4'b0000: hex3 = 7'b1000000;//0
		4'b0001: hex3 = 7'b1111001;//1
		4'b0010: hex3 = 7'b0100100;//2
		4'b0011: hex3 = 7'b0110000;//3
		4'b0100: hex3 = 7'b0011001;//4
		4'b0101: hex3 = 7'b0010010;//5
		4'b0110: hex3 = 7'b0000010;//6
		4'b0111: hex3 = 7'b1111000;//7
		4'b1000: hex3 = 7'b0000000;//8
		4'b1001: hex3 = 7'b0010000;//9
		default: hex3 = 7'b1111111;//nothing
		
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
	
endmodule 
			
module wincounter_testbench(); //testbench for bird movement

	logic clock, reset, win, die;
	
	logic [6:0] hex1, hex2, hex3; //declare 7 bit output logic
	
	logic [3:0] hex1count, hex2count, hex3count; //declare 4 bit logic for count, for count to reach 9 need 4 bits. 
	logic [9:0] count; //declare 10 bit logic for counter
	
	wincounter dut(.clock, .reset, .win, .die, .hex1, .hex2, .hex3); //ten bit module device under test
	
	parameter clock_period = 100;
		
			initial begin
				clock <= 0;
				forever #(clock_period /2) clock <= ~clock; //every 100/2 period flip the bit of the clock set by DE1_SoC
					
			end 
			
			initial begin 
			
			reset <= 1;	win <= 1; @(posedge clock); //no inputs except for reset and win and die so just put @ posedge clock to continue cycles.
			reset <= 0;	@(posedge clock);
							@(posedge clock);//count should be going up
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
							die <= 1; @(posedge clock);//count should reset
							die <= 0;@(posedge clock);
							@(posedge clock);
							win<= 1; @(posedge clock);//count should be going up again
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