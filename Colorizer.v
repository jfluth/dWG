`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	filename:	Colorizer.v
//
//	ECE 540 Project2: RojoBot World
//	
//	Jordan Fluth <jfluth@gmail>
//	Paul Long <pwl@pdx.edu>
// 
//	25 October 2014
//	
//	Description:
//		In addition to various houskeeping signals (like clock), this module
//		take in codes from the BotSim IP and from the Icon module that indicate
//		the color that should be painted to the screen. It is basically a mux.
// 
//////////////////////////////////////////////////////////////////////////////////


module Colorizer(
    input clk,
    input [1:0] worldIn,
    input [11:0] botIcon,
    input enableVideo,
    output reg [11:0] drawColor
    );
    					//	 {red,grn,blu}
    parameter   BLACK   = 12'b000000000000,
                WHITE   = 12'b111111111111,
                GREEN   = 12'b000011110000,
                RED     = 12'b111100000000,
				BLUE	= 12'b000000001111;
                

	always @ (posedge clk) begin
        if (~enableVideo) drawColor <= BLACK;		// if video is off show black
        else if (botIcon) drawColor <= botIcon;		// if botIcon is not transparent, draw it
        else begin
            case (worldIn)							
                2'b00:   drawColor <= WHITE;		// Background
                2'b01:   drawColor <= BLACK;		// Line
                2'b10:   drawColor <= GREEN;		// Obstruction
                2'b11:   drawColor <= RED;			// Reserved (green)
            endcase
        end
    end
endmodule
