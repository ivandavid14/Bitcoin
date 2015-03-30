`include "k_lut.v"

module SHA256(CLK, nreset, msg, length, hash);
	//assume for now length < 512
	input CLK, nreset, length;
	input [511:0] msg;
	output reg [255:0] hash;

	reg [31:0] H [0:7];
	reg [31:0] W [0:15];
	wire [31:0] w;
	reg [31:0] a,b,c,d,e,f,g,h;

	wire [31:0] k;
	reg [5:0] k_addr;
	reg [6:0] round;

	k_lut lookup_table(k_addr, k);

	reg [6:0] state;

	localparam
	INI  		= 	7'b0000001,
	COMPRESSION  = 	7'b0000010,
	UPDATE 		= 	7'b0000100,
	IDLE 		= 	7'b0001000,
	DONE 		= 	7'b1000000;

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
					
					for (i=0; i<=15; i=i+1)
						W[i] <= msg[ 31 + 32*i : 0 + 32*i ];
					
					state <= COMPRESSION;
				end
				COMPRESSION:
				begin
					if (round < 16)
						w = W[round];
					else begin
						w = (delta1(W[14]) + W[9] + delta0(W[1]) + W[0]);
						for (i=0; i<=14; i=i+1)
							W[i] <= W[(i+1)];
						W[15] <= w;
					end				
				
					k_addr = round;
					t1 <= T1(e, f, g, h, k, w);
					t2 <= T2(a, b, c);
					h <= g;
					g <= f;
					f <= e;
					e <= (d + t1);
					d <= c;
					c <= b;
					b <= a;
					a <= (t1 + t2);

					round <= round + 1;
					
					if( round <= 63)
						state <= COMPRESSION;
					else
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
					for (i=0; i<=7; i=i+1)
						hash[ 31 + 32*i : 0 + 32*i ] <= H[i];
					
					state <= IDLE;
				end
		endcase
		end
	end

	function [31:0] rotate (input [31:0] data, input [4:0] shift);
		reg [63:0] temp;
		begin
		  temp = {data, data} >> shift;
		  rotate = tmp[31:0];
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
		input [31 : 0] e, f, g, h, k, w;
		T2 = (Sigma0(a) + Maj(a, b, c));
	endfunction

endmodule
