# =============================================================================
# run_integration_if_id_tb.tcl
# use: do run_integration_if_id_ex_mem_tb.tcl
# =============================================================================

set SRC_DIR    "."
set LIB        "work"
set TB_ENTITY  "integration_if_id_ex_mem_tb"
set PROGRAM_IN "integration_if_id_ex_mem_bin.txt"
set REG_INIT   "regs_init.txt"

set NUM_CYCLES 100

# clean + compile
if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

vcom -2008 -work $LIB $SRC_DIR/memory.vhd
vcom -2008 -work $LIB $SRC_DIR/instruction_fetch.vhd
vcom -2008 -work $LIB $SRC_DIR/instruction_decode.vhd
vcom -2008 -work $LIB $SRC_DIR/register_file.vhd
vcom -2008 -work $LIB $SRC_DIR/execute.vhd
vcom -2008 -work $LIB $SRC_DIR/processor.vhd
vcom -2008 -work $LIB $SRC_DIR/mem_pipeline.vhd
vcom -2008 -work $LIB $SRC_DIR/integration_if_id_ex_mem_tb.vhd
vcom -2008 -work $LIB $SRC_DIR/ALU.vhd

puts "Compilation complete."

# simulate
vsim -t 1ps $LIB.$TB_ENTITY
radix decimal

# -----------------------------------------------------------------------------
# Load instruction memory
# -----------------------------------------------------------------------------
if {[file exists $PROGRAM_IN]} {
    puts "Loading $PROGRAM_IN into instruction memory..."
    mem load -infile $PROGRAM_IN -format binary \
        /integration_if_id_ex_mem_tb/uut/IF_stage/instr_memory/ram_block
    puts "Program loaded successfully."
} else {
    puts "WARNING: $PROGRAM_IN not found."
}

# -----------------------------------------------------------------------------
# Load register file- had to change run 3ns isntead of previous 1.1ns
# because reset was high  when we were trying to write RF values, causing 
# RF values to all be 0 and not loaded
# -----------------------------------------------------------------------------
run 3ns 

if {[file exists $REG_INIT]} {
    puts "Loading register file..."
    mem load -infile $REG_INIT -format binary \
        /integration_if_id_ex_mem_tb/uut/RF_stage/regs
    puts "Register file loaded."
} else {
    puts "WARNING: $REG_INIT not found - registers default to 0."
}

# waves (ordered)

# clock + reset
add wave /integration_if_id_ex_mem_tb/clk
add wave /integration_if_id_ex_mem_tb/reset

# IR
add wave -radix hexadecimal /integration_if_id_ex_mem_tb/uut/dbg_IF_IR
add wave -radix hexadecimal /integration_if_id_ex_mem_tb/uut/dbg_B




# run
run ${NUM_CYCLES}ns

# check data memory at word address 0 (should contain 3 after SW)
puts "Data memory at address 0:"
mem display -startaddress 0 -endaddress 0 \
    /integration_if_id_ex_mem_tb/uut/MEM_stage/data_mem/ram_block

# show register file contents
puts "Register file contents:"
mem display -startaddress 0 -endaddress 31 \
    /integration_if_id_ex_mem_tb/uut/RF_stage/regs

puts "Done."