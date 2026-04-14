# =============================================================================
# run_mem_tb.tcl
# ECSE 425 - Pipelined RISC-V Processor
# =============================================================================
# What this file does:
#   1. Compiles memory.vhd and mem_pipeline.vhd and mem_tb.vhd
#   2. Loads the simulation
#   3. Runs the testbench
#   4. Dumps data memory contents to memory.txt so you can verify
#      that SW wrote the correct values to the correct addresses
#
# Usage (in ModelSim console):
#   do run_mem_tb.tcl
# =============================================================================

set SRC_DIR   "."
set LIB       "work"
set TB_ENTITY "mem_tb"
set MEM_WORDS 8192
set MEM_OUT   "memory.txt"

# -----------------------------------------------------------------------------
# 1. Compile
# -----------------------------------------------------------------------------
if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

# Order matters — memory first
vcom -2008 -work $LIB $SRC_DIR/memory.vhd
vcom -2008 -work $LIB $SRC_DIR/mem_pipeline.vhd
vcom -2008 -work $LIB $SRC_DIR/mem_tb.vhd

puts "Compilation complete."

# -----------------------------------------------------------------------------
# 2. Load simulation
# -----------------------------------------------------------------------------
vsim -t 1ps work.$TB_ENTITY

# -----------------------------------------------------------------------------
# 3. Run the simulation
# -----------------------------------------------------------------------------
puts "Running mem_pipeline testbench..."
run 200ns
puts "Simulation complete."

# -----------------------------------------------------------------------------
# 4. Dump data memory -> memory.txt
# -----------------------------------------------------------------------------
# 
#
# ADAPT: update path if your mem_stage instance name differs
#   /mem_stage_tb/uut         <- mem_stage instance (labeled uut)
#   /data_mem                 <- memory instance inside mem_stage
#   /ram_block                <- memory array signal inside memory.vhd

puts "Dumping data memory to $MEM_OUT..."
set mem_file [open $MEM_OUT w]


for {set i 0} {$i < $MEM_WORDS} {incr i} {
    set word [examine -radix hexadecimal /mem_tb/uut/data_mem/ram_block($i)]
    set word [string map {" " ""} $word]  
    puts $mem_file "Address $i (byte 0x[format %08X [expr {$i * 4}]]): 0x$word"
}

       

close $mem_file

puts ""
puts "====================================================="
puts " mem_stage testbench complete."
puts "   Memory dump written to: $MEM_OUT"
puts "====================================================="