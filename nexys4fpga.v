// nexys4fpga.v - Top level module for Nexys4 as used in ECE 540 Project 2
//
// Paul Long <pwl@pdx.edu>
//
//
//
//


module Nexys4fpga (


	///////////////////////////////////////////////////////////////////////////
	// Port Declarations
	///////////////////////////////////////////////////////////////////////////
	//
	
	// System Connections
	input			clk,
	output	[7:0]	JA,			// still need to figure this guy out
	input			btnCpuReset,
	
	// On-Board Display Connections
	output			dp, 		// Proj2Demo Example Design Description page 3of6 has this as single bit????
	output	[6:0]	seg,
	output	[7:0]	an,
	output	[15:0]	led,
	
	// Buttons & Switches
	input			btnL, btnU,
					btnR, btnD,
					btnC, 
	input	[15:0]	sw
	
	// VGA Display Connections
	// these will not be needed for part one
);
	
	// parameter
	parameter SIMULATE = 0;

	
	///////////////////////////////////////////////////////////////////////////
	// Internal Signals
	///////////////////////////////////////////////////////////////////////////
	//
	
	// IO <-> RojoBot connections
	wire	[7:0]	motctl;
	wire	[7:0]	locx;
	wire	[7:0]	locy;
	wire	[7:0]	botinfo;
	wire	[7:0]	sensors;
	wire	[7:0]	lmdist;
	wire	[7:0]	rmdist;
	wire			upd_sysregs;
	
	// IO <-> Demo_CPU connections
	wire	[7:0]	port_id;
	wire	[7:0]	out_port;
	wire	[7:0]	in_port;
	wire			k_write_strobe;
	wire			write_strobe;
	wire			read_strobe;
	wire			interrupt;
	wire			interrupt_ack;
					
	// IO <-> Debounce connections
	wire	[5:0]	db_btns;
	wire	[15:0]	db_sw;
			
	// IO <-> 7-seg Connections
	wire	[4:0]	Dig[7:0];
	wire	[3:0]	DPHigh;
	wire	[3:0]	DPLow;
	
	// Demo_CPU <-> Code Store connections
	wire	[17:0]	instruction;
	wire	[11:0]	address;
	wire			bram_enable;
	
	// Demo_CPU <-> System connections
	wire			rdl;
	wire			kcpsm6_sleep;
	
	// System Level connections
	wire			sysreset;
	wire			sysclk;

	
	///////////////////////////////////////////////////////////////////////////
	// Global Assigns
	///////////////////////////////////////////////////////////////////////////
	//
	
	assign	sysclk = clk;
	assign	sysreset = db_btns[0];
	assign	JA = {sysclk, sysreset, 6'b000000};	//PWL: what is this whichcraft???
	
	//I think this is a mistake carried over from proj1. this means sysreset is *NOT* debounced, right?
	// assign 	sysreset = btnCpuReset; // btnCpuReset is asserted low
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// instantiate the debounce module
	///////////////////////////////////////////////////////////////////////////
	// 
	
	debounce #(
		.RESET_POLARITY_LOW(1),
		.SIMULATE(SIMULATE))
	DB (
		.clk(sysclk),	
		.pbtn_in({btnC, btnL, btnU, btnR, btnD, btnCpuReset}),
		.switch_in(sw),
		.pbtn_db({db_btns[5:1], sysreset}),
		.swtch_db(db_sw)
	);	
	
	
	///////////////////////////////////////////////////////////////////////////	
	// Instantiate the 7-segment, 8-digit display
	///////////////////////////////////////////////////////////////////////////
	//
	
	sevensegment #(
		.RESET_POLARITY_LOW(1),
		.SIMULATE(SIMULATE))
		
	SSD (
		// inputs for control signals
		.d0(Dig[0]),
		.d1(Dig[1]),
 		.d2(Dig[2]),
		.d3(Dig[3]),
		.d4(Dig[4]),
		.d5(Dig[5]),
		.d6(Dig[6]),
		.d7(Dig[7]),
		.dp({DPHigh, DPLow}),
		
		// outputs to seven segment display
		.seg({dp, seg}),			
		.an(an),
		
		// clock and reset signals (100 MHz clock, active low reset)
		.clk(sysclk),
		.reset(sysreset),
		
		// ouput for simulation only
		.digits_out() //PWL: did you implement this in this design??? I think not!!
	);
	
	///////////////////////////////////////////////////////////////////////////
	// Instantiate the I/O controller
	///////////////////////////////////////////////////////////////////////////
	//
	
	nexys4_bot_if #(
		/* module currently takes no parameters */)
	IO_Interface (
		// DEMO_CPU Interface
		.PortID			(port_id),		// Port address 			PB -> us
		.DataIn			(out_port),		// Data						PB -> us
		.DataOut		(in_port),		// Data						us -> PB
	
		.kWriteStrobe	(k_write_strobe),	// Constant write strobe	PB -> us
		.WriteStrobe	(write_strobe),	// write strobe				PB -> us
		.ReadStrobe		(read_strobe),
	
		.Interrupt		(interrupt),
		.InterruptAck	(interrupt_ack),
		
		// bot interface
		.MotCtl			(motctl),	// Instructions out to RojoBot
		.LocX			(locx),			// Location in from RojoBot
		.LocY			(locy),			// IBID
		.BotInfo		(botinfo),		// in from RojoBot
		.Sensors		(sensors),		// In from RojoBot
		.LMDist			(lmdist),		// DEPRICATED right motor distance
		.RMDist			(rmdist),		// DEPRICATED left motor distance
	
		.BotInterrupt	(upd_sysregs),	// interrupt from RojoBot when CSRs have been updated
	
		// display interface
		.Dig0			(Dig[0]),		// out to 7-seg digits
		.Dig1			(Dig[1]),
		.Dig2			(Dig[2]),
		.Dig3			(Dig[3]),
		.Dig4			(Dig[4]),
		.Dig5			(Dig[5]),
		.Dig6			(Dig[6]),
		.Dig7			(Dig[7]),
		.DP_l			(DPHigh),		// out to low-order decimal points on nexys4
		.DP_h			(DPLow),		// out to high-order decimal points on nexus
		.LED			(led),			// out to switch LEDs on nexys4
		
		// switch & button interface
		.Button			(db_btns[5:1]),	// debounced buttons in from nexys4
										// Button[{center,left,right,up,down}]
		.Switch			(db_sw),		// debounced switches in from nexys4
		
		// System Interface
		.clk			(sysclk),
		.rst			(sysreset));
		
	///////////////////////////////////////////////////////////////////////////
	// Instantiate RojoBot
	///////////////////////////////////////////////////////////////////////////
	//
	//
	// PWL: for part one, tie video controller logic low
	//
	
	bot # (
		/* bot module has no parameters */)
	RojoBot_CPU (
		// Main CSRs
		.MotCtl_in		(motctl),		// Motor control input	
		.LocX_reg		(locx),			// X-coordinate of rojobot's location		
		.LocY_reg		(locy),			// Y-coordinate of rojobot's location
		.Sensors_reg	(sensors),		// Sensor readings
		.BotInfo_reg	(botinfo),		// Information about rojobot's activity
		.LMDist_reg		(lmdist),		// left motor distance register (DEPRICATED)
		.RMDist_reg		(rmdist),		// right motor distance register (DEPRICATED)
						
		// Interface to the video logic
		// tied low for the demo (part1)
		.vid_row		(),		// video logic row address
		.vid_col		(),		// video logic column address

		.vid_pixel_out	(),			// pixel (location) value

		// System Interface
		.clk			(sysclk),		// system clock
		.reset			(sysreset),		// system reset
		.upd_sysregs	(upd_sysregs));	// flag from RojoBot to indicate that the system registers 
										// (LocX, LocY, Sensors, BotInfo) have been updated
		
	
	
	
	///////////////////////////////////////////////////////////////////////////
	// Instantiate PB for Demo (Part 1)
	///////////////////////////////////////////////////////////////////////////
	//
	//
	//
	// The KCPSM6 parameters defined here are just the defaults and as such,
	// could be left out. Leaving them in here so as to remember that they
	// exist and can be fiddled with if necessary
	//

	kcpsm6 #(
		.interrupt_vector		(12'h3FF),
		.scratch_pad_memory_size(64),
		.hwbuild				(8'h00))
	Demo_CPU (
		.address 		(address),
		.instruction 	(instruction),
		.bram_enable 	(bram_enable),
		.port_id 		(port_id),
		.write_strobe 	(write_strobe),
		.k_write_strobe (k_write_strobe),
		.out_port 		(out_port),
		.read_strobe 	(read_strobe),
		.in_port 		(in_port),
		.interrupt 		(interrupt),
		.interrupt_ack 	(interrupt_ack),
		.reset 			(sysreset),
		.sleep			(kcpsm6_sleep),
		.clk 			(sysclk)); 

	// for now, will not use sleep functionality so tying low
	assign kcpsm6_sleep = 1'b0;
	
	
	///////////////////////////////////////////////////////////////////////////	
	// Instantiate Demo BRAM (Code Store)
	///////////////////////////////////////////////////////////////////////////
	//
	
	proj2demo #(
		.C_FAMILY				("7S"),   	// setting to '7S' cince we are using a 7-series FPGA
		.C_RAM_SIZE_KWORDS		(2),     	//Program size '1', '2' or '4'
		.C_JTAG_LOADER_ENABLE	(1'b0))    	//PWL: I set this to zero PWL.....................Include JTAG Loader when set to 1'b1 
	Code_Store (							
		//.rdl 			(rdl),
		.enable 		(bram_enable),
		.address 		(address),
		.instruction 	(instruction),
		.clk 			(sysclk));
		
	//	enable system reset for the Demo_CPU and it's program store
	//assign kcpsm6_reset = sysreset | rdl;
	//assign rdl = 1'b0;						// for now not allowing the program store
											// to reset the Demo_CPU




endmodule