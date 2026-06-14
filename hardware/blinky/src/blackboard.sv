// ----------------------------------------------------------------------------
// blackboard.sv
//
// 6/13/2026 D. W. Hawkins (dwh@caltech.edu)
//
// Real Digital Blackboard Zynq-7000 'blinky' (fabric only) design.
//
// ----------------------------------------------------------------------------

module blackboard  (
		// 100MHz clock
		input        clk_100mhz,

		// Green LEDs
		output [9:0] led_g,

		// RGB LEDs
		output [5:0] led_rgb,

		// 7-segment Display
		output [3:0] sseg_a,
		output [7:0] sseg_c
	);

	// ------------------------------------------------------------------------
	// Local Parameters
	// ------------------------------------------------------------------------
	//
	// Clock frequency
	localparam real CLK_FREQUENCY = 100.0e6;

	// LED blink rate
	localparam real BLINK_PERIOD = 0.5;

	// Counter width
	//
	// Note: the integer'() casts are important, without them Vivado
	// generates incorrect counter widths (much wider than expected)
	//
	// Width to LSB at 100MHz
	localparam integer MIN_WIDTH =
		$clog2(integer'(CLK_FREQUENCY*BLINK_PERIOD));

	// LED width
	localparam integer LED_WIDTH = 10;

	// Segment width (4 displays, 4-bits per display)
	localparam integer SEG_WIDTH = 16;

	// Counter width
	localparam integer CNT_WIDTH =
		MIN_WIDTH + ((LED_WIDTH > SEG_WIDTH) ? LED_WIDTH : SEG_WIDTH);

	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	// Counter
	logic [CNT_WIDTH-1:0] count = '0;

	// RGB duty-cycle control
	logic       rgb_duty;
	logic [4:0] rgb_count;
	logic [5:0] rgb_en;
	logic [5:0] rgb_control;

	// 7-segment hex display multiplexed hex digit
	logic [1:0] hex_select;
	logic [3:0] hex_value;
	logic       hex_dp;

	// ------------------------------------------------------------------------
	// Counter
	// ------------------------------------------------------------------------
	//
	always_ff @(posedge clk_100mhz) begin
		count <= count + 1;
	end

	// ------------------------------------------------------------------------
	// Green LEDs
	// ------------------------------------------------------------------------
	//
	assign led_g = count[MIN_WIDTH +: LED_WIDTH];

	// ------------------------------------------------------------------------
	// RGB LEDs
	// ------------------------------------------------------------------------
	//
	// 12.5% duty-cycle
	assign rgb_duty = (count[2:0] == 3'h0) ? 1'b1 : 1'b0;

	// RGB LEDs
	// --------
	//
	// - There are 2 RGB LEDs, with 3-bits controlling the LED color:
	//
	//     3'b000 = off
	//     3'b001 = red
	//     3'b010 = green
	//     3'b100 = blue
	//
	// - 5-bits of the counter are used to control the LEDs. The 3-MSBs control
	//   the color, while the 2-LSBs control the count (which of the LEDs are
	//   enabled) from 0 to 3.
	//
	//   5'b000-xx =                off + count 0 to 3
	//   5'b001-xx =                red + count 0 to 3
	//   5'b010-xx =        green       + count 0 to 3
	//   5'b011-xx =        green + red + count 0 to 3
	//   5'b100-xx = blue               + count 0 to 3
	//   5'b101-xx = blue +         red + count 0 to 3
	//   5'b110-xx = blue + green       + count 0 to 3 (looks cyan)
	//   5'b111-xx = blue + green + red + count 0 to 3
	//
	// Counter 5-bits aligned with the green LED LSB
	assign rgb_count = count[MIN_WIDTH +: 5];

	// RGB LED enables
	assign rgb_en = {{3{rgb_count[1]}}, {3{rgb_count[0]}}};

	// Color and count
	assign rgb_control = {2{rgb_count[4:2]}} & rgb_en;

   	// Duty-cycled RGB output
    assign led_rgb = rgb_duty ? rgb_control : 6'h000;

	// ------------------------------------------------------------------------
	// Multiplexed 4-Digit 7-Segment Display
	// ------------------------------------------------------------------------
	//
	// Multiplex the 4 segments at about 2^8 = 256 Hz
	assign hex_select = count[MIN_WIDTH-8 +:2];

	// Hex display multiplexer
	hex_display_mux #(
		.NWIDTH(4)
	) u1 (
        .sel    (hex_select            ),
        .data_i (count[MIN_WIDTH +: 16]),
        .dp_i   (count[MIN_WIDTH +: 4] ),
		.an_o   (sseg_a                ),
        .data_o (hex_value             ),
        .dp_o   (hex_dp                )
    );

	// Hex display decode
	hex_display u2 (
        .hex     (hex_value  ),
        .display (sseg_c[6:0])
    );

	// Hex display decimal point (active low)
	assign sseg_c[7] = ~hex_dp;

endmodule

