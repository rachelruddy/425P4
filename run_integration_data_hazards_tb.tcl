# =============================================================================
# run_integration_data_hazards_tb.tcl
# use: do run_integration_data_hazards_tb.tcl
# =============================================================================

set SRC_DIR    "."
set LIB        "work"
set TB_ENTITY  "integration_data_hazards_tb"
set PROGRAM_IN "integration_data_hazards_bin.txt"
set REG_INIT   "regs_init.txt"

set NUM_CYCLES 250

# clean + compile
if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

vcom -2008 -work $LIB $SRC_DIR/memory.vhd
vcom -2008 -work $LIB $SRC_DIR/ALU.vhd
vcom -2008 -work $LIB $SRC_DIR/register_file.vhd
vcom -2008 -work $LIB $SRC_DIR/instruction_fetch.vhd
vcom -2008 -work $LIB $SRC_DIR/instruction_decode.vhd
vcom -2008 -work $LIB $SRC_DIR/execute.vhd
vcom -2008 -work $LIB $SRC_DIR/writeback.vhd
vcom -2008 -work $LIB $SRC_DIR/mem_pipeline.vhd
vcom -2008 -work $LIB $SRC_DIR/processor.vhd
vcom -2008 -work $LIB $SRC_DIR/integration_data_hazards_tb.vhd

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
        /integration_data_hazards_tb/uut/IF_stage/instr_memory/ram_block
    puts "Program loaded successfully."
} else {
    puts "WARNING: $PROGRAM_IN not found."
}

# -----------------------------------------------------------------------------
# Load register file after reset high phase
# -----------------------------------------------------------------------------
run 1.1ns

if {[file exists $REG_INIT]} {
    puts "Loading register file..."
    mem load -infile $REG_INIT -format binary \
        /integration_data_hazards_tb/uut/RF_stage/regs
    puts "Register file loaded."
} else {
    puts "WARNING: $REG_INIT not found - registers default to 0."
}

# waves (same style)
add wave /integration_data_hazards_tb/clk
add wave /integration_data_hazards_tb/reset

add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_IF_IR
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_ID_IR
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_IDEX_IR
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_EX_IR_out
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_EXMEM_IR_out
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_MEM_IR_out
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_MEMWB_IR_out

add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_EX_ALUResult_out
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_MEMWB_ALUResult_out

add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_WB_regfile_write_en
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_WB_regfile_write_addr
add wave -radix hexadecimal /integration_data_hazards_tb/uut/dbg_WB_regfile_write_data

# run
run ${NUM_CYCLES}ns

puts "Expected (data-hazard chain):"
puts "x1=5, x2=12, x3=17, x4=12, x5=0, x6=12, x7=1, x8=10"

puts "Register file contents:"
mem display -startaddress 0 -endaddress 31 \
    /integration_data_hazards_tb/uut/RF_stage/regs

puts "Done."
