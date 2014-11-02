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
  output	reg	[11:0]	botIcon			// Colour that should be output
);


  ///////////////////////////////////////////////////////////////////////////
  // Internal Signals
  ///////////////////////////////////////////////////////////////////////////
  reg	[3:0]	romX, romY;		// index into icon pixelmap ROM
  //reg	[3:0]	centeredLocX, centeredLocY;	// adjustment to center bot on line
  //wire	[3:0]	stretchLocX, stretchLocY;
  wire	[9:0]	iconLeft;			// Bounds of the icon 
  wire	[9:0]	iconRight;
  wire	[9:0]	iconTop;
  wire	[9:0]	iconBottom;
  
  wire	[11:0]	pixelColor;			// Color out from ROM
  reg	[8:0]	romAddress;		
  reg	[11:0]	iconPixArray[511:0];	
  //reg			redraw;	
  
  ///////////////////////////////////////////////////////////////////////////
  // Global Assigns
  ///////////////////////////////////////////////////////////////////////////
  assign iconLeft   = locX;
  assign iconRight  = locX+10'd15;
  assign iconTop    = locY;
  assign iconBottom = locY+10'd15;
  
  //assign strechLocX = {locX,2'b0};
  //assign sretchLocY = {locY,2'b0};
  
  
  
  
  // if at the edges don't adjust positions, otherwise center bot on line
