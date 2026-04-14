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
set DEBUG_TRACE 1
set DEBUG_CYCLES 120

# -----------------------------------------------------------------------------
# Debug helpers
# -----------------------------------------------------------------------------

proc ex_hex {path} {
    return [string trim [examine -radix hex $path]]
}

proc ex_dec {path} {
    return [string trim [examine -radix decimal $path]]
}

proc print_cycle_debug {cycle} {
    set pc        [ex_hex /processor_tb/uut/IF_stage/PC]
    set if_ir     [ex_hex /processor_tb/uut/IF_IR]
    set ifid_ir   [ex_hex /processor_tb/uut/IFID_IR]
    set idex_ir   [ex_hex /processor_tb/uut/IDEX_IR]
    set ex_ir     [ex_hex /processor_tb/uut/EX_IR_out]
    set ex_alu    [ex_hex /processor_tb/uut/EX_ALUResult_out]
    set ex_taken  [string trim [examine /processor_tb/uut/EX_BranchTaken]]
    set ex_tgt    [ex_hex /processor_tb/uut/EX_BranchTarget]
    set stall     [string trim [examine /processor_tb/uut/stall]]
    set hz_ex     [string trim [examine /processor_tb/uut/hazard_ex]]
    set hz_mem    [string trim [examine /processor_tb/uut/hazard_mem]]
    set hz_wb     [string trim [examine /processor_tb/uut/hazard_wb]]
    set wb_en     [string trim [examine /processor_tb/uut/WB_regfile_write_en]]
    set wb_rd     [ex_dec /processor_tb/uut/WB_regfile_write_addr]
    set wb_data   [ex_hex /processor_tb/uut/WB_regfile_write_data]

    puts [format "C%04d PC=%s IF=%s IFID=%s IDEX=%s EXIR=%s EXALU=%s TAKEN=%s TGT=%s ST=%s HZ(e/m/w)=%s/%s/%s WB(en,rd,data)=%s,%s,%s" \
        $cycle $pc $if_ir $ifid_ir $idex_ir $ex_ir $ex_alu $ex_taken $ex_tgt $stall $hz_ex $hz_mem $hz_wb $wb_en $wb_rd $wb_data]
}


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
if {$DEBUG_TRACE} {
    set trace_cycles $DEBUG_CYCLES
    if {$trace_cycles > $NUM_CYCLES} {
        set trace_cycles $NUM_CYCLES
    }

    puts "--- DEBUG TRACE (first $trace_cycles cycles) ---"
    for {set c 1} {$c <= $trace_cycles} {incr c} {
        run 1ns
        print_cycle_debug $c
    }

    set remaining [expr {$NUM_CYCLES - $trace_cycles}]
    if {$remaining > 0} {
        puts "Running remaining $remaining cycles..."
        run ${remaining}ns
    }
} else {
    run ${NUM_CYCLES}ns
}
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
