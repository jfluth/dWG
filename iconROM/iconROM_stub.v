// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.3 (win64) Build 1034051 Fri Oct  3 17:14:12 MDT 2014
// Date        : Thu Oct 30 16:44:41 2014
// Host        : pair running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub {C:/Users/pwl/Git Repos/540/proj2_src/iconROM/iconROM_stub.v}
// Design      : iconROM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2014.3" *)
module iconROM(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[7:0],douta[1:0]" */;
  input clka;
  input [7:0]addra;
  output [1:0]douta;
endmodule
