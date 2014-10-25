// filename proj2HeaderFile.vh
//
// Don't re-include this stuff if it is already included
`ifndef _proj2Header_vh_
`define _proj2Header_vh_

// ======================
// === Port Addresses ===
// ======================

// Nexys 4 board base I/O interface ports compatible with the Nexys3 I/O interface
//  Port Addresses
parameter	PA_PBTNS		= 8'h00;		// (i) pushbuttons inputs
parameter	PA_SLSWTCH		= 8'h01;		// (i) slide switches
parameter	PA_LEDS			= 8'h02;		// (o) LEDs
parameter	PA_DIG3			= 8'h03;		// (o) digit 3 port address
parameter	PA_DIG2			= 8'h04;		// (o) digit 2 port address
parameter	PA_DIG1			= 8'h05;		// (o) digit 1 port address
parameter	PA_DIG0			= 8'h06;		// (o) digit 0 port address
parameter	PA_DP			= 8'h07;		// (o) decimal points 3:0 port address
parameter	PA_RSVD			= 8'h08;		// (o) *RESERVED* port address


// Rojobot interface registers
parameter	PA_MOTCTL_IN	= 8'h09;		// (o) Rojobot motor control output from system
parameter	PA_LOCX			= 8'h0A;		// (i) X coordinate of rojobot location
parameter	PA_LOCY			= 8'h0B;		// (i))Y coordinate of rojobot location
parameter	PA_BOTINFO		= 8'h0C;		// (i) Rojobot info register
parameter	PA_SENSORS		= 8'h0D;		// (i) Sensor register
parameter	PA_LMDIST		= 8'h0E;		// (i) Rojobot left motor distance register
parameter	PA_RMDIST		= 8'h0F;		// (i) Rojobot right motor distance register

// Extended I/O interface port addresses for the Nexys4.  
parameter	PA_PBTNS_ALT	= 8'h10;		// (i) pushbutton inputs alternate port address
parameter	PA_SLSWTCH1508	= 8'h11;		// (i) slide switches 15:8 (high byte of switches
parameter	PA_LEDS1508		= 8'h12;		// (o) LEDs 15:8 (high byte of switches)
parameter	PA_DIG7			= 8'h13;		// (o) digit 7 port address
parameter	PA_DIG6			= 8'h14;		// (o) digit 6 port address
parameter	PA_DIG5			= 8'h15;		// (o) digit 5 port address
parameter	PA_DIG4			= 8'h16;		// (o) digit 4 port address
parameter	PA_DP0704		= 8'h17;		// (o) decimal points 7:4 port address
parameter	PA_RSVD_ALT		= 8'h18;		// (o) *RESERVED* alternate port address

// Extended Rojobot interface registers.  These are alternate Port addresses
parameter	PA_MOTCTL_IN_ALT	= 8'h19;	// (o) Rojobot motor control output from system
parameter	PA_LOCX_ALT			= 8'h1A;	// (i) X coordinate of rojobot location
parameter	PA_LOCY_ALT			= 8'h1B;	// (i))Y coordinate of rojobot location
parameter	PA_BOTINFO_ALT		= 8'h1C;	// (i) Rojobot info register
parameter	PA_SENSORS_ALT		= 8'h1D;	// (i) Sensor register
parameter	PA_LMDIST_ALT		= 8'h1E;	// (i) Rojobot left motor distance register
parameter	PA_RMDIST_ALT		= 8'h1F;	// (i) Rojobot right motor distance register



// ========================
// === Useful Constants ===
// ========================
// Character code table for special characters
// Decimal digits 0 to 15 display '0'to 'F'
parameter	CC_BASE		= 8'h10;	//Base value for special characters
parameter	CC_SEGBASE	= 8'h10; 	//Base value for segment display special characters
									//					 abcdefg
parameter	CC_SEGA		= 8'h10;	// Segment A		[1000000]
parameter	CC_SEGB		= 8'h11; 	// Segment B		[0100000]
parameter	CC_SEGC		= 8'h12; 	// Segment C		[0010000]
parameter	CC_SEGD		= 8'h13; 	// Segment D		[0001000]
parameter	CC_SEGE		= 8'h14; 	// Segment E		[0000100]
parameter	CC_SEGF		= 8'h15; 	// Segment F		[0000010]
parameter	CC_SEGG		= 8'h16; 	// Segment G		[0000001]
parameter	CC_DOT		= 8'h17; 	// Dot (period)
parameter	CC_UCH		= 8'h18; 	// Upper Case H
parameter	CC_UCL		= 8'h19; 	// Upper Case L
parameter	CC_UCR		= 8'h1A; 	// Upper Case R
parameter	CC_LCL		= 8'h1B; 	// Lower Case L
parameter	CC_LCR		= 8'h1C; 	// Lower Case R
parameter	CC_SPACE1	= 8'h1D; 	// Space (blank)
parameter	CC_SPACE2	= 8'h1E; 	// Space (blank)
parameter	CC_SPACE	= 8'h1F; 	// Space (blank)

`endif // -proj2Header_vh_