# -----------------------------------------------------------------------------
# constraints.tcl
#
# 6/13/2026 D. W. Hawkins (dwh@caltech.edu)
#
# Real Digital Blackboard constraints.
#
# -----------------------------------------------------------------------------

# Messages are written to build/vivado/blackboard.runs/impl_1/runme.log
puts "constraints.tcl: [string repeat = 80]"
puts "constraints.tcl: Running the constraints file!"

# ACTIVE_STEP = init_design
if {[info exists ACTIVE_STEP]} {
	puts "constraints.tcl: ACTIVE_STEP = $ACTIVE_STEP"
}

# -----------------------------------------------------------------------------
# Constraints Procedures
# -----------------------------------------------------------------------------
#
# The unmanaged constraint is marked for use in "Implementation".
#  * puts [file normalize [info script]]
#    ends with build/vivado/blackboard.runs/impl_1/blackboard.tcl
#  * puts [pwd]
#    ends with build/vivado/blackboard.runs/impl_1/
#
# Extract the path to the project directory
set path [file split [pwd]]
set len  [llength $path]
set top  [file join {*}[lrange $path 0 [expr {$len - 5}]]]

# Constraints procedures directory (common scripts)
set constraints [file normalize $top/../../tcl]

# Check the directory exists
if {![file isdirectory $constraints]} {
	error "Error: Blackboard constraints directory not found! ($constraints)"
}

# Read the pin constraints procedures
set filename $constraints/blackboard_pin_constraints.tcl
if {![file exists $filename]} {
	error "Error: Blackboard pin constraints script not found!"
}
source $filename

# Read the timing constraints procedures
set filename $constraints/blackboard_timing_constraints.tcl
if {![file exists $filename]} {
	error "Error: Blackboard timing constraints script not found!"
}
source $filename

# -----------------------------------------------------------------------------
# Project-specific Constraints
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Pin Constraints
# -----------------------------------------------------------------------------
#
# Ports used in the design
set ports [lsort [concat [get_ports *]]]

# Default pin constraints (no modifications required)
set pin_constraints [get_pin_constraints]

# Apply pin constraints
apply_pin_constraints $ports $pin_constraints

# -----------------------------------------------------------------------------
# Timing Constraints
# -----------------------------------------------------------------------------
#
# Apply clock constraints
apply_clock_constraints

# Apply false paths
apply_false_paths

