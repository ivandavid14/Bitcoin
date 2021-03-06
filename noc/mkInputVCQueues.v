`timescale 1ns / 1ps
/*
 * These source files contain a hardware description of a network
 * automatically generated by CONNECT (CONfigurable NEtwork Creation Tool).
 *
 * This product includes a hardware design developed by Carnegie Mellon
 * University.
 *
 * Copyright (c) 2012 by Michael K. Papamichael, Carnegie Mellon University
 *
 * For more information, see the CONNECT project website at:
 *   http://www.ece.cmu.edu/~mpapamic/connect
 *
 * This design is provided for internal, non-commercial research use only, 
 * cannot be used for, or in support of, goods or services, and is not for
 * redistribution, with or without modifications.
 * 
 * You may not use the name "Carnegie Mellon University" or derivations
 * thereof to endorse or promote products derived from this software.
 *
 * THE SOFTWARE IS PROVIDED "AS-IS" WITHOUT ANY WARRANTY OF ANY KIND, EITHER
 * EXPRESS, IMPLIED OR STATUTORY, INCLUDING BUT NOT LIMITED TO ANY WARRANTY
 * THAT THE SOFTWARE WILL CONFORM TO SPECIFICATIONS OR BE ERROR-FREE AND ANY
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
 * TITLE, OR NON-INFRINGEMENT.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
 * BE LIABLE FOR ANY DAMAGES, INCLUDING BUT NOT LIMITED TO DIRECT, INDIRECT,
 * SPECIAL OR CONSEQUENTIAL DAMAGES, ARISING OUT OF, RESULTING FROM, OR IN
 * ANY WAY CONNECTED WITH THIS SOFTWARE (WHETHER OR NOT BASED UPON WARRANTY,
 * CONTRACT, TORT OR OTHERWISE).
 *
 */


//
// Generated by Bluespec Compiler, version 2012.01.A (build 26572, 2012-01-17)
//
// On Sat Oct  5 04:50:56 EDT 2013
//
// Method conflict info:
// Method: enq
// Conflict-free: deq, notEmpty, notFull
// Conflicts: enq
//
// Method: deq
// Conflict-free: enq, notEmpty, notFull
// Conflicts: deq
//
// Method: notEmpty
// Conflict-free: enq, deq, notEmpty, notFull
//
// Method: notFull
// Conflict-free: enq, deq, notEmpty, notFull
//
//
// Ports:
// Name                         I/O  size props
// deq                            O    72
// notEmpty                       O     4 reg
// notFull                        O     4 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// enq_fifo_in                    I     2
// enq_data_in                    I    72
// deq_fifo_out                   I     2
// EN_enq                         I     1
// EN_deq                         I     1
//
// No combinational paths from inputs to outputs
//
//
`timescale 1ns / 1ps

