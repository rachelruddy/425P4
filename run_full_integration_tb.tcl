# =============================================================================
# run_full_integration_tb.tcl
# use: do run_full_integration_tb.tcl
# =============================================================================

set SRC_DIR    "."
set LIB        "work"
set TB_ENTITY  "full_integration_tb"
set PROGRAM_IN "full_integration_bin.txt"
set REG_INIT   "regs_init.txt"

set NUM_CYCLES 200

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
vcom -2008 -work $LIB $SRC_DIR/full_integration_tb.vhd


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
        /full_integration_tb/uut/IF_stage/instr_memory/ram_block
    puts "Program loaded successfully."
} else {
    puts "WARNING: $PROGRAM_IN not found."
}

# -----------------------------------------------------------------------------
# Load register file- had to change run 3ns isntead of previous 1.1ns
# because reset was high  when we were trying to write RF values, causing 
# RF values to all be 0 and not loaded
# -----------------------------------------------------------------------------
run 1.1ns 

if {[file exists $REG_INIT]} {
    puts "Loading register file..."
    mem load -infile $REG_INIT -format binary \
        /full_integration_tb/uut/RF_stage/regs
    puts "Register file loaded."
} else {
    puts "WARNING: $REG_INIT not found - registers default to 0."
}

# waves (ordered)

# clock + reset
add wave /full_integration_tb/clk
add wave /full_integration_tb/reset

# IR
add wave -radix hexadecimal /full_integration_tb/uut/dbg_IF_IR
add wave -radix hexadecimal /full_integration_tb/uut/dbg_ID_IR
add wave -radix hexadecimal /full_integration_tb/uut/dbg_B
add wave -radix hexadecimal /full_integration_tb/uut/dbg_IDEX_IR
add wave -radix hexadecimal /full_integration_tb/uut/dbg_EX_IR_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_EXMEM_IR_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEM_IR_out

add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_ALUResult_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_LMD_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_IR_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_NPC_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_Jump_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_JumpReg_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_RegWrite_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_MemToReg_out
add wave -radix hexadecimal /full_integration_tb/uut/dbg_MEMWB_rd_out


add wave -radix hexadecimal /full_integration_tb/uut/dbg_WB_regfile_write_en
add wave -radix hexadecimal /full_integration_tb/uut/dbg_WB_regfile_write_addr
add wave -radix hexadecimal /full_integration_tb/uut/dbg_WB_regfile_write_data

# register file contents
add wave -radix decimal /full_integration_tb/uut/RF_stage/regs(0)
add wave -radix decimal /full_integration_tb/uut/RF_stage/regs(1)
add wave -radix decimal /full_integration_tb/uut/RF_stage/regs(2)
add wave -radix decimal /full_integration_tb/uut/RF_stage/regs(3)
add wave -radix decimal /full_integration_tb/uut/RF_stage/regs(4)
add wave -radix decimal /full_integration_tb/uut/RF_stage/regs(5)


# run
run ${NUM_CYCLES}ns

# check data memory at word address 0 (should contain 3 after SW)
#puts "Data memory at address 0:"
#mem display -startaddress 0 -endaddress 0 \
    /full_integration_tb/uut/MEM_stage/data_mem/ram_block

# show register file contents
puts "Register file contents:"
mem display -startaddress 0 -endaddress 31 \
    /full_integration_tb/uut/RF_stage/regs

puts "Done."