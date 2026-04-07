# =============================================================================
# run_all_tb.tcl
# ECSE 425 - Pipelined RISC-V Processor
# =============================================================================
# The plan for this plan is to contain all the testbenches for the individual component and you just comment out the ones you aren't using
# So far I've onlu got the one for instruction_fetch
#
# Usage (in ModelSim console):
#   do run_all_tb.tcl
# =============================================================================


# -----------------------------------------------------------------------------
# 1. instruction_fetch (make sure you've got factorial_bin.txt in your dir)
# -----------------------------------------------------------------------------

set SRC_DIR    "."
set LIB        "work"
set TB_ENTITY  "instruction_fetch_tb"
set PROGRAM_IN "factorial_bin.txt"

# Number of cycles to run
set NUM_CYCLES  200


if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

# Order matters — memory must be compiled before instruction_fetch,
# and instruction_fetch before its testbench
vcom -2008 -work $LIB $SRC_DIR/memory.vhd
vcom -2008 -work $LIB $SRC_DIR/instruction_fetch.vhd
vcom -2008 -work $LIB $SRC_DIR/instruction_fetch_tb.vhd

puts "Compilation complete."

vsim -t 1ns $LIB.$TB_ENTITY


# -----------------------------------------------------------------------------
# Load program.txt into instruction memory using mem load
# -----------------------------------------------------------------------------
# mem load bypasses the port interface and writes directly into the memory
# array inside the simulation — no changes to your VHDL needed.
#
# The path follows the hierarchy:
#   /instruction_fetch_tb  <- testbench entity
#       /uut               <- instruction_fetch instance (labeled uut in tb)
#           /instr_memory  <- memory instance inside instruction_fetch
#               /ram_block       <- the actual array signal inside memory.vhd
#
# ADAPT: If the memory array signal inside memory.vhd is not called "ram",
#        update the last part of the path below.
# -----------------------------------------------------------------------------

if {[file exists $PROGRAM_IN]} {
    puts "Loading $PROGRAM_IN into instruction memory..."
    mem load -infile $PROGRAM_IN -format binary \
        /instruction_fetch_tb/uut/instr_memory/ram_block
    puts "Program loaded successfully."
} else {
    puts "WARNING: $PROGRAM_IN not found — instruction memory will be all zeros."
    puts "         IR output will not reflect real instructions."
    puts "         NPC tests will still run correctly."
}


puts "Running simulation for $NUM_CYCLES cycles..."
run ${NUM_CYCLES}ns
puts "Done."