`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif

module mkInputVCQueues(CLK,
		       RST_N,

		       enq_fifo_in,
		       enq_data_in,
		       EN_enq,

		       deq_fifo_out,
		       EN_deq,
		       deq,

		       notEmpty,

		       notFull);
  input  CLK;
  input  RST_N;

  // action method enq
  input  [1 : 0] enq_fifo_in;
  input  [71 : 0] enq_data_in;
  input  EN_enq;

  // actionvalue method deq
  input  [1 : 0] deq_fifo_out;
  input  EN_deq;
  output [71 : 0] deq;

  // value method notEmpty
  output [3 : 0] notEmpty;

  // value method notFull
  output [3 : 0] notFull;

  // signals for module outputs
  wire [71 : 0] deq;
  wire [3 : 0] notEmpty, notFull;

  // inlined wires
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_new_head$wget,
	       inputVCQueues_ifc_mf_ifc_new_tail$wget,
	       inputVCQueues_ifc_mf_ifc_rdFIFO$wget,
	       inputVCQueues_ifc_mf_ifc_wrFIFO$wget;

  // register inputVCQueues_ifc_mf_ifc_heads
  reg [2 : 0] inputVCQueues_ifc_mf_ifc_heads;
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_heads$D_IN;
  wire inputVCQueues_ifc_mf_ifc_heads$EN;

  // register inputVCQueues_ifc_mf_ifc_heads_1
  reg [2 : 0] inputVCQueues_ifc_mf_ifc_heads_1;
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_heads_1$D_IN;
  wire inputVCQueues_ifc_mf_ifc_heads_1$EN;

  // register inputVCQueues_ifc_mf_ifc_heads_2
  reg [2 : 0] inputVCQueues_ifc_mf_ifc_heads_2;
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_heads_2$D_IN;
  wire inputVCQueues_ifc_mf_ifc_heads_2$EN;

  // register inputVCQueues_ifc_mf_ifc_heads_3
  reg [2 : 0] inputVCQueues_ifc_mf_ifc_heads_3;
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_heads_3$D_IN;
  wire inputVCQueues_ifc_mf_ifc_heads_3$EN;

  // register inputVCQueues_ifc_mf_ifc_not_empty
  reg inputVCQueues_ifc_mf_ifc_not_empty;
  wire inputVCQueues_ifc_mf_ifc_not_empty$D_IN,
       inputVCQueues_ifc_mf_ifc_not_empty$EN;

  // register inputVCQueues_ifc_mf_ifc_not_empty_1
  reg inputVCQueues_ifc_mf_ifc_not_empty_1;
  wire inputVCQueues_ifc_mf_ifc_not_empty_1$D_IN,
       inputVCQueues_ifc_mf_ifc_not_empty_1$EN;

  // register inputVCQueues_ifc_mf_ifc_not_empty_2
  reg inputVCQueues_ifc_mf_ifc_not_empty_2;
  wire inputVCQueues_ifc_mf_ifc_not_empty_2$D_IN,
       inputVCQueues_ifc_mf_ifc_not_empty_2$EN;

  // register inputVCQueues_ifc_mf_ifc_not_empty_3
  reg inputVCQueues_ifc_mf_ifc_not_empty_3;
  wire inputVCQueues_ifc_mf_ifc_not_empty_3$D_IN,
       inputVCQueues_ifc_mf_ifc_not_empty_3$EN;

  // register inputVCQueues_ifc_mf_ifc_not_full
  reg inputVCQueues_ifc_mf_ifc_not_full;
  wire inputVCQueues_ifc_mf_ifc_not_full$D_IN,
       inputVCQueues_ifc_mf_ifc_not_full$EN;

  // register inputVCQueues_ifc_mf_ifc_not_full_1
  reg inputVCQueues_ifc_mf_ifc_not_full_1;
  wire inputVCQueues_ifc_mf_ifc_not_full_1$D_IN,
       inputVCQueues_ifc_mf_ifc_not_full_1$EN;

  // register inputVCQueues_ifc_mf_ifc_not_full_2
  reg inputVCQueues_ifc_mf_ifc_not_full_2;
  wire inputVCQueues_ifc_mf_ifc_not_full_2$D_IN,
       inputVCQueues_ifc_mf_ifc_not_full_2$EN;

  // register inputVCQueues_ifc_mf_ifc_not_full_3
  reg inputVCQueues_ifc_mf_ifc_not_full_3;
  wire inputVCQueues_ifc_mf_ifc_not_full_3$D_IN,
       inputVCQueues_ifc_mf_ifc_not_full_3$EN;

  // register inputVCQueues_ifc_mf_ifc_tails
  reg [2 : 0] inputVCQueues_ifc_mf_ifc_tails;
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_tails$D_IN;
  wire inputVCQueues_ifc_mf_ifc_tails$EN;

  // register inputVCQueues_ifc_mf_ifc_tails_1
  reg [2 : 0] inputVCQueues_ifc_mf_ifc_tails_1;
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_tails_1$D_IN;
  wire inputVCQueues_ifc_mf_ifc_tails_1$EN;

  // register inputVCQueues_ifc_mf_ifc_tails_2
  reg [2 : 0] inputVCQueues_ifc_mf_ifc_tails_2;
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_tails_2$D_IN;
  wire inputVCQueues_ifc_mf_ifc_tails_2$EN;

  // register inputVCQueues_ifc_mf_ifc_tails_3
  reg [2 : 0] inputVCQueues_ifc_mf_ifc_tails_3;
  wire [2 : 0] inputVCQueues_ifc_mf_ifc_tails_3$D_IN;
  wire inputVCQueues_ifc_mf_ifc_tails_3$EN;

  // ports of submodule inputVCQueues_ifc_mf_ifc_fifoMem
  wire [71 : 0] inputVCQueues_ifc_mf_ifc_fifoMem$D_IN,
		inputVCQueues_ifc_mf_ifc_fifoMem$D_OUT;
  wire [4 : 0] inputVCQueues_ifc_mf_ifc_fifoMem$ADDR_IN,
	       inputVCQueues_ifc_mf_ifc_fifoMem$ADDR_OUT;
  wire inputVCQueues_ifc_mf_ifc_fifoMem$WE;

  // remaining internal signals
  reg [2 : 0] fifoRdPtr__h5213, fifoWrPtr__h4675, y__h3244, y__h4017;
  reg IF_deq_fifo_out_EQ_0_34_THEN_NOT_inputVCQueues_ETC___d161,
      IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160;
  wire [2 : 0] x__h3243, x__h4016;
  wire IF_inputVCQueues_ifc_mf_ifc_new_head_whas__4_T_ETC___d92,
       IF_inputVCQueues_ifc_mf_ifc_new_tail_whas_THEN_ETC___d55,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d39,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d41,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d43,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d45,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d57,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d60,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d63,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d66,
       NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d68,
       NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d100,
       NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d103,
       NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d105,
       NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d94,
       NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d97,
       _dfoo1,
       _dfoo11,
       _dfoo13,
       _dfoo15,
       _dfoo3,
       _dfoo5,
       _dfoo7,
       _dfoo9;

  // actionvalue method deq
  assign deq = inputVCQueues_ifc_mf_ifc_fifoMem$D_OUT ;

  // value method notEmpty
  assign notEmpty =
	     { inputVCQueues_ifc_mf_ifc_not_empty_3,
	       inputVCQueues_ifc_mf_ifc_not_empty_2,
	       inputVCQueues_ifc_mf_ifc_not_empty_1,
	       inputVCQueues_ifc_mf_ifc_not_empty } ;

  // value method notFull
  assign notFull =
	     { inputVCQueues_ifc_mf_ifc_not_full_3,
	       inputVCQueues_ifc_mf_ifc_not_full_2,
	       inputVCQueues_ifc_mf_ifc_not_full_1,
	       inputVCQueues_ifc_mf_ifc_not_full } ;

  // submodule inputVCQueues_ifc_mf_ifc_fifoMem
  RegFile_1port #( /*data_width*/ 32'd72,
		   /*addr_width*/ 32'd5) inputVCQueues_ifc_mf_ifc_fifoMem(.CLK(CLK),
									  .rst_n(RST_N),
									  .ADDR_IN(inputVCQueues_ifc_mf_ifc_fifoMem$ADDR_IN),
									  .ADDR_OUT(inputVCQueues_ifc_mf_ifc_fifoMem$ADDR_OUT),
									  .D_IN(inputVCQueues_ifc_mf_ifc_fifoMem$D_IN),
									  .WE(inputVCQueues_ifc_mf_ifc_fifoMem$WE),
									  .D_OUT(inputVCQueues_ifc_mf_ifc_fifoMem$D_OUT));

  // inlined wires
  assign inputVCQueues_ifc_mf_ifc_wrFIFO$wget = { 1'd1, enq_fifo_in } ;
  assign inputVCQueues_ifc_mf_ifc_rdFIFO$wget = { 1'd1, deq_fifo_out } ;
  assign inputVCQueues_ifc_mf_ifc_new_tail$wget = fifoWrPtr__h4675 + 3'd1 ;
  assign inputVCQueues_ifc_mf_ifc_new_head$wget = fifoRdPtr__h5213 + 3'd1 ;

  // register inputVCQueues_ifc_mf_ifc_heads
  assign inputVCQueues_ifc_mf_ifc_heads$D_IN = x__h4016 ;
  assign inputVCQueues_ifc_mf_ifc_heads$EN =
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd0 ;

  // register inputVCQueues_ifc_mf_ifc_heads_1
  assign inputVCQueues_ifc_mf_ifc_heads_1$D_IN = x__h4016 ;
  assign inputVCQueues_ifc_mf_ifc_heads_1$EN =
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd1 ;

  // register inputVCQueues_ifc_mf_ifc_heads_2
  assign inputVCQueues_ifc_mf_ifc_heads_2$D_IN = x__h4016 ;
  assign inputVCQueues_ifc_mf_ifc_heads_2$EN =
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd2 ;

  // register inputVCQueues_ifc_mf_ifc_heads_3
  assign inputVCQueues_ifc_mf_ifc_heads_3$D_IN = x__h4016 ;
  assign inputVCQueues_ifc_mf_ifc_heads_3$EN =
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd3 ;

  // register inputVCQueues_ifc_mf_ifc_not_empty
  assign inputVCQueues_ifc_mf_ifc_not_empty$D_IN =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d39 ;
  assign inputVCQueues_ifc_mf_ifc_not_empty$EN = _dfoo15 ;

  // register inputVCQueues_ifc_mf_ifc_not_empty_1
  assign inputVCQueues_ifc_mf_ifc_not_empty_1$D_IN =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d41 ;
  assign inputVCQueues_ifc_mf_ifc_not_empty_1$EN = _dfoo13 ;

  // register inputVCQueues_ifc_mf_ifc_not_empty_2
  assign inputVCQueues_ifc_mf_ifc_not_empty_2$D_IN =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d43 ;
  assign inputVCQueues_ifc_mf_ifc_not_empty_2$EN = _dfoo11 ;

  // register inputVCQueues_ifc_mf_ifc_not_empty_3
  assign inputVCQueues_ifc_mf_ifc_not_empty_3$D_IN =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d45 ;
  assign inputVCQueues_ifc_mf_ifc_not_empty_3$EN = _dfoo9 ;

  // register inputVCQueues_ifc_mf_ifc_not_full
  assign inputVCQueues_ifc_mf_ifc_not_full$D_IN =
	     !EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	     !NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d57 ;
  assign inputVCQueues_ifc_mf_ifc_not_full$EN = _dfoo7 ;

  // register inputVCQueues_ifc_mf_ifc_not_full_1
  assign inputVCQueues_ifc_mf_ifc_not_full_1$D_IN =
	     !EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	     !NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d60 ;
  assign inputVCQueues_ifc_mf_ifc_not_full_1$EN = _dfoo5 ;

  // register inputVCQueues_ifc_mf_ifc_not_full_2
  assign inputVCQueues_ifc_mf_ifc_not_full_2$D_IN =
	     !EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	     !NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d63 ;
  assign inputVCQueues_ifc_mf_ifc_not_full_2$EN = _dfoo3 ;

  // register inputVCQueues_ifc_mf_ifc_not_full_3
  assign inputVCQueues_ifc_mf_ifc_not_full_3$D_IN =
	     !EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	     !NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d66 ;
  assign inputVCQueues_ifc_mf_ifc_not_full_3$EN = _dfoo1 ;

  // register inputVCQueues_ifc_mf_ifc_tails
  assign inputVCQueues_ifc_mf_ifc_tails$D_IN = x__h3243 ;
  assign inputVCQueues_ifc_mf_ifc_tails$EN =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd0 ;

  // register inputVCQueues_ifc_mf_ifc_tails_1
  assign inputVCQueues_ifc_mf_ifc_tails_1$D_IN = x__h3243 ;
  assign inputVCQueues_ifc_mf_ifc_tails_1$EN =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd1 ;

  // register inputVCQueues_ifc_mf_ifc_tails_2
  assign inputVCQueues_ifc_mf_ifc_tails_2$D_IN = x__h3243 ;
  assign inputVCQueues_ifc_mf_ifc_tails_2$EN =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd2 ;

  // register inputVCQueues_ifc_mf_ifc_tails_3
  assign inputVCQueues_ifc_mf_ifc_tails_3$D_IN = x__h3243 ;
  assign inputVCQueues_ifc_mf_ifc_tails_3$EN =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd3 ;

  // submodule inputVCQueues_ifc_mf_ifc_fifoMem
  assign inputVCQueues_ifc_mf_ifc_fifoMem$ADDR_IN =
	     { enq_fifo_in, fifoWrPtr__h4675 } ;
  assign inputVCQueues_ifc_mf_ifc_fifoMem$ADDR_OUT =
	     { deq_fifo_out, fifoRdPtr__h5213 } ;
  assign inputVCQueues_ifc_mf_ifc_fifoMem$D_IN = enq_data_in ;
  assign inputVCQueues_ifc_mf_ifc_fifoMem$WE = EN_enq ;

  // remaining internal signals
  assign IF_inputVCQueues_ifc_mf_ifc_new_head_whas__4_T_ETC___d92 =
	     x__h4016 == y__h4017 ;
  assign IF_inputVCQueues_ifc_mf_ifc_new_tail_whas_THEN_ETC___d55 =
	     x__h3243 == y__h3244 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d39 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd0 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d41 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd1 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d43 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd2 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d45 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd3 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d57 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_tail_whas_THEN_ETC___d55 &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd0 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d60 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_tail_whas_THEN_ETC___d55 &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd1 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d63 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_tail_whas_THEN_ETC___d55 &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd2 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d66 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_tail_whas_THEN_ETC___d55 &&
	     inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] == 2'd3 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d68 =
	     (!EN_deq || !inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_tail_whas_THEN_ETC___d55 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d100 =
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_head_whas__4_T_ETC___d92 &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd2 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d103 =
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_head_whas__4_T_ETC___d92 &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd3 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d105 =
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_head_whas__4_T_ETC___d92 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d94 =
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_head_whas__4_T_ETC___d92 &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd0 ;
  assign NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d97 =
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     IF_inputVCQueues_ifc_mf_ifc_new_head_whas__4_T_ETC___d92 &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd1 ;
  assign _dfoo1 =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d66 ||
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd3 ;
  assign _dfoo11 =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d43 ||
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d100 ;
  assign _dfoo13 =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d41 ||
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d97 ;
  assign _dfoo15 =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d39 ||
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d94 ;
  assign _dfoo3 =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d63 ||
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd2 ;
  assign _dfoo5 =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d60 ||
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd1 ;
  assign _dfoo7 =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d57 ||
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     (!EN_enq || !inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] ||
	      inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] !=
	      inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0]) &&
	     inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0] == 2'd0 ;
  assign _dfoo9 =
	     EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d45 ||
	     EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	     NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d103 ;
  assign x__h3243 = EN_enq ? inputVCQueues_ifc_mf_ifc_new_tail$wget : 3'd0 ;
  assign x__h4016 = EN_deq ? inputVCQueues_ifc_mf_ifc_new_head$wget : 3'd0 ;
  always@(enq_fifo_in or
	  inputVCQueues_ifc_mf_ifc_tails_3 or
	  inputVCQueues_ifc_mf_ifc_tails or
	  inputVCQueues_ifc_mf_ifc_tails_1 or
	  inputVCQueues_ifc_mf_ifc_tails_2)
  begin
    case (enq_fifo_in)
      2'd0: fifoWrPtr__h4675 = inputVCQueues_ifc_mf_ifc_tails;
      2'd1: fifoWrPtr__h4675 = inputVCQueues_ifc_mf_ifc_tails_1;
      2'd2: fifoWrPtr__h4675 = inputVCQueues_ifc_mf_ifc_tails_2;
      2'd3: fifoWrPtr__h4675 = inputVCQueues_ifc_mf_ifc_tails_3;
    endcase
  end
  always@(deq_fifo_out or
	  inputVCQueues_ifc_mf_ifc_heads_3 or
	  inputVCQueues_ifc_mf_ifc_heads or
	  inputVCQueues_ifc_mf_ifc_heads_1 or
	  inputVCQueues_ifc_mf_ifc_heads_2)
  begin
    case (deq_fifo_out)
      2'd0: fifoRdPtr__h5213 = inputVCQueues_ifc_mf_ifc_heads;
      2'd1: fifoRdPtr__h5213 = inputVCQueues_ifc_mf_ifc_heads_1;
      2'd2: fifoRdPtr__h5213 = inputVCQueues_ifc_mf_ifc_heads_2;
      2'd3: fifoRdPtr__h5213 = inputVCQueues_ifc_mf_ifc_heads_3;
    endcase
  end
  always@(enq_fifo_in or
	  inputVCQueues_ifc_mf_ifc_not_full_3 or
	  inputVCQueues_ifc_mf_ifc_not_full or
	  inputVCQueues_ifc_mf_ifc_not_full_1 or
	  inputVCQueues_ifc_mf_ifc_not_full_2)
  begin
    case (enq_fifo_in)
      2'd0:
	  IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160 =
	      !inputVCQueues_ifc_mf_ifc_not_full;
      2'd1:
	  IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160 =
	      !inputVCQueues_ifc_mf_ifc_not_full_1;
      2'd2:
	  IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160 =
	      !inputVCQueues_ifc_mf_ifc_not_full_2;
      2'd3:
	  IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160 =
	      !inputVCQueues_ifc_mf_ifc_not_full_3;
    endcase
  end
  always@(deq_fifo_out or
	  inputVCQueues_ifc_mf_ifc_not_empty_3 or
	  inputVCQueues_ifc_mf_ifc_not_empty or
	  inputVCQueues_ifc_mf_ifc_not_empty_1 or
	  inputVCQueues_ifc_mf_ifc_not_empty_2)
  begin
    case (deq_fifo_out)
      2'd0:
	  IF_deq_fifo_out_EQ_0_34_THEN_NOT_inputVCQueues_ETC___d161 =
	      !inputVCQueues_ifc_mf_ifc_not_empty;
      2'd1:
	  IF_deq_fifo_out_EQ_0_34_THEN_NOT_inputVCQueues_ETC___d161 =
	      !inputVCQueues_ifc_mf_ifc_not_empty_1;
      2'd2:
	  IF_deq_fifo_out_EQ_0_34_THEN_NOT_inputVCQueues_ETC___d161 =
	      !inputVCQueues_ifc_mf_ifc_not_empty_2;
      2'd3:
	  IF_deq_fifo_out_EQ_0_34_THEN_NOT_inputVCQueues_ETC___d161 =
	      !inputVCQueues_ifc_mf_ifc_not_empty_3;
    endcase
  end
  always@(inputVCQueues_ifc_mf_ifc_wrFIFO$wget or
	  inputVCQueues_ifc_mf_ifc_heads_3 or
	  inputVCQueues_ifc_mf_ifc_heads or
	  inputVCQueues_ifc_mf_ifc_heads_1 or
	  inputVCQueues_ifc_mf_ifc_heads_2)
  begin
    case (inputVCQueues_ifc_mf_ifc_wrFIFO$wget[1:0])
      2'd0: y__h3244 = inputVCQueues_ifc_mf_ifc_heads;
      2'd1: y__h3244 = inputVCQueues_ifc_mf_ifc_heads_1;
      2'd2: y__h3244 = inputVCQueues_ifc_mf_ifc_heads_2;
      2'd3: y__h3244 = inputVCQueues_ifc_mf_ifc_heads_3;
    endcase
  end
  always@(inputVCQueues_ifc_mf_ifc_rdFIFO$wget or
	  inputVCQueues_ifc_mf_ifc_tails_3 or
	  inputVCQueues_ifc_mf_ifc_tails or
	  inputVCQueues_ifc_mf_ifc_tails_1 or
	  inputVCQueues_ifc_mf_ifc_tails_2)
  begin
    case (inputVCQueues_ifc_mf_ifc_rdFIFO$wget[1:0])
      2'd0: y__h4017 = inputVCQueues_ifc_mf_ifc_tails;
      2'd1: y__h4017 = inputVCQueues_ifc_mf_ifc_tails_1;
      2'd2: y__h4017 = inputVCQueues_ifc_mf_ifc_tails_2;
      2'd3: y__h4017 = inputVCQueues_ifc_mf_ifc_tails_3;
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (!RST_N)
      begin
        inputVCQueues_ifc_mf_ifc_heads <= `BSV_ASSIGNMENT_DELAY 3'd0;
	inputVCQueues_ifc_mf_ifc_heads_1 <= `BSV_ASSIGNMENT_DELAY 3'd0;
	inputVCQueues_ifc_mf_ifc_heads_2 <= `BSV_ASSIGNMENT_DELAY 3'd0;
	inputVCQueues_ifc_mf_ifc_heads_3 <= `BSV_ASSIGNMENT_DELAY 3'd0;
	inputVCQueues_ifc_mf_ifc_not_empty <= `BSV_ASSIGNMENT_DELAY 1'd0;
	inputVCQueues_ifc_mf_ifc_not_empty_1 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	inputVCQueues_ifc_mf_ifc_not_empty_2 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	inputVCQueues_ifc_mf_ifc_not_empty_3 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	inputVCQueues_ifc_mf_ifc_not_full <= `BSV_ASSIGNMENT_DELAY 1'd1;
	inputVCQueues_ifc_mf_ifc_not_full_1 <= `BSV_ASSIGNMENT_DELAY 1'd1;
	inputVCQueues_ifc_mf_ifc_not_full_2 <= `BSV_ASSIGNMENT_DELAY 1'd1;
	inputVCQueues_ifc_mf_ifc_not_full_3 <= `BSV_ASSIGNMENT_DELAY 1'd1;
	inputVCQueues_ifc_mf_ifc_tails <= `BSV_ASSIGNMENT_DELAY 3'd0;
	inputVCQueues_ifc_mf_ifc_tails_1 <= `BSV_ASSIGNMENT_DELAY 3'd0;
	inputVCQueues_ifc_mf_ifc_tails_2 <= `BSV_ASSIGNMENT_DELAY 3'd0;
	inputVCQueues_ifc_mf_ifc_tails_3 <= `BSV_ASSIGNMENT_DELAY 3'd0;
      end
    else
      begin
        if (inputVCQueues_ifc_mf_ifc_heads$EN)
	  inputVCQueues_ifc_mf_ifc_heads <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_heads$D_IN;
	if (inputVCQueues_ifc_mf_ifc_heads_1$EN)
	  inputVCQueues_ifc_mf_ifc_heads_1 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_heads_1$D_IN;
	if (inputVCQueues_ifc_mf_ifc_heads_2$EN)
	  inputVCQueues_ifc_mf_ifc_heads_2 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_heads_2$D_IN;
	if (inputVCQueues_ifc_mf_ifc_heads_3$EN)
	  inputVCQueues_ifc_mf_ifc_heads_3 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_heads_3$D_IN;
	if (inputVCQueues_ifc_mf_ifc_not_empty$EN)
	  inputVCQueues_ifc_mf_ifc_not_empty <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_not_empty$D_IN;
	if (inputVCQueues_ifc_mf_ifc_not_empty_1$EN)
	  inputVCQueues_ifc_mf_ifc_not_empty_1 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_not_empty_1$D_IN;
	if (inputVCQueues_ifc_mf_ifc_not_empty_2$EN)
	  inputVCQueues_ifc_mf_ifc_not_empty_2 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_not_empty_2$D_IN;
	if (inputVCQueues_ifc_mf_ifc_not_empty_3$EN)
	  inputVCQueues_ifc_mf_ifc_not_empty_3 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_not_empty_3$D_IN;
	if (inputVCQueues_ifc_mf_ifc_not_full$EN)
	  inputVCQueues_ifc_mf_ifc_not_full <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_not_full$D_IN;
	if (inputVCQueues_ifc_mf_ifc_not_full_1$EN)
	  inputVCQueues_ifc_mf_ifc_not_full_1 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_not_full_1$D_IN;
	if (inputVCQueues_ifc_mf_ifc_not_full_2$EN)
	  inputVCQueues_ifc_mf_ifc_not_full_2 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_not_full_2$D_IN;
	if (inputVCQueues_ifc_mf_ifc_not_full_3$EN)
	  inputVCQueues_ifc_mf_ifc_not_full_3 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_not_full_3$D_IN;
	if (inputVCQueues_ifc_mf_ifc_tails$EN)
	  inputVCQueues_ifc_mf_ifc_tails <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_tails$D_IN;
	if (inputVCQueues_ifc_mf_ifc_tails_1$EN)
	  inputVCQueues_ifc_mf_ifc_tails_1 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_tails_1$D_IN;
	if (inputVCQueues_ifc_mf_ifc_tails_2$EN)
	  inputVCQueues_ifc_mf_ifc_tails_2 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_tails_2$D_IN;
	if (inputVCQueues_ifc_mf_ifc_tails_3$EN)
	  inputVCQueues_ifc_mf_ifc_tails_3 <= `BSV_ASSIGNMENT_DELAY
	      inputVCQueues_ifc_mf_ifc_tails_3$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    inputVCQueues_ifc_mf_ifc_heads = 3'h2;
    inputVCQueues_ifc_mf_ifc_heads_1 = 3'h2;
    inputVCQueues_ifc_mf_ifc_heads_2 = 3'h2;
    inputVCQueues_ifc_mf_ifc_heads_3 = 3'h2;
    inputVCQueues_ifc_mf_ifc_not_empty = 1'h0;
    inputVCQueues_ifc_mf_ifc_not_empty_1 = 1'h0;
    inputVCQueues_ifc_mf_ifc_not_empty_2 = 1'h0;
    inputVCQueues_ifc_mf_ifc_not_empty_3 = 1'h0;
    inputVCQueues_ifc_mf_ifc_not_full = 1'h0;
    inputVCQueues_ifc_mf_ifc_not_full_1 = 1'h0;
    inputVCQueues_ifc_mf_ifc_not_full_2 = 1'h0;
    inputVCQueues_ifc_mf_ifc_not_full_3 = 1'h0;
    inputVCQueues_ifc_mf_ifc_tails = 3'h2;
    inputVCQueues_ifc_mf_ifc_tails_1 = 3'h2;
    inputVCQueues_ifc_mf_ifc_tails_2 = 3'h2;
    inputVCQueues_ifc_mf_ifc_tails_3 = 3'h2;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N)
      if (EN_enq && IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160)
	$write("");
    if (RST_N)
      if (EN_enq && IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160)
	$write("");
    if (RST_N)
      if (EN_enq && IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160)
	$display("Dynamic assertion failed: \"MultiFIFOMem.bsv\", line 156, column 38\nEnqueing to full FIFO in MultiFIFOMem!");
    if (RST_N)
      if (EN_enq && IF_enq_fifo_in_EQ_0_07_THEN_NOT_inputVCQueues__ETC___d160)
	$finish(32'd0);
    if (RST_N) if (EN_enq) $write("");
    if (RST_N)
      if (EN_deq && IF_deq_fifo_out_EQ_0_34_THEN_NOT_inputVCQueues_ETC___d161)
	$display("Dynamic assertion failed: \"MultiFIFOMem.bsv\", line 190, column 40\nDequeing from empty FIFO in MultiFIFOMem!");
    if (RST_N)
      if (EN_deq && IF_deq_fifo_out_EQ_0_34_THEN_NOT_inputVCQueues_ETC___d161)
	$finish(32'd0);
    if (RST_N) if (EN_deq) $write("");
    if (RST_N)
      if (EN_enq && inputVCQueues_ifc_mf_ifc_wrFIFO$wget[2] &&
	  NOT_inputVCQueues_ifc_mf_ifc_rdFIFO_whas__7_3__ETC___d68)
	$write("");
    if (RST_N)
      if (EN_deq && inputVCQueues_ifc_mf_ifc_rdFIFO$wget[2] &&
	  NOT_inputVCQueues_ifc_mf_ifc_wrFIFO_whas_0_OR__ETC___d105)
	$write("");
  end
  // synopsys translate_on
endmodule  // mkInputVCQueues

