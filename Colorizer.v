`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Paul Long and Jordan Fluth
// 
// Create Date: 10/25/2014 10:56:23 PM
// Design Name: 
// Module Name: Colorizer
// Project Name: Project 2
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
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
                
/*******************************************************************************
    -- INSERT COMMENTS --
*******************************************************************************/                
    
	
	//assign botIcon = 2'b0; // Force for testing, not Icon Module yet :(
	
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
