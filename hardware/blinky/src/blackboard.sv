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
		output [5:0] led_rgb
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
	// 10 LEDs driven by 100MHz
	localparam integer WIDTH =
		$clog2(integer'(CLK_FREQUENCY*BLINK_PERIOD))+9;

	// ------------------------------------------------------------------------
	// Internal Signals
	// ------------------------------------------------------------------------
	//
	// Counter
	logic [WIDTH-1:0] count = '0;

	// RGB duty-cycle control
	logic       rgb_duty;
	logic [4:0] rgb_count;
	logic [5:0] rgb_en;
	logic [5:0] rgb_control;

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
	assign led_g = count[WIDTH-1:WIDTH-10];

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
	assign rgb_count = count[WIDTH-6:WIDTH-10];

	// RGB LED enables
	assign rgb_en = {{3{rgb_count[1]}}, {3{rgb_count[0]}}};

	// Color and count
	assign rgb_control = {2{rgb_count[4:2]}} & rgb_en;

   	// Duty-cycled RGB output
    assign led_rgb = rgb_duty ? rgb_control : 6'h000;

endmodule

