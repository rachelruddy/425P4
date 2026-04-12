LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- processor would use output from writeback to update the register file

entity writeback is
    port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;

        MemToReg : in STD_LOGIC; -- load (memory data is value to write)  (0 = ALU output, 1 = mem_data for loads)
        RegWrite : in STD_LOGIC; -- store (writes to a register)
        Jump : in STD_LOGIC; -- jump instruction (value written back should be pc + 4 (NPC))
        JumpReg : in STD_LOGIC; -- jump-register instruction (value written back should be pc + 4 (NPC))
        rd : in STD_LOGIC_VECTOR(4 DOWNTO 0); -- destination register number to write
        ALUOutput : in STD_LOGIC_VECTOR(31 DOWNTO 0); -- result from ALU
        mem_data : in STD_LOGIC_VECTOR(31 DOWNTO 0); -- value returned from memory for load instructions
        NPC : in STD_LOGIC_VECTOR(31 DOWNTO 0); -- NPC return address used for jal and jalr instructions

        regfile_write_en : out STD_LOGIC; -- tells the register file to perform a write for this cycle
        regfile_write_addr : out STD_LOGIC_VECTOR(4 DOWNTO 0); -- which register file number to write
        regfile_write_data : out STD_LOGIC_VECTOR(31 DOWNTO 0) -- value being written
    );
end writeback;

architecture rtl of writeback is
    signal write_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal write_enable : STD_LOGIC;
	 signal x0_error : STD_LOGIC;
	 
	begin
    write_data <= NPC when (Jump = '1' or JumpReg = '1') else
                  mem_data when MemToReg = '1' else
                  ALUOutput;

    -- protect from writing to r0, should be kept as zero
    write_enable <= RegWrite when rd /= "0" else '0';
	 -- added this signal here to detect if rd = 0 because test in tb werent passing when rd = 0000. now in clocked process, theres an if statement that checks this signal, and tests work, so write is disabled when rd = 0000
	 x0_error <= '1' when (rd = "00000") else '0';

    -- combinational outputs
	 regfile_write_en   <= '0' when x0_error = '1' else write_enable;
	 regfile_write_addr <= rd;
	 regfile_write_data <= write_data;
end rtl;