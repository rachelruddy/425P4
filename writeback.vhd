LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- processor would use output from writeback to update the register file

ENTITY writeback IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        MemToReg : IN STD_LOGIC; -- load (memory data is value to write)  (0 = ALU output, 1 = mem_data for loads)
        RegWrite : IN STD_LOGIC; -- store (writes to a register)
        Jump : IN STD_LOGIC; -- jump instruction (value written back should be pc + 4 (NPC))
        JumpReg : IN STD_LOGIC; -- jump-register instruction (value written back should be pc + 4 (NPC))
        rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- destination register number to write
        ALUOutput : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- result from ALU
        mem_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- value returned from memory for load instructions
        NPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- NPC return address used for jal and jalr instructions

        regfile_write_en : OUT STD_LOGIC; -- tells the register file to perform a write for this cycle
        regfile_write_addr : OUT STD_LOGIC_VECTOR(4 DOWNTO 0); -- which register file number to write
        regfile_write_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- value being written
    );
END writeback;

ARCHITECTURE rtl OF writeback IS
    SIGNAL write_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_enable : STD_LOGIC;
    SIGNAL x0_error : STD_LOGIC;

BEGIN
    write_data <= NPC WHEN (Jump = '1' OR JumpReg = '1') ELSE
        mem_data WHEN MemToReg = '1' ELSE
        ALUOutput;

    -- protect from writing to r0, should be kept as zero
    write_enable <= RegWrite WHEN rd /= "00000" ELSE
        '0';
    -- added this signal here to detect if rd = 0 because test in tb werent passing when rd = 0000. now in clocked process, theres an if statement that checks this signal, and tests work, so write is disabled when rd = 0000
    x0_error <= '1' WHEN (rd = "00000") ELSE
        '0';

    -- combinational outputs
    regfile_write_en <= '0' WHEN x0_error = '1' ELSE
        write_enable;
    regfile_write_addr <= rd;
    regfile_write_data <= write_data;
END rtl;