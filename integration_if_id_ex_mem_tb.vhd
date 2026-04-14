LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY integration_if_id_ex_mem_tb IS
END;

ARCHITECTURE tb OF integration_if_id_ex_mem_tb IS
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';
    SIGNAL dbg_IF_IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_IFID_IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_ID_IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_IF_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_IFID_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_ID_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_ALUSrc : STD_LOGIC;
    SIGNAL dbg_ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL dbg_ALUFunc : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL dbg_Branch : STD_LOGIC;
    SIGNAL dbg_BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL dbg_Jump : STD_LOGIC;
    SIGNAL dbg_JumpReg : STD_LOGIC;
    SIGNAL dbg_MemRead : STD_LOGIC;
    SIGNAL dbg_MemWrite : STD_LOGIC;
    SIGNAL dbg_RegWrite : STD_LOGIC;
    SIGNAL dbg_MemToReg : STD_LOGIC;

    SIGNAL dbg_IDEX_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_IDEX_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_IDEX_imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_IDEX_IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_IDEX_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_IDEX_ALUSrc : STD_LOGIC;
    SIGNAL dbg_IDEX_ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL dbg_IDEX_ALUFunc : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL dbg_IDEX_Branch : STD_LOGIC;
    SIGNAL dbg_IDEX_BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL dbg_IDEX_Jump : STD_LOGIC;
    SIGNAL dbg_IDEX_JumpReg : STD_LOGIC;
    SIGNAL dbg_IDEX_MemRead : STD_LOGIC;
    SIGNAL dbg_IDEX_MemWrite : STD_LOGIC;
    SIGNAL dbg_IDEX_RegWrite : STD_LOGIC;
    SIGNAL dbg_IDEX_MemToReg : STD_LOGIC;

    -- EX outputs
    -- outputs of EX
    SIGNAL dbg_EX_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EX_B_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EX_IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EX_NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EX_BranchTaken : STD_LOGIC;
    SIGNAL dbg_EX_BranchTarget : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EX_Jump_out : STD_LOGIC;
    SIGNAL dbg_EX_JumpReg_out : STD_LOGIC;
    SIGNAL dbg_EX_MemRead_out : STD_LOGIC;
    SIGNAL dbg_EX_MemWrite_out : STD_LOGIC;
    SIGNAL dbg_EX_RegWrite_out : STD_LOGIC;
    SIGNAL dbg_EX_MemToReg_out : STD_LOGIC;
    -- EX/MEM pipeline registers
    SIGNAL dbg_EXMEM_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EXMEM_B_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EXMEM_IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EXMEM_NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EXMEM_BranchTaken : STD_LOGIC;
    SIGNAL dbg_EXMEM_BranchTarget : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_EXMEM_Jump_out : STD_LOGIC;
    SIGNAL dbg_EXMEM_JumpReg_out : STD_LOGIC;
    SIGNAL dbg_EXMEM_MemRead_out : STD_LOGIC;
    SIGNAL dbg_EXMEM_MemWrite_out : STD_LOGIC;
    SIGNAL dbg_EXMEM_RegWrite_out : STD_LOGIC;
    SIGNAL dbg_EXMEM_MemToReg_out : STD_LOGIC;
    -- MEM outputs
    SIGNAL dbg_MEM_LMD_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_MEM_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_MEM_IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_MEM_NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_MEM_Jump_out : STD_LOGIC;
    SIGNAL dbg_MEM_JumpReg_out : STD_LOGIC;
    SIGNAL dbg_MEM_RegWrite_out : STD_LOGIC;
    SIGNAL dbg_MEM_MemToReg_out : STD_LOGIC;
    SIGNAL dbg_MEM_rd_out : STD_LOGIC_VECTOR(4 DOWNTO 0);

    -- MEM/WB pipeline registers
    SIGNAL dbg_MEMWB_LMD_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_MEMWB_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_MEMWB_IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_MEMWB_NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dbg_MEMWB_Jump_out : STD_LOGIC;
    SIGNAL dbg_MEMWB_JumpReg_out : STD_LOGIC;
    SIGNAL dbg_MEMWB_RegWrite_out : STD_LOGIC;
    SIGNAL dbg_MEMWB_MemToReg_out : STD_LOGIC;
    SIGNAL dbg_MEMWB_rd_out : STD_LOGIC_VECTOR(4 DOWNTO 0);

    -- WB outputs
    SIGNAL dbg_WB_regfile_write_en : STD_LOGIC;
    SIGNAL dbg_WB_regfile_write_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL dbg_WB_regfile_write_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    COMPONENT processor IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            -- testing/debugging outputs (to be removed later)
            dbg_IF_IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_IFID_IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_ID_IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_IF_NPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_IFID_NPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_ID_NPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_imm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_ALUSrc : OUT STD_LOGIC;
            dbg_ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            dbg_ALUFunc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            dbg_Branch : OUT STD_LOGIC;
            dbg_BranchType : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            dbg_Jump : OUT STD_LOGIC;
            dbg_JumpReg : OUT STD_LOGIC;
            dbg_MemRead : OUT STD_LOGIC;
            dbg_MemWrite : OUT STD_LOGIC;
            dbg_RegWrite : OUT STD_LOGIC;
            dbg_MemToReg : OUT STD_LOGIC;

            dbg_IDEX_A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_IDEX_B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_IDEX_imm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_IDEX_IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_IDEX_NPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_IDEX_ALUSrc : OUT STD_LOGIC;
            dbg_IDEX_ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            dbg_IDEX_ALUFunc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            dbg_IDEX_Branch : OUT STD_LOGIC;
            dbg_IDEX_BranchType : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            dbg_IDEX_Jump : OUT STD_LOGIC;
            dbg_IDEX_JumpReg : OUT STD_LOGIC;
            dbg_IDEX_MemRead : OUT STD_LOGIC;
            dbg_IDEX_MemWrite : OUT STD_LOGIC;
            dbg_IDEX_RegWrite : OUT STD_LOGIC;
            dbg_IDEX_MemToReg : OUT STD_LOGIC;

            dbg_EX_ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EX_B_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EX_IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EX_NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EX_BranchTaken : OUT STD_LOGIC;
            dbg_EX_BranchTarget : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EX_Jump_out : OUT STD_LOGIC;
            dbg_EX_JumpReg_out : OUT STD_LOGIC;
            dbg_EX_MemRead_out : OUT STD_LOGIC;
            dbg_EX_MemWrite_out : OUT STD_LOGIC;
            dbg_EX_RegWrite_out : OUT STD_LOGIC;
            dbg_EX_MemToReg_out : OUT STD_LOGIC;

            dbg_EXMEM_ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EXMEM_B_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EXMEM_IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EXMEM_NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EXMEM_BranchTaken : OUT STD_LOGIC;
            dbg_EXMEM_BranchTarget : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_EXMEM_Jump_out : OUT STD_LOGIC;
            dbg_EXMEM_JumpReg_out : OUT STD_LOGIC;
            dbg_EXMEM_MemRead_out : OUT STD_LOGIC;
            dbg_EXMEM_MemWrite_out : OUT STD_LOGIC;
            dbg_EXMEM_RegWrite_out : OUT STD_LOGIC;
            dbg_EXMEM_MemToReg_out : OUT STD_LOGIC;

            -- outputs of MEM
            dbg_MEM_LMD_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_MEM_ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_MEM_IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_MEM_NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_MEM_Jump_out : OUT STD_LOGIC;
            dbg_MEM_JumpReg_out : OUT STD_LOGIC;
            dbg_MEM_RegWrite_out : OUT STD_LOGIC;
            dbg_MEM_MemToReg_out : OUT STD_LOGIC;
            dbg_MEM_rd_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

            -- MEM/WB pipeline registers
            dbg_MEMWB_LMD_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_MEMWB_ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_MEMWB_IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_MEMWB_NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dbg_MEMWB_Jump_out : OUT STD_LOGIC;
            dbg_MEMWB_JumpReg_out : OUT STD_LOGIC;
            dbg_MEMWB_RegWrite_out : OUT STD_LOGIC;
            dbg_MEMWB_MemToReg_out : OUT STD_LOGIC;
            dbg_MEMWB_rd_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

            -- WB outputs
            dbg_WB_regfile_write_en : OUT STD_LOGIC;
            dbg_WB_regfile_write_addr : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            dbg_WB_regfile_write_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

        );
    END COMPONENT;

