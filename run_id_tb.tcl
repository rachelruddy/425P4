# =============================================================================
# run_id_tb.tcl
# ECSE 425 - Pipelined RISC-V Processor
# =============================================================================
# Runs the instruction_decode testbench.
# No memory loading needed since IR is driven directly by the testbench and is
# isolated form IF.
#
# Usage (in ModelSim console):
#   do run_id_tb.tcl
# =============================================================================

set SRC_DIR    "."
set LIB        "work"
set TB_ENTITY  "id_tb"

# Number of cycles to run
set NUM_CYCLES  200

if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

# Order matters — instruction_decode before its testbench
vcom -2008 -work $LIB $SRC_DIR/instruction_decode.vhd
vcom -2008 -work $LIB $SRC_DIR/id_tb.vhd

puts "Compilation complete."
vsim -t 1ps $LIB.$TB_ENTITY
set IterationLimit 100000


# =============================================================================
# Load initial register values into the register file
# x0=0, x1=5, x2=3, rest=0
# =============================================================================
if {[file exists "regs_init.txt"]} {
    puts "Loading register initial values..."
    mem load -infile regs_init.txt -format binary /id_tb/uut/regs
    puts "Registers loaded."
} else {
    puts "WARNING: regs_init.txt not found - registers will be all zeros."
}

puts "Running simulation for $NUM_CYCLES cycles..."
run ${NUM_CYCLES}ns
puts "Done."