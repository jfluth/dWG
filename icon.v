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
//
//////////////////////////////////////////////////////////////////////////////////
module icon (
  
  ///////////////////////////////////////////////////////////////////////////
  // Port Declarations
  ///////////////////////////////////////////////////////////////////////////
  input					clk,
  input			[9:0]	pixCol,			// Current pixel getting drawn
  input			[9:0]	pixRow,
  input			[7:0]	locX,			// RoboCop's current location
  input			[7:0]	locY,			// top left corner
  input			[7:0]	botInfo,
  output	reg	[11:0]	botIcon			// Colour that should be output
);


  ///////////////////////////////////////////////////////////////////////////
  // Internal Signals
  ///////////////////////////////////////////////////////////////////////////
  reg	[3:0]	iconX;			// index into columns of icon pixelmap ROM
  reg	[3:0]	iconY;			// index into rows of icon pixelmap ROM
  wire	[7:0]	iconTopLeft;	// Bounds of the icon 
  wire	[7:0]	iconTopRight;
  wire	[7:0]	iconBotLeft;
  wire	[7:0]	iconBotRight;
  wire	[11:0]	pixelColor;		// Colour out from ROM
  reg	[8:0]	romAddress;		
  wire	[9:0]	stretchLocX, stretchLocY;
  
  
  ///////////////////////////////////////////////////////////////////////////
  // Global Assigns
  ///////////////////////////////////////////////////////////////////////////
  assign iconLeft   = locX;
  assign iconRight  = locX+10'd15;
  assign iconTop    = locY;
  assign iconBottom = locY+10'd15;
  
  // Stretch the world, man (map 128 world into 512 world
  //assign stretchLocX = {locX,2'b0};
  //assign stretchLocY = {locY,2'b0};
  
  ///////////////////////////////////////////////////////////////////////////
  // Instantiate the Block ROM holding Icon
  ///////////////////////////////////////////////////////////////////////////
  iconRom2 iconROM (
	.clka	(clk),
	.ena	(1'b0),				// Always enabled
	.addra	(romAddress),
	.douta	(pixelColor));
  
  
  // Set index into icon ROM
  always @ (posedge clk) begin
	iconX <= pixCol[3:0] - locX[3:0];
	iconY <= pixRow[3:0] - locX[3:0];
  end
  
 
  // Decide when to paint the botIcon
  // If (pixCol,pixRow) overlap (locX,locY) to (locX+15,locY+15)
  // Paint the Icon, otherwise paint "00" (transparency)
  //PWL YOU HAVE THIS MATH WRONG THIS IS WHERE YOU SHOULD BE LOOKING
  always @ (posedge clk) begin
	if (pixCol >= iconLeft && pixCol <= iconRight &&
		pixRow >= iconTop  && pixRow <= iconBottom) begin
		
		romAddress <= {1'b0,iconY,iconX};	// index into rom
		botIcon    <= pixelColor;			// paint that color
	end
	else begin
		romAddress <= 9'b0;					// reset index
		botIcon    <= 12'b0;				// transparent
		
	end
  end
	  





endmodule 