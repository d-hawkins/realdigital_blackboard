// ----------------------------------------------------------------------------
// hex_display_mux.sv
//
// 6/14/2026 D. W. Hawkins (dwh@caltech.edu)
//
// Multi-segment hexadecimal (7-segment) display multiplexer.
//
// ----------------------------------------------------------------------------

module hex_display_mux #(
		// Number of segments
		parameter integer NWIDTH = 4,

		// Segment select width
		// * log2(number of segments)
		localparam integer SWIDTH = $clog2(NWIDTH)
	) (

		// Multiplexer select
        input   [SWIDTH-1:0] sel,

		// Multi-digit inputs
        input [4*NWIDTH-1:0] data_i,
        input   [NWIDTH-1:0] dp_i,

		// Multiplexed outputs
		output  [NWIDTH-1:0] an_o,
        output         [3:0] data_o,
        output               dp_o
    );

	// ------------------------------------------------------------------------
	// Local Signals
	// ------------------------------------------------------------------------
	//
	// Anode decode
	logic [NWIDTH-1:0] anode;

	// ------------------------------------------------------------------------
	// Anodes
	// ------------------------------------------------------------------------
	//
	always_comb begin
		// Default
		anode = {NWIDTH{1'b1}};

		// Selected anodoe
		anode[sel] = 1'b0;
	end
	assign an_o = anode;

	// ------------------------------------------------------------------------
	// Cathodes
	// ------------------------------------------------------------------------
	//
	assign data_o = data_i[4*sel +: 4];
	assign dp_o   = dp_i[sel];

endmodule


