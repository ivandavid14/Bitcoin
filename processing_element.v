module processing_element(sys_clk, BTNC, LED, CATHODE, AN, SW); //, found_nonce);
    input sys_clk,BTNC;
	input [15:0] SW;
	/*input*/ reg [4:0] processor_id;
	//output reg found_nonce;
	output [15:0] LED;
	output [7:0] CATHODE;
	output [7:0] AN;
	reg [31:0] word_out;
	reg [63:0] Clk_cnt;
	
	reg found_nonce;

    reg [1023:0] buffer;
    wire [255:0] hash_out;
    reg [511:0] msg_in;
    reg [1:0] blk_type;
    wire blk_done;
    reg start;
	reg [31:0] nonce;

    reg [2:0] state;
    reg blk_iteration;

	wire reset;
	assign reset = BTNC;
	
	/*reg reset, sim_clk;	
	initial begin
		sim_clk <= 0;
		reset <= 0;
		#10 reset <= 1;
		#10 reset <= 0;
	end
	
	always #5 sim_clk = ~sim_clk;
	*/
	
    localparam
    INIT =                 3'b001,
    PREPROCESS =           3'b011,
    INPUT_FIRST_BLOCK =    3'b010,
    FIRST_BLOCK_WAITING =  3'b110,
    SECOND_BLOCK_WAITING = 3'b111,
    WAIT_HASH =            3'b101,
    DONE =                 3'b100;

    localparam
    HASH =         2'b00,
    MERKLE_LEAF =  2'b01,
    HEADER =       2'b10;

	localparam testheader = 640'h8601a8807d39ef0f73ac5b3aac28c527c89542b8029600809f5fe5ace2ea82b273fcdb297fba14e33f9d2921356b84cf853b629d639e028729d5b40f2b0f6a9649b8965140e8a10adf06070a00000000;
	
	always @(posedge sys_clk)
	begin
		if (reset)
		begin
			blk_type <= 2'b11;
			state <= INIT;
			blk_iteration <= 1'b0;
			start <= 1'b0;
			nonce <= 32'h0000_0000;
			found_nonce <= 1'b0;
			processor_id <= 0;
		end
		else
		begin
			case (state)
				INIT:
				begin
					start <= 1'b0;
					blk_iteration <= 1'b0;
					buffer <= testheader;
					blk_type <= HEADER;
					state <= PREPROCESS;
				end
				
				PREPROCESS:
				begin
					if (blk_type == MERKLE_LEAF)
					begin
						buffer <= {buffer[511:0],1'b1,{447{1'b0}},64'h200};
					end
					else if (blk_type == HEADER)
					begin
						buffer <= {buffer[639:32], nonce, 1'b1, {319{1'b0}}, 64'h280};
					end
					state <= INPUT_FIRST_BLOCK;
				end
				
				INPUT_FIRST_BLOCK:
				begin
					msg_in <= buffer[1023:512];
					state <= FIRST_BLOCK_WAITING;
					start <= 1'b1;
				end
				
				FIRST_BLOCK_WAITING:
				begin
					start <= 1'b0;
					if (blk_done)
					begin
						state <= SECOND_BLOCK_WAITING;
						msg_in <= buffer[511:0];
						start <= 1'b1;
					end
				end
				
				SECOND_BLOCK_WAITING:
				begin
					if (blk_done)
					begin
						start <= 1'b1;
						state <= WAIT_HASH;
						blk_type <= HASH;
						msg_in[511:0] <= {hash_out, 1'b1, {191{1'b0}},64'h100};
					end
				end
				
				WAIT_HASH:
				begin
					start <= 1'b0;
					if (blk_done & (hash_out[255:228] == 28'd0) & (nonce <= 32'hffff_ffff))
					begin
						found_nonce <= 1'b1;
						state <= DONE;
					end
					else if (blk_done & (hash_out[255:228] != 28'd0) & (nonce < 32'hffff_ffff))
					begin
						nonce <= nonce + 1'b1 + processor_id;
						state <= INIT;
					end
					else
						state <= state;
				end
				
				DONE:
				begin
					
				end
				
				default:
					state <= 3'd0;
			endcase
		end
	end
    SHA256 UUT(.CLK(sys_clk), .nreset(~reset), .start(start), .msg(msg_in), .hash(hash_out), .blk_done(blk_done), .blk_type(blk_type));

	assign LED[15] = found_nonce;
	assign LED[14] = state[2];
	assign LED[13] = state[1];
	assign LED[12] = state[0];
	assign LED[11:8] = {reset,reset,reset,reset};
	wire [7:0] LED_walk;
	assign LED[7:0] = LED_walk;
	
	always @(posedge sys_clk)
	begin
		if (reset)
			Clk_cnt <= 0;
		else if( (Clk_cnt < 64'hffff_ffff_ffff_ffff) & (state != DONE) )
			Clk_cnt <= Clk_cnt + 1'b1;
		else
			Clk_cnt <= Clk_cnt;
	end
	
	always @(*)
	begin
		if(SW[0])
			word_out = hash_out[255:224];
		else if(SW[1])
			word_out = Clk_cnt[31:0];
		else if(SW[2])
			word_out = Clk_cnt[63:32];
		else
			word_out = nonce;		
	end
	nexys4_display d1(.clk_in(sys_clk), .LED_proc(LED_walk), .CATHODE_proc(CATHODE), .AN_proc(AN), .Word(word_out),
	.BTNC_in(BTNC));
endmodule