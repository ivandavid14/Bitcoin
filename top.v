`timescale 1ns / 1ps

`include "noc/connect_parameters.v"

//`define SIM 1

`ifndef SIM
module top(sys_clk, BTNC, LED, CATHODE, AN, SW);
`else
module top(BTNC, LED, CATHODE, AN, SW);
`endif
	// Display variables
	input [15:0] SW;
	input BTNC;  
	output [15:0] LED;
	output [7:0] CATHODE;
	output [7:0] AN;
	reg [31:0] word_out;
	wire [7:0] LED_walk;
	
	// NOC variables
	localparam flit_port_width = 73;
	localparam credit_port_width = 3;

	// input regs
	wire send_flit [0:`NUM_USER_SEND_PORTS-1]; // enable sending flits
	wire [73-1:0] flit_in [0:`NUM_USER_SEND_PORTS-1]; // send port inputs

	wire send_credit [0:`NUM_USER_RECV_PORTS-1]; // enable sending credits
	wire [credit_port_width-1:0] credit_in [0:`NUM_USER_RECV_PORTS-1]; //recv port credits

	// output wires
	wire [credit_port_width-1:0] credit_out [0:`NUM_USER_SEND_PORTS-1];
	wire [73-1:0] flit_out [0:`NUM_USER_RECV_PORTS-1];

	wire ctrl_EN_getFlit;
	wire [63:0] ctrl_Clk_cnt;
	wire [31:0] ctrl_nonce;
	wire ctrl_done;
	
	wire [`NUM_PE:1] PE_done;
	wire one_pe_done;
	
	`ifndef SIM
		input sys_clk;
		clk_wiz_0 cw(sys_clk, hash_clk);

		wire Rst_n;
		assign Rst_n = ~BTNC;
	`else
		parameter HalfClkPeriod = 2.5;
		localparam ClkPeriod = 2*HalfClkPeriod;
		reg sys_clk;
		wire hash_clk;
		assign hash_clk = sys_clk;
		initial sys_clk = 0;
		always #(HalfClkPeriod) sys_clk = ~sys_clk;

		reg Rst_n;
		initial begin
			Rst_n = 0;
			#(5*ClkPeriod+HalfClkPeriod);
			Rst_n = 1;
		end
	`endif

	controller c0(.sys_clk(hash_clk), .nreset(Rst_n)
		, .putFlit(flit_in[0]), .EN_putFlit(send_flit[0])
		, .getCredits(credit_out[0])
		, .EN_getFlit(ctrl_EN_getFlit), .getFlit(flit_out[0])
		, .EN_putCredits(send_credit[0]), .putCredits(credit_in[0])
		, .done(ctrl_done), .nonce(ctrl_nonce), .Clk_cnt(ctrl_Clk_cnt) );
	
	assign one_pe_done = | PE_done[`NUM_PE:1];
	
	generate
		genvar j;
		for(j=1; j <= `NUM_PE ; j=j+1) begin
		processing_element pe(.sys_clk(hash_clk), .reset(Rst_n), .flit(flit_out[j])
			, .send_credit(send_credit[j]), .credit_in(credit_in[j])
			, .processor_id(j[4:0])
			, .putFlit(flit_in[j]), .EN_putFlit(send_flit[j])
			, .done_out(PE_done[j]), .done_in(one_pe_done)
			);
		end
	endgenerate

	// Display code
	assign LED[15] = ctrl_done;
	assign LED[14:8] = {7{~Rst_n}};
	assign LED[7:0] = LED_walk;

	always @(*)
	begin
		if(SW[0])
			word_out = ctrl_Clk_cnt[31:0];
		else if(SW[1])
			word_out = ctrl_Clk_cnt[63:32];
		else
			word_out = ctrl_nonce;
	end

	nexys4_display d1(.clk_in(hash_clk), .LED_proc(LED_walk), .CATHODE_proc(CATHODE), .AN_proc(AN), .Word(word_out),
	.BTNC_in(BTNC));

	// Instantiate CONNECT network
	mkNetwork noc
	(.CLK(hash_clk)
	,.RST_N(Rst_n)

	// send ports 0-4
	,.send_ports_0_putFlit_flit_in(flit_in[0])
	,.EN_send_ports_0_putFlit(send_flit[0])
	,.EN_send_ports_0_getCredits(1'b1) // drain credits
	,.send_ports_0_getCredits(credit_out[0])

	,.send_ports_1_putFlit_flit_in(flit_in[1])
	,.EN_send_ports_1_putFlit(send_flit[1])
	,.EN_send_ports_1_getCredits(1'b1)
	,.send_ports_1_getCredits(credit_out[1])

	,.send_ports_2_putFlit_flit_in(flit_in[2])
	,.EN_send_ports_2_putFlit(send_flit[2])
	,.EN_send_ports_2_getCredits(1'b1)
	,.send_ports_2_getCredits(credit_out[2])

	,.send_ports_3_putFlit_flit_in(flit_in[3])
	,.EN_send_ports_3_putFlit(send_flit[3])
	,.EN_send_ports_3_getCredits(1'b1)
	,.send_ports_3_getCredits(credit_out[3])

	,.send_ports_4_putFlit_flit_in(flit_in[4])
	,.EN_send_ports_4_putFlit(send_flit[4])
	,.EN_send_ports_4_getCredits(1'b1)
	,.send_ports_4_getCredits(credit_out[4])

	// send ports 5-9
	,.send_ports_5_putFlit_flit_in(flit_in[5])
	,.EN_send_ports_5_putFlit(send_flit[5])
	,.EN_send_ports_5_getCredits(1'b1)
	,.send_ports_5_getCredits(credit_out[5])

	,.send_ports_6_putFlit_flit_in(flit_in[6])
	,.EN_send_ports_6_putFlit(send_flit[6])
	,.EN_send_ports_6_getCredits(1'b1)
	,.send_ports_6_getCredits(credit_out[6])


	,.send_ports_7_putFlit_flit_in(flit_in[7])
	,.EN_send_ports_7_putFlit(send_flit[7])
	,.EN_send_ports_7_getCredits(1'b1)
	,.send_ports_7_getCredits(credit_out[7])

	,.send_ports_8_putFlit_flit_in(flit_in[8])
	,.EN_send_ports_8_putFlit(send_flit[8])
	,.EN_send_ports_8_getCredits(1'b1)
	,.send_ports_8_getCredits(credit_out[8])
	/*

	,.send_ports_9_putFlit_flit_in(flit_in[9])
	,.EN_send_ports_9_putFlit(send_flit[9])
	,.EN_send_ports_9_getCredits(1'b1)
	,.send_ports_9_getCredits(credit_out[9])


	// send ports 10-14
	,.send_ports_10_putFlit_flit_in(flit_in[10])
	,.EN_send_ports_10_putFlit(send_flit[10])
	,.EN_send_ports_10_getCredits(1'b1)
	,.send_ports_10_getCredits(credit_out[10])

	,.send_ports_11_putFlit_flit_in(flit_in[11])
	,.EN_send_ports_11_putFlit(send_flit[11])
	,.EN_send_ports_11_getCredits(1'b1)
	,.send_ports_11_getCredits(credit_out[11])

	,.send_ports_12_putFlit_flit_in(flit_in[12])
	,.EN_send_ports_12_putFlit(send_flit[12])
	,.EN_send_ports_12_getCredits(1'b1)
	,.send_ports_12_getCredits(credit_out[12])

	,.send_ports_13_putFlit_flit_in(flit_in[13])
	,.EN_send_ports_13_putFlit(send_flit[13])
	,.EN_send_ports_13_getCredits(1'b1)
	,.send_ports_13_getCredits(credit_out[13])

	,.send_ports_14_putFlit_flit_in(flit_in[14])
	,.EN_send_ports_14_putFlit(send_flit[14])
	,.EN_send_ports_14_getCredits(1'b1)
	,.send_ports_14_getCredits(credit_out[14])

	// send ports 15-19
	,.send_ports_15_putFlit_flit_in(flit_in[15])
	,.EN_send_ports_15_putFlit(send_flit[15])
	,.EN_send_ports_15_getCredits(1'b1)
	,.send_ports_15_getCredits(credit_out[15])

	,.send_ports_16_putFlit_flit_in(flit_in[16])
	,.EN_send_ports_16_putFlit(send_flit[16])
	,.EN_send_ports_16_getCredits(1'b1)
	,.send_ports_16_getCredits(credit_out[16])

	,.send_ports_17_putFlit_flit_in(flit_in[17])
	,.EN_send_ports_17_putFlit(send_flit[17])
	,.EN_send_ports_17_getCredits(1'b1)
	,.send_ports_17_getCredits(credit_out[17])

	,.send_ports_18_putFlit_flit_in(flit_in[18])
	,.EN_send_ports_18_putFlit(send_flit[18])
	,.EN_send_ports_18_getCredits(1'b1)
	,.send_ports_18_getCredits(credit_out[18])

	,.send_ports_19_putFlit_flit_in(flit_in[19])
	,.EN_send_ports_19_putFlit(send_flit[19])
	,.EN_send_ports_19_getCredits(1'b1)
	,.send_ports_19_getCredits(credit_out[19])

	// send ports 20-24
	,.send_ports_20_putFlit_flit_in(flit_in[20])
	,.EN_send_ports_20_putFlit(send_flit[20])
	,.EN_send_ports_20_getCredits(1'b1)
	,.send_ports_20_getCredits(credit_out[20])

	,.send_ports_21_putFlit_flit_in(flit_in[21])
	,.EN_send_ports_21_putFlit(send_flit[21])
	,.EN_send_ports_21_getCredits(1'b1)
	,.send_ports_21_getCredits(credit_out[21])

	,.send_ports_22_putFlit_flit_in(flit_in[22])
	,.EN_send_ports_22_putFlit(send_flit[22])
	,.EN_send_ports_22_getCredits(1'b1)
	,.send_ports_22_getCredits(credit_out[22])

	,.send_ports_23_putFlit_flit_in(flit_in[23])
	,.EN_send_ports_23_putFlit(send_flit[23])
	,.EN_send_ports_23_getCredits(1'b1)
	,.send_ports_23_getCredits(credit_out[23])

	,.send_ports_24_putFlit_flit_in(flit_in[24])
	,.EN_send_ports_24_putFlit(send_flit[24])
	,.EN_send_ports_24_getCredits(1'b1)
	,.send_ports_24_getCredits(credit_out[24])
	 */

	//
	//receive ports 0-4
	,.EN_recv_ports_0_getFlit(ctrl_EN_getFlit) // drain flits
	,.recv_ports_0_getFlit(flit_out[0])
	,.recv_ports_0_putCredits_cr_in(credit_in[0])
	,.EN_recv_ports_0_putCredits(send_credit[0])

	,.EN_recv_ports_1_getFlit(1'b1)
	,.recv_ports_1_getFlit(flit_out[1])
	,.recv_ports_1_putCredits_cr_in(credit_in[1])
	,.EN_recv_ports_1_putCredits(send_credit[1])

	,.EN_recv_ports_2_getFlit(1'b1)
	,.recv_ports_2_getFlit(flit_out[2])
	,.recv_ports_2_putCredits_cr_in(credit_in[2])
	,.EN_recv_ports_2_putCredits(send_credit[2])

	,.EN_recv_ports_3_getFlit(1'b1)
	,.recv_ports_3_getFlit(flit_out[3])
	,.recv_ports_3_putCredits_cr_in(credit_in[3])
	,.EN_recv_ports_3_putCredits(send_credit[3])

	,.EN_recv_ports_4_getFlit(1'b1)
	,.recv_ports_4_getFlit(flit_out[4])
	,.recv_ports_4_putCredits_cr_in(credit_in[4])
	,.EN_recv_ports_4_putCredits(send_credit[4])

	//receive ports 5-9
	,.EN_recv_ports_5_getFlit(1'b1)
	,.recv_ports_5_getFlit(flit_out[5])
	,.recv_ports_5_putCredits_cr_in(credit_in[5])
	,.EN_recv_ports_5_putCredits(send_credit[5])

	,.EN_recv_ports_6_getFlit(1'b1)
	,.recv_ports_6_getFlit(flit_out[6])
	,.recv_ports_6_putCredits_cr_in(credit_in[6])
	,.EN_recv_ports_6_putCredits(send_credit[6])

	,.EN_recv_ports_7_getFlit(1'b1)
	,.recv_ports_7_getFlit(flit_out[7])
	,.recv_ports_7_putCredits_cr_in(credit_in[7])
	,.EN_recv_ports_7_putCredits(send_credit[7])

	,.EN_recv_ports_8_getFlit(1'b1)
	,.recv_ports_8_getFlit(flit_out[8])
	,.recv_ports_8_putCredits_cr_in(credit_in[8])
	,.EN_recv_ports_8_putCredits(send_credit[8])
	/*

	,.EN_recv_ports_9_getFlit(1'b1)
	,.recv_ports_9_getFlit(flit_out[9])
	,.recv_ports_9_putCredits_cr_in(credit_in[9])
	,.EN_recv_ports_9_putCredits(send_credit[9])

	//receive ports 10-14
	,.EN_recv_ports_10_getFlit(1'b1)
	,.recv_ports_10_getFlit(flit_out[10])
	,.recv_ports_10_putCredits_cr_in(credit_in[10])
	,.EN_recv_ports_10_putCredits(send_credit[10])

	,.EN_recv_ports_11_getFlit(1'b1)
	,.recv_ports_11_getFlit(flit_out[11])
	,.recv_ports_11_putCredits_cr_in(credit_in[11])
	,.EN_recv_ports_11_putCredits(send_credit[11])

	,.EN_recv_ports_12_getFlit(1'b1)
	,.recv_ports_12_getFlit(flit_out[12])
	,.recv_ports_12_putCredits_cr_in(credit_in[12])
	,.EN_recv_ports_12_putCredits(send_credit[12])

	,.EN_recv_ports_13_getFlit(1'b1)
	,.recv_ports_13_getFlit(flit_out[13])
	,.recv_ports_13_putCredits_cr_in(credit_in[13])
	,.EN_recv_ports_13_putCredits(send_credit[13])

	,.EN_recv_ports_14_getFlit(1'b1)
	,.recv_ports_14_getFlit(flit_out[14])
	,.recv_ports_14_putCredits_cr_in(credit_in[14])
	,.EN_recv_ports_14_putCredits(send_credit[14])

	//receive ports 15-19
	,.EN_recv_ports_15_getFlit(1'b1)
	,.recv_ports_15_getFlit(flit_out[15])
	,.recv_ports_15_putCredits_cr_in(credit_in[15])
	,.EN_recv_ports_15_putCredits(send_credit[15])

	,.EN_recv_ports_16_getFlit(1'b1)
	,.recv_ports_16_getFlit(flit_out[16])
	,.recv_ports_16_putCredits_cr_in(credit_in[16])
	,.EN_recv_ports_16_putCredits(send_credit[16])

	,.EN_recv_ports_17_getFlit(1'b1)
	,.recv_ports_17_getFlit(flit_out[17])
	,.recv_ports_17_putCredits_cr_in(credit_in[17])
	,.EN_recv_ports_17_putCredits(send_credit[17])

	,.EN_recv_ports_18_getFlit(1'b1)
	,.recv_ports_18_getFlit(flit_out[18])
	,.recv_ports_18_putCredits_cr_in(credit_in[18])
	,.EN_recv_ports_18_putCredits(send_credit[18])

	,.EN_recv_ports_19_getFlit(1'b1)
	,.recv_ports_19_getFlit(flit_out[19])
	,.recv_ports_19_putCredits_cr_in(credit_in[19])
	,.EN_recv_ports_19_putCredits(send_credit[19])

	//receive ports 20-24
	,.EN_recv_ports_20_getFlit(1'b1)
	,.recv_ports_20_getFlit(flit_out[20])
	,.recv_ports_20_putCredits_cr_in(credit_in[20])
	,.EN_recv_ports_20_putCredits(send_credit[20])

	,.EN_recv_ports_21_getFlit(1'b1)
	,.recv_ports_21_getFlit(flit_out[21])
	,.recv_ports_21_putCredits_cr_in(credit_in[21])
	,.EN_recv_ports_21_putCredits(send_credit[21])

	,.EN_recv_ports_22_getFlit(1'b1)
	,.recv_ports_22_getFlit(flit_out[22])
	,.recv_ports_22_putCredits_cr_in(credit_in[22])
	,.EN_recv_ports_22_putCredits(send_credit[22])

	,.EN_recv_ports_23_getFlit(1'b1)
	,.recv_ports_23_getFlit(flit_out[23])
	,.recv_ports_23_putCredits_cr_in(credit_in[23])
	,.EN_recv_ports_23_putCredits(send_credit[23])

	,.EN_recv_ports_24_getFlit(1'b1)
	,.recv_ports_24_getFlit(flit_out[24])
	,.recv_ports_24_putCredits_cr_in(credit_in[24])
	,.EN_recv_ports_24_putCredits(send_credit[24])
	*/
	);
endmodule