BEGIN

    uut : processor
    PORT MAP(
        clk => clk,
        reset => reset,
        dbg_IF_IR => dbg_IF_IR,
        dbg_IFID_IR => dbg_IFID_IR,
        dbg_ID_IR => dbg_ID_IR,
        dbg_IF_NPC => dbg_IF_NPC,
        dbg_IFID_NPC => dbg_IFID_NPC,
        dbg_ID_NPC => dbg_ID_NPC,
        dbg_A => dbg_A,
        dbg_B => dbg_B,
        dbg_imm => dbg_imm,
        dbg_ALUSrc => dbg_ALUSrc,
        dbg_ALUOp => dbg_ALUOp,
        dbg_ALUFunc => dbg_ALUFunc,
        dbg_Branch => dbg_Branch,
        dbg_BranchType => dbg_BranchType,
        dbg_Jump => dbg_Jump,
        dbg_JumpReg => dbg_JumpReg,
        dbg_MemRead => dbg_MemRead,
        dbg_MemWrite => dbg_MemWrite,
        dbg_RegWrite => dbg_RegWrite,
        dbg_MemToReg => dbg_MemToReg,

        dbg_IDEX_A => dbg_IDEX_A,
        dbg_IDEX_B => dbg_IDEX_B,
        dbg_IDEX_imm => dbg_IDEX_imm,
        dbg_IDEX_IR => dbg_IDEX_IR,
        dbg_IDEX_NPC => dbg_IDEX_NPC,
        dbg_IDEX_ALUSrc => dbg_IDEX_ALUSrc,
        dbg_IDEX_ALUOp => dbg_IDEX_ALUOp,
        dbg_IDEX_ALUFunc => dbg_IDEX_ALUFunc,
        dbg_IDEX_Branch => dbg_IDEX_Branch,
        dbg_IDEX_BranchType => dbg_IDEX_BranchType,
        dbg_IDEX_Jump => dbg_IDEX_Jump,
        dbg_IDEX_JumpReg => dbg_IDEX_JumpReg,
        dbg_IDEX_MemRead => dbg_IDEX_MemRead,
        dbg_IDEX_MemWrite => dbg_IDEX_MemWrite,
        dbg_IDEX_RegWrite => dbg_IDEX_RegWrite,
        dbg_IDEX_MemToReg => dbg_IDEX_MemToReg,

        dbg_EX_ALUResult_out => dbg_EX_ALUResult_out,
        dbg_EX_B_out => dbg_EX_B_out,
        dbg_EX_IR_out => dbg_EX_IR_out,
        dbg_EX_NPC_out => dbg_EX_NPC_out,
        dbg_EX_BranchTaken => dbg_EX_BranchTaken,
        dbg_EX_BranchTarget => dbg_EX_BranchTarget,
        dbg_EX_Jump_out => dbg_EX_Jump_out,
        dbg_EX_JumpReg_out => dbg_EX_JumpReg_out,
        dbg_EX_MemRead_out => dbg_EX_MemRead_out,
        dbg_EX_MemWrite_out => dbg_EX_MemWrite_out,
        dbg_EX_RegWrite_out => dbg_EX_RegWrite_out,
        dbg_EX_MemToReg_out => dbg_EX_MemToReg_out,

        dbg_EXMEM_ALUResult_out => dbg_EXMEM_ALUResult_out,
        dbg_EXMEM_B_out => dbg_EXMEM_B_out,
        dbg_EXMEM_IR_out => dbg_EXMEM_IR_out,
        dbg_EXMEM_NPC_out => dbg_EXMEM_NPC_out,
        dbg_EXMEM_BranchTaken => dbg_EXMEM_BranchTaken,
        dbg_EXMEM_BranchTarget => dbg_EXMEM_BranchTarget,
        dbg_EXMEM_Jump_out => dbg_EXMEM_Jump_out,
        dbg_EXMEM_JumpReg_out => dbg_EXMEM_JumpReg_out,
        dbg_EXMEM_MemRead_out => dbg_EXMEM_MemRead_out,
        dbg_EXMEM_MemWrite_out => dbg_EXMEM_MemWrite_out,
        dbg_EXMEM_RegWrite_out => dbg_EXMEM_RegWrite_out,
        dbg_EXMEM_MemToReg_out => dbg_EXMEM_MemToReg_out,

        dbg_MEM_LMD_out => dbg_MEM_LMD_out,
        dbg_MEM_ALUResult_out => dbg_MEM_ALUResult_out,
        dbg_MEM_IR_out => dbg_MEM_IR_out,
        dbg_MEM_NPC_out => dbg_MEM_NPC_out,
        dbg_MEM_Jump_out => dbg_MEM_Jump_out,
        dbg_MEM_JumpReg_out => dbg_MEM_JumpReg_out,
        dbg_MEM_RegWrite_out => dbg_MEM_RegWrite_out,
        dbg_MEM_MemToReg_out => dbg_MEM_MemToReg_out,
        dbg_MEM_rd_out => dbg_MEM_rd_out,

        dbg_MEMWB_LMD_out => dbg_MEMWB_LMD_out,
        dbg_MEMWB_ALUResult_out => dbg_MEMWB_ALUResult_out,
        dbg_MEMWB_IR_out => dbg_MEMWB_IR_out,
        dbg_MEMWB_NPC_out => dbg_MEMWB_NPC_out,
        dbg_MEMWB_Jump_out => dbg_MEMWB_Jump_out,
        dbg_MEMWB_JumpReg_out => dbg_MEMWB_JumpReg_out,
        dbg_MEMWB_RegWrite_out => dbg_MEMWB_RegWrite_out,
        dbg_MEMWB_MemToReg_out => dbg_MEMWB_MemToReg_out,
        dbg_MEMWB_rd_out => dbg_MEMWB_rd_out,

        dbg_WB_regfile_write_en => dbg_WB_regfile_write_en,
        dbg_WB_regfile_write_addr => dbg_WB_regfile_write_addr,
        dbg_WB_regfile_write_data => dbg_WB_regfile_write_data

    );

    -- clock
    clk_process : PROCESS
    BEGIN
        WHILE true LOOP
            clk <= '0';
            WAIT FOR 0.5 ns;
            clk <= '1';
            WAIT FOR 0.5 ns;
        END LOOP;
    END PROCESS;

    -- stimulus
    stim : PROCESS
        VARIABLE pass_count : INTEGER := 0;
        VARIABLE fail_count : INTEGER := 0;
    BEGIN
        -- reset
        reset <= '1';
        WAIT FOR 1 ns;
        reset <= '0';

        -- =====================================================================
        -- readme
        -- =====================================================================

        -- wait for first rising edge
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- instr1:  SW x2, 0(x0), 
        -- instr2:  LW x3, 0(x0)
        -------------------------------------------------------------------------------------------------------------------------------
        -- reset
        reset <= '1';
        WAIT FOR 1 ns;
        reset <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 1: SW in IF
        -------------------------------------------------------------------------------------------------------------------------------
        IF (dbg_IF_IR /= "00000000001000000010000000100011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 1 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 2: SW in ID, LW in IF
        -------------------------------------------------------------------------------------------------------------------------------
        IF (dbg_IF_IR /= "00000000000000000010000110000011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 2 (LW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '1' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 2 (SW in ID)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '0' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 2 (SW in ID, should be 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        IF (dbg_B /= x"00000003") THEN
            REPORT "FAIL: B incorrect at cycle 2 (SW in ID, x2 should be 3, got " &
                INTEGER'image(to_integer(unsigned(dbg_B))) &
                " (0x" & to_hstring(dbg_B) & "))" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        REPORT "DEBUG: ID_IR at cycle 2 = " & to_hstring(dbg_ID_IR) SEVERITY note;
        REPORT "DEBUG: B at cycle 2 = " & to_hstring(dbg_B) SEVERITY note;
        REPORT "DEBUG: rs2 extracted = " & INTEGER'image(to_integer(unsigned(dbg_ID_IR(24 DOWNTO 20)))) SEVERITY note;
        REPORT "DEBUG: rs1 extracted = " & INTEGER'image(to_integer(unsigned(dbg_ID_IR(19 DOWNTO 15)))) SEVERITY note;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 3: SW in EX, LW in ID
        -- SW: ALU computes x0 + 0 = 0 (memory address)
        -- LW: decoded, MemRead=1
        -- ADDI x4, x1, 10 in IF
        -------------------------------------------------------------------------------------------------------------------------------
        IF (dbg_EX_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: EX_ALUResult incorrect at cycle 3 (SW address should be 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemWrite_out /= '1' THEN
            REPORT "FAIL: EX_MemWrite_out incorrect at cycle 3 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- LW now in ID
        IF dbg_MemRead /= '1' THEN
            REPORT "FAIL: MemRead incorrect at cycle 3 (LW in ID)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_IR /= "00000000101000001000001000010011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 3 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"0000000C") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 3 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --ADDI
        IF (dbg_IF_IR /= "00000000101000001000001000010011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 3 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"0000000C") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 3 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 4: SW in MEM (write happens here), LW in EX
        -- SW: memory write occurs, B_out should contain x2=3
        -- LW: ALU computes x0+0=0 (memory address)
        -- ADDI in ID
        -- BEQ x0, x9, 8 in IF
        -------------------------------------------------------------------------------------------------------------------------------
        IF (dbg_EXMEM_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: EXMEM_ALUResult incorrect at cycle 4 (SW address)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_B_out /= x"00000003") THEN
            REPORT "FAIL: EXMEM_B_out incorrect at cycle 4 (SW store value should be 3, got " &
                INTEGER'image(to_integer(unsigned(dbg_EXMEM_B_out))) &
                " (0x" & to_hstring(dbg_EXMEM_B_out) & "))" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemWrite_out /= '1' THEN
            REPORT "FAIL: EXMEM_MemWrite_out incorrect at cycle 4 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        -- LW in EX
        IF (dbg_EX_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: EX_ALUResult incorrect at cycle 4 (LW address should be 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --ADDI in ID
        IF (dbg_A /= x"00000005") THEN
            REPORT "FAIL: A incorrect at cycle 4 (ADDI, expected x1=5, got " &
                to_hstring(dbg_A) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"0000000A") THEN
            REPORT "FAIL: imm incorrect at cycle 4 (ADDI, expected 10, got " &
                to_hstring(dbg_imm) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '1' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 4 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 4 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 4 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '0' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 4 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- BEQ
        IF (dbg_IF_IR /= "00000000100100000000010001100011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 4 (BEQ taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"00000010") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 4 (BEQ taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 5: SW in MEMWB (passthrough), LW in MEM (read happens here)
        -- SW: RegWrite=0, nothing written to register file
        -- LW: memory read occurs, LMD should get value 3
        -- ADDI in EXEC
        -- beq in id
        -- BEQ x1, x2, 8 in IF
        -------------------------------------------------------------------------------------------------------------------------------
        IF dbg_MEMWB_RegWrite_out /= '0' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 5 (SW should not write register)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- LW in MEM - check MEM outputs
        IF (dbg_MEM_LMD_out /= x"00000003") THEN
            REPORT "FAIL: MEM_LMD_out incorrect at cycle 5 (LW should read 3)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_MemToReg_out /= '1' THEN
            REPORT "FAIL: MEM_MemToReg_out incorrect at cycle 5 (LW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_ALUResult_out /= x"0000000F") THEN
            REPORT "FAIL: EX_ALUResult_out incorrect at cycle 5 (ADDI, expected 5+10=15, got " &
                to_hstring(dbg_EX_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 5 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 5 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_MEM_rd_out /= "00011") THEN
            REPORT "FAIL: MEM_rd_out incorrect for LW x3 (expected rd=3, got " &
                INTEGER'image(to_integer(unsigned(dbg_MEM_rd_out))) &
                ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- beq
        IF (dbg_A /= x"00000000") THEN
            REPORT "FAIL: A incorrect at cycle 5 (BEQ taken, expected x0=0, got " &
                to_hstring(dbg_A) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000000") THEN
            REPORT "FAIL: B incorrect at cycle 5 (BEQ taken, expected x9=0, got " &
                to_hstring(dbg_B) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000008") THEN
            REPORT "FAIL: imm incorrect at cycle 5 (BEQ taken, expected 8, got " &
                to_hstring(dbg_imm) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Branch /= '1' THEN
            REPORT "FAIL: Branch incorrect at cycle 5 (BEQ taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_BranchType /= "000") THEN
            REPORT "FAIL: BranchType incorrect at cycle 5 (BEQ taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '0' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 5 (BEQ taken, should be 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --beq2
        IF (dbg_IF_IR /= "00000000001000001000010001100011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 5 (BEQ not taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"00000014") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 5 (BEQ not taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 6: LW in MEMWB
        -- LMD should be 3, MemToReg=1, RegWrite=1
        -- ADDI in MEM
        -- BEQ in ex
        -- beq2 in id
        -- JAL x1, 12 in IF
        -------------------------------------------------------------------------------------------------------------------------------
        IF (dbg_MEMWB_LMD_out /= x"00000003") THEN
            REPORT "FAIL: MEMWB_LMD_out incorrect at cycle 6 (LW should have loaded 3)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 6 (LW should write register)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_MemToReg_out /= '1' THEN
            REPORT "FAIL: MEMWB_MemToReg_out incorrect at cycle 6 (LW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_MEMWB_rd_out /= "00011") THEN
            REPORT "FAIL: MEMWB_rd_out incorrect for LW x3 (expected rd=3, got " &
                INTEGER'image(to_integer(unsigned(dbg_MEMWB_rd_out))) &
                ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- ADDI mem
        IF (dbg_MEM_ALUResult_out /= x"0000000F") THEN
            REPORT "FAIL: MEM_ALUResult_out incorrect at cycle 6 (ADDI, expected 15, got " &
                to_hstring(dbg_MEM_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEM_RegWrite_out incorrect at cycle 6 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEM_MemToReg_out incorrect at cycle 6 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --beq
        IF dbg_EX_BranchTaken /= '1' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 6 (BEQ taken, expected 1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_BranchTarget /= x"00000014") THEN
            REPORT "FAIL: EX_BranchTarget incorrect at cycle 6 (BEQ taken, expected 0x14, got " &
                to_hstring(dbg_EX_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: EX_ALUResult_out incorrect at cycle 6 (BEQ taken, expected 0, got " &
                to_hstring(dbg_EX_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '0' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 6 (BEQ taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- beq2
        IF (dbg_A /= x"00000005") THEN
            REPORT "FAIL: A incorrect at cycle 6 (BEQ not taken, expected x1=5, got " &
                to_hstring(dbg_A) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000003") THEN
            REPORT "FAIL: B incorrect at cycle 6 (BEQ not taken, expected x2=3, got " &
                to_hstring(dbg_B) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000008") THEN
            REPORT "FAIL: imm incorrect at cycle 6 (BEQ not taken, expected 8, got " &
                to_hstring(dbg_imm) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Branch /= '1' THEN
            REPORT "FAIL: Branch incorrect at cycle 6 (BEQ not taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_BranchType /= "000") THEN
            REPORT "FAIL: BranchType incorrect at cycle 6 (BEQ not taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '0' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 6 (BEQ not taken, should be 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- jal
        IF (dbg_IF_IR /= "00000000110000000000000011101111") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 6 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"00000018") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 6 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 7: ADDI in MEMWB
        -- critical: ALUResult=15, RegWrite=1, MemToReg=0
        -- BEQ in MEM
        -- beq2 in exec
        -- jal in id
        -- JALR x1, x2, 0 in IF
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_MEMWB_ALUResult_out /= x"0000000F") THEN
            REPORT "FAIL: MEMWB_ALUResult_out incorrect at cycle 7 (ADDI, expected 15, got " &
                to_hstring(dbg_MEMWB_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 7 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEMWB_MemToReg_out incorrect at cycle 7 (ADDI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --BEQ
        IF (dbg_EXMEM_BranchTaken /= '1') THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 7 (BEQ taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_BranchTarget /= x"00000014") THEN
            REPORT "FAIL: EXMEM_BranchTarget incorrect at cycle 7 (BEQ taken, expected 0x14, got " &
                to_hstring(dbg_EXMEM_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_RegWrite_out /= '0' THEN
            REPORT "FAIL: MEM_RegWrite_out incorrect at cycle 7 (BEQ taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --beq2
        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 7 (BEQ not taken, expected 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_BranchTarget /= x"00000000") THEN
            REPORT "FAIL: EX_BranchTarget incorrect at cycle 7 (BEQ not taken, expected 0, got " &
                to_hstring(dbg_EX_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        IF dbg_EX_RegWrite_out /= '0' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 7 (BEQ not taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --jal
        IF dbg_Jump /= '1' THEN
            REPORT "FAIL: Jump incorrect at cycle 7 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 7 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 7 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '0' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 7 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"0000000C") THEN
            REPORT "FAIL: imm incorrect at cycle 7 (JAL, expected 12, got " &
                to_hstring(dbg_imm) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --jalr
        IF (dbg_IF_IR /= "00000000000000010000000011100111") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 7 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"0000001C") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 7 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 8: BEQ in MEMWB
        -- critical: RegWrite=0, MemToReg=0
        -- beq2 in mem
        -- jal in ex
        -- jalr in id
        -- LUI x5, 5 in IF
        -------------------------------------------------------------------------------------------------------------------------------

        IF dbg_MEMWB_RegWrite_out /= '0' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 8 (BEQ taken, should not write register)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEMWB_MemToReg_out incorrect at cycle 8 (BEQ taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --beq2
        IF (dbg_EXMEM_BranchTaken /= '0') THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 8 (BEQ not taken, expected 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_RegWrite_out /= '0' THEN
            REPORT "FAIL: MEM_RegWrite_out incorrect at cycle 8 (BEQ not taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --jal
        IF (dbg_EX_ALUResult_out /= x"00000018") THEN
            REPORT "FAIL: EX_ALUResult_out incorrect at cycle 8 (JAL, expected NPC=0x18, got " &
                to_hstring(dbg_EX_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '1' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 8 (JAL, expected 1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_BranchTarget /= x"00000020") THEN
            REPORT "FAIL: EX_BranchTarget incorrect at cycle 8 (JAL, expected 0x20, got " &
                to_hstring(dbg_EX_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        ---------------------jump and jumpreg-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF dbg_EX_Jump_out /= '1' THEN
            REPORT "FAIL: EX_Jump_out incorrect at cycle 8 (jump = 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_JumpReg_out /= '0' THEN
            REPORT "FAIL: EX_JumpReg_out incorrect at cycle 8 (jumpreg = 1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        ---------------------jump and jumpreg-------------------------------------------------------------------------------------------------------------------------------------------------------------------

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 8 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --jalr
        IF dbg_JumpReg /= '1' THEN
            REPORT "FAIL: JumpReg incorrect at cycle 8 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 8 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_A /= x"00000003") THEN
            REPORT "FAIL: A incorrect at cycle 8 (JALR, expected x2=3, got " &
                to_hstring(dbg_A) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000000") THEN
            REPORT "FAIL: imm incorrect at cycle 8 (JALR, expected 0, got " &
                to_hstring(dbg_imm) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 8 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '0' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 8 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --LUI
        IF (dbg_IF_IR /= "00000000000000000101001010110111") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 8 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"00000020") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 8 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 9: BEQ not taken in MEMWB
        -- critical: RegWrite=0, MemToReg=0
        -- jal in mem
        -- jalr in ex
        -- lui in id
        -- SRA x6, x1, x2 in IF
        -------------------------------------------------------------------------------------------------------------------------------

        IF dbg_MEMWB_RegWrite_out /= '0' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 9 (BEQ not taken, should not write register)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEMWB_MemToReg_out incorrect at cycle 9 (BEQ not taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --jal
        IF (dbg_EXMEM_ALUResult_out /= x"00000018") THEN
            REPORT "FAIL: EXMEM_ALUResult_out incorrect at cycle 9 (JAL, expected 0x18, got " &
                to_hstring(dbg_EXMEM_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_BranchTaken /= '1' THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 9 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_BranchTarget /= x"00000020") THEN
            REPORT "FAIL: EXMEM_BranchTarget incorrect at cycle 9 (JAL, expected 0x20, got " &
                to_hstring(dbg_EXMEM_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        ---------------------jump and jumpreg-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF dbg_EXMEM_Jump_out /= '1' THEN
            REPORT "FAIL: EXMEM_Jump_out incorrect at cycle 9 (jump = 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_JumpReg_out /= '0' THEN
            REPORT "FAIL: EXMEM_JumpReg_out incorrect at cycle 9 (jumpreg = 1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        ---------------------jump and jumpreg-------------------------------------------------------------------------------------------------------------------------------------------------------------------

        ---------------------jump and jumpreg-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF dbg_MEM_Jump_out /= '1' THEN
            REPORT "FAIL: MEM_Jump_out incorrect at cycle 9 (jump = 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_JumpReg_out /= '0' THEN
            REPORT "FAIL: MEM_JumpReg_out incorrect at cycle 9 (jumpreg = 1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        ---------------------jump and jumpreg------------------------------------------------------------------------------------------------------------------------------------------------------------

        IF dbg_MEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEM_RegWrite_out incorrect at cycle 9 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_MEM_ALUResult_out /= x"00000018") THEN
            REPORT "FAIL: MEM_ALUResult_out incorrect at cycle 9 (JAL, expected 0x18, got " &
                to_hstring(dbg_MEM_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_MEM_rd_out /= "00001") THEN
            REPORT "FAIL: MEM_rd_out incorrect for JAL x1 (expected rd=1, got " &
                INTEGER'image(to_integer(unsigned(dbg_MEM_rd_out))) &
                ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --jalr
        IF (dbg_EX_ALUResult_out /= x"0000001C") THEN
            REPORT "FAIL: EX_ALUResult_out incorrect at cycle 9 (JALR, expected NPC=0x1C, got " &
                to_hstring(dbg_EX_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '1' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 9 (JALR, expected 1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_BranchTarget /= x"00000002") THEN
            REPORT "FAIL: EX_BranchTarget incorrect at cycle 9 (JALR, expected x2+0 bit0 cleared=2, got " &
                to_hstring(dbg_EX_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        ---------------------jump and jumpreg-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF dbg_EX_Jump_out /= '0' THEN
            REPORT "FAIL: EXMEM_Jump_out incorrect at cycle 9 (jump = 1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_JumpReg_out /= '1' THEN
            REPORT "FAIL: EXMEM_JumpReg_out incorrect at cycle 9 (jumpreg = 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        ---------------------jump and jumpreg------------------------------------------------------------------------------------------------------------------------------------------------------------

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 9 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --lui
        IF (dbg_imm /= x"00005000") THEN
            REPORT "FAIL: imm incorrect at cycle 9 (LUI, expected 0x00005000, got " &
                to_hstring(dbg_imm) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '1' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 9 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUOp /= "11") THEN
            REPORT "FAIL: ALUOp incorrect at cycle 9 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUFunc /= "1010") THEN
            REPORT "FAIL: ALUFunc incorrect at cycle 9 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 9 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --sra
        IF (dbg_IF_IR /= "01000000001000001101001100110011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 9 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"00000024") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 9 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 10: JAL in MEMWB
        -- critical: ALUResult=0x18 (return address to write to x1), RegWrite=1, MemToReg=0
        -- jalr in mem
        -- lui in ex
        -- sra in id
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_MEMWB_ALUResult_out /= x"00000018") THEN
            REPORT "FAIL: MEMWB_ALUResult_out incorrect at cycle 10 (JAL, expected 0x18, got " &
                to_hstring(dbg_MEMWB_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 10 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEMWB_MemToReg_out incorrect at cycle 10 (JAL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        ---------------------jump and jumpreg-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        IF dbg_MEMWB_Jump_out /= '1' THEN
            REPORT "FAIL: MEMWB_Jump_out incorrect at cycle 10 (jump = 0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_JumpReg_out /= '0' THEN
            REPORT "FAIL: MEMWB_JumpReg_out incorrect at cycle 10 (jumpreg = 1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        ---------------------jump and jumpreg---------------------------------------------------------------------------------------------------------------------------------------------------------
        IF (dbg_MEMWB_rd_out /= "00001") THEN
            REPORT "FAIL: MEMWB_rd_out incorrect for JAL x1 (expected rd=1, got " &
                INTEGER'image(to_integer(unsigned(dbg_MEMWB_rd_out))) &
                ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        --jalr
        IF (dbg_EXMEM_ALUResult_out /= x"0000001C") THEN
            REPORT "FAIL: EXMEM_ALUResult_out incorrect at cycle 10 (JALR, expected 0x1C, got " &
                to_hstring(dbg_EXMEM_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_BranchTaken /= '1' THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 10 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_BranchTarget /= x"00000002") THEN
            REPORT "FAIL: EXMEM_BranchTarget incorrect at cycle 10 (JALR, expected 0x2, got " &
                to_hstring(dbg_EXMEM_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEM_RegWrite_out incorrect at cycle 10 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_MEM_ALUResult_out /= x"0000001C") THEN
            REPORT "FAIL: MEM_ALUResult_out incorrect at cycle 10 (JALR, expected 0x1C, got " &
                to_hstring(dbg_MEM_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --lui ex
        IF (dbg_EX_ALUResult_out /= x"00005000") THEN
            REPORT "FAIL: EX_ALUResult_out incorrect at cycle 10 (LUI, expected 0x00005000, got " &
                to_hstring(dbg_EX_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 10 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 10 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --sra
        IF (dbg_A /= x"00000005") THEN
            REPORT "FAIL: A incorrect at cycle 10 (SRA, expected x1=5, got " &
                to_hstring(dbg_A) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000003") THEN
            REPORT "FAIL: B incorrect at cycle 10 (SRA, expected x2=3, got " &
                to_hstring(dbg_B) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '0' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 10 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUOp /= "10") THEN
            REPORT "FAIL: ALUOp incorrect at cycle 10 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUFunc /= "0111") THEN
            REPORT "FAIL: ALUFunc incorrect at cycle 10 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 10 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 11: JALR in MEMWB
        -- critical: ALUResult=0x1C (return address to write to x1), RegWrite=1, MemToReg=0
        -- lui mem
        -- sra in ex
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_MEMWB_ALUResult_out /= x"0000001C") THEN
            REPORT "FAIL: MEMWB_ALUResult_out incorrect at cycle 11 (JALR, expected 0x1C, got " &
                to_hstring(dbg_MEMWB_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 11 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEMWB_MemToReg_out incorrect at cycle 11 (JALR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --lui
        IF (dbg_MEM_ALUResult_out /= x"00005000") THEN
            REPORT "FAIL: MEM_ALUResult_out incorrect at cycle 11 (LUI, expected 0x00005000, got " &
                to_hstring(dbg_MEM_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEM_RegWrite_out incorrect at cycle 11 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEM_MemToReg_out incorrect at cycle 11 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --sra
        IF (dbg_EX_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: EX_ALUResult_out incorrect at cycle 11 (SRA, expected 5>>3=0, got " &
                to_hstring(dbg_EX_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 11 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 11 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 12: LUI in MEMWB
        -- critical: ALUResult=0x00005000, RegWrite=1, MemToReg=0
        --sra in mem
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_MEMWB_ALUResult_out /= x"00005000") THEN
            REPORT "FAIL: MEMWB_ALUResult_out incorrect at cycle 12 (LUI, expected 0x00005000, got " &
                to_hstring(dbg_MEMWB_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 12 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEMWB_MemToReg_out incorrect at cycle 12 (LUI)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --sra
        IF (dbg_MEM_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: MEM_ALUResult_out incorrect at cycle 12 (SRA, expected 0, got " &
                to_hstring(dbg_MEM_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEM_RegWrite_out incorrect at cycle 12 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEM_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEM_MemToReg_out incorrect at cycle 12 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 13: SRA in MEMWB
        -- critical: ALUResult=0, RegWrite=1, MemToReg=0
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_MEMWB_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: MEMWB_ALUResult_out incorrect at cycle 13 (SRA, expected 0, got " &
                to_hstring(dbg_MEMWB_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_RegWrite_out /= '1' THEN
            REPORT "FAIL: MEMWB_RegWrite_out incorrect at cycle 13 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MEMWB_MemToReg_out /= '0' THEN
            REPORT "FAIL: MEMWB_MemToReg_out incorrect at cycle 13 (SRA)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT FOR 5 ns;

        REPORT "===================================" SEVERITY note;
        REPORT "Results: " & INTEGER'image(pass_count) &
            " passed, " & INTEGER'image(fail_count) & " failed." SEVERITY note;
        IF fail_count = 0 THEN
            REPORT "All tests PASSED." SEVERITY note;
        ELSE
            REPORT "Some tests FAILED - check output above." SEVERITY error;
        END IF;
        ASSERT false REPORT "Simulation done" SEVERITY failure;
    END PROCESS;

END;