module processing_element(CLK, nreset);
    input CLK, nreset;
    
    reg [1023:0] buffer;
    wire [255:0] hash_out;
    reg [511:0] msg_in;
    reg [1:0] blk_type;
    wire blk_done;
    reg start;
    
    reg [3:0] state;
    reg blk_iteration;
    
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
    
    always @(posedge CLK or negedge nreset)
        begin
            if (!nreset)
                begin
                    blk_type <= 2'b11;
                    state <= INIT;
                    blk_iteration <= 1'b0;
                    start <= 1'b0;
                end
            else
                begin
                    if (state == INIT)
                        begin
                            start <= 1'b0;
                            blk_iteration <= 1'b0;
                            buffer <= {512'hcdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361cdd1babeb9616ba90edc69a05c086b08b4ad1fee05e68c1093ba7b07328e1361};
                            blk_type <= MERKLE_LEAF;
                            
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
                                      buffer <= {buffer[639:0], 1'b1, {319{1'b0}}, 64'h280};  
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
                                     state <= DONE;
                                 end
                         end
                     else if (state == DONE)
                         begin
                             
                         end
                end
        end
    SHA256 UUT(.CLK(CLK), .nreset(nreset), .start(start), .msg(msg_in), .hash(hash_out), .blk_done(blk_done), .blk_type(blk_type));

endmodule