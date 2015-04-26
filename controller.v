`include "connect_parameters.v"

module controller(CLK, nreset, putFlit, EN_putFlit, getCredits, EN_getCredits,
                  getFlit, EN_getFlit, putCredits, EN_putCredits);
    input CLK, nreset, getCredits, getFlit;
    
    output EN_putFlit, putFlit, EN_getCredits, EN_getFlit, EN_putCredits, putCredits;
    
    localparam vc_bits = (`NUM_VCS > 1) ? $clog2(`NUM_VCS) : 1;
    localparam dest_bits = $clog2(`NUM_USER_RECV_PORTS);
    // 2 + 64 + 5 + 2  = 73
    localparam flit_port_width = 2 /*valid and tail bits*/+ `FLIT_DATA_WIDTH + dest_bits + vc_bits;
    localparam credit_port_width = 1 + vc_bits; // 1 valid bit
    
    localparam counter_bits = $clog2(`FLIT_BUFFER_DEPTH) + 1;
    
    // Registers/wires for sending data
    
    // registers to store information for putFlit
    reg is_valid;
    reg is_tail;
    reg [dest_bits-1:0] dest;
    reg [vc_bits-1:0]   vc;
    reg [`FLIT_DATA_WIDTH-1:0] data;
    
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
    
    reg [1023:0] data_store;
    reg [3:0] state;
    
    localparam
    INIT = 4'b0000,
    SEND_DATA = 4'b0001,
    CONFIRMATION_STATE = 4'b0010,
    FOUND_BITCOIN = 4'b0011;
    
    localparam
    FOUND_BITCOIN_MSG = 64'h00000001;
    
    
    reg [7:0] block_counter;
    reg [9:0] msg_counter;
    
    wire[639:0] msg_tb_640;
    assign msg_tb_640[639:0] = {640'hcdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361cdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361b4ad1fee05e68c1093ba7b07328e1361};
    
    always@(posedge CLK or negedge nreset)
        begin
            if (!nreset)
                begin
                    block_counter <= 8'h00;
                    data_store <= 64'h00000000;
                    state <= INIT;
                    credit_counter <= 16;
                    EN_putFlit <= 0;
                    EN_getCredits <= 1;
                    EN_getFlit <= 0;
                    EN_putCredits <= 0;
                    data_store <= 0;
                    state <= INIT;
                    msg_counter <= 0;
                    vc <= 0;
                end
            else
                begin
                    if (state == INIT)
                        begin
                            // GENERATE A NEW BLOCK HEADER.
                            state <= SEND_DATA;
                            EN_putFlit <= 1'b0;
                        end
                    else if (state == SEND_DATA)
                        begin
                            if (credit_counter >= 1)
                                begin
                                    EN_putFlit <= 1'b1;
                                    putFlit <= 
                                        {1'b1, // Valid bit
                                        (msg_counter == 10'd576) ? 1'b1 : 1'b0, // Tail bit
                                        dest,    // Destination 
                                        vc,     // Virtual channel
                                        msg_tb_640[msg_counter+:64]}; // actual data
                                    msg_counter <= (msg_counter + 64) % 640;
                                    
                                    if (msg_counter == 10'd576)
                                        begin
                                            dest <= (dest + 1) % 25;
                                            if (dest == 24)
                                                begin
                                                    state <= CONFIRMATION_STATE;
                                                    EN_putFlit <= 1'b0;
                                                end
                                        end
                                end
                            else
                                begin
                                    EN_putFlit <= 1'b0;
                                end
                        end
                    else if (state == CONFIRMATION_STATE)
                        begin
                            EN_getFlit <= 1'b1;
                            if (getFlit[72] == 1'b1)
                                begin
                                    // Found bitcoin
                                    if (getFlit[63:0] == FOUND_BITCOIN_MSG)
                                        begin
                                            EN_getFlit <= 1'b0;
                                            state <= INIT;
                                            EN_putCredits <= 1'b1;
                                            putCredits[vc_bits:0] <= {1'b1, 2'b00};
                                        end
                                end
                        end
                    else if (state == FOUND_BITCOIN)
                        begin
                            EN_putCredits <= 1'b0;
                            // Do nothing for now.
                        end
                        
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