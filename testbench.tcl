# =============================================================================
# testbench.tcl
# ECSE 425 - Pipelined RISC-V Processor
# =============================================================================
# What this file does:
#   1. Compiles all VHDL source files
#   2. Loads the simulation
#   3. Asserts reset
#   4. Loads program.txt into instruction memory via mem load
#   5. Releases reset and runs for 10,000 clock cycles
#   6. Dumps data memory    -> memory.txt        (8192 lines)
#   7. Dumps register file  -> register_file.txt (32 lines)
#
# Usage (in ModelSim console):
#   do testbench.tcl
#
# 
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Configuration
# -----------------------------------------------------------------------------

set SRC_DIR     "."
set LIB         "work"
set TB_ENTITY   "processor_tb"
set PROGRAM_IN  "factorial_bin.txt"
set MEM_OUT     "memory.txt"
set REGFILE_OUT "register_file.txt"
set MEM_WORDS   8192
set NUM_REGS    32
set NUM_CYCLES  10000


# -----------------------------------------------------------------------------
# 1. Compile all VHDL source files
# -----------------------------------------------------------------------------

if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

# ADAPT: list files in compilation order — dependencies first
# Example order based on your project files:
vcom -2008 -work $LIB $SRC_DIR/memory.vhd
vcom -2008 -work $LIB $SRC_DIR/ALU.vhd
vcom -2008 -work $LIB $SRC_DIR/register_file.vhd
vcom -2008 -work $LIB $SRC_DIR/instruction_fetch.vhd
vcom -2008 -work $LIB $SRC_DIR/instruction_decode.vhd
vcom -2008 -work $LIB $SRC_DIR/execute.vhd
vcom -2008 -work $LIB $SRC_DIR/mem_pipeline.vhd
vcom -2008 -work $LIB $SRC_DIR/writeback.vhd
vcom -2008 -work $LIB $SRC_DIR/processor.vhd
vcom -2008 -work $LIB $SRC_DIR/processor_tb.vhd

puts "Compilation complete."


# -----------------------------------------------------------------------------
# 2. Load the simulation
# -----------------------------------------------------------------------------

vsim -t 1ps $LIB.$TB_ENTITY


# -----------------------------------------------------------------------------
# 3. Assert reset
# -----------------------------------------------------------------------------
force -freeze /processor_tb/reset 1 0


# -----------------------------------------------------------------------------
# 4. Load program.txt into instruction memory
# -----------------------------------------------------------------------------

if {[file exists $PROGRAM_IN]} {
    puts "Loading $PROGRAM_IN into instruction memory..."
    mem load -infile $PROGRAM_IN -format binary \
        /processor_tb/uut/IF_stage/instr_memory/ram_block
    puts "Program loaded successfully."
} else {
    puts "ERROR: $PROGRAM_IN not found — make sure it is in the same folder as this script."
    quit
}


# -----------------------------------------------------------------------------
# 5. Release reset and run for 10,000 clock cycles
# -----------------------------------------------------------------------------

# give memory a couple cycles to settle before releasing reset
run 2ns

# release reset
force -freeze /processor_tb/reset 0 0

# run for 10,000 cycles (10,000 ns at 1 GHz)
puts "Running simulation for $NUM_CYCLES cycles..."
run ${NUM_CYCLES}ns
puts "Simulation complete."


# -----------------------------------------------------------------------------
# 6. Dump data memory -> memory.txt
# -----------------------------------------------------------------------------
# Reads every word of data memory and writes as a 32-char binary string.
# Output has 8192 lines, one per 32-bit word, as required by the spec.
#

puts "Writing data memory to $MEM_OUT..."
set mem_file [open $MEM_OUT w]

for {set i 0} {$i < $MEM_WORDS} {incr i} {
    # ADAPT: update this path
    set word [examine -radix binary /processor_tb/uut/MEM_stage/data_mem/ram_block($i)]
    set word [string map {" " ""} $word]
    set word [format "%032s" $word]
    set word [string map {" " "0"} $word]
    puts $mem_file $word
}

close $mem_file
puts "Wrote $MEM_WORDS words to $MEM_OUT."


# -----------------------------------------------------------------------------
# 7. Dump register file -> register_file.txt
# -----------------------------------------------------------------------------
# Reads each of the 32 registers and writes as a 32-char binary string.
# x0 should always be 0x00000000.
#

puts "Writing register file to $REGFILE_OUT..."
set reg_file [open $REGFILE_OUT w]

for {set i 0} {$i < $NUM_REGS} {incr i} {
    set word [examine -radix binary /processor_tb/uut/RF_stage/regs($i)]
    set word [string map {" " ""} $word]
    set word [format "%032s" $word]
    set word [string map {" " "0"} $word]
    puts $reg_file $word
}

close $reg_file
puts "Wrote $NUM_REGS registers to $REGFILE_OUT."


# -----------------------------------------------------------------------------
# 8. Done
# -----------------------------------------------------------------------------
puts ""
puts "====================================================="
puts " Testbench complete."
puts "   Program loaded from      : $PROGRAM_IN"
puts "   Data memory written to   : $MEM_OUT"
puts "   Register file written to : $REGFILE_OUT"
puts "====================================================="
