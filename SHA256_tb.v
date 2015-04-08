`timescale 1 ns / 100 ps

module SHA256_tb;

	reg Clk_tb, Rstb_tb;
	integer  Clk_cnt;
  
	localparam CLK_PERIOD = 20;

	reg [511:0] msg_tb_512;
	reg [1023:0] msg_tb_1024;
	wire [255:0] hash_tb;
	wire blk_done_tb;
	reg [1:0] blk_type_tb;

	localparam
		HASH  		= 	7'd0,
		MERKLE_LEAF  = 	7'd1,
		HEADER 	= 	7'd2;

	SHA256 UUT(.CLK(Clk_tb), .nreset(Rstb_tb), .msg(msg_tb_512), .hash(hash_tb), .blk_done(blk_done_tb), .blk_type(blk_type_tb));
		 
	initial
	begin  : CLK_GENERATOR
		Clk_tb = 0;
		forever
		begin
			#(CLK_PERIOD/2) Clk_tb = ~Clk_tb;
		end 
	end

	initial
	begin  : RESET_GENERATOR
		Rstb_tb = 0;
		#(2 * CLK_PERIOD) Rstb_tb = 1;
	end

	initial Clk_cnt = 0;
	always @ (posedge Clk_tb)  
	begin
		# (0.1 * CLK_PERIOD);
		Clk_cnt <= Clk_cnt + 1;
	end

	initial
	begin  : Init_Msg
		//input hash
		//msg_tb_512 <= {256'hcdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361,1'b1,{191{1'b0}},64'h100};
		//msg_tb_512 <= {256'hcdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361,1'b1,{191{1'b0}},64'h100};
	
		//input merkle leaf
		blk_type_tb <= MERKLE_LEAF;
		msg_tb_1024 <= {512'hcdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361cdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361,1'b1,{447{1'b0}},64'h200};
		@(posedge Clk_tb);
		msg_tb_512 <= msg_tb_1024[1023:512];
		@(posedge blk_done_tb);
		msg_tb_512 <= msg_tb_1024[511:0];
		@(posedge blk_done_tb);
		$stop;
	
		//input header
		//msg_tb_1024 <= {512'hcdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361cdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361,1'b1,{319{1'b0}},64'h280};
	end

endmodule  
