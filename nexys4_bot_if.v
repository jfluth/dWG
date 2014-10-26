// filename nexus4_bot_if.v
// Paul and Jordans Project
//

module  nexys4_bot_if #(parameter integer RESET_POLARITY_LOW = 1)(

	// system interface
	input			clk,
	input			rst,			// consider implementing agnostic wrt: active high or active low

	// pico blaze interface	
	input		[7:0]	PortID,			// Port address 			PB -> us
	input		[7:0]	DataIn,			// Data						PB -> us
	output	reg	[7:0]	DataOut,		// Data						us -> PB
	
	input				kWriteStrobe,	// Constant write strobe	PB -> us
	input				WriteStrobe,	// write strobe				PB -> us
	input				ReadStrobe,
	
	output	reg			Interrupt,
	input				InterruptAck,
	
	// bot interface
	output	reg	[7:0]	MotCtl,			// Instructions out to RojoBot
	input		[7:0]	LocX,			// Location in from RojoBot
	input 		[7:0]	LocY,			// IBID
	input		[7:0]	BotInfo,		// in from RojoBot
	input		[7:0]	Sensors,		// In from RojoBot
	input		[7:0]	LMDist,			// depricated right motor distance
	input		[7:0]	RMDist,			// depricated left motor distance
	
	input			    BotInterrupt,	// interrupt from RojoBot when CSRs have been updated
	
	// display interface
	output	reg	[4:0]	Dig0,			// out to 7-seg digits
	output	reg	[4:0]	Dig1,
	output	reg	[4:0]	Dig2,
	output	reg	[4:0]	Dig3,
	output	reg	[4:0]	Dig4,
	output	reg	[4:0]	Dig5,
	output	reg	[4:0]	Dig6,
	output	reg	[4:0]	Dig7,
	output	reg	[3:0]	DP_l,			// out to low-order decimal points on nexys4
	output	reg	[3:0]	DP_h,			// out to high-order decimal points on nexus
	output	reg	[15:0]	LED,			// out to switch LEDs on nexys4
	
	// switch & button interface
	input		[3:0]	Button,			// Debounced buttons in from nexys4
										// Demo_CPU module expects the following:
										// Button[{left,up,right,down}]
	input		[15:0]	Switch			// Debounced switches in from nexys4
);
/////////////////////////
// End Port Definitions	
/////////////////////////
	`include "proj2Header.vh"			
	//wire reset = RESET_POLARITY_LOW ? ~rst : rst;			

    
	// Outgoing from I/O block
	always @(posedge clk) begin
		// Currently not going to use the read strobe it will be up to the 
		// design to make sure right data is in the right place at the right time
		case (PortID)
			// In from Rojobot
			// Keeping  original and _ALT port address to maintain
			// backwards compatibility with Nexys3
			PA_LOCX:		DataOut <= LocX;
			PA_LOCX_ALT:	DataOut <= LocX;
			PA_LOCY:		DataOut <= LocY;
			PA_LOCY_ALT:	DataOut <= LocY;
			PA_BOTINFO:		DataOut <= BotInfo;
			PA_BOTINFO_ALT:	DataOut <= BotInfo;
			PA_SENSORS:		DataOut <= Sensors;
			PA_SENSORS_ALT:	DataOut <= Sensors;
			PA_LMDIST:		DataOut <= LMDist;			// Deprecated, include for completeness
			PA_LMDIST_ALT:	DataOut <= LMDist;			// IBID
			PA_RMDIST:		DataOut <= RMDist;			// IBID
			PA_RMDIST_ALT:	DataOut <= RMDist;			// IBID
			
			// In from Nexys4
			PA_PBTNS:		DataOut <= {Button};
			PA_PBTNS_ALT:	DataOut <= {Button};
			PA_SLSWTCH:		DataOut <= Switch[15:8];	// Low-order switches
			PA_SLSWTCH1508:	DataOut <= Switch[7:0];		// High-order switches
			
			// Unused states set to don't care per kcpsm6_desigh_template.v
			default:		DataOut <= 8'bx;
		endcase
	end// always block
	
	// Incoming to I/O block
	always @(posedge clk /*or negedge rst*/) begin

		
	  //Dig0 <= 8'd16;
		/*if (!rst) begin // see comment above re: agnostic wrt: reste active high/low
			// Blank 7-Seg Displays
			Dig0 <= CC_SPACE;
			Dig1 <= CC_SPACE;
			Dig2 <= CC_SPACE;
			Dig3 <= CC_SPACE;
			Dig4 <= CC_SPACE;
			Dig5 <= CC_SPACE;
			Dig6 <= CC_SPACE;
			Dig7 <= CC_SPACE;
			
			// Blank DPs
			DP_l <= 4'b0;//PWL: These widths might be wrong, give this a look please!
			DP_h <= 4'b0;
		end
		else begin*/
			if (WriteStrobe) begin
				case(PortID)// PWL: should I be switching on the low-order 5 bits to save a LUT6 on implementation
					// Out to 7-seg Displays
					PA_DIG7:	Dig7  <= DataIn;
					PA_DIG6:	Dig6  <= DataIn;
					PA_DIG5:	Dig5  <= DataIn;
					PA_DIG4:	Dig4  <= DataIn;
					PA_DIG3:	Dig3  <= DataIn;
					PA_DIG2:	Dig2  <= DataIn;
					PA_DIG1:	Dig1  <= DataIn;
					PA_DIG0:	Dig0  <= DataIn;
					PA_DP:		DP_l  <= DataIn;
					PA_DP0704:	DP_h  <= DataIn;
					
					// Out to LED's
					PA_LEDS:	 LED[7:0]  <= DataIn;
					PA_LEDS1508: LED[15:8] <= DataIn;
					
					// Out to RojoBot
					PA_MOTCTL_IN:	  MotCtl[7:0] <= DataIn;
					PA_MOTCTL_IN_ALT: MotCtl[7:0] <= DataIn;
	
					//default: ;// PWL: there is a lot more to do here, mister!
				endcase
			//end
		end
	end //always block
		
	// Interrupt Flop
	always @(posedge clk) begin
		if (InterruptAck)
			Interrupt <= 1'b0;
		else if (BotInterrupt)
			Interrupt <= 1'b1;
		else
			Interrupt <= Interrupt;
	end
	//always @(posedge clk) begin
	//	Interrupt <= BotInterrupt; //PWL: this looks fishy, prolly need some wires
	//end
		
endmodule