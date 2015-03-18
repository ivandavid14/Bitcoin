module k_lut( input wire  [5:0] address, output wire [31 : 0] k );
	reg [31 : 0] temp;
	assign K = temp;

	always @(*)
	begin
		case(addr)
			0: temp = 32'h428a2f98;
			1: temp = 32'h71374491;
			2: temp = 32'hb5c0fbcf;
			3: temp = 32'he9b5dba5;
			4: temp = 32'h3956c25b;
			5: temp = 32'h59f111f1;
			6: temp = 32'h923f82a4;
			7: temp = 32'hab1c5ed5;
			8: temp = 32'hd807aa98;
			9: temp = 32'h12835b01;
			10: temp = 32'h243185be;
			11: temp = 32'h550c7dc3;
			12: temp = 32'h72be5d74;
			13: temp = 32'h80deb1fe;
			14: temp = 32'h9bdc06a7;
			15: temp = 32'hc19bf174;
			16: temp = 32'he49b69c1;
			17: temp = 32'hefbe4786;
			18: temp = 32'h0fc19dc6;
			19: temp = 32'h240ca1cc;
			20: temp = 32'h2de92c6f;
			21: temp = 32'h4a7484aa;
			22: temp = 32'h5cb0a9dc;
			23: temp = 32'h76f988da;
			24: temp = 32'h983e5152;
			25: temp = 32'ha831c66d;
			26: temp = 32'hb00327c8;
			27: temp = 32'hbf597fc7;
			28: temp = 32'hc6e00bf3;
			29: temp = 32'hd5a79147;
			30: temp = 32'h06ca6351;
			31: temp = 32'h14292967;
			32: temp = 32'h27b70a85;
			33: temp = 32'h2e1b2138;
			34: temp = 32'h4d2c6dfc;
			35: temp = 32'h53380d13;
			36: temp = 32'h650a7354;
			37: temp = 32'h766a0abb;
			38: temp = 32'h81c2c92e;
			39: temp = 32'h92722c85;
			40: temp = 32'ha2bfe8a1;
			41: temp = 32'ha81a664b;
			42: temp = 32'hc24b8b70;
			43: temp = 32'hc76c51a3;
			44: temp = 32'hd192e819;
			45: temp = 32'hd6990624;
			46: temp = 32'hf40e3585;
			47: temp = 32'h106aa070;
			48: temp = 32'h19a4c116;
			49: temp = 32'h1e376c08;
			50: temp = 32'h2748774c;
			51: temp = 32'h34b0bcb5;
			52: temp = 32'h391c0cb3;
			53: temp = 32'h4ed8aa4a;
			54: temp = 32'h5b9cca4f;
			55: temp = 32'h682e6ff3;
			56: temp = 32'h748f82ee;
			57: temp = 32'h78a5636f;
			58: temp = 32'h84c87814;
			59: temp = 32'h8cc70208;
			60: temp = 32'h90befffa;
			61: temp = 32'ha4506ceb;
			62: temp = 32'hbef9a3f7;
			63: temp = 32'hc67178f2;
		endcase
	end
endmodule
