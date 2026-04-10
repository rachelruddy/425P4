LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- processor would use output from writeback to update the register file

entity writeback is
    port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;

        MemToReg : in STD_LOGIC; -- load (memory data is value to write)
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
begin
    write_data <= NPC when (Jump = '1' or JumpReg = '1') else
                  mem_data when MemToReg = '1' else
                  ALUOutput;

    -- protect from writing to r0, should be kept as zero
    write_enable <= RegWrite when rd /= "0" else '0';

    -- i put this in a clocked process because the register file in processor will be sampling the outputs on a clock edge as well
    -- if not, maybe the outputs should be combinatorial? idk how that 
    process(clk, reset)
    begin
        if reset = '1' then
            regfile_write_en <= '0';
            regfile_write_addr <= (others => '0');
            regfile_write_data <= (others => '0');
        elsif rising_edge(clk) then
            regfile_write_en <= write_enable;
            regfile_write_addr <= rd;
            regfile_write_data <= write_data;
        end if;
    end process;
end rtl;