
/*
	Christopher Lam
	EE271A
	12/7
	Lab 6
	ledlights module
	
	This module takes in all the rows that we have set to move and combines them into a 16x16 array to input into the driver for display. 
*/

module ledlights(RST, row16, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15, g16, RedPixels, GrnPixels);
    input logic RST; //reset input
	 input logic [15:0] row16, g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g13, g14, g15, g16; //input our green and red rows
	 
    output logic [15:0][15:0] RedPixels; // 16x16 array of red LEDs
    output logic [15:0][15:0] GrnPixels; // 16x16 array of green LEDs
	 
	 always_comb 
	 begin
		
		// Reset - Turn off all LEDs 
		if (RST)
		begin
			RedPixels = '0;
			GrnPixels = '0;
		end
		
	  // Display a pattern
		else
		begin
		  //                  FEDCBA9876543210
		  RedPixels[00] = 16'b0000000000000000;
		  RedPixels[01] = 16'b0000000000000000;
		  RedPixels[02] = 16'b0000000000000000;
		  RedPixels[03] = row16;
		  RedPixels[04] = 16'b0000000000000000;
		  RedPixels[05] = 16'b0000000000000000;
		  RedPixels[06] = 16'b0000000000000000;
		  RedPixels[07] = 16'b0000000000000000;
		  RedPixels[08] = 16'b0000000000000000;
		  RedPixels[09] = 16'b0000000000000000;
		  RedPixels[10] = 16'b0000000000000000;
		  RedPixels[11] = 16'b0000000000000000;
		  RedPixels[12] = 16'b0000000000000000;
		  RedPixels[13] = 16'b0000000000000000;
		  RedPixels[14] = 16'b0000000000000000;
		  RedPixels[15] = 16'b0000000000000000;
		  
		  //                  FEDCBA9876543210
		  GrnPixels[00] = g1;
		  GrnPixels[01] = g2;
		  GrnPixels[02] = g3;
		  GrnPixels[03] = g4;
		  GrnPixels[04] = g5;
		  GrnPixels[05] = g6;
		  GrnPixels[06] = g7;
		  GrnPixels[07] = g8;
		  GrnPixels[08] = g9;
		  GrnPixels[09] = g10;
		  GrnPixels[10] = g11;
		  GrnPixels[11] = g12;
		  GrnPixels[12] = g13;
		  GrnPixels[13] = g14;
		  GrnPixels[14] = g15;
		  GrnPixels[15] = g16;
		end
	end

endmodule

module ledlights_testbench(); //testbench for Ledlights

	logic RST;
	logic [15:0][15:0] RedPixels, GrnPixels;
	
	ledlights dut (.RST, .RedPixels, .GrnPixels);
	
	initial begin
	RST = 1'b1; #10;
	RST = 1'b0; #10;
	end
	
endmodule
