# =============================================================================
# run_alu_tb.tcl
# ECSE 425 - Pipelined RISC-V Processor
# =============================================================================
# Yeah my plan to use just 1 tcl wont work bc tcl wont let you comment blocks at once source
# this on just runs the alu testbench
#
# Usage (in ModelSim console):
#   do run_alu_tb.tcl
# =============================================================================


set SRC_DIR    "."
set LIB        "work"
set TB_ENTITY  "alu_tb"

# Number of cycles to run
set NUM_CYCLES  200


if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

# Order matters 
vcom -2008 -work $LIB $SRC_DIR/ALU.vhd
vcom -2008 -work $LIB $SRC_DIR/alu_tb.vhd

puts "Compilation complete."

vsim -t 1ps $LIB.$TB_ENTITY
set IterationLimit 100000

puts "Running simulation for $NUM_CYCLES cycles..."
run ${NUM_CYCLES}ns
puts "Done."