//  always @(posedge clk) begin
//	centeredLocX <= (locX == 10'b0 || locX == 10'b0)?locX:locX - 10'd6;
//	centeredLocY <= (locY == 10'b0 || locY == 10'b0)?locY:locY - 10'd6;
//  end
  


 
  ///////////////////////////////////////////////////////////////////////////
  // Instantiate the Block ROM holding Icon
  ///////////////////////////////////////////////////////////////////////////
  iconRom3 iconROM (
	.clka	(clk),
	.ena	(1'b0),				// Always enabled
	.addra	(romAddress),
	.douta	(pixelColor));
  
  
  // Set index into icon ROM
  always @ (posedge clk) begin
	romX <= pixCol[3:0] - locX[3:0];
	romY <= pixRow[3:0] - locY[3:0];
  end
  
 
  // Decide when to paint the botIcon
  // If (pixCol,pixRow) overlap (locX,locY) to (locX+15,locY+15)
  // Paint the Icon, otherwise paint "00" (transparency)

  always @ (posedge clk) begin
	 if (pixCol >= iconLeft && pixCol <= iconRight &&
		pixRow >= iconTop  && pixRow <= iconBottom) begin
		
		romAddress <= {1'b1,romY,romX};	// index into rom */
		botIcon    <=  iconPixArray[{1'b0,romY,romX}];			// paint that color
		
	end
	else begin
		//romAddress <= 9'b0;					// reset index
		botIcon    <= 12'b0;				// transparent 
		
	end
  end
	  
  initial begin
	iconPixArray[0]   = 12'h000;
	iconPixArray[1]   = 12'hA30;
	iconPixArray[2]   = 12'h000;
	iconPixArray[3]   = 12'hA30;
	iconPixArray[4]   = 12'h000;
	iconPixArray[5]   = 12'hA30;
	iconPixArray[6]   = 12'h000;
	iconPixArray[7]   = 12'hA30;
	iconPixArray[8]   = 12'hF30;
	iconPixArray[9]   = 12'h000;
	iconPixArray[10]  = 12'h000;
	iconPixArray[11]  = 12'h000;
	iconPixArray[12]  = 12'h000;
	iconPixArray[13]  = 12'h000;
	iconPixArray[14]  = 12'h000;
	iconPixArray[15]  = 12'h000;
	iconPixArray[16]  = 12'h000;
	iconPixArray[17]  = 12'h000;
	iconPixArray[18]  = 12'h000;
	iconPixArray[19]  = 12'h000;
	iconPixArray[20]  = 12'h000;
	iconPixArray[21]  = 12'h000;
	iconPixArray[22]  = 12'h000;
	iconPixArray[23]  = 12'hA30;
	iconPixArray[24]  = 12'hF30;
	iconPixArray[25]  = 12'hF30;
	iconPixArray[26]  = 12'h000;
	iconPixArray[27]  = 12'h000;
	iconPixArray[28]  = 12'h000;
	iconPixArray[29]  = 12'h000;
	iconPixArray[30]  = 12'h000;
	iconPixArray[31]  = 12'h000;
	iconPixArray[32]  = 12'h000;
	iconPixArray[33]  = 12'h000;
	iconPixArray[34]  = 12'h000;
	iconPixArray[35]  = 12'h000;
	iconPixArray[36]  = 12'h000;
	iconPixArray[37]  = 12'h000;
	iconPixArray[38]  = 12'h000;
	iconPixArray[39]  = 12'h000;
	iconPixArray[40]  = 12'hA30;
	iconPixArray[41]  = 12'hF30;
	iconPixArray[42]  = 12'hF30;
	iconPixArray[43]  = 12'h000;
	iconPixArray[44]  = 12'h000;
	iconPixArray[45]  = 12'h000;
	iconPixArray[46]  = 12'h000;
	iconPixArray[47]  = 12'h000;
	iconPixArray[48]  = 12'h000;
	iconPixArray[49]  = 12'h000;
	iconPixArray[50]  = 12'h000;
	iconPixArray[51]  = 12'h000;
	iconPixArray[52]  = 12'h000;
	iconPixArray[53]  = 12'h000;
	iconPixArray[54]  = 12'h000;
	iconPixArray[55]  = 12'h000;
	iconPixArray[56]  = 12'h000;
	iconPixArray[57]  = 12'h000;
	iconPixArray[58]  = 12'hF30;
	iconPixArray[59]  = 12'hF30;
	iconPixArray[60]  = 12'h000;
	iconPixArray[61]  = 12'h000;
	iconPixArray[62]  = 12'h000;
	iconPixArray[63]  = 12'h000;
	iconPixArray[64]  = 12'h000;
	iconPixArray[65]  = 12'h000;
	iconPixArray[66]  = 12'h000;
	iconPixArray[67]  = 12'h000;
	iconPixArray[68]  = 12'h000;
	iconPixArray[69]  = 12'h000;
	iconPixArray[70]  = 12'h000;
	iconPixArray[71]  = 12'h000;
	iconPixArray[72]  = 12'h000;
	iconPixArray[73]  = 12'h000;
	iconPixArray[74]  = 12'h000;
	iconPixArray[75]  = 12'hF30;
	iconPixArray[76]  = 12'hF30;
	iconPixArray[77]  = 12'h000;
	iconPixArray[78]  = 12'h000;
	iconPixArray[79]  = 12'h000;
	iconPixArray[80]  = 12'h000;
	iconPixArray[81]  = 12'h000;
	iconPixArray[82]  = 12'h000;
	iconPixArray[83]  = 12'h000;
	iconPixArray[84]  = 12'h000;
	iconPixArray[85]  = 12'h000;
	iconPixArray[86]  = 12'h000;
	iconPixArray[87]  = 12'h000;
	iconPixArray[88]  = 12'h000;
	iconPixArray[89]  = 12'h000;
	iconPixArray[90]  = 12'h000;
	iconPixArray[91]  = 12'hF3F;
	iconPixArray[92]  = 12'hF30;
	iconPixArray[93]  = 12'hF30;
	iconPixArray[94]  = 12'h000;
	iconPixArray[95]  = 12'h000;
	iconPixArray[96]  = 12'h000;
	iconPixArray[97]  = 12'h000;
	iconPixArray[98]  = 12'h000;
	iconPixArray[99]  = 12'h000;
	iconPixArray[100] = 12'h000;
	iconPixArray[101] = 12'h000;
	iconPixArray[102] = 12'h000;
	iconPixArray[103] = 12'h000;
	iconPixArray[104] = 12'h000;
	iconPixArray[105] = 12'h000;
	iconPixArray[106] = 12'h000;
	iconPixArray[107] = 12'hF3F;
	iconPixArray[108] = 12'hF30;
	iconPixArray[109] = 12'hF30;
	iconPixArray[110] = 12'hF3F;
	iconPixArray[111] = 12'h000;
	iconPixArray[112] = 12'hF30;
	iconPixArray[113] = 12'hF30;
	iconPixArray[114] = 12'hF30;
	iconPixArray[115] = 12'hF30;
	iconPixArray[116] = 12'hF30;
	iconPixArray[117] = 12'hF30;
	iconPixArray[118] = 12'hF30;
	iconPixArray[119] = 12'hF30;
	iconPixArray[120] = 12'hF30;
	iconPixArray[121] = 12'hF30;
	iconPixArray[122] = 12'hF30;
	iconPixArray[123] = 12'hF3F;
	iconPixArray[124] = 12'hF30;
	iconPixArray[125] = 12'hF30;
	iconPixArray[126] = 12'hF30;
	iconPixArray[127] = 12'hF3F;
	iconPixArray[128] = 12'hF30;
	iconPixArray[129] = 12'hF30;
	iconPixArray[130] = 12'hF30;
	iconPixArray[131] = 12'hF30;
	iconPixArray[132] = 12'hF30;
	iconPixArray[133] = 12'hF30;
	iconPixArray[134] = 12'hF30;
	iconPixArray[135] = 12'hF30;
	iconPixArray[136] = 12'hF30;
	iconPixArray[137] = 12'hF30;
	iconPixArray[138] = 12'hF30;
	iconPixArray[139] = 12'hF3F;
	iconPixArray[140] = 12'hF30;
	iconPixArray[141] = 12'hF30;
	iconPixArray[142] = 12'hF30;
	iconPixArray[143] = 12'hF3F;
	iconPixArray[144] = 12'h000;
	iconPixArray[145] = 12'h000;
	iconPixArray[146] = 12'h000;
	iconPixArray[147] = 12'h000;
	iconPixArray[148] = 12'h000;
	iconPixArray[149] = 12'h000;
	iconPixArray[150] = 12'h000;
	iconPixArray[151] = 12'h000;
	iconPixArray[152] = 12'h000;
	iconPixArray[153] = 12'h000;
	iconPixArray[154] = 12'h000;
	iconPixArray[155] = 12'hF3F;
	iconPixArray[156] = 12'hF30;
	iconPixArray[157] = 12'hF30;
	iconPixArray[158] = 12'hF3F;
	iconPixArray[159] = 12'h000;
	iconPixArray[160] = 12'h000;
	iconPixArray[161] = 12'h000;
	iconPixArray[162] = 12'h000;
	iconPixArray[163] = 12'h000;
	iconPixArray[164] = 12'h000;
	iconPixArray[165] = 12'h000;
	iconPixArray[166] = 12'h000;
	iconPixArray[167] = 12'h000;
	iconPixArray[168] = 12'h000;
	iconPixArray[169] = 12'h000;
	iconPixArray[170] = 12'h000;
	iconPixArray[171] = 12'hF3F;
	iconPixArray[172] = 12'hF30;
	iconPixArray[173] = 12'hF30;
	iconPixArray[174] = 12'h000;
	iconPixArray[175] = 12'h000;
	iconPixArray[176] = 12'h000;
	iconPixArray[177] = 12'h000;
	iconPixArray[178] = 12'h000;
	iconPixArray[179] = 12'h000;
	iconPixArray[180] = 12'h000;
	iconPixArray[181] = 12'h000;
	iconPixArray[182] = 12'h000;
	iconPixArray[183] = 12'h000;
	iconPixArray[184] = 12'h000;
	iconPixArray[185] = 12'h000;
	iconPixArray[186] = 12'h000;
	iconPixArray[187] = 12'hF30;
	iconPixArray[188] = 12'hF30;
	iconPixArray[189] = 12'h000;
	iconPixArray[190] = 12'h000;
	iconPixArray[191] = 12'h000;
	iconPixArray[192] = 12'h000;
	iconPixArray[193] = 12'h000;
	iconPixArray[194] = 12'h000;
	iconPixArray[195] = 12'h000;
	iconPixArray[196] = 12'h000;
	iconPixArray[197] = 12'h000;
	iconPixArray[198] = 12'h000;
	iconPixArray[199] = 12'h000;
	iconPixArray[200] = 12'h000;
	iconPixArray[201] = 12'h000;
	iconPixArray[202] = 12'hF30;
	iconPixArray[203] = 12'hF30;
	iconPixArray[204] = 12'h000;
	iconPixArray[205] = 12'h000;
	iconPixArray[206] = 12'h000;
	iconPixArray[207] = 12'h000;
	iconPixArray[208] = 12'h000;
	iconPixArray[209] = 12'h000;
	iconPixArray[210] = 12'h000;
	iconPixArray[211] = 12'h000;
	iconPixArray[212] = 12'h000;
	iconPixArray[213] = 12'h000;
	iconPixArray[214] = 12'h000;
	iconPixArray[215] = 12'h000;
	iconPixArray[216] = 12'hA30;
	iconPixArray[217] = 12'hF30;
	iconPixArray[218] = 12'hF30;
	iconPixArray[219] = 12'h000;
	iconPixArray[220] = 12'h000;
	iconPixArray[221] = 12'h000;
	iconPixArray[222] = 12'h000;
	iconPixArray[223] = 12'h000;
	iconPixArray[224] = 12'h000;
	iconPixArray[225] = 12'h000;
	iconPixArray[226] = 12'h000;
	iconPixArray[227] = 12'h000;
	iconPixArray[228] = 12'h000;
	iconPixArray[229] = 12'h000;
	iconPixArray[230] = 12'h000;
	iconPixArray[231] = 12'hA30;
	iconPixArray[232] = 12'hF30;
	iconPixArray[233] = 12'hF30;
	iconPixArray[234] = 12'h000;
	iconPixArray[235] = 12'h000;
	iconPixArray[236] = 12'h000;
	iconPixArray[237] = 12'h000;
	iconPixArray[238] = 12'h000;
	iconPixArray[239] = 12'h000;
	iconPixArray[240] = 12'h000;
	iconPixArray[241] = 12'hA30;
	iconPixArray[242] = 12'h000;
	iconPixArray[243] = 12'hA30;
	iconPixArray[244] = 12'h000;
	iconPixArray[245] = 12'hA30;
	iconPixArray[246] = 12'h000;
	iconPixArray[247] = 12'hA30;
	iconPixArray[248] = 12'hF30;
	iconPixArray[249] = 12'h000;
	iconPixArray[250] = 12'h000;
	iconPixArray[251] = 12'h000;
	iconPixArray[252] = 12'h000;
	iconPixArray[253] = 12'h000;
	iconPixArray[254] = 12'h000;
	iconPixArray[255] = 12'h000;
	iconPixArray[256] = 12'h000;
	iconPixArray[257] = 12'h000;
	iconPixArray[258] = 12'h000;
	iconPixArray[259] = 12'h000;
	iconPixArray[260] = 12'h000;
	iconPixArray[261] = 12'hA30;
	iconPixArray[262] = 12'hF30;
	iconPixArray[263] = 12'hF30;
	iconPixArray[264] = 12'hF30;
	iconPixArray[265] = 12'hF30;
	iconPixArray[266] = 12'hF30;
	iconPixArray[267] = 12'hF30;
	iconPixArray[268] = 12'hF30;
	iconPixArray[269] = 12'hF30;
	iconPixArray[270] = 12'hF3F;
	iconPixArray[271] = 12'hF3F;
	iconPixArray[272] = 12'h000;
	iconPixArray[273] = 12'h000;
	iconPixArray[274] = 12'h000;
	iconPixArray[275] = 12'h000;
	iconPixArray[276] = 12'hA30;
	iconPixArray[277] = 12'h000;
	iconPixArray[278] = 12'h000;
	iconPixArray[279] = 12'h000;
	iconPixArray[280] = 12'h000;
	iconPixArray[281] = 12'hF3F;
	iconPixArray[282] = 12'hF3F;
	iconPixArray[283] = 12'hF30;
	iconPixArray[284] = 12'hF30;
	iconPixArray[285] = 12'hF3F;
	iconPixArray[286] = 12'hF30;
	iconPixArray[287] = 12'hF3F;
	iconPixArray[288] = 12'h000;
	iconPixArray[289] = 12'h000;
	iconPixArray[290] = 12'h000;
	iconPixArray[291] = 12'h000;
	iconPixArray[292] = 12'h000;
	iconPixArray[293] = 12'h000;
	iconPixArray[294] = 12'h000;
	iconPixArray[295] = 12'h000;
	iconPixArray[296] = 12'h000;
	iconPixArray[297] = 12'h000;
	iconPixArray[298] = 12'hF3F;
	iconPixArray[299] = 12'hF30;
	iconPixArray[300] = 12'hF3F;
	iconPixArray[301] = 12'hF30;
	iconPixArray[302] = 12'hF3F;
	iconPixArray[303] = 12'hF30;
	iconPixArray[304] = 12'h000;
	iconPixArray[305] = 12'h000;
	iconPixArray[306] = 12'hA30;
	iconPixArray[307] = 12'h000;
	iconPixArray[308] = 12'h000;
	iconPixArray[309] = 12'h000;
	iconPixArray[310] = 12'h000;
	iconPixArray[311] = 12'h000;
	iconPixArray[312] = 12'h000;
	iconPixArray[313] = 12'h000;
	iconPixArray[314] = 12'h000;
	iconPixArray[315] = 12'hF3F;
	iconPixArray[316] = 12'hF30;
	iconPixArray[317] = 12'hF3F;
	iconPixArray[318] = 12'hF30;
	iconPixArray[319] = 12'hF30;
	iconPixArray[320] = 12'h000;
	iconPixArray[321] = 12'h000;
	iconPixArray[322] = 12'h000;
	iconPixArray[323] = 12'h000;
	iconPixArray[324] = 12'h000;
	iconPixArray[325] = 12'h000;
	iconPixArray[326] = 12'h000;
	iconPixArray[327] = 12'h000;
	iconPixArray[328] = 12'h000;
	iconPixArray[329] = 12'h000;
	iconPixArray[330] = 12'hF3F;
	iconPixArray[331] = 12'hF30;
	iconPixArray[332] = 12'hF3F;
	iconPixArray[333] = 12'hF30;
	iconPixArray[334] = 12'hF30;
	iconPixArray[335] = 12'hF30;
	iconPixArray[336] = 12'hA30;
	iconPixArray[337] = 12'h000;
	iconPixArray[338] = 12'h000;
	iconPixArray[339] = 12'h000;
	iconPixArray[340] = 12'h000;
	iconPixArray[341] = 12'h000;
	iconPixArray[342] = 12'h000;
	iconPixArray[343] = 12'h000;
	iconPixArray[344] = 12'h000;
	iconPixArray[345] = 12'hF3F;
	iconPixArray[346] = 12'hF30;
	iconPixArray[347] = 12'hF3F;
	iconPixArray[348] = 12'h000;
	iconPixArray[349] = 12'hF3F;
	iconPixArray[350] = 12'hF3F;
	iconPixArray[351] = 12'hF30;
	iconPixArray[352] = 12'h000;
	iconPixArray[353] = 12'h000;
	iconPixArray[354] = 12'h000;
	iconPixArray[355] = 12'h000;
	iconPixArray[356] = 12'h000;
	iconPixArray[357] = 12'h000;
	iconPixArray[358] = 12'h000;
	iconPixArray[359] = 12'h000;
	iconPixArray[360] = 12'hF3F;
	iconPixArray[361] = 12'hF30;
	iconPixArray[362] = 12'hF3F;
	iconPixArray[363] = 12'h000;
	iconPixArray[364] = 12'h000;
	iconPixArray[365] = 12'h000;
	iconPixArray[366] = 12'hF3F;
	iconPixArray[367] = 12'hF30;
	iconPixArray[368] = 12'h000;
	iconPixArray[369] = 12'h000;
	iconPixArray[370] = 12'h000;
	iconPixArray[371] = 12'h000;
	iconPixArray[372] = 12'h000;
	iconPixArray[373] = 12'h000;
	iconPixArray[374] = 12'h000;
	iconPixArray[375] = 12'hF3F;
	iconPixArray[376] = 12'hF30;
	iconPixArray[377] = 12'hF3F;
	iconPixArray[378] = 12'h000;
	iconPixArray[379] = 12'h000;
	iconPixArray[380] = 12'h000;
	iconPixArray[381] = 12'h000;
	iconPixArray[382] = 12'h000;
	iconPixArray[383] = 12'hF30;
	iconPixArray[384] = 12'h000;
	iconPixArray[385] = 12'h000;
	iconPixArray[386] = 12'h000;
	iconPixArray[387] = 12'h000;
	iconPixArray[388] = 12'h000;
	iconPixArray[389] = 12'h000;
	iconPixArray[390] = 12'hF3F;
	iconPixArray[391] = 12'hF30;
	iconPixArray[392] = 12'hF3F;
	iconPixArray[393] = 12'h000;
	iconPixArray[394] = 12'h000;
	iconPixArray[395] = 12'h000;
	iconPixArray[396] = 12'h000;
	iconPixArray[397] = 12'h000;
	iconPixArray[398] = 12'h000;
	iconPixArray[399] = 12'hF30;
	iconPixArray[400] = 12'h000;
	iconPixArray[401] = 12'h000;
	iconPixArray[402] = 12'h000;
	iconPixArray[403] = 12'h000;
	iconPixArray[404] = 12'h000;
	iconPixArray[405] = 12'hF3F;
	iconPixArray[406] = 12'hF30;
	iconPixArray[407] = 12'hF3F;
	iconPixArray[408] = 12'h000;
	iconPixArray[409] = 12'h000;
	iconPixArray[410] = 12'h000;
	iconPixArray[411] = 12'h000;
	iconPixArray[412] = 12'h000;
	iconPixArray[413] = 12'h000;
	iconPixArray[414] = 12'h000;
	iconPixArray[415] = 12'hF30;
	iconPixArray[416] = 12'h000;
	iconPixArray[417] = 12'h000;
	iconPixArray[418] = 12'h000;
	iconPixArray[419] = 12'h000;
	iconPixArray[420] = 12'hF3F;
	iconPixArray[421] = 12'hF30;
	iconPixArray[422] = 12'hF3F;
	iconPixArray[423] = 12'h000;
	iconPixArray[424] = 12'h000;
	iconPixArray[425] = 12'h000;
	iconPixArray[426] = 12'h000;
	iconPixArray[427] = 12'h000;
	iconPixArray[428] = 12'h000;
	iconPixArray[429] = 12'h000;
	iconPixArray[430] = 12'h000;
	iconPixArray[431] = 12'hA30;
	iconPixArray[432] = 12'h000;
	iconPixArray[433] = 12'h000;
	iconPixArray[434] = 12'h000;
	iconPixArray[435] = 12'hF3F;
	iconPixArray[436] = 12'hF30;
	iconPixArray[437] = 12'hF3F;
	iconPixArray[438] = 12'h000;
	iconPixArray[439] = 12'h000;
	iconPixArray[440] = 12'h000;
	iconPixArray[441] = 12'h000;
	iconPixArray[442] = 12'h000;
	iconPixArray[443] = 12'h000;
	iconPixArray[444] = 12'h000;
	iconPixArray[445] = 12'h000;
	iconPixArray[446] = 12'hA30;
	iconPixArray[447] = 12'h000;
	iconPixArray[448] = 12'h000;
	iconPixArray[449] = 12'h000;
	iconPixArray[450] = 12'hF3F;
	iconPixArray[451] = 12'hF30;
	iconPixArray[452] = 12'hF3F;
	iconPixArray[453] = 12'h000;
	iconPixArray[454] = 12'h000;
	iconPixArray[455] = 12'h000;
	iconPixArray[456] = 12'h000;
	iconPixArray[457] = 12'h000;
	iconPixArray[458] = 12'h000;
	iconPixArray[459] = 12'h000;
	iconPixArray[460] = 12'h000;
	iconPixArray[461] = 12'h000;
	iconPixArray[462] = 12'h000;
	iconPixArray[463] = 12'h000;
	iconPixArray[464] = 12'h000;
	iconPixArray[465] = 12'hF3F;
	iconPixArray[466] = 12'hF30;
	iconPixArray[467] = 12'hF3F;
	iconPixArray[468] = 12'h000;
	iconPixArray[469] = 12'h000;
	iconPixArray[470] = 12'h000;
	iconPixArray[471] = 12'h000;
	iconPixArray[472] = 12'h000;
	iconPixArray[473] = 12'h000;
	iconPixArray[474] = 12'h000;
	iconPixArray[475] = 12'h000;
	iconPixArray[476] = 12'hA30;
	iconPixArray[477] = 12'h000;
	iconPixArray[478] = 12'h000;
	iconPixArray[479] = 12'h000;
	iconPixArray[480] = 12'hF3F;
	iconPixArray[481] = 12'hF30;
	iconPixArray[482] = 12'hF3F;
	iconPixArray[483] = 12'h000;
	iconPixArray[484] = 12'h000;
	iconPixArray[485] = 12'h000;
	iconPixArray[486] = 12'h000;
	iconPixArray[487] = 12'h000;
	iconPixArray[488] = 12'h000;
	iconPixArray[489] = 12'h000;
	iconPixArray[490] = 12'h000;
	iconPixArray[491] = 12'h000;
	iconPixArray[492] = 12'h000;
	iconPixArray[493] = 12'h000;
	iconPixArray[494] = 12'h000;
	iconPixArray[495] = 12'h000;
	iconPixArray[496] = 12'hF30;
	iconPixArray[497] = 12'hF3F;
	iconPixArray[498] = 12'h000;
	iconPixArray[499] = 12'h000;
	iconPixArray[500] = 12'h000;
	iconPixArray[501] = 12'h000;
	iconPixArray[502] = 12'h000;
	iconPixArray[503] = 12'h000;
	iconPixArray[504] = 12'h000;
	iconPixArray[505] = 12'h000;
	iconPixArray[506] = 12'hA30;
	iconPixArray[507] = 12'h000;
	iconPixArray[508] = 12'h000;
	iconPixArray[509] = 12'h000;
	iconPixArray[510] = 12'h000;
	iconPixArray[511] = 12'h000;
  end




endmodule 