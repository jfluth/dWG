`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// filename:	icon.v
//
// ECE 540 Project 2: RojoBot World
//
// Jordan Fluth <jfluth@gmail.com>
// Paul Long pwl@pdx.edu
//
// 29 October 2014
//
// Description:
//
// 
//
//
// PWL TODO:	fix reset. invert the reset globally and change
//				debounce and sevenseg to expect reset active high.
//
//////////////////////////////////////////////////////////////////////////////////
module icon (
  
  ///////////////////////////////////////////////////////////////////////////
  // Port Declarations
  ///////////////////////////////////////////////////////////////////////////
  input					clk,
  input			[9:0]	pixCol,			// Current pixed getting drawn
  input			[9:0]	pixRow,
  input			[7:0]	locX,			// RoboCop's current location
  input			[7:0]	locY,			// top left corner

  output	reg	[11:0]	botIcon			// Color that should be output
);


  ///////////////////////////////////////////////////////////////////////////
  // Internal Signals
  ///////////////////////////////////////////////////////////////////////////
  reg	[3:0]	iconX;			// index into columns of icon pixelmap
  reg	[3:0]	iconY;			// index into rows of icon pixelmap
  wire	[7:0]	iconTopLeft;	// Bounds of the icon 
  wire	[7:0]	iconTopRight;
  wire	[7:0]	iconBotLeft;
  wire	[7:0]	iconBotRight;
  wire	[1:0]	pixelColor;
  
  
  ///////////////////////////////////////////////////////////////////////////
  // Global Assigns
  ///////////////////////////////////////////////////////////////////////////
  assign iconTopLeft  = {locX,			locY};
  assign iconTopRight = {locX+4'd15,	locY};
  assign iconBotLeft  = {locX,			locY+4'd15};
  assign iconBotRight = {locX+4'd15,	locY+4'd15};
  
  
  ///////////////////////////////////////////////////////////////////////////
  // Instantiate the Block ROM holding Icon
  ///////////////////////////////////////////////////////////////////////////
  iconROM iconROM (
	.clka	(clk),
	.addra	({iconX,iconY}),
	.douta	(pixelColor));
  
  
  // Set index into icon ROM
  always @ (posedge clk) begin
	iconX <= pixCol - iconX;
	iconY <= pixRow - iconY;
  end

 
  // Decide when to paint the botIcon
  // If (pixCol,pixRow) overlap (locX,locY) to (locX+15,locY+15)
  // Paint the Icon, otherwise paint "00" (transparency)
  always @ (posedge clk) begin
	if (pixCol >= iconTopLeft && pixCol <= iconTopRight &&
		pixRow >= iconBotLeft && pixRow <= iconBotRight) begin
		
		botIcon <= pixelColor;
	end
	else begin
		botIcon <= 2'b0;
	end
  end
	  





endmodule 