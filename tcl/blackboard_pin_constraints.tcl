# -----------------------------------------------------------------------------
# blackboard_pin_constraints.tcl
#
# 6/13/2026 D. W. Hawkins (dwh@caltech.edu)
#
# Real Digital Blackboard pin constraints file.
#
# This script defines procedures for a master pin constraints dictionary
# and a pin contraints assignment procedure. Projects can modify the pin
# constraints dictionary for project-specific needs, eg., rename a pin,
# or change a pin I/O standard from the default setting, before applying
# the pin constraints.
#
# The constraint dictionary is based on the Blackboard schematic [1] and
# master constraints [2]. Some pin names were changed slightly.
#
# -----------------------------------------------------------------------------
# Notes
# ------
#
# 1. Vivado 'unmanaged' constraints file
#
#    This file is a Vivado 'unmanaged' constraints file. It will not be
#    modified by Vivado and supports all Tcl constructs. XDC files support
#    very limited Tcl syntax, eg., no conditional logic.
#
# 2. Multi-bit bus indexing
#
#    Multi-bit bus pin assignments are defined using paranthesis rather
#    than square brackets  so that the dictionary script procedures work
#    in any Tcl interpreter (not just Vivado). In the apply constraints
#    procedure, the paranthesis are converted to square brackets before
#    calls to Vivado set_property.
#
# -----------------------------------------------------------------------------
# References
# ----------
#
# [1] Real Digital, "Blackboard Schematic", 2018.
#     https://www.realdigital.org/hardware/blackboard
#     https://www.realdigital.org/downloads/bfea4bfc8ec2d05539fc8e2fa9cd66aa.pdf
#
# [2] Real Digital, "Master Constraints XDC", blackboard.xdc.
#     https://www.realdigital.org/hardware/blackboard
#     https://www.realdigital.org/downloads/615e6849c320c5615deeebaf0ea38e94.txt
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Pins Constraints Dictionary
# -----------------------------------------------------------------------------
#
# These are the default constraints. A design constraints script reads these
# default constraints and applies project-specific changes. For example:
#  * Rename pins, eg., change PMod names to project-specific names
#  * Modify pin constraints, eg., change the I/O standard  or add
#    drive strength and slew rate for output signals
#
proc get_pin_constraints {} {

	# -------------------------------------------------------------------------
	# 100MHz Clock
	# -------------------------------------------------------------------------
	#
	# * Schematic net PL_CLK
	# * MRCC clock pin on bank 34 (p6 [1]) at 3.3V (p11 [1])
	# * Oscillator (p6 [1])
	# * Microchip Technology Discera P5 family DSC6111CI2-100.0000 (+/-50ppm)
	#
	dict set pin clk_100mhz {PACKAGE_PIN H16  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# Green LEDs
	# -------------------------------------------------------------------------
	#
	# * Schematic nets LD[9:0]
	# * Pins on bank 34 (p6 [1]) at 3.3V (p11 [1])
	# * LEDs on p7 [1]
	# * LEDs 0 to 9 are located above switches 0 to 9
	#
	dict set pin led_g(0) {PACKAGE_PIN N20  IOSTANDARD LVCMOS33}
	dict set pin led_g(1) {PACKAGE_PIN P20  IOSTANDARD LVCMOS33}
	dict set pin led_g(2) {PACKAGE_PIN R19  IOSTANDARD LVCMOS33}
	dict set pin led_g(3) {PACKAGE_PIN T20  IOSTANDARD LVCMOS33}
	dict set pin led_g(4) {PACKAGE_PIN T19  IOSTANDARD LVCMOS33}
	dict set pin led_g(5) {PACKAGE_PIN U13  IOSTANDARD LVCMOS33}
	dict set pin led_g(6) {PACKAGE_PIN V20  IOSTANDARD LVCMOS33}
	dict set pin led_g(7) {PACKAGE_PIN W20  IOSTANDARD LVCMOS33}
	dict set pin led_g(8) {PACKAGE_PIN W19  IOSTANDARD LVCMOS33}
	dict set pin led_g(9) {PACKAGE_PIN Y19  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# RGB LEDs
	# -------------------------------------------------------------------------
	#
	# * Schematic nets LD[10:11]_R/G/B
	# * Pins on bank 34 (p6 [1]) at 3.3V (p11 [1])
	# * LEDs on p7 [1]
	# * mod index = [0, 1, 2] = [R, G, B]
	# * LEDs 10 and 11 are located above switches 10 and 11
	#
	dict set pin led_rgb(0) {PACKAGE_PIN W18  IOSTANDARD LVCMOS33}
	dict set pin led_rgb(1) {PACKAGE_PIN W16  IOSTANDARD LVCMOS33}
	dict set pin led_rgb(2) {PACKAGE_PIN Y18  IOSTANDARD LVCMOS33}
	#
	dict set pin led_rgb(3) {PACKAGE_PIN Y14  IOSTANDARD LVCMOS33}
	dict set pin led_rgb(4) {PACKAGE_PIN Y16  IOSTANDARD LVCMOS33}
	dict set pin led_rgb(5) {PACKAGE_PIN Y17  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# Switches
	# -------------------------------------------------------------------------
	#
	# * Schematic nets SW[0:11]
	# * Pins on banks 34+35 (p6 [1]) at 3.3V (p11 [1])
	# * Switches on p7 [1]
	# * Each switch has an LED above it (10 and 11 are RGB)
	#
	dict set pin sw(0)  {PACKAGE_PIN R17  IOSTANDARD LVCMOS33}
	dict set pin sw(1)  {PACKAGE_PIN U20  IOSTANDARD LVCMOS33}
	dict set pin sw(2)  {PACKAGE_PIN R16  IOSTANDARD LVCMOS33}
	dict set pin sw(3)  {PACKAGE_PIN N16  IOSTANDARD LVCMOS33}
	dict set pin sw(4)  {PACKAGE_PIN R14  IOSTANDARD LVCMOS33}
	dict set pin sw(5)  {PACKAGE_PIN P14  IOSTANDARD LVCMOS33}
	dict set pin sw(6)  {PACKAGE_PIN L15  IOSTANDARD LVCMOS33}
	dict set pin sw(7)  {PACKAGE_PIN M15  IOSTANDARD LVCMOS33}
	dict set pin sw(8)  {PACKAGE_PIN T10  IOSTANDARD LVCMOS33}
	dict set pin sw(9)  {PACKAGE_PIN T12  IOSTANDARD LVCMOS33}
	dict set pin sw(10) {PACKAGE_PIN T11  IOSTANDARD LVCMOS33}
	dict set pin sw(11) {PACKAGE_PIN T14  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# Push Buttons
	# -------------------------------------------------------------------------
	#
	# * Schematic nets BTN[0:3]
	# * Pins on banks 34+35 (p6 [1]) at 3.3V (p11 [1])
	# * Buttons on p7 [1]
	#
	dict set pin pb(0) {PACKAGE_PIN W14  IOSTANDARD LVCMOS33}
	dict set pin pb(1) {PACKAGE_PIN W13  IOSTANDARD LVCMOS33}
	dict set pin pb(2) {PACKAGE_PIN P15  IOSTANDARD LVCMOS33}
	dict set pin pb(3) {PACKAGE_PIN M14  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# 4 x 7-Segment Display
	# -------------------------------------------------------------------------
	#
	# * Schematic nets SSEG_AN[0:3]/SSEG_CA, B, C, D, E, F, G, P
	# * Pins on bank 35 (p6 [1]) at 3.30V (p11 [1])
	# * Display on p9 [1]
	# * sseg_a(n) LOW to turn on a segment
	#
	# Anodes
	dict set pin sseg_a(0) {PACKAGE_PIN K19  IOSTANDARD LVCMOS33}
	dict set pin sseg_a(1) {PACKAGE_PIN H17  IOSTANDARD LVCMOS33}
	dict set pin sseg_a(2) {PACKAGE_PIN M18  IOSTANDARD LVCMOS33}
	dict set pin sseg_a(3) {PACKAGE_PIN L16  IOSTANDARD LVCMOS33}

	# Cathodes (7-segment plus decimal point)
	dict set pin sseg_c(0) {PACKAGE_PIN K14  IOSTANDARD LVCMOS33}
	dict set pin sseg_c(1) {PACKAGE_PIN H15  IOSTANDARD LVCMOS33}
	dict set pin sseg_c(2) {PACKAGE_PIN J18  IOSTANDARD LVCMOS33}
	dict set pin sseg_c(3) {PACKAGE_PIN J15  IOSTANDARD LVCMOS33}
	dict set pin sseg_c(4) {PACKAGE_PIN M17  IOSTANDARD LVCMOS33}
	dict set pin sseg_c(5) {PACKAGE_PIN J16  IOSTANDARD LVCMOS33}
	dict set pin sseg_c(6) {PACKAGE_PIN H18  IOSTANDARD LVCMOS33}
	dict set pin sseg_c(7) {PACKAGE_PIN K18  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# Inertial Module (Accelerometer/Gyroscope/Magnetometer)
	# -------------------------------------------------------------------------
	#
	# * Schematic nets GYRO*
	# * Pins on banks 35 (p6 [1]) at 3.30V (p11 [1])
	# * Module on p8 [1]
	#
	dict set pin gyro_scl     {PACKAGE_PIN H20  IOSTANDARD LVCMOS33}
	dict set pin gyro_sda     {PACKAGE_PIN J19  IOSTANDARD LVCMOS33}
	dict set pin gyro_sdo_a_g {PACKAGE_PIN J20  IOSTANDARD LVCMOS33}
	dict set pin gyro_sdo_m   {PACKAGE_PIN L17  IOSTANDARD LVCMOS33}
	dict set pin gyro_cs_a_g  {PACKAGE_PIN K17  IOSTANDARD LVCMOS33}
	dict set pin gyro_cs_m    {PACKAGE_PIN K16  IOSTANDARD LVCMOS33}
	dict set pin gyro_den_a_g {PACKAGE_PIN J14  IOSTANDARD LVCMOS33}
	dict set pin gyro_drdy_m  {PACKAGE_PIN L20  IOSTANDARD LVCMOS33}
	dict set pin gyro_int_a_g {PACKAGE_PIN M20  IOSTANDARD LVCMOS33}
	dict set pin gyro_int_m   {PACKAGE_PIN L19  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# Microphone
	# -------------------------------------------------------------------------
	#
	# * Schematic nets M_CLK, M_DATA
	# * Pins on banks 35 (p6 [1]) at 3.30V (p11 [1])
	# * Microphone on p8 [1]
	#
	dict set pin mic_clk  {PACKAGE_PIN N15  IOSTANDARD LVCMOS33}
	dict set pin mic_data {PACKAGE_PIN L14  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# Speaker
	# -------------------------------------------------------------------------
	#
	# * Schematic net SPEAKER
	# * Pin on bank 35 (p6 [1]) at 3.30V (p11 [1])
	# * Speaker (analog filter) on p8 [1]
	#
	dict set pin speaker {PACKAGE_PIN G18  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# HDMI Interface
	# -------------------------------------------------------------------------
	#
	# * Schematic nets HDMI*
	# * Pin on banks 34+35 (p6 [1]) at 3.30V (p11 [1])
	# * HDMI interface on p10 [1]
	#
	dict set pin hdmi_clk_n   {PACKAGE_PIN U19  IOSTANDARD LVCMOS33}
	dict set pin hdmi_clk_p   {PACKAGE_PIN U18  IOSTANDARD LVCMOS33}
	dict set pin hdmi_tx_n(0) {PACKAGE_PIN V18  IOSTANDARD LVCMOS33}
	dict set pin hdmi_tx_p(0) {PACKAGE_PIN V17  IOSTANDARD LVCMOS33}
	dict set pin hdmi_tx_n(1) {PACKAGE_PIN P18  IOSTANDARD LVCMOS33}
	dict set pin hdmi_tx_p(1) {PACKAGE_PIN N17  IOSTANDARD LVCMOS33}
	dict set pin hdmi_tx_n(2) {PACKAGE_PIN P19  IOSTANDARD LVCMOS33}
	dict set pin hdmi_tx_p(2) {PACKAGE_PIN N18  IOSTANDARD LVCMOS33}
	dict set pin hdmi_cec     {PACKAGE_PIN U17  IOSTANDARD LVCMOS33}
	dict set pin hdmi_hpd     {PACKAGE_PIN P16  IOSTANDARD LVCMOS33}
	dict set pin hdmi_out_en  {PACKAGE_PIN F17  IOSTANDARD LVCMOS33}
	dict set pin hdmi_scl     {PACKAGE_PIN T17  IOSTANDARD LVCMOS33}
	dict set pin hdmi_sda     {PACKAGE_PIN R18  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# PMods
	# -------------------------------------------------------------------------
	#
	# * Pins on banks 34+35 (p6 [1]) at 3.30V (p11 [1])
	# * PMod connectors on p9 [1]
	# * JA and JB have 200-ohm series resistors
	# * JC has 1k-ohm series resistors
	#

	# PModA (JA[1:4]_P/N)
	dict set pin pmod_a(0) {PACKAGE_PIN F16  IOSTANDARD LVCMOS33}
	dict set pin pmod_a(1) {PACKAGE_PIN F17  IOSTANDARD LVCMOS33}
	dict set pin pmod_a(2) {PACKAGE_PIN G19  IOSTANDARD LVCMOS33}
	dict set pin pmod_a(3) {PACKAGE_PIN G20  IOSTANDARD LVCMOS33}
	dict set pin pmod_a(4) {PACKAGE_PIN E18  IOSTANDARD LVCMOS33}
	dict set pin pmod_a(5) {PACKAGE_PIN E19  IOSTANDARD LVCMOS33}
	dict set pin pmod_a(6) {PACKAGE_PIN E17  IOSTANDARD LVCMOS33}
	dict set pin pmod_a(7) {PACKAGE_PIN D18  IOSTANDARD LVCMOS33}

	# PModB (JB[1:4]_P/N)
	dict set pin pmod_b(0) {PACKAGE_PIN D19  IOSTANDARD LVCMOS33}
	dict set pin pmod_b(1) {PACKAGE_PIN D20  IOSTANDARD LVCMOS33}
	dict set pin pmod_b(2) {PACKAGE_PIN F19  IOSTANDARD LVCMOS33}
	dict set pin pmod_b(3) {PACKAGE_PIN F20  IOSTANDARD LVCMOS33}
	dict set pin pmod_b(4) {PACKAGE_PIN C20  IOSTANDARD LVCMOS33}
	dict set pin pmod_b(5) {PACKAGE_PIN B20  IOSTANDARD LVCMOS33}
	dict set pin pmod_b(6) {PACKAGE_PIN B19  IOSTANDARD LVCMOS33}
	dict set pin pmod_b(7) {PACKAGE_PIN A20  IOSTANDARD LVCMOS33}

	# PModC (JC[1:4, 7:10])
	dict set pin pmod_c(0) {PACKAGE_PIN V15  IOSTANDARD LVCMOS33}
	dict set pin pmod_c(1) {PACKAGE_PIN W15  IOSTANDARD LVCMOS33}
	dict set pin pmod_c(2) {PACKAGE_PIN V16  IOSTANDARD LVCMOS33}
	dict set pin pmod_c(3) {PACKAGE_PIN T16  IOSTANDARD LVCMOS33}
	dict set pin pmod_c(4) {PACKAGE_PIN M19  IOSTANDARD LVCMOS33}
	dict set pin pmod_c(5) {PACKAGE_PIN G14  IOSTANDARD LVCMOS33}
	dict set pin pmod_c(6) {PACKAGE_PIN G17  IOSTANDARD LVCMOS33}
	dict set pin pmod_c(7) {PACKAGE_PIN G15  IOSTANDARD LVCMOS33}

	# -------------------------------------------------------------------------
	# Servo Motor Connections
	# -------------------------------------------------------------------------
	#
	# * Schematic nets SERVO[0:3]
	# * Pins on banks 34 (p6 [1]) at 3.30V (p11 [1])
	#
	dict set pin servo(0) {PACKAGE_PIN G17  IOSTANDARD LVCMOS33}
	dict set pin servo(1) {PACKAGE_PIN G15  IOSTANDARD LVCMOS33}
	dict set pin servo(2) {PACKAGE_PIN G14  IOSTANDARD LVCMOS33}
	dict set pin servo(3) {PACKAGE_PIN M19  IOSTANDARD LVCMOS33}

	# Return dictionary
	return $pin
}

# -----------------------------------------------------------------------------
# Apply Pin Constraints
# -----------------------------------------------------------------------------
#
# This procedure takes two arguments:
#
# * 'ports' is a list of top-level pin names  eg.
#
#   tcl> set ports [lsort [concat [get_ports *]]]
#
# * 'pin_constraints' is the constraints dictionary
#
#   tcl> set pin_constraints [get_pin_constraints]
#
#   The dictionary content can be manipulated to rename pins  or to modify
#   constraint values (or to add new constraints).
#
proc apply_pin_constraints {ports pin_constraints {unused Pullup}} {

	# Unused pins
	# * unused = Pullup, Pulldown, or Pullnone
	set_property BITSTREAM.CONFIG.UNUSEDPIN $unused [current_design]

	# Loop over the top-level ports list
	foreach port $ports {

		# Convert port name (with square brackets) to pin name
		# * Replace square brackets with paranthesis
		set pin [string map {\[ ( \] )} $port]

		# Check that the pin name exists in the dictionary
		# * Top-level port names must match the dictionary names
		if {![dict exists $pin_constraints $pin]} {
			error "Error: Invalid top-level port name $port!"
		}

		# Apply the pin constraints
		set constraints [dict get $pin_constraints $pin]
		dict for {key val} $constraints {

			# Print the package pin
			if {[string equal $key "PACKAGE_PIN"] == 1} {
				puts "pin_constraints.tcl: $port $val"
			}

			# Execute the Vivado constraint
			set_property $key $val $port
#			puts "pin_constraints.tcl: set_property $key $val $port"
		}
	}
	return
}
