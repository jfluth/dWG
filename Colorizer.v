`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2014 10:56:23 PM
// Design Name: 
// Module Name: Colorizer
// Project Name: 
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
    input [7:0] botIcon,
    input enableVideo,
    output reg [7:0] drawColor
    );
    
    parameter   BLACK   = 8'b00000000,
                WHITE   = 8'b11111111,
                GREY    = 8'b11011011,
                RED     = 8'b11100000,
                GREEN   = 8'b00011100;
                
/*******************************************************************************
    -- INSERT COMMENTS --
*******************************************************************************/                
    always @ (posedge clk) begin
        if (~enableVideo) drawColor <= BLACK;
        else if (botIcon != BLACK) drawColor <= botIcon;
        else begin
            case (worldIn)
                2'd0:   drawColor <= WHITE;
                2'd1:   drawColor <= BLACK;
                2'b2:   drawColor <= RED;
                2'd3:   drawColor <= GREY;
            endcase
        end
    end
endmodule
