`include "connect_parameters.v"

module controller(CLK, nreset, putFlit, EN_putFlit, getCredits, EN_getCredits,
                  getFlit, EN_getFlit, putCredits, EN_putCredits);
    input CLK, nreset, getCredits, getFlit;
    
    output EN_putFlit, putFlit, EN_getCredits, EN_getFlit, EN_putCredits, putCredits;
    
    localparam vc_bits = (`NUM_VCS > 1) ? $clog2(`NUM_VCS) : 1;
    localparam dest_bits = $clog2(`NUM_USER_RECV_PORTS);
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
    SEND_DATA = 4'b0001;
    
    reg [7:0] block_counter;
    
    always@(posedge CLK or negedge nreset)
        begin
            if (!nreset)
                begin
                    block_counter <= 8'h00;
                    data_store <= 64'h00000000;
                    state <= INIT;
                    credit_counter <= 16;
                    EN_putFlit <= 0;
                    EN_getCredits <= 0;
                    EN_getFlit <= 0;
                    EN_putCredits <= 0;
                    data_store <= 0;
                end
            else
                begin
                    if (state == INIT)
                        begin
                            
                        end
                    else if (state == SEND_DATA)
                        begin
                            
                        end
                end
        end   
endmodule