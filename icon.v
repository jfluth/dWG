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
  input			[9:0]	locX,			// RoboCop's current location
  input			[9:0]	locY,			// top left corner
  input			[7:0]	botInfo,
  output	reg	[11:0]	botIcon			// 12-bit rgb color
);


  ///////////////////////////////////////////////////////////////////////////
  // Some Nice Constants
  ///////////////////////////////////////////////////////////////////////////
  localparam N  = 3'b000;				// These are the BotInfo_reg encodings
  localparam S  = 3'b100;				// for compass heading
  localparam E  = 3'b010;
  localparam W  = 3'b110;
  localparam NE = 3'b001;
  localparam SW = 3'b101;
  localparam SE = 3'b011;
  localparam NW = 3'b111;
  
  
  ///////////////////////////////////////////////////////////////////////////
  // Internal Signals
  ///////////////////////////////////////////////////////////////////////////
  reg	[3:0]	iconBitmapX, iconBitmapY;		// index into icon pixelmap ROM
  //reg	[3:0]	centeredLocX, centeredLocY;	// adjustment to center bot on line
  //wire	[3:0]	stretchLocX, stretchLocY;
  wire	[9:0]	iconLeft;			// Bounds of the icon 
  wire	[9:0]	iconRight;
  wire	[9:0]	iconTop;
  wire	[9:0]	iconBottom;
  
  wire	[11:0]	pixelColor;			// Color out from ROM
  reg	[8:0]	romAddress;		
  reg	[11:0]	iconPixArray[511:0];	
  
  
  // These are the icon index transforms that need done in order to use
  // 2 Icons for the eight ordinal directions in which the bot can be headed
  wire	[8:0]	xformN  = {1'b0, 		iconBitmapY,		iconBitmapX }; 
  wire	[8:0]	xformS  = {1'b0, 4'd15-	iconBitmapY, 4'd15-	iconBitmapX }; 
  wire	[8:0]	xformE  = {1'b0, 4'd15-	iconBitmapX, 		iconBitmapY }; 
  wire	[8:0]	xformW  = {1'b0, 		iconBitmapX, 4'd15-	iconBitmapY }; 
  wire	[8:0]	xformNE = {1'b1, 		iconBitmapY, 		iconBitmapX };
  wire	[8:0]	xformSW = {1'b1, 4'd15-	iconBitmapY, 4'd15-	iconBitmapX };
  wire	[8:0]	xformSE = {1'b1, 4'd15-	iconBitmapX, 		iconBitmapY };
  wire	[8:0]	xformNW = {1'b1, 		iconBitmapX, 4'd15-	iconBitmapY };
  
  
  
  ///////////////////////////////////////////////////////////////////////////
  // Global Assigns
  ///////////////////////////////////////////////////////////////////////////
  // This give us an 16x16 box centered on both loc(x,y) and the line
  assign iconLeft   = locX-10'd6;
  assign iconRight  = locX+10'd9;
  assign iconTop    = locY-10'd6;
  assign iconBottom = locY+10'd9;
  
 
  ///////////////////////////////////////////////////////////////////////////
  // Instantiate the Block ROM holding Icon
  ///////////////////////////////////////////////////////////////////////////
  /*iconRom iconROM (
	.clka	(clk),
	.ena	(1'b0),				// Always enabled
	.addra	(romAddress),
	.douta	(pixelColor));*/
  
  
  // Set index into icon
  always @ (posedge clk) begin
	iconBitmapX <= pixCol[3:0] - iconLeft[3:0];
	iconBitmapY <= pixRow[3:0] -  iconTop[3:0];
  end
  
 
  // Decide when to paint the botIcon
  // If the cathode ray gun overlaps the adjusted bot location,
  // paint the icon, otherwise paint "00" (transparency)

  always @ (posedge clk) begin
	if (pixCol >= iconLeft && pixCol <= iconRight &&
		pixRow >= iconTop  && pixRow <= iconBottom) begin
		
		case (botInfo[2:0])
			N :	botIcon <= iconPixArray[xformN];
			S :	botIcon <= iconPixArray[xformS];
			E :	botIcon <= iconPixArray[xformE];
			W :	botIcon <= iconPixArray[xformW];
			NE:	botIcon <= iconPixArray[xformNE];
			NW:	botIcon <= iconPixArray[xformNW];
			SE:	botIcon <= iconPixArray[xformSE];
			SW:	botIcon <= iconPixArray[xformSW];
			// We should never get here
			default: botIcon <= 12'b0;
		endcase	
	end
	else begin
		botIcon    <= 12'b0;				// transparent 
	end
  end
	  
  initial begin
/*	iconPixArray[0]   = 12'h000;
	iconPixArray[1]   = 12'h000;
	iconPixArray[2]   = 12'h000;
	iconPixArray[3]   = 12'h000;
	iconPixArray[4]   = 12'h000;
	iconPixArray[5]   = 12'h5BB;
	iconPixArray[6]   = 12'h5BB;
	iconPixArray[7]   = 12'h5BB;
	iconPixArray[8]   = 12'h5BB;
	iconPixArray[9]   = 12'h5BB;
	iconPixArray[10]  = 12'h5BB;
	iconPixArray[11]  = 12'h000;
	iconPixArray[12]  = 12'h000;
	iconPixArray[13]  = 12'h000;
	iconPixArray[14]  = 12'h000;
	iconPixArray[15]  = 12'h000;
	iconPixArray[16]  = 12'h000;
	iconPixArray[17]  = 12'h000;
	iconPixArray[18]  = 12'h000;
	iconPixArray[19]  = 12'h5BB;
	iconPixArray[20]  = 12'h5BB;
	iconPixArray[21]  = 12'h599;
	iconPixArray[22]  = 12'hE22;
	iconPixArray[23]  = 12'hECC;
	iconPixArray[24]  = 12'hD44;
	iconPixArray[25]  = 12'hE22;
	iconPixArray[26]  = 12'h599;
	iconPixArray[27]  = 12'h5BB;
	iconPixArray[28]  = 12'h5BB;
	iconPixArray[29]  = 12'h000;
	iconPixArray[30]  = 12'h000;
	iconPixArray[31]  = 12'h000;
	iconPixArray[32]  = 12'h000;
	iconPixArray[33]  = 12'h000;
	iconPixArray[34]  = 12'h5BB;
	iconPixArray[35]  = 12'h599;
	iconPixArray[36]  = 12'hD44;
	iconPixArray[37]  = 12'hA55;
	iconPixArray[38]  = 12'hC77;
	iconPixArray[39]  = 12'hC77;
	iconPixArray[40]  = 12'hC77;
	iconPixArray[41]  = 12'hC77;
	iconPixArray[42]  = 12'hB00;
	iconPixArray[43]  = 12'hD44;
	iconPixArray[44]  = 12'h599;
	iconPixArray[45]  = 12'h5BB;
	iconPixArray[46]  = 12'h000;
	iconPixArray[47]  = 12'h000;
	iconPixArray[48]  = 12'h000;
	iconPixArray[49]  = 12'h5BB;
	iconPixArray[50]  = 12'h599;
	iconPixArray[51]  = 12'hA55;
	iconPixArray[52]  = 12'hAFF;
	iconPixArray[53]  = 12'h933;
	iconPixArray[54]  = 12'h9FF;
	iconPixArray[55]  = 12'h9FF;
	iconPixArray[56]  = 12'h9FF;
	iconPixArray[57]  = 12'h9FF;
	iconPixArray[58]  = 12'h9FF;
	iconPixArray[59]  = 12'hAFF;
	iconPixArray[60]  = 12'hB00;
	iconPixArray[61]  = 12'h433;
	iconPixArray[62]  = 12'h5BB;
	iconPixArray[63]  = 12'h000;
	iconPixArray[64]  = 12'h000;
	iconPixArray[65]  = 12'h5BB;
	iconPixArray[66]  = 12'h9BB;
	iconPixArray[67]  = 12'h6AA;
	iconPixArray[68]  = 12'h288;
	iconPixArray[69]  = 12'hFFF;
	iconPixArray[70]  = 12'hFFF;
	iconPixArray[71]  = 12'hFFF;
	iconPixArray[72]  = 12'hFFF;
	iconPixArray[73]  = 12'hFFF;
	iconPixArray[74]  = 12'hFFF;
	iconPixArray[75]  = 12'hFFF;
	iconPixArray[76]  = 12'h4BB;
	iconPixArray[77]  = 12'h9BB;
	iconPixArray[78]  = 12'h5BB;
	iconPixArray[79]  = 12'h000;
	iconPixArray[80]  = 12'h5BB;
	iconPixArray[81]  = 12'h433;
	iconPixArray[82]  = 12'h511;
	iconPixArray[83]  = 12'h288;
	iconPixArray[84]  = 12'hFFF;
	iconPixArray[85]  = 12'hFFF;
	iconPixArray[86]  = 12'hFFF;
	iconPixArray[87]  = 12'hFFF;
	iconPixArray[88]  = 12'hFFF;
	iconPixArray[89]  = 12'hFFF;
	iconPixArray[90]  = 12'hFFF;
	iconPixArray[91]  = 12'hFFF;
	iconPixArray[92]  = 12'hFFF;
	iconPixArray[93]  = 12'h222;
	iconPixArray[94]  = 12'h433;
	iconPixArray[95]  = 12'h5BB;
	iconPixArray[96]  = 12'h5BB;
	iconPixArray[97]  = 12'h6BB;
	iconPixArray[98]  = 12'h222;
	iconPixArray[99]  = 12'hFFF;
	iconPixArray[100] = 12'hFFF;
	iconPixArray[101] = 12'hD55;
	iconPixArray[102] = 12'h800;
	iconPixArray[103] = 12'hFFF;
	iconPixArray[104] = 12'hFFF;
	iconPixArray[105] = 12'hFFF;
	iconPixArray[106] = 12'h800;
	iconPixArray[107] = 12'h800;
	iconPixArray[108] = 12'hFFF;
	iconPixArray[109] = 12'h900;
	iconPixArray[110] = 12'h9BB;
	iconPixArray[111] = 12'h5BB;
	iconPixArray[112] = 12'h5BB;
	iconPixArray[113] = 12'h088;
	iconPixArray[114] = 12'h288;
	iconPixArray[115] = 12'hFFF;
	iconPixArray[116] = 12'hFFF;
	iconPixArray[117] = 12'h1BB;
	iconPixArray[118] = 12'h800;
	iconPixArray[119] = 12'hFFF;
	iconPixArray[120] = 12'hFFF;
	iconPixArray[121] = 12'hFFF;
	iconPixArray[122] = 12'h800;
	iconPixArray[123] = 12'h800;
	iconPixArray[124] = 12'hFFF;
	iconPixArray[125] = 12'hFFF;
	iconPixArray[126] = 12'h088;
	iconPixArray[127] = 12'h5BB;
	iconPixArray[128] = 12'h5BB;
	iconPixArray[129] = 12'h088;
	iconPixArray[130] = 12'hFFF;
	iconPixArray[131] = 12'h544;
	iconPixArray[132] = 12'hFFF;
	iconPixArray[133] = 12'hFFF;
	iconPixArray[134] = 12'hFFF;
	iconPixArray[135] = 12'hFFF;
	iconPixArray[136] = 12'hFFF;
	iconPixArray[137] = 12'hFFF;
	iconPixArray[138] = 12'hFFF;
	iconPixArray[139] = 12'hFFF;
	iconPixArray[140] = 12'hFFF;
	iconPixArray[141] = 12'h544;
	iconPixArray[142] = 12'h088;
	iconPixArray[143] = 12'h5BB;
	iconPixArray[144] = 12'h5BB;
	iconPixArray[145] = 12'h088;
	iconPixArray[146] = 12'h5DD;
	iconPixArray[147] = 12'h544;
	iconPixArray[148] = 12'hFFF;
	iconPixArray[149] = 12'hFFF;
	iconPixArray[150] = 12'hFFF;
	iconPixArray[151] = 12'hFFF;
	iconPixArray[152] = 12'hA11;
	iconPixArray[153] = 12'hFFF;
	iconPixArray[154] = 12'hFFF;
	iconPixArray[155] = 12'hFFF;
	iconPixArray[156] = 12'hFFF;
	iconPixArray[157] = 12'h544;
	iconPixArray[158] = 12'h088;
	iconPixArray[159] = 12'h5BB;
	iconPixArray[160] = 12'h5BB;
	iconPixArray[161] = 12'h744;
	iconPixArray[162] = 12'h744;
	iconPixArray[163] = 12'h1BB;
	iconPixArray[164] = 12'hFDD;
	iconPixArray[165] = 12'hFFF;
	iconPixArray[166] = 12'hFFF;
	iconPixArray[167] = 12'hFFF;
	iconPixArray[168] = 12'hFFF;
	iconPixArray[169] = 12'hFFF;
	iconPixArray[170] = 12'hFFF;
	iconPixArray[171] = 12'hFFF;
	iconPixArray[172] = 12'hA11;
	iconPixArray[173] = 12'h900;
	iconPixArray[174] = 12'h744;
	iconPixArray[175] = 12'h5BB;
	iconPixArray[176] = 12'h000;
	iconPixArray[177] = 12'h5BB;
	iconPixArray[178] = 12'hB00;
	iconPixArray[179] = 12'h544;
	iconPixArray[180] = 12'h1BB;
	iconPixArray[181] = 12'h9EE;
	iconPixArray[182] = 12'hFFF;
	iconPixArray[183] = 12'h6AA;
	iconPixArray[184] = 12'hFFF;
	iconPixArray[185] = 12'h6AA;
	iconPixArray[186] = 12'hFFF;
	iconPixArray[187] = 12'h9EE;
	iconPixArray[188] = 12'h1BB;
	iconPixArray[189] = 12'hB00;
	iconPixArray[190] = 12'h5BB;
	iconPixArray[191] = 12'h000;
	iconPixArray[192] = 12'h000;
	iconPixArray[193] = 12'h5BB;
	iconPixArray[194] = 12'hF11;
	iconPixArray[195] = 12'h5DD;
	iconPixArray[196] = 12'h1BB;
	iconPixArray[197] = 12'hA11;
	iconPixArray[198] = 12'hFFF;
	iconPixArray[199] = 12'h6AA;
	iconPixArray[200] = 12'hFFF;
	iconPixArray[201] = 12'h6AA;
	iconPixArray[202] = 12'hFFF;
	iconPixArray[203] = 12'hA11;
	iconPixArray[204] = 12'h744;
	iconPixArray[205] = 12'hF11;
	iconPixArray[206] = 12'h5BB;
	iconPixArray[207] = 12'h000;
	iconPixArray[208] = 12'h000;
	iconPixArray[209] = 12'h000;
	iconPixArray[210] = 12'h5BB;
	iconPixArray[211] = 12'hE99;
	iconPixArray[212] = 12'h744;
	iconPixArray[213] = 12'hFDD;
	iconPixArray[214] = 12'hA11;
	iconPixArray[215] = 12'h9EE;
	iconPixArray[216] = 12'h9EE;
	iconPixArray[217] = 12'hA11;
	iconPixArray[218] = 12'hFDD;
	iconPixArray[219] = 12'h5DD;
	iconPixArray[220] = 12'hE99;
	iconPixArray[221] = 12'h5BB;
	iconPixArray[222] = 12'h000;
	iconPixArray[223] = 12'h000;
	iconPixArray[224] = 12'h000;
	iconPixArray[225] = 12'h000;
	iconPixArray[226] = 12'h000;
	iconPixArray[227] = 12'h5BB;
	iconPixArray[228] = 12'h5BB;
	iconPixArray[229] = 12'hE99;
	iconPixArray[230] = 12'h744;
	iconPixArray[231] = 12'h5DD;
	iconPixArray[232] = 12'h5DD;
	iconPixArray[233] = 12'h744;
	iconPixArray[234] = 12'hE99;
	iconPixArray[235] = 12'h5BB;
	iconPixArray[236] = 12'h5BB;
	iconPixArray[237] = 12'h000;
	iconPixArray[238] = 12'h000;
	iconPixArray[239] = 12'h000;
	iconPixArray[240] = 12'h000;
	iconPixArray[241] = 12'h000;
	iconPixArray[242] = 12'h000;
	iconPixArray[243] = 12'h000;
	iconPixArray[244] = 12'h000;
	iconPixArray[245] = 12'h5BB;
	iconPixArray[246] = 12'h5BB;
	iconPixArray[247] = 12'h5BB;
	iconPixArray[248] = 12'h5BB;
	iconPixArray[249] = 12'h5BB;
	iconPixArray[250] = 12'h5BB;
	iconPixArray[251] = 12'h000;
	iconPixArray[252] = 12'h000;
	iconPixArray[253] = 12'h000;
	iconPixArray[254] = 12'h000;
	iconPixArray[255] = 12'h000;
*/                            

	iconPixArray[0]   = 12'hf00;
	iconPixArray[1]   = 12'hf00;
	iconPixArray[2]   = 12'hf00;
	iconPixArray[3]   = 12'hf00;
	iconPixArray[4]   = 12'hf00;
	iconPixArray[5]   = 12'hf00;
	iconPixArray[6]   = 12'hf00;
	iconPixArray[7]   = 12'hf00;
	iconPixArray[8]   = 12'hf00;
	iconPixArray[9]   = 12'hf00;
	iconPixArray[10]  = 12'hf00;
	iconPixArray[11]  = 12'hf00;
	iconPixArray[12]  = 12'hf00;
	iconPixArray[13]  = 12'hf00;
	iconPixArray[14]  = 12'hf00;
	iconPixArray[15]  = 12'hf00;
	iconPixArray[16]  = 12'hf00;
	iconPixArray[17]  = 12'hf00;
	iconPixArray[18]  = 12'hf00;
	iconPixArray[19]  = 12'hf00;
	iconPixArray[20]  = 12'hf00;
	iconPixArray[21]  = 12'hf00;
	iconPixArray[22]  = 12'hf00;
	iconPixArray[23]  = 12'hf0f;
	iconPixArray[24]  = 12'hf0f;
	iconPixArray[25]  = 12'hf00;
	iconPixArray[26]  = 12'hf00;
	iconPixArray[27]  = 12'hf00;
	iconPixArray[28]  = 12'hf00;
	iconPixArray[29]  = 12'hf00;
	iconPixArray[30]  = 12'hf00;
	iconPixArray[31]  = 12'hf00;
	iconPixArray[32]  = 12'hf00;
	iconPixArray[33]  = 12'hf00;
	iconPixArray[34]  = 12'hf00;
	iconPixArray[35]  = 12'hf00;
	iconPixArray[36]  = 12'hf00;
	iconPixArray[37]  = 12'hf00;
	iconPixArray[38]  = 12'hf0f;
	iconPixArray[39]  = 12'hf0f;
	iconPixArray[40]  = 12'hf0f;
	iconPixArray[41]  = 12'hf0f;
	iconPixArray[42]  = 12'hf00;
	iconPixArray[43]  = 12'hf00;
	iconPixArray[44]  = 12'hf00;
	iconPixArray[45]  = 12'hf00;
	iconPixArray[46]  = 12'hf00;
	iconPixArray[47]  = 12'hf00;
	iconPixArray[48]  = 12'hf00;
	iconPixArray[49]  = 12'hf00;
	iconPixArray[50]  = 12'hf00;
	iconPixArray[51]  = 12'hf00;
	iconPixArray[52]  = 12'hf00;
	iconPixArray[53]  = 12'hf0f;
	iconPixArray[54]  = 12'hf0f;
	iconPixArray[55]  = 12'hf0f;
	iconPixArray[56]  = 12'hf0f;
	iconPixArray[57]  = 12'hf0f;
	iconPixArray[58]  = 12'hf0f;
	iconPixArray[59]  = 12'hf00;
	iconPixArray[60]  = 12'hf00;
	iconPixArray[61]  = 12'hf00;
	iconPixArray[62]  = 12'hf00;
	iconPixArray[63]  = 12'hf00;
	iconPixArray[64]  = 12'hf00;
	iconPixArray[65]  = 12'hf00;
	iconPixArray[66]  = 12'hf00;
	iconPixArray[67]  = 12'hf00;
	iconPixArray[68]  = 12'hf0f;
	iconPixArray[69]  = 12'hf0f;
	iconPixArray[70]  = 12'hf0f;
	iconPixArray[71]  = 12'hf0f;
	iconPixArray[72]  = 12'hf0f;
	iconPixArray[73]  = 12'hf0f;
	iconPixArray[74]  = 12'hf0f;
	iconPixArray[75]  = 12'hf0f;
	iconPixArray[76]  = 12'hf00;
	iconPixArray[77]  = 12'hf00;
	iconPixArray[78]  = 12'hf00;
	iconPixArray[79]  = 12'hf00;
	iconPixArray[80]  = 12'hf00;
	iconPixArray[81]  = 12'hf00;
	iconPixArray[82]  = 12'hf00;
	iconPixArray[83]  = 12'hf0f;
	iconPixArray[84]  = 12'hf0f;
	iconPixArray[85]  = 12'hf0f;
	iconPixArray[86]  = 12'hf0f;
	iconPixArray[87]  = 12'hf0f;
	iconPixArray[88]  = 12'hf0f;
	iconPixArray[89]  = 12'hf0f;
	iconPixArray[90]  = 12'hf0f;
	iconPixArray[91]  = 12'hf0f;
	iconPixArray[92]  = 12'hf0f;
	iconPixArray[93]  = 12'hf00;
	iconPixArray[94]  = 12'hf00;
	iconPixArray[95]  = 12'hf00;
	iconPixArray[96]  = 12'hf00;
	iconPixArray[97]  = 12'hf00;
	iconPixArray[98]  = 12'hf0f;
	iconPixArray[99]  = 12'hf0f;
	iconPixArray[100] = 12'hf0f;
	iconPixArray[101] = 12'hf0f;
	iconPixArray[102] = 12'hf0f;
	iconPixArray[103] = 12'hf0f;
	iconPixArray[104] = 12'hf0f;
	iconPixArray[105] = 12'hf0f;
	iconPixArray[106] = 12'hf0f;
	iconPixArray[107] = 12'hf0f;
	iconPixArray[108] = 12'hf0f;
	iconPixArray[109] = 12'hf0f;
	iconPixArray[110] = 12'hf00;
	iconPixArray[111] = 12'hf00;
	iconPixArray[112] = 12'hf00;
	iconPixArray[113] = 12'hf0f;
	iconPixArray[114] = 12'hf0f;
	iconPixArray[115] = 12'hf0f;
	iconPixArray[116] = 12'hf0f;
	iconPixArray[117] = 12'hf0f;
	iconPixArray[118] = 12'hf0f;
	iconPixArray[119] = 12'hf0f;
	iconPixArray[120] = 12'hf0f;
	iconPixArray[121] = 12'hf0f;
	iconPixArray[122] = 12'hf0f;
	iconPixArray[123] = 12'hf0f;
	iconPixArray[124] = 12'hf0f;
	iconPixArray[125] = 12'hf0f;
	iconPixArray[126] = 12'hf0f;
	iconPixArray[127] = 12'hf00;
	iconPixArray[128] = 12'hf00;
	iconPixArray[129] = 12'hf00;
	iconPixArray[130] = 12'hf00;
	iconPixArray[131] = 12'hf00;
	iconPixArray[132] = 12'hf00;
	iconPixArray[133] = 12'hf0f;
	iconPixArray[134] = 12'hf0f;
	iconPixArray[135] = 12'hf0f;
	iconPixArray[136] = 12'hf0f;
	iconPixArray[137] = 12'hf0f;
	iconPixArray[138] = 12'hf0f;
	iconPixArray[139] = 12'hf00;
	iconPixArray[140] = 12'hf00;
	iconPixArray[141] = 12'hf00;
	iconPixArray[142] = 12'hf00;
	iconPixArray[143] = 12'hf00;
	iconPixArray[144] = 12'hf00;
	iconPixArray[145] = 12'hf00;
	iconPixArray[146] = 12'hf00;
	iconPixArray[147] = 12'hf00;
	iconPixArray[148] = 12'hf00;
	iconPixArray[149] = 12'hf0f;
	iconPixArray[150] = 12'hf0f;
	iconPixArray[151] = 12'hf0f;
	iconPixArray[152] = 12'hf0f;
	iconPixArray[153] = 12'hf0f;
	iconPixArray[154] = 12'hf0f;
	iconPixArray[155] = 12'hf00;
	iconPixArray[156] = 12'hf00;
	iconPixArray[157] = 12'hf00;
	iconPixArray[158] = 12'hf00;
	iconPixArray[159] = 12'hf00;
	iconPixArray[160] = 12'hf00;
	iconPixArray[161] = 12'hf00;
	iconPixArray[162] = 12'hf00;
	iconPixArray[163] = 12'hf00;
	iconPixArray[164] = 12'hf00;
	iconPixArray[165] = 12'hf0f;
	iconPixArray[166] = 12'hf0f;
	iconPixArray[167] = 12'hf0f;
	iconPixArray[168] = 12'hf0f;
	iconPixArray[169] = 12'hf0f;
	iconPixArray[170] = 12'hf0f;
	iconPixArray[171] = 12'hf00;
	iconPixArray[172] = 12'hf00;
	iconPixArray[173] = 12'hf00;
	iconPixArray[174] = 12'hf00;
	iconPixArray[175] = 12'hf00;
	iconPixArray[176] = 12'hf00;
	iconPixArray[177] = 12'hf00;
	iconPixArray[178] = 12'hf00;
	iconPixArray[179] = 12'hf00;
	iconPixArray[180] = 12'hf00;
	iconPixArray[181] = 12'hf0f;
	iconPixArray[182] = 12'hf0f;
	iconPixArray[183] = 12'hf0f;
	iconPixArray[184] = 12'hf0f;
	iconPixArray[185] = 12'hf0f;
	iconPixArray[186] = 12'hf0f;
	iconPixArray[187] = 12'hf00;
	iconPixArray[188] = 12'hf00;
	iconPixArray[189] = 12'hf00;
	iconPixArray[190] = 12'hf00;
	iconPixArray[191] = 12'hf00;
	iconPixArray[192] = 12'hf00;
	iconPixArray[193] = 12'hf00;
	iconPixArray[194] = 12'hf00;
	iconPixArray[195] = 12'hf00;
	iconPixArray[196] = 12'hf00;
	iconPixArray[197] = 12'hf0f;
	iconPixArray[198] = 12'hf0f;
	iconPixArray[199] = 12'hf0f;
	iconPixArray[200] = 12'hf0f;
	iconPixArray[201] = 12'hf0f;
	iconPixArray[202] = 12'hf0f;
	iconPixArray[203] = 12'hf00;
	iconPixArray[204] = 12'hf00;
	iconPixArray[205] = 12'hf00;
	iconPixArray[206] = 12'hf00;
	iconPixArray[207] = 12'hf00;
	iconPixArray[208] = 12'hf00;
	iconPixArray[209] = 12'hf00;
	iconPixArray[210] = 12'hf00;
	iconPixArray[211] = 12'hf00;
	iconPixArray[212] = 12'hf00;
	iconPixArray[213] = 12'hf0f;
	iconPixArray[214] = 12'hf0f;
	iconPixArray[215] = 12'hf0f;
	iconPixArray[216] = 12'hf0f;
	iconPixArray[217] = 12'hf0f;
	iconPixArray[218] = 12'hf0f;
	iconPixArray[219] = 12'hf00;
	iconPixArray[220] = 12'hf00;
	iconPixArray[221] = 12'hf00;
	iconPixArray[222] = 12'hf00;
	iconPixArray[223] = 12'hf00;
	iconPixArray[224] = 12'hf00;
	iconPixArray[225] = 12'hf00;
	iconPixArray[226] = 12'hf00;
	iconPixArray[227] = 12'hf00;
	iconPixArray[228] = 12'hf00;
	iconPixArray[229] = 12'hf0f;
	iconPixArray[230] = 12'hf0f;
	iconPixArray[231] = 12'hf0f;
	iconPixArray[232] = 12'hf0f;
	iconPixArray[233] = 12'hf0f;
	iconPixArray[234] = 12'hf0f;
	iconPixArray[235] = 12'hf00;
	iconPixArray[236] = 12'hf00;
	iconPixArray[237] = 12'hf00;
	iconPixArray[238] = 12'hf00;
	iconPixArray[239] = 12'hf00;
	iconPixArray[240] = 12'hf00;
	iconPixArray[241] = 12'hf00;
	iconPixArray[242] = 12'hf00;
	iconPixArray[243] = 12'hf00;
	iconPixArray[244] = 12'hf00;
	iconPixArray[245] = 12'hf00;
	iconPixArray[246] = 12'hf00;
	iconPixArray[247] = 12'hf00;
	iconPixArray[248] = 12'hf00;
	iconPixArray[249] = 12'hf00;
	iconPixArray[250] = 12'hf00;
	iconPixArray[251] = 12'hf00;
	iconPixArray[252] = 12'hf00;
	iconPixArray[253] = 12'hf00;
	iconPixArray[254] = 12'hf00;
	iconPixArray[255] = 12'hf00;
							
	iconPixArray[256] = 12'hf00;						
	iconPixArray[257] = 12'hf00;
	iconPixArray[258] = 12'hf00;
	iconPixArray[259] = 12'hf00;
	iconPixArray[260] = 12'hf00;
	iconPixArray[261] = 12'hf00;
	iconPixArray[262] = 12'hf00;
	iconPixArray[263] = 12'hf00;
	iconPixArray[264] = 12'hf00;
	iconPixArray[265] = 12'hf00;
	iconPixArray[266] = 12'hf00;
	iconPixArray[267] = 12'hf00;
	iconPixArray[268] = 12'hf00;
	iconPixArray[269] = 12'hf00;
	iconPixArray[270] = 12'hf00;
	iconPixArray[271] = 12'hf00;
	iconPixArray[272] = 12'hf00;
	iconPixArray[273] = 12'hf00;
	iconPixArray[274] = 12'hf00;
	iconPixArray[275] = 12'hf0f;
	iconPixArray[276] = 12'hf0f;
	iconPixArray[277] = 12'hf0f;
	iconPixArray[278] = 12'hf0f;
	iconPixArray[279] = 12'hf0f;
	iconPixArray[280] = 12'hf0f;
	iconPixArray[281] = 12'hf0f;
	iconPixArray[282] = 12'hf0f;
	iconPixArray[283] = 12'hf0f;
	iconPixArray[284] = 12'hf0f;
	iconPixArray[285] = 12'hf0f;
	iconPixArray[286] = 12'hf0f;
	iconPixArray[287] = 12'hf00;
	iconPixArray[288] = 12'hf00;
	iconPixArray[289] = 12'hf00;
	iconPixArray[290] = 12'hf00;
	iconPixArray[291] = 12'hf00;
	iconPixArray[292] = 12'hf00;
	iconPixArray[293] = 12'hf0f;
	iconPixArray[294] = 12'hf0f;
	iconPixArray[295] = 12'hf0f;
	iconPixArray[296] = 12'hf0f;
	iconPixArray[297] = 12'hf0f;
	iconPixArray[298] = 12'hf0f;
	iconPixArray[299] = 12'hf0f;
	iconPixArray[300] = 12'hf0f;
	iconPixArray[301] = 12'hf0f;
	iconPixArray[302] = 12'hf0f;
	iconPixArray[303] = 12'hf00;
	iconPixArray[304] = 12'hf00;
	iconPixArray[305] = 12'hf00;
	iconPixArray[306] = 12'hf00;
	iconPixArray[307] = 12'hf00;
	iconPixArray[308] = 12'hf00;
	iconPixArray[309] = 12'hf00;
	iconPixArray[310] = 12'hf00;
	iconPixArray[311] = 12'hf0f;
	iconPixArray[312] = 12'hf0f;
	iconPixArray[313] = 12'hf0f;
	iconPixArray[314] = 12'hf0f;
	iconPixArray[315] = 12'hf0f;
	iconPixArray[316] = 12'hf0f;
	iconPixArray[317] = 12'hf0f;
	iconPixArray[318] = 12'hf0f;
	iconPixArray[319] = 12'hf00;
	iconPixArray[320] = 12'hf00;
	iconPixArray[321] = 12'hf00;
	iconPixArray[322] = 12'hf00;
	iconPixArray[323] = 12'hf00;
	iconPixArray[324] = 12'hf00;
	iconPixArray[325] = 12'hf00;
	iconPixArray[326] = 12'hf00;
	iconPixArray[327] = 12'hf00;
	iconPixArray[328] = 12'hf00;
	iconPixArray[329] = 12'hf0f;
	iconPixArray[330] = 12'hf0f;
	iconPixArray[331] = 12'hf0f;
	iconPixArray[332] = 12'hf0f;
	iconPixArray[333] = 12'hf0f;
	iconPixArray[334] = 12'hf0f;
	iconPixArray[335] = 12'hf00;
	iconPixArray[336] = 12'hf00;
	iconPixArray[337] = 12'hf00;
	iconPixArray[338] = 12'hf00;
	iconPixArray[339] = 12'hf00;
	iconPixArray[340] = 12'hf00;
	iconPixArray[341] = 12'hf00;
	iconPixArray[342] = 12'hf00;
	iconPixArray[343] = 12'hf00;
	iconPixArray[344] = 12'hf00;
	iconPixArray[345] = 12'hf0f;
	iconPixArray[346] = 12'hf0f;
	iconPixArray[347] = 12'hf0f;
	iconPixArray[348] = 12'hf0f;
	iconPixArray[349] = 12'hf0f;
	iconPixArray[350] = 12'hf0f;
	iconPixArray[351] = 12'hf00;
	iconPixArray[352] = 12'hf00;
	iconPixArray[353] = 12'hf00;
	iconPixArray[354] = 12'hf00;
	iconPixArray[355] = 12'hf00;
	iconPixArray[356] = 12'hf00;
	iconPixArray[357] = 12'hf00;
	iconPixArray[358] = 12'hf00;
	iconPixArray[359] = 12'hf00;
	iconPixArray[360] = 12'hf0f;
	iconPixArray[361] = 12'hf0f;
	iconPixArray[362] = 12'hf0f;
	iconPixArray[363] = 12'hf0f;
	iconPixArray[364] = 12'hf0f;
	iconPixArray[365] = 12'hf0f;
	iconPixArray[366] = 12'hf0f;
	iconPixArray[367] = 12'hf00;
	iconPixArray[368] = 12'hf00;
	iconPixArray[369] = 12'hf00;
	iconPixArray[370] = 12'hf00;
	iconPixArray[371] = 12'hf00;
	iconPixArray[372] = 12'hf00;
	iconPixArray[373] = 12'hf00;
	iconPixArray[374] = 12'hf00;
	iconPixArray[375] = 12'hf0f;
	iconPixArray[376] = 12'hf0f;
	iconPixArray[377] = 12'hf0f;
	iconPixArray[378] = 12'hf00;
	iconPixArray[379] = 12'hf00;
	iconPixArray[380] = 12'hf0f;
	iconPixArray[381] = 12'hf0f;
	iconPixArray[382] = 12'hf0f;
	iconPixArray[383] = 12'hf00;
	iconPixArray[384] = 12'hf00;
	iconPixArray[385] = 12'hf00;
	iconPixArray[386] = 12'hf00;
	iconPixArray[387] = 12'hf00;
	iconPixArray[388] = 12'hf00;
	iconPixArray[389] = 12'hf00;
	iconPixArray[390] = 12'hf0f;
	iconPixArray[391] = 12'hf0f;
	iconPixArray[392] = 12'hf0f;
	iconPixArray[393] = 12'hf00;
	iconPixArray[394] = 12'hf00;
	iconPixArray[395] = 12'hf00;
	iconPixArray[396] = 12'hf0f;
	iconPixArray[397] = 12'hf0f;
	iconPixArray[398] = 12'hf0f;
	iconPixArray[399] = 12'hf00;
	iconPixArray[400] = 12'hf00;
	iconPixArray[401] = 12'hf00;
	iconPixArray[402] = 12'hf00;
	iconPixArray[403] = 12'hf00;
	iconPixArray[404] = 12'hf00;
	iconPixArray[405] = 12'hf0f;
	iconPixArray[406] = 12'hf0f;
	iconPixArray[407] = 12'hf0f;
	iconPixArray[408] = 12'hf00;
	iconPixArray[409] = 12'hf00;
	iconPixArray[410] = 12'hf00;
	iconPixArray[411] = 12'hf00;
	iconPixArray[412] = 12'hf0f;
	iconPixArray[413] = 12'hf0f;
	iconPixArray[414] = 12'hf0f;
	iconPixArray[415] = 12'hf00;
	iconPixArray[416] = 12'hf00;
	iconPixArray[417] = 12'hf00;
	iconPixArray[418] = 12'hf00;
	iconPixArray[419] = 12'hf00;
	iconPixArray[420] = 12'hf0f;
	iconPixArray[421] = 12'hf0f;
	iconPixArray[422] = 12'hf0f;
	iconPixArray[423] = 12'hf00;
	iconPixArray[424] = 12'hf00;
	iconPixArray[425] = 12'hf00;
	iconPixArray[426] = 12'hf00;
	iconPixArray[427] = 12'hf00;
	iconPixArray[428] = 12'hf00;
	iconPixArray[429] = 12'hf0f;
	iconPixArray[430] = 12'hf0f;
	iconPixArray[431] = 12'hf00;
	iconPixArray[432] = 12'hf00;
	iconPixArray[433] = 12'hf00;
	iconPixArray[434] = 12'hf00;
	iconPixArray[435] = 12'hf0f;
	iconPixArray[436] = 12'hf0f;
	iconPixArray[437] = 12'hf00;
	iconPixArray[438] = 12'hf00;
	iconPixArray[439] = 12'hf00;
	iconPixArray[440] = 12'hf00;
	iconPixArray[441] = 12'hf00;
	iconPixArray[442] = 12'hf00;
	iconPixArray[443] = 12'hf00;
	iconPixArray[444] = 12'hf00;
	iconPixArray[445] = 12'hf00;
	iconPixArray[446] = 12'hf0f;
	iconPixArray[447] = 12'hf00;
	iconPixArray[448] = 12'hf00;
	iconPixArray[449] = 12'hf00;
	iconPixArray[450] = 12'hf0f;
	iconPixArray[451] = 12'hf0f;
	iconPixArray[452] = 12'hf0f;
	iconPixArray[453] = 12'hf00;
	iconPixArray[454] = 12'hf00;
	iconPixArray[455] = 12'hf00;
	iconPixArray[456] = 12'hf00;
	iconPixArray[457] = 12'hf00;
	iconPixArray[458] = 12'hf00;
	iconPixArray[459] = 12'hf00;
	iconPixArray[460] = 12'hf00;
	iconPixArray[461] = 12'hf00;
	iconPixArray[462] = 12'hf0f;
	iconPixArray[463] = 12'hf00;
	iconPixArray[464] = 12'hf00;
	iconPixArray[465] = 12'hf0f;
	iconPixArray[466] = 12'hf0f;
	iconPixArray[467] = 12'hf0f;
	iconPixArray[468] = 12'hf00;
	iconPixArray[469] = 12'hf00;
	iconPixArray[470] = 12'hf00;
	iconPixArray[471] = 12'hf00;
	iconPixArray[472] = 12'hf00;
	iconPixArray[473] = 12'hf00;
	iconPixArray[474] = 12'hf00;
	iconPixArray[475] = 12'hf00;
	iconPixArray[476] = 12'hf00;
	iconPixArray[477] = 12'hf00;
	iconPixArray[478] = 12'hf00;
	iconPixArray[479] = 12'hf00;
	iconPixArray[480] = 12'hf00;
	iconPixArray[481] = 12'hf0f;
	iconPixArray[482] = 12'hf0f;
	iconPixArray[483] = 12'hf00;
	iconPixArray[484] = 12'hf00;
	iconPixArray[485] = 12'hf00;
	iconPixArray[486] = 12'hf00;
	iconPixArray[487] = 12'hf00;
	iconPixArray[488] = 12'hf00;
	iconPixArray[489] = 12'hf00;
	iconPixArray[490] = 12'hf00;
	iconPixArray[491] = 12'hf00;
	iconPixArray[492] = 12'hf00;
	iconPixArray[493] = 12'hf00;
	iconPixArray[494] = 12'hf00;
	iconPixArray[495] = 12'hf00;
	iconPixArray[496] = 12'hf00;
	iconPixArray[497] = 12'hf00;
	iconPixArray[498] = 12'hf00;
	iconPixArray[499] = 12'hf00;
	iconPixArray[500] = 12'hf00;
	iconPixArray[501] = 12'hf00;
	iconPixArray[502] = 12'hf00;
	iconPixArray[503] = 12'hf00;
	iconPixArray[504] = 12'hf00;
	iconPixArray[505] = 12'hf00;
	iconPixArray[506] = 12'hf00;
	iconPixArray[507] = 12'hf00;
	iconPixArray[508] = 12'hf00;
	iconPixArray[509] = 12'hf00;
	iconPixArray[510] = 12'hf00;
	iconPixArray[511] = 12'hf00;
                 
                 
   end           
                 
































































































































































































































































                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
                 












endmodule 