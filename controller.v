`include "noc/connect_parameters.v"

module controller(sys_clk, nreset, putFlit, EN_putFlit, getCredits, EN_getCredits,
                  getFlit, EN_getFlit, putCredits, EN_putCredits,
				  nonce, Clk_cnt, done);
    input sys_clk, nreset, getCredits, getFlit;

    output EN_putFlit, putFlit, EN_getCredits, EN_getFlit, EN_putCredits, putCredits;

    localparam vc_bits = 2; //(`NUM_VCS > 1) ? $clog2(`NUM_VCS) : 1;
    localparam dest_bits = 5; //$clog2(`NUM_USER_RECV_PORTS);
    // 2 + 64 + 5 + 2  = 73
    localparam flit_port_width = 2 /*valid and tail bits*/+ `FLIT_DATA_WIDTH + dest_bits + vc_bits;
    localparam credit_port_width = 1 + vc_bits; // 1 valid bit

    localparam counter_bits = 4 + 1;//$clog2(`FLIT_BUFFER_DEPTH) + 1;

    // Registers/wires for sending data

    // registers to store information for putFlit
    //wire is_valid;
    //wire is_tail;
    reg [dest_bits-1:0] dest;
    reg [vc_bits-1:0]   vc;
    //reg [`FLIT_DATA_WIDTH-1:0] data;

    // stores data to be sent into network
    reg [flit_port_width-1:0] putFlit;

    // bit to put a flit in the network
    reg EN_putFlit;

    // reg for number of credits
    reg [counter_bits - 1 : 0] credit_counter;

    // reg for indicated that the module wants to get a credit
    reg EN_getCredits;

    // wire for stating what channel the incoming credit is for
    wire [vc_bits: 0] getCredits;

    // Registers/wires for receiving data
    // Indicates that flit is ready to be received
    reg EN_getFlit;

    // Wires to store the received flits
    wire [flit_port_width-1:0] getFlit;

    // Indicates that credits are to be sent
    reg EN_putCredits;

    // reg for actually sending credit
    reg [vc_bits:0] putCredits;

    //reg [1023:0] data_store;
    reg [3:0] state;

    localparam
    INIT = 4'd0,
    SEND_DATA = 4'd1,
    CONFIRMATION_STATE = 4'd2,
    FOUND_BITCOIN = 4'd3,
	OUTPUT_CLKS = 4'd4,
	DONE = 4'D5;

    localparam FOUND_BITCOIN_MSG = 64'h00000001;

    reg [7:0] block_counter;
    reg [9:0] msg_counter;

    wire[639:0] msg_tb_640;
    assign msg_tb_640[639:0] = {640'h8601a8807d39ef0f73ac5b3aac28c527c89542b8029600809f5fe5ace2ea82b273fcdb297fba14e33f9d2921356b84cf853b629d639e028729d5b40f2b0f6a9649b8965140e8a10adf06070a00000000};

	reg last_msg;

	output reg [63:0] Clk_cnt;
	output reg [31:0] nonce;
	output reg done;

    always@(posedge sys_clk or negedge nreset)
        begin
            if (!nreset)
                begin
					putFlit <= 0;
                    block_counter <= 8'h00;
                    state <= INIT;
                    credit_counter <= 16;
                    EN_putFlit <= 0;
                    EN_getCredits <= 1;
                    EN_getFlit <= 0;
                    EN_putCredits <= 0;
                    //data_store <= 0;
                    state <= INIT;
                    msg_counter <= 0;
                    vc <= 0;
					last_msg <= 0;
					Clk_cnt <= 0;
					nonce <= 0;
					done <= 1'b0;
					dest <= 1;
                end
            else
                begin
					case(state)
						INIT:
						begin
							// GENERATE A NEW BLOCK HEADER.
							state <= SEND_DATA;
							EN_putFlit <= 1'b0;
						end

						SEND_DATA:
						begin
							EN_getFlit <= 1'b1;

							if(getFlit[flit_port_width-1]) // valid flit
							begin
								if (getFlit[63:0] == FOUND_BITCOIN_MSG) // Found bitcoin
								begin
									$display("Found bitcoin");
									state <= FOUND_BITCOIN;
									EN_putFlit <= 1'b0;
									putFlit <= 0;
									done <= 1'b1;
								end
								EN_putCredits <= 1'b1;
								putCredits <= 3'b100;
							end
							else

							begin
								EN_putCredits <= 0;
								putCredits <= 0;
								if (credit_counter >= 1)
								begin
									EN_putFlit <= 1'b1;
									putFlit <=
									{1'b1, // Valid bit
									(msg_counter == 10'd576) ? 1'b1 : 1'b0 , // Tail bit
									dest,    // Destination
									vc,     // Virtual channel
									msg_tb_640[msg_counter+:64] }; // actual data
									msg_counter <= (msg_counter + 64) % 640;

									if( (msg_counter == 10'd448) & (dest > 0) & (dest < `NUM_PE))
										dest <= (dest + 1) % (`NUM_PE + 1);

									if( (msg_counter == 0) & (dest == `NUM_PE) )
										last_msg <= 1;

									if ( (msg_counter == 10'd0) & last_msg )
									begin
										state <= CONFIRMATION_STATE;
										EN_putFlit <= 1'b0;
										putFlit <= 0;
									end
								end
								else
								begin
									EN_putFlit <= 1'b0;
								end
							end
						end

						CONFIRMATION_STATE:
						begin
							if(getFlit[flit_port_width-1]) // valid flit
							begin
								if (getFlit[63:0] == FOUND_BITCOIN_MSG) // Found bitcoin
								begin
									$display("Controller: Found bitcoin");
									state <= FOUND_BITCOIN;
									done <= 1'b1;
								end
								EN_putCredits <= 1'b1;
								putCredits <= 3'b100;
							end
							else begin
								EN_putCredits <= 0;
								putCredits <= 0;
							end
						end

						FOUND_BITCOIN:
						begin
							if(getFlit[flit_port_width-1]) // valid flit
							begin
								nonce <= getFlit[31:0];
								state <= OUTPUT_CLKS;

								$display("Controller: nonce = %h", getFlit[31:0]);

								EN_putCredits <= 1'b1;
								putCredits <= 3'b100;
							end
							else begin
								EN_putCredits <= 0;
								putCredits <= 0;
							end
						end

						OUTPUT_CLKS:
						begin
							if(getFlit[flit_port_width-1]) // valid flit
							begin
								Clk_cnt <= getFlit[63:0];
								state <= DONE;

								$display("Controller: clks = %h", getFlit[63:0]);

								EN_putCredits <= 1'b1;
								putCredits <= 3'b100;
							end
							else begin
								EN_putCredits <= 0;
								putCredits <= 0;
							end
						end

						DONE:
						begin
							//$display("nonce = %h", nonce);
							//$display("CLKS = %h", Clk_cnt);
							//$stop;
						end

						default:
							state <= DONE;
					endcase

                    // Handle getting of credits & incrementing/decrementing credit_counter
                    if (getCredits[vc_bits] == 1'b1)
                        begin
                            if (state == SEND_DATA)
                                begin
                                    // If we get a credit and use a credit. Do nothing.
                                    // If we get a credit and don't use one (because we have none). Increment
                                    // the credit counter
                                    if (credit_counter == 0)
                                        begin
                                            credit_counter <= credit_counter + 1;
                                        end
                                end
                            else
                                begin
                                    credit_counter <= credit_counter + 1;
                                end
                        end
                    else
                        begin
                            if (state == SEND_DATA && credit_counter >= 1)
                                begin
                                    credit_counter <= credit_counter - 1;
                                end
                        end
                end
        end
endmodule