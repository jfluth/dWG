`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// filename:	icon.v
//
// ECE 540 Project 2: RojoBot World
//
// Jordan Fluth <jfluth@gmail.com>
// Paul Long <pwl@pdx.edu>
//
// 29 October 2014
//
// Description:
//		This module produces the icon that gets painted over the background map
//		produced buy the botsim IP. It relies on the scaling from the 128x128
//		rojobot world to the 512x512 display world to have been done already. 
//		
//		The icon image is stored in a 2D array which is automatically created
//		from an external python script that reads in any bit-mapped image file
//		(.jpg or .png, for example). The array contains the color info for 2 images
//		one pointing North and one pointing NE. The N image is stored in the 256
//		low-order locations and the NE image is stored in the high-order locations.
//		This allows the two Icons to be accessed the same with the exception of the
//		high-order address bit. If that bit is '0', we are addressing the N icon. If 
//		that bit is '1', we are addressing the NE icon.
//		
//		Icons for the other directions are derived on-the-fly by manipulating the
//		order that array is painted onto the screen.
//		
//	General operation:
//		The location reported by the botsim IP is corrected to center the icon
//		on the line. This corrected location is compared to the location of the 
//		cathode ray painting the screen. If the ray is overlapping the bot, the
//		difference between current ray pixel and the bot's top left corner can
//		be used as an index ito the Icon array. The	orientation, as reported by
//		botsim IP, is checked and any necessary	transforms are applied to the
//		indecies to rotate the icon as appropriate.
//
//
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
  reg	[3:0]	iconBitmapX, iconBitmapY;	// index into icon pixelmap 
  wire	[9:0]	iconLeft;					// Bounds of the icon 
  wire	[9:0]	iconRight;
  wire	[9:0]	iconTop;
  wire	[9:0]	iconBottom;
  
  wire	[11:0]	pixelColor;					// Color out from ROM
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
     /**********************************************
    *****  Template file for the image array
    *****  Produced from icon.png
    ***********************************************/
    iconPixArray[0] = 12'h 00;
    iconPixArray[1] = 12'h 00;
    iconPixArray[2] = 12'h 00;
    iconPixArray[3] = 12'h 00;
    iconPixArray[4] = 12'h 00;
    iconPixArray[5] = 12'h 00;
    iconPixArray[6] = 12'h 00;
    iconPixArray[7] = 12'h247;
    iconPixArray[8] = 12'h246;
    iconPixArray[9] = 12'h 00;
    iconPixArray[10] = 12'h 00;
    iconPixArray[11] = 12'h 00;
    iconPixArray[12] = 12'h 00;
    iconPixArray[13] = 12'h 00;
    iconPixArray[14] = 12'h 00;
    iconPixArray[15] = 12'h 00;
    iconPixArray[16] = 12'h 00;
    iconPixArray[17] = 12'h 00;
    iconPixArray[18] = 12'h 00;
    iconPixArray[19] = 12'h 00;
    iconPixArray[20] = 12'h 00;
    iconPixArray[21] = 12'h 00;
    iconPixArray[22] = 12'h 12;
    iconPixArray[23] = 12'h5AE;
    iconPixArray[24] = 12'h49E;
    iconPixArray[25] = 12'h 11;
    iconPixArray[26] = 12'h 00;
    iconPixArray[27] = 12'h 00;
    iconPixArray[28] = 12'h 00;
    iconPixArray[29] = 12'h 00;
    iconPixArray[30] = 12'h 00;
    iconPixArray[31] = 12'h 00;
    iconPixArray[32] = 12'h 00;
    iconPixArray[33] = 12'h 00;
    iconPixArray[34] = 12'h 00;
    iconPixArray[35] = 12'h 00;
    iconPixArray[36] = 12'h 00;
    iconPixArray[37] = 12'h 00;
    iconPixArray[38] = 12'h36A;
    iconPixArray[39] = 12'h5AF;
    iconPixArray[40] = 12'h5AF;
    iconPixArray[41] = 12'h369;
    iconPixArray[42] = 12'h 00;
    iconPixArray[43] = 12'h 00;
    iconPixArray[44] = 12'h 00;
    iconPixArray[45] = 12'h 00;
    iconPixArray[46] = 12'h 00;
    iconPixArray[47] = 12'h 00;
    iconPixArray[48] = 12'h 00;
    iconPixArray[49] = 12'h 00;
    iconPixArray[50] = 12'h 00;
    iconPixArray[51] = 12'h 00;
    iconPixArray[52] = 12'h 00;
    iconPixArray[53] = 12'h 11;
    iconPixArray[54] = 12'h49E;
    iconPixArray[55] = 12'h49F;
    iconPixArray[56] = 12'h49E;
    iconPixArray[57] = 12'h49E;
    iconPixArray[58] = 12'h 11;
    iconPixArray[59] = 12'h 00;
    iconPixArray[60] = 12'h 00;
    iconPixArray[61] = 12'h 00;
    iconPixArray[62] = 12'h 00;
    iconPixArray[63] = 12'h 00;
    iconPixArray[64] = 12'h 00;
    iconPixArray[65] = 12'h 00;
    iconPixArray[66] = 12'h 00;
    iconPixArray[67] = 12'h 00;
    iconPixArray[68] = 12'h 00;
    iconPixArray[69] = 12'h135;
    iconPixArray[70] = 12'h5AF;
    iconPixArray[71] = 12'h8BE;
    iconPixArray[72] = 12'h9BE;
    iconPixArray[73] = 12'h5AF;
    iconPixArray[74] = 12'h135;
    iconPixArray[75] = 12'h 00;
    iconPixArray[76] = 12'h 00;
    iconPixArray[77] = 12'h 00;
    iconPixArray[78] = 12'h 00;
    iconPixArray[79] = 12'h 00;
    iconPixArray[80] = 12'h 00;
    iconPixArray[81] = 12'h 00;
    iconPixArray[82] = 12'h 00;
    iconPixArray[83] = 12'h 00;
    iconPixArray[84] = 12'h 00;
    iconPixArray[85] = 12'h258;
    iconPixArray[86] = 12'h7BF;
    iconPixArray[87] = 12'hFFE;
    iconPixArray[88] = 12'hFFE;
    iconPixArray[89] = 12'h9CE;
    iconPixArray[90] = 12'h258;
    iconPixArray[91] = 12'h 00;
    iconPixArray[92] = 12'h 00;
    iconPixArray[93] = 12'h 00;
    iconPixArray[94] = 12'h 00;
    iconPixArray[95] = 12'h 00;
    iconPixArray[96] = 12'h 00;
    iconPixArray[97] = 12'h 00;
    iconPixArray[98] = 12'h 00;
    iconPixArray[99] = 12'h 00;
    iconPixArray[100] = 12'h 00;
    iconPixArray[101] = 12'h269;
    iconPixArray[102] = 12'h7BF;
    iconPixArray[103] = 12'hEEE;
    iconPixArray[104] = 12'hFFE;
    iconPixArray[105] = 12'h8CF;
    iconPixArray[106] = 12'h269;
    iconPixArray[107] = 12'h 00;
    iconPixArray[108] = 12'h 00;
    iconPixArray[109] = 12'h 00;
    iconPixArray[110] = 12'h 00;
    iconPixArray[111] = 12'h 00;
    iconPixArray[112] = 12'h 00;
    iconPixArray[113] = 12'h 00;
    iconPixArray[114] = 12'h 00;
    iconPixArray[115] = 12'h 00;
    iconPixArray[116] = 12'h 00;
    iconPixArray[117] = 12'h369;
    iconPixArray[118] = 12'h5AF;
    iconPixArray[119] = 12'h6AE;
    iconPixArray[120] = 12'h7BE;
    iconPixArray[121] = 12'h5AF;
    iconPixArray[122] = 12'h37B;
    iconPixArray[123] = 12'h 00;
    iconPixArray[124] = 12'h 00;
    iconPixArray[125] = 12'h 00;
    iconPixArray[126] = 12'h 00;
    iconPixArray[127] = 12'h 00;
    iconPixArray[128] = 12'h 00;
    iconPixArray[129] = 12'h 00;
    iconPixArray[130] = 12'h 00;
    iconPixArray[131] = 12'h 00;
    iconPixArray[132] = 12'h 00;
    iconPixArray[133] = 12'h269;
    iconPixArray[134] = 12'h5AF;
    iconPixArray[135] = 12'h49E;
    iconPixArray[136] = 12'h49E;
    iconPixArray[137] = 12'h5AF;
    iconPixArray[138] = 12'h26A;
    iconPixArray[139] = 12'h 00;
    iconPixArray[140] = 12'h 00;
    iconPixArray[141] = 12'h 00;
    iconPixArray[142] = 12'h 00;
    iconPixArray[143] = 12'h 00;
    iconPixArray[144] = 12'h 00;
    iconPixArray[145] = 12'h 00;
    iconPixArray[146] = 12'h 00;
    iconPixArray[147] = 12'h 00;
    iconPixArray[148] = 12'h 00;
    iconPixArray[149] = 12'h447;
    iconPixArray[150] = 12'h5AF;
    iconPixArray[151] = 12'h59E;
    iconPixArray[152] = 12'h59E;
    iconPixArray[153] = 12'h4AF;
    iconPixArray[154] = 12'h658;
    iconPixArray[155] = 12'h200;
    iconPixArray[156] = 12'h 00;
    iconPixArray[157] = 12'h 00;
    iconPixArray[158] = 12'h 00;
    iconPixArray[159] = 12'h 00;
    iconPixArray[160] = 12'h 00;
    iconPixArray[161] = 12'h 00;
    iconPixArray[162] = 12'h 00;
    iconPixArray[163] = 12'h 00;
    iconPixArray[164] = 12'h800;
    iconPixArray[165] = 12'hD24;
    iconPixArray[166] = 12'h4AF;
    iconPixArray[167] = 12'h59E;
    iconPixArray[168] = 12'h59E;
    iconPixArray[169] = 12'h4AF;
    iconPixArray[170] = 12'hB47;
    iconPixArray[171] = 12'hD00;
    iconPixArray[172] = 12'h100;
    iconPixArray[173] = 12'h 00;
    iconPixArray[174] = 12'h 00;
    iconPixArray[175] = 12'h 00;
    iconPixArray[176] = 12'h 00;
    iconPixArray[177] = 12'h 00;
    iconPixArray[178] = 12'h 00;
    iconPixArray[179] = 12'h100;
    iconPixArray[180] = 12'hF00;
    iconPixArray[181] = 12'hD12;
    iconPixArray[182] = 12'h59E;
    iconPixArray[183] = 12'h5AF;
    iconPixArray[184] = 12'h59E;
    iconPixArray[185] = 12'h4AE;
    iconPixArray[186] = 12'hB35;
    iconPixArray[187] = 12'hF00;
    iconPixArray[188] = 12'h700;
    iconPixArray[189] = 12'h 00;
    iconPixArray[190] = 12'h 00;
    iconPixArray[191] = 12'h 00;
    iconPixArray[192] = 12'h 00;
    iconPixArray[193] = 12'h 00;
    iconPixArray[194] = 12'h 00;
    iconPixArray[195] = 12'h200;
    iconPixArray[196] = 12'hE00;
    iconPixArray[197] = 12'hE00;
    iconPixArray[198] = 12'h68D;
    iconPixArray[199] = 12'h4AE;
    iconPixArray[200] = 12'h59E;
    iconPixArray[201] = 12'h4AF;
    iconPixArray[202] = 12'hC23;
    iconPixArray[203] = 12'hE00;
    iconPixArray[204] = 12'h600;
    iconPixArray[205] = 12'h 00;
    iconPixArray[206] = 12'h 00;
    iconPixArray[207] = 12'h 00;
    iconPixArray[208] = 12'h 00;
    iconPixArray[209] = 12'h 00;
    iconPixArray[210] = 12'h 00;
    iconPixArray[211] = 12'h 00;
    iconPixArray[212] = 12'hD00;
    iconPixArray[213] = 12'hF00;
    iconPixArray[214] = 12'h78C;
    iconPixArray[215] = 12'h4AF;
    iconPixArray[216] = 12'h59E;
    iconPixArray[217] = 12'h49E;
    iconPixArray[218] = 12'hD12;
    iconPixArray[219] = 12'hF00;
    iconPixArray[220] = 12'h200;
    iconPixArray[221] = 12'h 00;
    iconPixArray[222] = 12'h 00;
    iconPixArray[223] = 12'h 00;
    iconPixArray[224] = 12'h 00;
    iconPixArray[225] = 12'h 00;
    iconPixArray[226] = 12'h 00;
    iconPixArray[227] = 12'h 00;
    iconPixArray[228] = 12'h900;
    iconPixArray[229] = 12'hE00;
    iconPixArray[230] = 12'h223;
    iconPixArray[231] = 12'h123;
    iconPixArray[232] = 12'h112;
    iconPixArray[233] = 12'h 12;
    iconPixArray[234] = 12'h800;
    iconPixArray[235] = 12'hD00;
    iconPixArray[236] = 12'h 00;
    iconPixArray[237] = 12'h 00;
    iconPixArray[238] = 12'h 00;
    iconPixArray[239] = 12'h 00;
    iconPixArray[240] = 12'h 00;
    iconPixArray[241] = 12'h 00;
    iconPixArray[242] = 12'h 00;
    iconPixArray[243] = 12'h 00;
    iconPixArray[244] = 12'h 00;
    iconPixArray[245] = 12'h 00;
    iconPixArray[246] = 12'h 00;
    iconPixArray[247] = 12'h 00;
    iconPixArray[248] = 12'h 00;
    iconPixArray[249] = 12'h 00;
    iconPixArray[250] = 12'h 00;
    iconPixArray[251] = 12'h 00;
    iconPixArray[252] = 12'h 00;
    iconPixArray[253] = 12'h 00;
    iconPixArray[254] = 12'h 00;
    iconPixArray[255] = 12'h 00;
    iconPixArray[256] = 12'h 00;
    iconPixArray[257] = 12'h 00;
    iconPixArray[258] = 12'h 00;
    iconPixArray[259] = 12'h 00;
    iconPixArray[260] = 12'h 00;
    iconPixArray[261] = 12'h 00;
    iconPixArray[262] = 12'h 00;
    iconPixArray[263] = 12'h 00;
    iconPixArray[264] = 12'h 00;
    iconPixArray[265] = 12'h 00;
    iconPixArray[266] = 12'h 00;
    iconPixArray[267] = 12'h 00;
    iconPixArray[268] = 12'h 00;
    iconPixArray[269] = 12'h 00;
    iconPixArray[270] = 12'h 00;
    iconPixArray[271] = 12'h 00;
    iconPixArray[272] = 12'h 00;
    iconPixArray[273] = 12'h 00;
    iconPixArray[274] = 12'h 00;
    iconPixArray[275] = 12'h 00;
    iconPixArray[276] = 12'h 00;
    iconPixArray[277] = 12'h 00;
    iconPixArray[278] = 12'h 00;
    iconPixArray[279] = 12'h 00;
    iconPixArray[280] = 12'h 00;
    iconPixArray[281] = 12'h 00;
    iconPixArray[282] = 12'h 00;
    iconPixArray[283] = 12'h 01;
    iconPixArray[284] = 12'h134;
    iconPixArray[285] = 12'h257;
    iconPixArray[286] = 12'h123;
    iconPixArray[287] = 12'h 00;
    iconPixArray[288] = 12'h 00;
    iconPixArray[289] = 12'h 00;
    iconPixArray[290] = 12'h 00;
    iconPixArray[291] = 12'h 00;
    iconPixArray[292] = 12'h 00;
    iconPixArray[293] = 12'h 00;
    iconPixArray[294] = 12'h 00;
    iconPixArray[295] = 12'h 00;
    iconPixArray[296] = 12'h 00;
    iconPixArray[297] = 12'h 11;
    iconPixArray[298] = 12'h369;
    iconPixArray[299] = 12'h49D;
    iconPixArray[300] = 12'h5AF;
    iconPixArray[301] = 12'h5BF;
    iconPixArray[302] = 12'h124;
    iconPixArray[303] = 12'h 00;
    iconPixArray[304] = 12'h 00;
    iconPixArray[305] = 12'h 00;
    iconPixArray[306] = 12'h 00;
    iconPixArray[307] = 12'h 00;
    iconPixArray[308] = 12'h 00;
    iconPixArray[309] = 12'h 00;
    iconPixArray[310] = 12'h 00;
    iconPixArray[311] = 12'h 00;
    iconPixArray[312] = 12'h135;
    iconPixArray[313] = 12'h49D;
    iconPixArray[314] = 12'h4AF;
    iconPixArray[315] = 12'h49F;
    iconPixArray[316] = 12'h59E;
    iconPixArray[317] = 12'h49E;
    iconPixArray[318] = 12'h 11;
    iconPixArray[319] = 12'h 00;
    iconPixArray[320] = 12'h 00;
    iconPixArray[321] = 12'h 00;
    iconPixArray[322] = 12'h 00;
    iconPixArray[323] = 12'h 00;
    iconPixArray[324] = 12'h 00;
    iconPixArray[325] = 12'h 00;
    iconPixArray[326] = 12'h 00;
    iconPixArray[327] = 12'h246;
    iconPixArray[328] = 12'h5AF;
    iconPixArray[329] = 12'h9CF;
    iconPixArray[330] = 12'hBDE;
    iconPixArray[331] = 12'h7BE;
    iconPixArray[332] = 12'h4AE;
    iconPixArray[333] = 12'h37B;
    iconPixArray[334] = 12'h 00;
    iconPixArray[335] = 12'h 00;
    iconPixArray[336] = 12'h 00;
    iconPixArray[337] = 12'h 00;
    iconPixArray[338] = 12'h 00;
    iconPixArray[339] = 12'h 00;
    iconPixArray[340] = 12'h 00;
    iconPixArray[341] = 12'h 00;
    iconPixArray[342] = 12'h246;
    iconPixArray[343] = 12'h5AF;
    iconPixArray[344] = 12'h5AE;
    iconPixArray[345] = 12'hFEE;
    iconPixArray[346] = 12'hFFF;
    iconPixArray[347] = 12'hCDE;
    iconPixArray[348] = 12'h5AF;
    iconPixArray[349] = 12'h135;
    iconPixArray[350] = 12'h 00;
    iconPixArray[351] = 12'h 00;
    iconPixArray[352] = 12'h 00;
    iconPixArray[353] = 12'h 00;
    iconPixArray[354] = 12'h 00;
    iconPixArray[355] = 12'h600;
    iconPixArray[356] = 12'hA00;
    iconPixArray[357] = 12'h812;
    iconPixArray[358] = 12'h4AE;
    iconPixArray[359] = 12'h5AE;
    iconPixArray[360] = 12'h59E;
    iconPixArray[361] = 12'hBDF;
    iconPixArray[362] = 12'hEEE;
    iconPixArray[363] = 12'h9CF;
    iconPixArray[364] = 12'h37B;
    iconPixArray[365] = 12'h 00;
    iconPixArray[366] = 12'h 00;
    iconPixArray[367] = 12'h 00;
    iconPixArray[368] = 12'h 00;
    iconPixArray[369] = 12'h 00;
    iconPixArray[370] = 12'h600;
    iconPixArray[371] = 12'hF00;
    iconPixArray[372] = 12'hF00;
    iconPixArray[373] = 12'h87B;
    iconPixArray[374] = 12'h4AF;
    iconPixArray[375] = 12'h59E;
    iconPixArray[376] = 12'h49F;
    iconPixArray[377] = 12'h49E;
    iconPixArray[378] = 12'h6AF;
    iconPixArray[379] = 12'h49E;
    iconPixArray[380] = 12'h 11;
    iconPixArray[381] = 12'h 00;
    iconPixArray[382] = 12'h 00;
    iconPixArray[383] = 12'h 00;
    iconPixArray[384] = 12'h 00;
    iconPixArray[385] = 12'h100;
    iconPixArray[386] = 12'hE00;
    iconPixArray[387] = 12'hF00;
    iconPixArray[388] = 12'h957;
    iconPixArray[389] = 12'h4AF;
    iconPixArray[390] = 12'h59E;
    iconPixArray[391] = 12'h5AF;
    iconPixArray[392] = 12'h59E;
    iconPixArray[393] = 12'h5AF;
    iconPixArray[394] = 12'h49E;
    iconPixArray[395] = 12'h123;
    iconPixArray[396] = 12'h 00;
    iconPixArray[397] = 12'h 00;
    iconPixArray[398] = 12'h 00;
    iconPixArray[399] = 12'h 00;
    iconPixArray[400] = 12'h 00;
    iconPixArray[401] = 12'h800;
    iconPixArray[402] = 12'hF00;
    iconPixArray[403] = 12'hC34;
    iconPixArray[404] = 12'h4AE;
    iconPixArray[405] = 12'h59E;
    iconPixArray[406] = 12'h5AE;
    iconPixArray[407] = 12'h59E;
    iconPixArray[408] = 12'h4AF;
    iconPixArray[409] = 12'h49D;
    iconPixArray[410] = 12'h123;
    iconPixArray[411] = 12'h 00;
    iconPixArray[412] = 12'h 00;
    iconPixArray[413] = 12'h 00;
    iconPixArray[414] = 12'h 00;
    iconPixArray[415] = 12'h 00;
    iconPixArray[416] = 12'h 00;
    iconPixArray[417] = 12'h700;
    iconPixArray[418] = 12'h400;
    iconPixArray[419] = 12'h258;
    iconPixArray[420] = 12'h5AF;
    iconPixArray[421] = 12'h59E;
    iconPixArray[422] = 12'h59E;
    iconPixArray[423] = 12'h4AF;
    iconPixArray[424] = 12'h87B;
    iconPixArray[425] = 12'hB11;
    iconPixArray[426] = 12'h 00;
    iconPixArray[427] = 12'h 00;
    iconPixArray[428] = 12'h 00;
    iconPixArray[429] = 12'h 00;
    iconPixArray[430] = 12'h 00;
    iconPixArray[431] = 12'h 00;
    iconPixArray[432] = 12'h 00;
    iconPixArray[433] = 12'h 00;
    iconPixArray[434] = 12'h 00;
    iconPixArray[435] = 12'h 00;
    iconPixArray[436] = 12'h258;
    iconPixArray[437] = 12'h5AF;
    iconPixArray[438] = 12'h4AF;
    iconPixArray[439] = 12'h958;
    iconPixArray[440] = 12'hE00;
    iconPixArray[441] = 12'hD00;
    iconPixArray[442] = 12'h 00;
    iconPixArray[443] = 12'h 00;
    iconPixArray[444] = 12'h 00;
    iconPixArray[445] = 12'h 00;
    iconPixArray[446] = 12'h 00;
    iconPixArray[447] = 12'h 00;
    iconPixArray[448] = 12'h 00;
    iconPixArray[449] = 12'h 00;
    iconPixArray[450] = 12'h 00;
    iconPixArray[451] = 12'h 00;
    iconPixArray[452] = 12'h 00;
    iconPixArray[453] = 12'h157;
    iconPixArray[454] = 12'hA46;
    iconPixArray[455] = 12'hF00;
    iconPixArray[456] = 12'hF00;
    iconPixArray[457] = 12'h800;
    iconPixArray[458] = 12'h 00;
    iconPixArray[459] = 12'h 00;
    iconPixArray[460] = 12'h 00;
    iconPixArray[461] = 12'h 00;
    iconPixArray[462] = 12'h 00;
    iconPixArray[463] = 12'h 00;
    iconPixArray[464] = 12'h 00;
    iconPixArray[465] = 12'h 00;
    iconPixArray[466] = 12'h 00;
    iconPixArray[467] = 12'h 00;
    iconPixArray[468] = 12'h 00;
    iconPixArray[469] = 12'h100;
    iconPixArray[470] = 12'hF00;
    iconPixArray[471] = 12'hE00;
    iconPixArray[472] = 12'h800;
    iconPixArray[473] = 12'h 00;
    iconPixArray[474] = 12'h 00;
    iconPixArray[475] = 12'h 00;
    iconPixArray[476] = 12'h 00;
    iconPixArray[477] = 12'h 00;
    iconPixArray[478] = 12'h 00;
    iconPixArray[479] = 12'h 00;
    iconPixArray[480] = 12'h 00;
    iconPixArray[481] = 12'h 00;
    iconPixArray[482] = 12'h 00;
    iconPixArray[483] = 12'h 00;
    iconPixArray[484] = 12'h 00;
    iconPixArray[485] = 12'h400;
    iconPixArray[486] = 12'h800;
    iconPixArray[487] = 12'h200;
    iconPixArray[488] = 12'h 00;
    iconPixArray[489] = 12'h 00;
    iconPixArray[490] = 12'h 00;
    iconPixArray[491] = 12'h 00;
    iconPixArray[492] = 12'h 00;
    iconPixArray[493] = 12'h 00;
    iconPixArray[494] = 12'h 00;
    iconPixArray[495] = 12'h 00;
    iconPixArray[496] = 12'h 00;
    iconPixArray[497] = 12'h 00;
    iconPixArray[498] = 12'h 00;
    iconPixArray[499] = 12'h 00;
    iconPixArray[500] = 12'h 00;
    iconPixArray[501] = 12'h 00;
    iconPixArray[502] = 12'h 00;
    iconPixArray[503] = 12'h 00;
    iconPixArray[504] = 12'h 00;
    iconPixArray[505] = 12'h 00;
    iconPixArray[506] = 12'h 00;
    iconPixArray[507] = 12'h 00;
    iconPixArray[508] = 12'h 00;
    iconPixArray[509] = 12'h 00;
    iconPixArray[510] = 12'h 00;
    iconPixArray[511] = 12'h 00;


  end
endmodule 
