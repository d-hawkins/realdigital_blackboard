# -----------------------------------------------------------------------------
# blackboard_timing_constraints.tcl
#
# 6/13/2026 D. W. Hawkins (dwh@caltech.edu)
#
# Real Digital Blackboard timing constraints file.
#
# -----------------------------------------------------------------------------
# BSCAN Timing Constraints
# ------------------------
#
# The BSCAN component outputs DRCK and UPDATE have to be used as clocks due
# to the gated nature of DRCK, i.e., DRCK toggles when CAPTURE asserts, so
# CAPTURE can be used as an input, however, DRCK does not toggle when UPDATE
# asserts, so UPDATE has to be used as a clock too.
#
#            __:   __:   __:   __:   __:   __:   __:   __:     :     :     :
#    DRCK __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |_____:_____:_____:
#              :_____:     :     :     :     :     :     :     :     :     :
# CAPTURE _____:     :_____:_____:_____:_____:_____:_____:_____|_____:_____:
#         _____:_____:_____:_____:_____:_____:_____:_____:_____:_____:_____:
#   TDI/O _____|_____|_____|_____|_____|_____|_____|_____|__________________
#              :     :     :     :     :     :     :     :     :_____:     :
#  UPDATE _____:_____:_____:_____:_____:_____:_____:_____:_____|     |_____:
#              :     :     :     :     :     :     :     :     :     :     :
#                                           0ns  30ns  60ns  90ns
#
# Defining the two BSCAN clocks results in Vivado 2024.1 methodology warnings
# as the tool cannot find a common path (BSCAN internals must not be visible
# to static timing analysis). Setting the clocks as exclusive resolved the
# methodology warnings.
#
# Using set_clock_groups -logically_exclusive for BSCAN was found in the
# constraints file for XAPP1026.
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Apply Clock Constraints
# -----------------------------------------------------------------------------
#
# This procedure assigns default clock constraints. Each clock has a default
# frequency constraint that could be overridden using the dictionary argument.
# Currently no overrides are implemented.
#
proc apply_clock_constraints {} {

	# -------------------------------------------------------------------------
	# 100MHz Clock
	# -------------------------------------------------------------------------
	#
	set port [get_ports -quiet clk_100mhz]
	if {[llength $port]} {
		create_clock -period 10.000 -name clk_100mhz -add $port
		set_clock_groups -group \
			[get_clocks clk_100mhz -include_generated_clocks] -asynchronous
	}

	# -------------------------------------------------------------------------
	# CFGMCLK 65MHz internal oscillator
	# -------------------------------------------------------------------------
	#
	# CFGMCLK is 65MHz (+/-50%)
	set port [get_pins -quiet */CFGMCLK]
	if {[llength $port]} {
		create_clock -period 15.384 -name clk_65mhz $port
		set_clock_groups -group \
			[get_clocks clk_65mhz -include_generated_clocks] -asynchronous
	}

	# -------------------------------------------------------------------------
	# BSCAN
	# -------------------------------------------------------------------------
	#
	set port [get_pins -quiet */DRCK]
	if {[llength $port]} {
		create_clock -period  30.000 -name bscan_drck $port
		set port [get_pins */UPDATE]
		create_clock -period 120.000 -name bscan_udr $port

		# Exclusive clock groups
		set_clock_groups -logically_exclusive \
			-group [get_clocks bscan_drck] -group [get_clocks bscan_udr]
	}

	return
}


