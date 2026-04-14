library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity integration_data_hazards_tb is
end;

architecture tb of integration_data_hazards_tb is
    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

    -- selected debug taps
    signal dbg_EX_ALUResult_out_s      : std_logic_vector(31 downto 0);
    signal dbg_EX_IR_out_s             : std_logic_vector(31 downto 0);
    signal dbg_EX_RegWrite_out_s       : std_logic;
    signal dbg_WB_regfile_write_en_s   : std_logic;
    signal dbg_WB_regfile_write_addr_s : std_logic_vector(4 downto 0);
    signal dbg_WB_regfile_write_data_s : std_logic_vector(31 downto 0);
begin

    uut : entity work.processor
        port map(
            clk => clk,
            reset => reset,

            dbg_IF_IR => open,
            dbg_IF_NPC => open,
            dbg_IFID_IR => open,
            dbg_IFID_NPC => open,
            dbg_ID_IR => open,
            dbg_ID_NPC => open,
            dbg_A => open,
            dbg_B => open,
            dbg_imm => open,
            dbg_ALUSrc => open,
            dbg_ALUOp => open,
            dbg_ALUFunc => open,
            dbg_Branch => open,
            dbg_BranchType => open,
            dbg_Jump => open,
            dbg_JumpReg => open,
            dbg_MemRead => open,
            dbg_MemWrite => open,
            dbg_RegWrite => open,
            dbg_MemToReg => open,

            dbg_IDEX_A => open,
            dbg_IDEX_B => open,
            dbg_IDEX_imm => open,
            dbg_IDEX_IR => open,
            dbg_IDEX_NPC => open,
            dbg_IDEX_ALUSrc => open,
            dbg_IDEX_ALUOp => open,
            dbg_IDEX_ALUFunc => open,
            dbg_IDEX_Branch => open,
            dbg_IDEX_BranchType => open,
            dbg_IDEX_Jump => open,
            dbg_IDEX_JumpReg => open,
            dbg_IDEX_MemRead => open,
            dbg_IDEX_MemWrite => open,
            dbg_IDEX_RegWrite => open,
            dbg_IDEX_MemToReg => open,

            dbg_EX_ALUResult_out => dbg_EX_ALUResult_out_s,
            dbg_EX_B_out => open,
            dbg_EX_IR_out => dbg_EX_IR_out_s,
            dbg_EX_NPC_out => open,
            dbg_EX_BranchTaken => open,
            dbg_EX_BranchTarget => open,
            dbg_EX_Jump_out => open,
            dbg_EX_JumpReg_out => open,
            dbg_EX_MemRead_out => open,
            dbg_EX_MemWrite_out => open,
            dbg_EX_RegWrite_out => dbg_EX_RegWrite_out_s,
            dbg_EX_MemToReg_out => open,

            dbg_EXMEM_ALUResult_out => open,
            dbg_EXMEM_B_out => open,
            dbg_EXMEM_IR_out => open,
            dbg_EXMEM_NPC_out => open,
            dbg_EXMEM_BranchTaken => open,
            dbg_EXMEM_BranchTarget => open,
            dbg_EXMEM_Jump_out => open,
            dbg_EXMEM_JumpReg_out => open,
            dbg_EXMEM_MemRead_out => open,
            dbg_EXMEM_MemWrite_out => open,
            dbg_EXMEM_RegWrite_out => open,
            dbg_EXMEM_MemToReg_out => open,

            dbg_MEM_LMD_out => open,
            dbg_MEM_ALUResult_out => open,
            dbg_MEM_IR_out => open,
            dbg_MEM_NPC_out => open,
            dbg_MEM_Jump_out => open,
            dbg_MEM_JumpReg_out => open,
            dbg_MEM_RegWrite_out => open,
            dbg_MEM_MemToReg_out => open,
            dbg_MEM_rd_out => open,

            dbg_MEMWB_LMD_out => open,
            dbg_MEMWB_ALUResult_out => open,
            dbg_MEMWB_IR_out => open,
            dbg_MEMWB_NPC_out => open,
            dbg_MEMWB_Jump_out => open,
            dbg_MEMWB_JumpReg_out => open,
            dbg_MEMWB_RegWrite_out => open,
            dbg_MEMWB_MemToReg_out => open,
            dbg_MEMWB_rd_out => open,

            dbg_WB_regfile_write_en => dbg_WB_regfile_write_en_s,
            dbg_WB_regfile_write_addr => dbg_WB_regfile_write_addr_s,
            dbg_WB_regfile_write_data => dbg_WB_regfile_write_data_s
        );


-- addi x1, x0, 5 (x1 = 5)

-- addi x2, x1, 7 (x2 = 12)


-- add x3, x2, x1 (x3 = 17)

-- sub x4, x3, x1 (x4 = 12)

-- and x5, x4, x3 (x5 = 12 & 17 = 0)

-- or x6, x5, x2 (x6 = 0 | 12 = 12)

-- slti x7, x6, 40 (x7 = 1 since 12 < 40)

-- addi x8, x7, 9 (x8 = 10)

-- jal x0, 0 (infinite self-loop, no useful register write)
-- Expected final register values
-- x0 = 0 
-- x1 = 5
-- x2 = 12
-- x3 = 17
-- x4 = 12
-- x5 = 0
-- x6 = 12
-- x7 = 1
-- x8 = 10

    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 0.5 ns;
            clk <= '1'; wait for 0.5 ns;
        end loop;
    end process;

    stim : process
    begin
        reset <= '1';
        wait for 1 ns;
        reset <= '0';
        wait;
    end process;

    monitor : process(clk)
        variable cycle : integer := 0;
        variable ex_rd : integer;
    begin
        if rising_edge(clk) then
            cycle := cycle + 1;

            ex_rd := to_integer(unsigned(dbg_EX_IR_out_s(11 downto 7)));

            if dbg_EX_RegWrite_out_s = '1' then
                report "C" & integer'image(cycle) &
                       " EX: rd=x" & integer'image(ex_rd) &
                       " alu=" & integer'image(to_integer(signed(dbg_EX_ALUResult_out_s)));
            end if;

            if dbg_WB_regfile_write_en_s = '1' then
                report "C" & integer'image(cycle) &
                       " WB: x" & integer'image(to_integer(unsigned(dbg_WB_regfile_write_addr_s))) &
                       " <= " & integer'image(to_integer(signed(dbg_WB_regfile_write_data_s)));
            end if;
        end if;
    end process;

end tb;
