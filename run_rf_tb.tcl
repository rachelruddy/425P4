# =============================================================================
# run_rf_tb.tcl
# ECSE 425 - Pipelined RISC-V Processor
# =============================================================================
# Runs the register_file testbench.
# Usage (in ModelSim console):
#   do run_rf_tb.tcl
# =============================================================================

set SRC_DIR    "."
set LIB        "work"
set TB_ENTITY  "rf_tb"

# Number of cycles to run
set NUM_CYCLES  200

if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

# Order matters — register_file before its testbench
vcom -2008 -work $LIB $SRC_DIR/register_file.vhd
vcom -2008 -work $LIB $SRC_DIR/rf_tb.vhd

puts "Compilation complete."
vsim -t 1ps $LIB.$TB_ENTITY
set IterationLimit 100000

puts "Running simulation for $NUM_CYCLES cycles..."
run ${NUM_CYCLES}ns
puts "Done."