# -----------------------------------------------------------------------------
# Apply False Paths
# -----------------------------------------------------------------------------
#
# The 'set_false_path' command is not sufficient to clear all Vivado warnings
# on inputs and outputs that do not need timing constraints. The tool will
# still warn that the inputs and outputs are missing delay constraints.
# This procedure applies impossible-to-meet delay constraints. For designs
# that need the false path constraint is applied, timing will be met, as
# these impossible-to-meet delay constraints are not analyzed for timing.
#
proc apply_false_paths {{inputs {}} {outputs {}}} {

	# -------------------------------------------------------------------------
	# Asynchronous inputs (false paths)
	# -------------------------------------------------------------------------
	#
	# Asynchronous ports list
	set names [list \
		{sw[*]} {pb[*]} uart_rxd \
	]

	# Additional inputs
	if {[llength $inputs]} {
		lappend names {*}$inputs
	}

	# False path and dummy output delays
	foreach name $names {
		set ports [get_ports -quiet $name]
		set len [llength $ports]
		for {set i 0} {$i < $len} {incr i} {
			set port [lindex $ports $i]
			set port_name [get_property NAME $port]

			# Find the clock source for the input
			set path [get_timing_paths -quiet -from $port]
			set clk [get_property -quiet ENDPOINT_CLOCK $path]

			# Input delay constraints
			# (to suppress the Vivado warning that they are missing)
			if {[llength $clk]} {
				puts "timing_constraints.tcl: $port_name clk = $clk"

				# False path
				set_false_path -from $port

				# Input delay constraints
				set_input_delay -clock $clk -min -add_delay 1.000 $port
				set_input_delay -clock $clk -max -add_delay 2.000 $port
			}
		}
	}

	# -------------------------------------------------------------------------
	# Asynchronous outputs (false paths)
	# -------------------------------------------------------------------------
	#
	# Asynchronous ports list
	set names [list \
		{led_g[*]} {led_rgb[*]} {sseg_a[*]} {sseg_c[*]} uart_txd \
	]

	# Additional outputs
	if {[llength $outputs]} {
		lappend names {*}$outputs
	}

	# False path and dummy input delays
	foreach name $names {
		set ports [get_ports -quiet $name]
		set len [llength $ports]
		for {set i 0} {$i < $len} {incr i} {
			set port [lindex $ports $i]
			set port_name [get_property NAME $port]

			# Find the clock source for the output
			set path [get_timing_paths -quiet -to $port]
			set clk [get_property -quiet STARTPOINT_CLOCK $path]

			# Output delay constraints
			# (to suppress the Vivado warning that they are missing)
			if {[llength $clk]} {
				puts "timing_constraints.tcl: $port_name clk = $clk"

				# False path
				set_false_path -to $port

				# Output delay constraints
				set_output_delay -clock $clk -min -add_delay 1.000 $port
				set_output_delay -clock $clk -max -add_delay 2.000 $port
			}
		}
	}
	return
}

# -----------------------------------------------------------------------------
# Check Debug Hub Clock
# -----------------------------------------------------------------------------
#
# The parameters C_CLK_INPUT_FREQ_HZ and C_ENABLE_CLK_DIVIDER determine the
# debug clock implementation. If C_ENABLE_CLK_DIVIDER is false, then the
# value of C_CLK_INPUT_FREQ_HZ is ignored, and a 100MHz clock on the
# debug hub clock input is required. This procedure checks the debug hub
# clock period is 10ns (to reflect that the designs using the debug hub were
# intended to use a debug clock of 100MHz).
#
proc check_debug_hub_clock {} {
	# Confirm the design uses the debug hub
	set hub [get_debug_cores dbg_hub]
	if {[llength $hub] == 0} {
		error "Error: Debug hub not found!"
	}
	set divider [get_property C_ENABLE_CLK_DIVIDER [get_debug_cores dbg_hub]]
	if {![string eq $divider false]} {
		error "Error: Debug hub C_ENABLE_CLK_DIVIDER should be false!"
	}

	# Get the clock
	set clk [get_clocks -of [get_pins dbg_hub/clk]]

	# Get the period
	set period [get_property PERIOD $clk]
	puts "timing_constraints.tcl: dbg_hub/clk period = $period ns"

	# Confirm that it is 10.000ns +/- 0.001
	set err [expr {abs($period-10.0)*1000}]
	if {$err > 1.0} {
		error "Error: Debug hub clock period is not 10.0ns!"
	}
	return
}
