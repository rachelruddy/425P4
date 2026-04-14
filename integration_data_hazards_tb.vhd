LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY integration_data_hazards_tb IS
END;

ARCHITECTURE tb OF integration_data_hazards_tb IS
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';

    -- selected debug taps
    SIGNAL dbg_EX_ALUResult_out_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EX_IR_out_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EX_RegWrite_out_s : STD_LOGIC;
    SIGNAL dbg_WB_regfile_write_en_s : STD_LOGIC;
    SIGNAL dbg_WB_regfile_write_addr_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL dbg_WB_regfile_write_data_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    uut : ENTITY work.processor
        PORT MAP(
            clk => clk,
            reset => reset,

            dbg_IF_IR => OPEN,
            dbg_IF_NPC => OPEN,
            dbg_IFID_IR => OPEN,
            dbg_IFID_NPC => OPEN,
            dbg_ID_IR => OPEN,
            dbg_ID_NPC => OPEN,
            dbg_A => OPEN,
            dbg_B => OPEN,
            dbg_imm => OPEN,
            dbg_ALUSrc => OPEN,
            dbg_ALUOp => OPEN,
            dbg_ALUFunc => OPEN,
            dbg_Branch => OPEN,
            dbg_BranchType => OPEN,
            dbg_Jump => OPEN,
            dbg_JumpReg => OPEN,
            dbg_MemRead => OPEN,
            dbg_MemWrite => OPEN,
            dbg_RegWrite => OPEN,
            dbg_MemToReg => OPEN,

            dbg_IDEX_A => OPEN,
            dbg_IDEX_B => OPEN,
            dbg_IDEX_imm => OPEN,
            dbg_IDEX_IR => OPEN,
            dbg_IDEX_NPC => OPEN,
            dbg_IDEX_ALUSrc => OPEN,
            dbg_IDEX_ALUOp => OPEN,
            dbg_IDEX_ALUFunc => OPEN,
            dbg_IDEX_Branch => OPEN,
            dbg_IDEX_BranchType => OPEN,
            dbg_IDEX_Jump => OPEN,
            dbg_IDEX_JumpReg => OPEN,
            dbg_IDEX_MemRead => OPEN,
            dbg_IDEX_MemWrite => OPEN,
            dbg_IDEX_RegWrite => OPEN,
            dbg_IDEX_MemToReg => OPEN,

            dbg_EX_ALUResult_out => dbg_EX_ALUResult_out_s,
            dbg_EX_B_out => OPEN,
            dbg_EX_IR_out => dbg_EX_IR_out_s,
            dbg_EX_NPC_out => OPEN,
            dbg_EX_BranchTaken => OPEN,
            dbg_EX_BranchTarget => OPEN,
            dbg_EX_Jump_out => OPEN,
            dbg_EX_JumpReg_out => OPEN,
            dbg_EX_MemRead_out => OPEN,
            dbg_EX_MemWrite_out => OPEN,
            dbg_EX_RegWrite_out => dbg_EX_RegWrite_out_s,
            dbg_EX_MemToReg_out => OPEN,

            dbg_EXMEM_ALUResult_out => OPEN,
            dbg_EXMEM_B_out => OPEN,
            dbg_EXMEM_IR_out => OPEN,
            dbg_EXMEM_NPC_out => OPEN,
            dbg_EXMEM_BranchTaken => OPEN,
            dbg_EXMEM_BranchTarget => OPEN,
            dbg_EXMEM_Jump_out => OPEN,
            dbg_EXMEM_JumpReg_out => OPEN,
            dbg_EXMEM_MemRead_out => OPEN,
            dbg_EXMEM_MemWrite_out => OPEN,
            dbg_EXMEM_RegWrite_out => OPEN,
            dbg_EXMEM_MemToReg_out => OPEN,

            dbg_MEM_LMD_out => OPEN,
            dbg_MEM_ALUResult_out => OPEN,
            dbg_MEM_IR_out => OPEN,
            dbg_MEM_NPC_out => OPEN,
            dbg_MEM_Jump_out => OPEN,
            dbg_MEM_JumpReg_out => OPEN,
            dbg_MEM_RegWrite_out => OPEN,
            dbg_MEM_MemToReg_out => OPEN,
            dbg_MEM_rd_out => OPEN,

            dbg_MEMWB_LMD_out => OPEN,
            dbg_MEMWB_ALUResult_out => OPEN,
            dbg_MEMWB_IR_out => OPEN,
            dbg_MEMWB_NPC_out => OPEN,
            dbg_MEMWB_Jump_out => OPEN,
            dbg_MEMWB_JumpReg_out => OPEN,
            dbg_MEMWB_RegWrite_out => OPEN,
            dbg_MEMWB_MemToReg_out => OPEN,
            dbg_MEMWB_rd_out => OPEN,

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

    clk_process : PROCESS
    BEGIN
        WHILE true LOOP
            clk <= '0';
            WAIT FOR 0.5 ns;
            clk <= '1';
            WAIT FOR 0.5 ns;
        END LOOP;
    END PROCESS;

    stim : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 1 ns;
        reset <= '0';
        WAIT;
    END PROCESS;

    monitor : PROCESS (clk)
        VARIABLE cycle : INTEGER := 0;
        VARIABLE ex_rd : INTEGER;
    BEGIN
        IF rising_edge(clk) THEN
            cycle := cycle + 1;

            ex_rd := to_integer(unsigned(dbg_EX_IR_out_s(11 DOWNTO 7)));

            IF dbg_EX_RegWrite_out_s = '1' THEN
                REPORT "C" & INTEGER'image(cycle) &
                    " EX: rd=x" & INTEGER'image(ex_rd) &
                    " alu=" & INTEGER'image(to_integer(signed(dbg_EX_ALUResult_out_s)));
            END IF;

            IF dbg_WB_regfile_write_en_s = '1' THEN
                REPORT "C" & INTEGER'image(cycle) &
                    " WB: x" & INTEGER'image(to_integer(unsigned(dbg_WB_regfile_write_addr_s))) &
                    " <= " & INTEGER'image(to_integer(signed(dbg_WB_regfile_write_data_s)));
            END IF;
        END IF;
    END PROCESS;

END tb;