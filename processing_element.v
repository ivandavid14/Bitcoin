module processing_element(sys_clk, BTNC, LED, CATHODE, AN); //, found_nonce);
    input sys_clk, BTNC;
	//output reg found_nonce;
	output [15:0] LED;
	output [7:0] CATHODE;
	output [7:0] AN;
	reg found_nonce;
    
    reg [1023:0] buffer;
    wire [255:0] hash_out;
    reg [511:0] msg_in;
    reg [1:0] blk_type;
    wire blk_done;
    reg start;
	reg [31:0] nonce;
    
    reg [3:0] state;
    reg blk_iteration;
	
	//wire reset;
	//assign reset = BTNC;
    reg reset;
	initial begin
		reset <= 1'b0;
		#10 reset <= 1'b1;
		#10 reset <= 1'b0;
	end
	
	always #5 sys_clk = ~sys_clk;
	
    localparam
    INIT =                 4'b0000,
    PREPROCESS =           4'b0001,
    INPUT_FIRST_BLOCK =    4'b0010,
    FIRST_BLOCK_WAITING =  4'b0011,
    SECOND_BLOCK_WAITING = 4'b0100,
    WAIT_HASH =            4'b0101,
    DONE =                 4'b1111;   
    
    localparam
    HASH =         2'b00,
    MERKLE_LEAF =  2'b01,
    HEADER =       2'b10;
	
	localparam testheader = 640'hcdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361cdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361b4ad1fee05e68c1093ba7b07328e0000;
    
	localparam dononce = 1'b1;
	
    always @(posedge sys_clk or posedge reset)
        begin
            if (reset)
                begin
                    blk_type <= 2'b11;
                    state <= INIT;
                    blk_iteration <= 1'b0;
                    start <= 1'b0;
					nonce <= 32'd0;
					found_nonce <= 1'b0;
                end
            else
                begin
                    if (state == INIT)
                        begin
                            start <= 1'b0;
                            blk_iteration <= 1'b0;
                            buffer <= testheader;
                            blk_type <= HEADER;
                            
                            state <= PREPROCESS;
                        end
                     else if (state == PREPROCESS)
                         begin
                             if (blk_type == MERKLE_LEAF)
                                  begin
                                      buffer <= {buffer[511:0],1'b1,{447{1'b0}},64'h200};
                                  end
                              else if (blk_type == HEADER)
                                  begin
                                      buffer <= {buffer[639:4], nonce, 1'b1, {319{1'b0}}, 64'h280};  
                                  end
                              state <= INPUT_FIRST_BLOCK;                               
                         end
                     else if (state == INPUT_FIRST_BLOCK)
                         begin
                             msg_in <= buffer[1023:512];
                             state <= FIRST_BLOCK_WAITING;
                             start <= 1'b1;
                         end
                     else if (state == FIRST_BLOCK_WAITING)
                         begin
                             start <= 1'b0;
                             if (blk_done)
                                 begin
                                     state <= SECOND_BLOCK_WAITING;
                                     msg_in <= buffer[511:0];
                                     start <= 1'b1;
                                 end
                         end
                     else if (state == SECOND_BLOCK_WAITING)
                         begin
                             if (blk_done)
                                 begin
                                     start <= 1'b1;
                                     state <= WAIT_HASH;
                                     blk_type <= HASH;
                                     msg_in[511:0] <= {hash_out, 1'b1, {191{1'b0}},64'h100};
                                 end
                         end
                     else if (state == WAIT_HASH)
                         begin
                             start <= 1'b0;
                             if (blk_done)
                                 begin
									if(dononce) begin
										if(hash_out[255:250] == 6'd0) begin
											found_nonce <= 1'b1;
											state <= DONE;
										end
										else begin
											nonce <= nonce + 1'b1;
											state <= INIT;
										end
									end										
									else
										state <= DONE;
                                 end
                         end
                     else if (state == DONE)
                         begin
                             
                         end
                end
        end
    SHA256 UUT(.CLK(sys_clk), .nreset(~reset), .start(start), .msg(msg_in), .hash(hash_out), .blk_done(blk_done), .blk_type(blk_type));
	
	assign LED[15] = found_nonce;
	//assign LED[14:8] = 1'b0;
	wire [7:0] LED_walk;
	assign LED[7:0] = LED_walk;
	
	nexys4_display d1(.clk_in(sys_clk), .LED_proc(LED_walk), .CATHODE_proc(CATHODE), .AN_proc(AN), .Word(nonce),
	.BTNC_in(BTNC));
endmodule