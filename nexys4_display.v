module nexys4_display
	(
	Word,
	clk_in,
	//BTNL, BTNU, BTND, BTNR,
	BTNC_in,
	//SW,
	LED_proc,
	AN_proc,						// Anodes
	CATHODE_proc	// Cathodes, Dot Point[7]
	);

	input [31:0] Word;
	input clk_in;
	input BTNC_in; //BTNL, BTNU, BTND, BTNR, BTNC;
	//input [15:0] SW;

	output [7:0] LED_proc;
	output [7:0] AN_proc;
	//output CA,CB,CC,CD,CE,CF,CG;
	//output DP;
	output [7:0] CATHODE_proc;

	wire reset;
	wire board_clk;
	wire [2:0] slow_bits;
	wire [2:0] sev_seg_clk;
	reg [27:0] divclk;

	assign reset = BTNC_in;

	always @(posedge clk_in, posedge reset)
	begin
		if (reset)
			divclk <= 0;
		else
			divclk <= divclk + 1'b1;
	end

	assign CATHODE_proc[7] = divclk[25]; // The dot point on each SSD flashes
	// divclk[25] (~1.5Hz) = (100MHz / 2**26)
	assign sev_seg_clk = divclk[17:15];
	assign slow_bits = divclk[26:24];


	// Buttons and LEDs
	//wire button_pressed;
	//assign button_pressed = BTNL | BTNU | BTND | BTNR ;

	reg [7:0] walking_leds;

	//assign LED_proc[7:0] = button_pressed ? {BTNL, BTNL, BTNU, BTNU, BTND, BTND, BTNR, BTNR} : ( divclk[27] ? 8'b11111111 : walking_leds );
	assign LED_proc[7:0] = divclk[27] ? 8'b11111111 : walking_leds;

	reg [31:0] Word_slow;

	always @ (posedge divclk[24])
	begin
		Word_slow <= Word;
	end

	always @ (slow_bits)
	begin
		case (slow_bits)
			3'b000: walking_leds = 8'b00000001 ;
			3'b001: walking_leds = 8'b00000010 ;
			3'b010: walking_leds = 8'b00000100 ;
			3'b011: walking_leds = 8'b00001000 ;
			3'b100: walking_leds = 8'b00010000 ;
			3'b101: walking_leds = 8'b00100000 ;
			3'b110: walking_leds = 8'b01000000 ;
			3'b111: walking_leds = 8'b10000000 ;
			default:walking_leds = 8'bXXXXXXXX ;
		endcase
	end


	// SSD (Seven Segment Display)
	reg [3:0] SSD;
	wire [3:0] SSD3, SSD2, SSD1, SSD0, SSD4, SSD5, SSD6, SSD7;

	assign AN_proc[0] = sev_seg_clk != 3'd0;
	assign AN_proc[1] = sev_seg_clk != 3'd1;
	assign AN_proc[2] = sev_seg_clk != 3'd2;
	assign AN_proc[3] = sev_seg_clk != 3'd3;
	assign AN_proc[4] = sev_seg_clk != 3'd4;
	assign AN_proc[5] = sev_seg_clk != 3'd5;
	assign AN_proc[6] = sev_seg_clk != 3'd6;
	assign AN_proc[7] = sev_seg_clk != 3'd7;

	// localparam word = 32'habcd_ef45;

	assign {SSD7, SSD6, SSD5, SSD4, SSD3, SSD2, SSD1, SSD0} = Word_slow;
	/*
	assign SSD0 = SW[3:0];
	assign SSD1 = SW[7:4];
	assign SSD2 = SW[11:8];
	assign SSD3 = SW[15:12];
	assign SSD4 = ~SW[3:0];
	assign SSD5 = ~SW[7:4];
	assign SSD6 = ~SW[11:8];
	assign SSD7 = ~SW[15:12];
	*/

	always @ (sev_seg_clk, SSD0, SSD1, SSD2, SSD3, SSD4, SSD5, SSD6, SSD7)
	begin
		case (sev_seg_clk)
			3'b000: SSD = SSD0;
			3'b001: SSD = SSD1;
			3'b010: SSD = SSD2;
			3'b011: SSD = SSD3;
			3'b100: SSD = SSD4;
			3'b101: SSD = SSD5;
			3'b110: SSD = SSD6;
			3'b111: SSD = SSD7;
		endcase
	end

	reg [6:0] cathodes;
	assign CATHODE_proc[6:0] = cathodes;

	// Following is Hex to SSD
	always @ (SSD)
	begin
		case (SSD)
			4'b0000: cathodes = 7'b0000001 ; // 0
			4'b0001: cathodes = 7'b1001111 ; // 1
			4'b0010: cathodes = 7'b0010010 ; // 2
			4'b0011: cathodes = 7'b0000110 ; // 3
			4'b0100: cathodes = 7'b1001100 ; // 4
			4'b0101: cathodes = 7'b0100100 ; // 5
			4'b0110: cathodes = 7'b0100000 ; // 6
			4'b0111: cathodes = 7'b0001111 ; // 7
			4'b1000: cathodes = 7'b0000000 ; // 8
			4'b1001: cathodes = 7'b0000100 ; // 9
			4'b1010: cathodes = 7'b0001000 ; // A
			4'b1011: cathodes = 7'b1100000 ; // b
			4'b1100: cathodes = 7'b0110001 ; // C
			4'b1101: cathodes = 7'b1000010 ; // d
			4'b1110: cathodes = 7'b0110000 ; // E
			4'b1111: cathodes = 7'b0111000 ; // F
			default: cathodes = 7'bXXXXXXX ;
		endcase
	end
endmodule