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
endmodule
