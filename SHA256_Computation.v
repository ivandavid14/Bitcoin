module SHA256(CLK, nreset, msg, length, hash);
	//assume for now length < 512
	input CLK, nreset, msg, length;
	output hash;
	
	reg [0:511] hash;
	reg [0:7] h;

	reg [0:5] k_lut_addr;
	wire [0:31] k;

	always @(negedge nreset or posedge CLK)
	begin
		if (!nreset)
		begin
			h[0] = 32'h6a09e667;
			h[1] = 32'hbb67ae85;
			h[2] = 32'h3c6ef372;
			h[3] = 32'ha54ff53a;
			h[4] = 32'h510e527f;
			h[5] = 32'h9b05688c;
			h[6] = 32'h1f83d9ab;
			h[7] = 32'h5be0cd19;
			k_lut_addr = 6'bXXXXXX;
		end
		else
		begin
			
		end
	end

	k_lut lookup_table(k, k_lut_addr);

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
