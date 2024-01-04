
//Christopher Lam, 12/7, EE271A, Lab 6

// Takes in a clock signal, divides the clock cycle and outputs 32
// divided clock signals of varying frequency.
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ...
// [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	
	input logic clock; //declare input logic clock
	output logic [31:0] divided_clocks = 32'b0;//declare output logic for clock as 32 bit index
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1; 
		/*as you pull higher bits from clock index of 32 output result is slower clocks.
	  When you increase bit count by one the clock will switch at half the frequency of the previous bit index. 
	*/
	end
endmodule


module clock_divider_testbench();//testbench for clock divdier, test runs clock cycles 100 before stoping
	logic clock;//declare clock logic
	logic [31:0] divided_clocks;//declare 32 bit clock logic
	
	clock_divider dut (.clock, .divided_clocks);//call clock divider module
	
	// TODO: Set up the clock.

	initial begin
		
				parameter clock_period = 100; //set parameter variable clock period
		
			clock <= 0;
			forever #(clock_period /2) clock <= ~clock; //every 100/2 period flip the bit of the clock. 
					
		end //initial
		
		integer i;//declare i int
		
		initial begin
		
		
		for (i=0; i<100; i++) begin//begin for loop to test clock cycles for different bit changes 100 times
				@(posedge clock);
			end//end for loop

		$stop;//stop the clock cycles
	end
endmodule

