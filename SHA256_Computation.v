`include "k_lut.v"

module SHA256(CLK, nreset, msg, length, hash);
	//assume for now length < 512
	input CLK, nreset, length;
	input [511:0] msg;
	output reg [255:0] hash;
	
	reg [511:0] test_msg;

	reg [31:0] H [0:7];
	reg [31:0] W [0:15];
	reg [31:0] a,b,c,d,e,f,g,h,t1,t2,w;

	wire [31:0] k;
	reg [5:0] k_addr;
	reg [6:0] round;
	reg [3:0] i;

	k_lut lookup_table(k_addr, k);

	reg [6:0] state;

	localparam
	INI  		= 	7'd0,
	UPDATE_W 	= 	7'd1,
	UPDATE_K 	= 	7'd2,
	COMPRESSION_1= 	7'd3,
	COMPRESSION_2= 	7'd4,
	UPDATE 		= 	7'd5,
	DONE 		= 	7'd6,
	IDLE	 	= 	7'd7;
	
	always @(posedge CLK, negedge nreset)
	begin: CU
		if (~nreset)
		begin
			state <= INI;
			H[0] <= 32'h6a09e667;
			H[1] <= 32'hbb67ae85;
			H[2] <= 32'h3c6ef372;
			H[3] <= 32'ha54ff53a;
			H[4] <= 32'h510e527f;
			H[5] <= 32'h9b05688c;
			H[6] <= 32'h1f83d9ab;
			H[7] <= 32'h5be0cd19;
			k_addr <= 6'b0;
			round <= 0;
	
			end
		else
		begin
			case (state)
				INI:
				begin
					a <= H[0];
					b <= H[1];
					c <= H[2];
					d <= H[3];
					e <= H[4];
					f <= H[5];
					g <= H[6];
					h <= H[7];
					
					//for (i=0; i<=15; i=i+1)
					W[15] <= msg[ 31 + 32*0 : 0 + 32*0 ];
					W[14] <= msg[ 31 + 32*1 : 0 + 32*1 ];
					W[13] <= msg[ 31 + 32*2 : 0 + 32*2 ];
					W[12] <= msg[ 31 + 32*3 : 0 + 32*3 ];
					
					W[11] <= msg[ 31 + 32*4 : 0 + 32*4 ];
					W[10] <= msg[ 31 + 32*5 : 0 + 32*5 ];
					W[9] <= msg[ 31 + 32*6 : 0 + 32*6 ];
					W[8] <= msg[ 31 + 32*7 : 0 + 32*7 ];
					
					W[7] <= msg[ 31 + 32*8 : 0 + 32*8 ];
					W[6] <= msg[ 31 + 32*9 : 0 + 32*9 ];
					W[5] <= msg[ 31 + 32*10 : 0 + 32*10 ];
					W[4] <= msg[ 31 + 32*11 : 0 + 32*11 ];
					
					W[3] <= msg[ 31 + 32*12 : 0 + 32*12 ];
					W[2] <= msg[ 31 + 32*13 : 0 + 32*13 ];
					W[1] <= msg[ 31 + 32*14 : 0 + 32*14 ];
					W[0] <= msg[ 31 + 32*15 : 0 + 32*15 ];
					
					state <= UPDATE_W;
				end
				UPDATE_W:
				begin
					if (round < 16)
						w <= W[round];
					else begin
						w <= (Delta1(W[14]) + W[9] + Delta0(W[1]) + W[0]);
						for (i=0; i<=14; i=i+1)
							W[i] <= W[(i+1)];
						W[15] <= (Delta1(W[14]) + W[9] + Delta0(W[1]) + W[0]);
					end
					state <= UPDATE_K;
				end
				
				UPDATE_K:
				begin
					k_addr = round;
					state <= COMPRESSION_1;
				end
				
				COMPRESSION_1:
				begin
					t1 <= T1(e, f, g, h, k, w);
					t2 <= T2(a, b, c);
					state <= COMPRESSION_2;
				end
				
				COMPRESSION_2:
				begin
					h <= g;
					g <= f;
					f <= e;
					e <= (d + t1);
					d <= c;
					c <= b;
					b <= a;
					a <= (t1 + t2);

					
					
					if( round < 63) begin
						state <= UPDATE_W;
						round <= round + 1;
					end else
						state <= UPDATE;
				end
				UPDATE:
				begin
					H[0] = (H[0] + a);
					H[1] = (H[1] + b);
					H[2] = (H[2] + c);
					H[3] = (H[3] + d);
					H[4] = (H[4] + e);
					H[5] = (H[5] + f);
					H[6] = (H[6] + g);
					H[7] = (H[7] + h); 
					
					state <= DONE;
				end
				DONE:
				begin
					//for (i=0; i<=7; i=i+1)
					hash[ 31 + 32*0 : 0 + 32*0 ] <= H[7];
					hash[ 31 + 32*1 : 0 + 32*1 ] <= H[6];
					hash[ 31 + 32*2 : 0 + 32*2 ] <= H[5];
					hash[ 31 + 32*3 : 0 + 32*3 ] <= H[4];
					
					hash[ 31 + 32*4 : 0 + 32*4 ] <= H[3];
					hash[ 31 + 32*5 : 0 + 32*5 ] <= H[2];
					hash[ 31 + 32*6 : 0 + 32*6 ] <= H[1];
					hash[ 31 + 32*7 : 0 + 32*7 ] <= H[0];
					
					state <= IDLE;
				end
		endcase
		end
	end

	function [31:0] rotate (input [31:0] data, input [4:0] shift);
		reg [63:0] temp;
		begin
		  temp = {data, data} >> shift;
		  rotate = temp[31:0];
		end
	endfunction

	function [31 : 0] Ch;
		input [31 : 0] x,y,z;
		Ch = (x & y) ^ (~x & z);
	endfunction

	function [31 : 0] Maj;
		input [31 : 0] x,y,z;
		Maj = (x & y) ^ (x & z) ^ (y & z);
	endfunction

	function [31 : 0] Sigma0;
		input [31 : 0] x;
		Sigma0 = rotate(x, 2) ^ rotate(x, 13) ^ rotate(x, 22);
	endfunction

	function [31 : 0] Sigma1;
		input [31 : 0] x;
		Sigma1 = rotate(x, 6) ^ rotate(x, 11) ^ rotate(x, 25);
	endfunction

	function [31 : 0] Delta0;
		input [31 : 0] x;
		Delta0 = rotate(x, 7) ^ rotate(x, 18) ^ (x >> 3);
	endfunction

	function [31 : 0] Delta1;
		input [31 : 0] x;
		Delta1 = rotate(x, 17) ^ rotate(x, 19) ^ (x >> 10);
	endfunction

	function [31 : 0] T1;
		input [31 : 0] e, f, g, h, k, w;
		T1 = (h + Sigma1(e) + Ch(e, f, g) + k + w);
	endfunction

	function [31 : 0] T2;
		input [31 : 0] a, b, c;
		T2 = (Sigma0(a) + Maj(a, b, c));
	endfunction

endmodule
