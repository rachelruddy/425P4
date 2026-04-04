# =============================================================================
# testbench.tcl
# ECSE 425 - Pipelined RISC-V Processor
# =============================================================================
# What this file does:
#   1. Compiles all VHDL source files
#   2. Loads program.txt into instruction memory
#   3. Runs the simulation for 10,000 clock cycles (1 GHz clock = 1 ns period)
#   4. Dumps data memory  -> memory.txt        (8192 lines, one 32-bit word each)
#   5. Dumps register file -> register_file.txt (32 lines,  one 32-bit word each)
#
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Configuration — edit these to match your project layout
# -----------------------------------------------------------------------------

set SRC_DIR "."

# Name of your top-level testbench VHDL entity
# ADAPT: change if your testbench entity has a different name
set TB_ENTITY "processor_tb"

# ModelSim work library name
set LIB "work"

# Simulation time per clock cycle (1 GHz = 1 ns period)
set CLK_PERIOD_NS 1

# Total number of clock cycles to simulate
set NUM_CYCLES 10000

# Output file names (spec-mandated)
set MEM_OUT      "memory.txt"
set REGFILE_OUT  "register_file.txt"
set PROGRAM_IN   "program.txt"

# Number of 32-bit words in data memory (32768 bytes / 4 = 8192)
set MEM_WORDS 8192

# Number of registers
set NUM_REGS 32


# -----------------------------------------------------------------------------
# 1. Compile all VHDL source files
# -----------------------------------------------------------------------------

# Create/reset the work library
if {[file exists $LIB]} {
    vdel -lib $LIB -all
}
vlib $LIB
vmap work $LIB

# Compile every .vhd file found in SRC_DIR.
# If your files have a required compilation order (e.g. packages first),
# list them explicitly here instead.
# ADAPT: list files explicitly if compilation order matters, e.g.:
#   vcom -2008 -work $LIB memory.vhd
#   vcom -2008 -work $LIB alu.vhd
#   vcom -2008 -work $LIB processor.vhd
#   vcom -2008 -work $LIB processor_tb.vhd
foreach vhd_file [glob -nocomplain $SRC_DIR/*.vhd] {
    vcom -2008 -work $LIB $vhd_file
}


# -----------------------------------------------------------------------------
# 2. Load the simulation
# -----------------------------------------------------------------------------

vsim -t 1ns $LIB.$TB_ENTITY


# -----------------------------------------------------------------------------
# 3. Load program.txt into instruction memory
# -----------------------------------------------------------------------------
# This reads each line of program.txt (a 32-char binary string) and writes it
# into the instruction memory array, word by word.
#
# ADAPT: Change the mem_force path to match your instruction memory signal.
#        Common patterns:
#          /processor_tb/uut/instr_mem/ram
#          /processor_tb/dut/imem/mem_array
#        The signal must be an array of std_logic_vector(31 downto 0).

set prog_file [open $PROGRAM_IN r]
set addr 0

while {[gets $prog_file line] >= 0} {
    # Skip blank lines
    set line [string trim $line]
    if {$line eq ""} { continue }

    # Sanity check: each line must be exactly 32 characters of '0'/'1'
    if {[string length $line] != 32} {
        puts "WARNING: Line $addr in $PROGRAM_IN has [string length $line] chars (expected 32), skipping."
        continue
    }

    # Force the value into the memory array at index $addr
    # ADAPT: replace the path below with your instruction memory array path
    mem load -infile /dev/stdin -format binary $LIB.$TB_ENTITY/uut/instr_mem/ram($addr) << $line

    # Alternative approach if mem load doesn't work for your memory model:
    # force -freeze /processor_tb/uut/instr_mem/ram($addr) $line 0

    incr addr
}

close $prog_file
puts "Loaded $addr instruction(s) into instruction memory."


# -----------------------------------------------------------------------------
# 4. Set up the clock and reset
# -----------------------------------------------------------------------------
# ADAPT: Change signal paths to match your testbench's clock and reset ports.

# Clock: 1 GHz -> period = 1 ns (0.5 ns high, 0.5 ns low)
force -freeze /processor_tb/clk 0 0ns, 1 0.5ns -repeat 1ns

# Reset: assert for 2 cycles, then release
# ADAPT: change reset polarity (0 vs 1) and signal name as needed
force -freeze /processor_tb/reset 1 0ns
run 2ns
force -freeze /processor_tb/reset 0 0ns


# -----------------------------------------------------------------------------
# 5. Run for 10,000 clock cycles
# -----------------------------------------------------------------------------

set sim_time [expr {$NUM_CYCLES * $CLK_PERIOD_NS}]
puts "Running simulation for $NUM_CYCLES cycles ($sim_time ns)..."
run ${sim_time}ns
puts "Simulation complete."


# -----------------------------------------------------------------------------
# 6. Dump data memory -> memory.txt
# -----------------------------------------------------------------------------
# Reads each word of data memory from the simulation and writes it as a
# 32-character binary string.
#
# ADAPT: Change the examine path to match your data memory array signal.
#        Common patterns:
#          /processor_tb/uut/data_mem/ram
#          /processor_tb/dut/dmem/mem_array

puts "Writing data memory to $MEM_OUT..."
set mem_file [open $MEM_OUT w]

for {set i 0} {$i < $MEM_WORDS} {incr i} {
    # ADAPT: update this path to your data memory array
    set word [examine -radix binary /processor_tb/uut/data_mem/ram($i)]

    # examine may return a value with spaces (e.g. "0000 0000 0000 0000")
    # Strip spaces to get a clean 32-char binary string
    set word [string map {" " ""} $word]

    # Pad or trim to exactly 32 bits just in case
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
# x0 should always read as 0x00000000.
#
# ADAPT: Change the examine path to match your register file array signal.
#        Common patterns:
#          /processor_tb/uut/reg_file/registers
#          /processor_tb/dut/regfile/regs

puts "Writing register file to $REGFILE_OUT..."
set reg_file [open $REGFILE_OUT w]

for {set i 0} {$i < $NUM_REGS} {incr i} {
    # ADAPT: update this path to your register file array
    set word [examine -radix binary /processor_tb/uut/reg_file/registers($i)]

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
puts "   Instruction memory loaded from : $PROGRAM_IN"
puts "   Data memory written to         : $MEM_OUT"
puts "   Register file written to       : $REGFILE_OUT"
puts "====================================================="