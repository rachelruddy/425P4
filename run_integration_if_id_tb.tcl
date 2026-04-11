# =============================================================================
# run_integration_if_id_tb.tcl
# use: do run_integration_if_id_tb.tcl
# =============================================================================

set SRC_DIR    "."
set LIB        "work"
set TB_ENTITY  "integration_if_id_tb"
set PROGRAM_IN "integration_if_id_test_bin.txt"
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
vcom -2008 -work $LIB $SRC_DIR/processor.vhd
vcom -2008 -work $LIB $SRC_DIR/integration_if_id_tb.vhd

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
        /integration_if_id_tb/uut/IF_stage/instr_memory/ram_block
    puts "Program loaded successfully."
} else {
    puts "WARNING: $PROGRAM_IN not found."
}

# -----------------------------------------------------------------------------
# Load register file
# -----------------------------------------------------------------------------
if {[file exists $REG_INIT]} {
    puts "Loading register file..."
    mem load -infile $REG_INIT -format binary \
        /integration_if_id_tb/uut/ID_stage/regs
    puts "Register file loaded."
} else {
    puts "WARNING: $REG_INIT not found - registers default to 0."
}

# waves
add wave *

add wave -radix binary /integration_if_id_tb/uut/dbg_ALUFunc
add wave -radix binary /integration_if_id_tb/uut/dbg_ALUOp
add wave -radix binary /integration_if_id_tb/uut/dbg_BranchType
# run
run ${NUM_CYCLES}ns

puts "Done."