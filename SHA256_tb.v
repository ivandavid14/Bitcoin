`timescale 1 ns / 100 ps

module SHA256_tb;

reg Clk_tb, Rstb_tb;
integer  Clk_cnt;
  
localparam CLK_PERIOD = 20;

reg [511:0] msg_tb;
wire [255:0] hash_tb;

SHA256 UUT(.CLK(Clk_tb), .nreset(Rstb_tb), .msg(msg_tb), .length(512), .hash(hash_tb));
		 
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
    msg_tb <= 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
  end

endmodule  
