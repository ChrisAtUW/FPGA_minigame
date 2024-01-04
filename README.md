# Game Instructions and General Info

## General Information

Hello! This project was made for one of the final labs in EE271 at UW Seattle, in which we had to create a mini game based on a short prompt. Within these files resides the code for minigame resembling "Flappy Bird" meant to be played on an FPGA board. On the LED array extension, a red dot representing a bird must be held in the air to fly between green pipes/trees. Colliding with any of the pipes/trees or flying off the screen results in death of the bird and the game restarts. Shown on HEX displays on the FPGA board is the score count for sucessful passes of tree/pipe obstacles.

The following code is written in SystemVerilog and is meant to synthesized and uploaded onto an FPGA Board with an LED array Extension. The DE1_SoC sv file combines all other files together to form the general game logic. It takes in FPGA inputs and outputs the game on the LED array extension. As an acknowledgement, the LEDDriver file and code was provided to us by Professor Scott Hauck for use and functionality of the LED array extension. 

### Video Demonstration of Game Functionality


https://github.com/ChrisAtUW/FPGA_minigame/assets/146300146/f0d137b0-1e2f-4345-a508-5066aeac3b16


Press play to start video.

## Game Instructions

### Inputs:
-Press Key 3 to go up once, hold to continue going up
-Flip Switch 0 off to pause the game and on to resume
-Flip Switch 9 on and then back to off to reset
	
### Description:

Control your bird to fly between the trees, try not to bump into the trees otherwise you die. You will also die if your bird falls off the map. Once you make it to the otherside of all the trees you will win and your score will increment and display on the HEX displays. When you win the trees reset for the next round, but your bird and score will still be in the same place. If you die, your score and everything will reset.

