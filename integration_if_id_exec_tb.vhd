LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY integration_if_id_exec_tb IS
END;

ARCHITECTURE tb OF integration_if_id_exec_tb IS
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
    SIGNAL dbg_EXMEM_MemRead_out : STD_LOGIC;
    SIGNAL dbg_EXMEM_MemWrite_out : STD_LOGIC;
    SIGNAL dbg_EXMEM_RegWrite_out : STD_LOGIC;
    SIGNAL dbg_EXMEM_MemToReg_out : STD_LOGIC;
    --EX/MEM pipeline regs

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
            dbg_EXMEM_MemRead_out : OUT STD_LOGIC;
            dbg_EXMEM_MemWrite_out : OUT STD_LOGIC;
            dbg_EXMEM_RegWrite_out : OUT STD_LOGIC;
            dbg_EXMEM_MemToReg_out : OUT STD_LOGIC

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
        dbg_EXMEM_MemRead_out => dbg_EXMEM_MemRead_out,
        dbg_EXMEM_MemWrite_out => dbg_EXMEM_MemWrite_out,
        dbg_EXMEM_RegWrite_out => dbg_EXMEM_RegWrite_out,
        dbg_EXMEM_MemToReg_out => dbg_EXMEM_MemToReg_out
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
        -- instructions are already loaded into instruction memory via the tcl 
        -- file for this integration test- binary instructions are located in 
        -- integration_if_id_test_bin.txt

        -- i added intermediary signals all prefixed "dbg"
        -- this allows us to view the values of the signals inside of 
        -- processor.vhd while the component is running
        -- once testing is done, we can remove these debugging signals

        -- for future integration tests, they can build off of the flow of this one
        -- integration_if_id_test_bin contains almost every instruction except
        -- srl, slti, and auipc
        -- when integrating execute into the pipeline, can keep this source code
        -- and add debug signals inside of processor that allow us to access 
        -- the input signals of EX, the EX/MEM pipeline register signals, 
        -- and the output signals of EX

        -- idea is you would keep all if the code below, add those dbg signals
        -- into processor.vhd, then for each cycle you can see whether you are 
        -- getting the expected results for execute
        -- =====================================================================

        -- wait for first rising edge
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 1: IF should have first instruction- ADD x3, x1, x2
        -------------------------------------------------------------------------------------------------------------------------------
        IF (dbg_IF_IR /= "00000000001000001000000110110011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 1" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= "00000000000000000000000000000100") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 1" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 2: IF/ID pipeline registers should have instr 1's IR and NPC (dbg_IFID_IR, dbg_IFID_NPC ), and outputs of ID (dbg_ID_IR, dbg_ID_NPC, dbg_A, dbg_B, 
        -- dbg_imm, dbg_ALUSrc dbg_ALUOp, dbg_ALUFunc, dbg_Branch, dbg_BranchType, dbg_Jump, dbg_JumpReg, dbg_MemRead, dbg_MemWrite, 
        -- dbg_RegWrite, dbg_MemToReg) are all their values are correct for ADD x3, x1, x2
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_IFID_IR /= "00000000001000001000000110110011") THEN
            REPORT "FAIL: IFID_IR incorrect at cycle 2" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IFID_NPC /= "00000000000000000000000000000100") THEN
            REPORT "FAIL: IFID_NPC incorrect at cycle 2" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_IR /= "00000000001000001000000110110011") THEN
            REPORT "FAIL: ID_IR incorrect at cycle 2" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_NPC /= "00000000000000000000000000000100") THEN
            REPORT "FAIL: ID_NPC incorrect at cycle 2" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_A /= x"00000005") THEN
            REPORT "FAIL: A incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000003") THEN
            REPORT "FAIL: B incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000000") THEN
            REPORT "FAIL: imm incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '0' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUOp /= "10") THEN
            REPORT "FAIL: ALUOp incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUFunc /= "0000") THEN
            REPORT "FAIL: ALUFunc incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Branch /= '0' THEN
            REPORT "FAIL: Branch incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Jump /= '0' THEN
            REPORT "FAIL: Jump incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '0' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 2 (ADD)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- assertions for SUB instruction:
        IF (dbg_IF_IR /= "01000000001000001000000110110011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 2 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= "00000000000000000000000000001000") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 2 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 3: ID/EX pipeline registers should have outputs instr1 from ID(dbg_IDEX_A,dbg_IDEX_B,dbg_IDEX_imm,dbg_IDEX_IR,
        -- dbg_IDEX_NPC,dbg_IDEX_ALUSrc,dbg_IDEX_ALUOp,dbg_IDEX_ALUFunc,dbg_IDEX_Branch,dbg_IDEX_BranchType,dbg_IDEX_Jump,
        -- dbg_IDEX_JumpReg,dbg_IDEX_MemWrite,dbg_IDEX_RegWrite, dbg_IDEX_MemToReg), and outputs of EX (dbg_EX_ALUResult_out, dbg_EX_B_out,
        -- dbg_EX_IR_out, dbg_EX_NPC_out, dbg_EX_BranchTaken, dbg_EX_BranchTarget, dbg_EX_MemRead_out, dbg_EX_MemWrite_out, 
        -- dbg_EX_RegWrite_out, dbg_EX_MemToReg_out) are all their values are correct for ADD x3, x1, x2
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_IDEX_IR /= "00000000001000001000000110110011") THEN
            REPORT "FAIL: IDEX_IR incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_NPC /= "00000000000000000000000000000100") THEN
            REPORT "FAIL: IDEX_NPC incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_A /= x"00000005") THEN
            REPORT "FAIL: IDEX_A incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_B /= x"00000003") THEN
            REPORT "FAIL: IDEX_B incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_ALUFunc /= "0000") THEN
            REPORT "FAIL: IDEX_ALUFunc incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_ALUSrc /= '0' THEN
            REPORT "FAIL: IDEX_ALUSrc incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_RegWrite /= '1' THEN
            REPORT "FAIL: IDEX_RegWrite incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemRead /= '0' THEN
            REPORT "FAIL: IDEX_MemRead incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemWrite /= '0' THEN
            REPORT "FAIL: IDEX_MemWrite incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- EX outputs (combinational, should be valid same cycle as IDEX)
        IF (dbg_EX_ALUResult_out /= x"00000008") THEN
            REPORT "FAIL: EX_ALUResult incorrect at cycle 3 (expected 5+3=8)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_IR_out /= "00000000001000001000000110110011") THEN
            REPORT "FAIL: EX_IR_out incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_NPC_out /= "00000000000000000000000000000100") THEN
            REPORT "FAIL: EX_NPC_out incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemRead_out /= '0' THEN
            REPORT "FAIL: EX_MemRead_out incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemWrite_out /= '0' THEN
            REPORT "FAIL: EX_MemWrite_out incorrect at cycle 3" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        -- SUB in ID, IF/ID has SUB, ID outputs decoded values for SUB
        IF (dbg_IFID_IR /= "01000000001000001000000110110011") THEN
            REPORT "FAIL: IFID_IR incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IFID_NPC /= "00000000000000000000000000001000") THEN
            REPORT "FAIL: IFID_NPC incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_IR /= "01000000001000001000000110110011") THEN
            REPORT "FAIL: ID_IR incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_NPC /= "00000000000000000000000000001000") THEN
            REPORT "FAIL: ID_NPC incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_A /= x"00000005") THEN
            REPORT "FAIL: A incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000003") THEN
            REPORT "FAIL: B incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000000") THEN
            REPORT "FAIL: imm incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '0' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUOp /= "10") THEN
            REPORT "FAIL: ALUOp incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUFunc /= "0001") THEN
            REPORT "FAIL: ALUFunc incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Branch /= '0' THEN
            REPORT "FAIL: Branch incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Jump /= '0' THEN
            REPORT "FAIL: Jump incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '0' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 3 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- MUL now entering IF
        IF (dbg_IF_IR /= "00000010001000001000000110110011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 3 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"0000000C") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 3 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 4: EX/MEM pipeline registers should have outputs instr1 from EX (dbg_EXMEM_ALUResult_out,dbg_EXMEM_B_out,dbg_EXMEM_IR_out,
        -- dbg_EXMEM_NPC_out, dbg_EXMEM_BranchTaken,dbg_EXMEM_BranchTarget,dbg_EXMEM_MemRead_out,dbg_EXMEM_MemWrite_out,
        -- dbg_EXMEM_RegWrite_out,dbg_EXMEM_MemToReg_out)
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_EXMEM_ALUResult_out /= x"00000008") THEN
            REPORT "FAIL: EXMEM_ALUResult incorrect at cycle 4 (expected 8)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_IR_out /= "00000000001000001000000110110011") THEN
            REPORT "FAIL: EXMEM_IR_out incorrect at cycle 4" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_NPC_out /= "00000000000000000000000000000100") THEN
            REPORT "FAIL: EXMEM_NPC_out incorrect at cycle 4" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_BranchTaken /= '0' THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 4" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: EXMEM_RegWrite_out incorrect at cycle 4" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemRead_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemRead_out incorrect at cycle 4" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemWrite_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemWrite_out incorrect at cycle 4" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- SUB in EX, ID/EX has SUB, EX outputs computed
        IF (dbg_IDEX_IR /= "01000000001000001000000110110011") THEN
            REPORT "FAIL: IDEX_IR incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_NPC /= "00000000000000000000000000001000") THEN
            REPORT "FAIL: IDEX_NPC incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_A /= x"00000005") THEN
            REPORT "FAIL: IDEX_A incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_B /= x"00000003") THEN
            REPORT "FAIL: IDEX_B incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_ALUFunc /= "0001") THEN
            REPORT "FAIL: IDEX_ALUFunc incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_ALUSrc /= '0' THEN
            REPORT "FAIL: IDEX_ALUSrc incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_RegWrite /= '1' THEN
            REPORT "FAIL: IDEX_RegWrite incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemRead /= '0' THEN
            REPORT "FAIL: IDEX_MemRead incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemWrite /= '0' THEN
            REPORT "FAIL: IDEX_MemWrite incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_ALUResult_out /= x"00000002") THEN
            REPORT "FAIL: EX_ALUResult incorrect at cycle 4 (SUB, expected 5-3=2)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_IR_out /= "01000000001000001000000110110011") THEN
            REPORT "FAIL: EX_IR_out incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_NPC_out /= "00000000000000000000000000001000") THEN
            REPORT "FAIL: EX_NPC_out incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemRead_out /= '0' THEN
            REPORT "FAIL: EX_MemRead_out incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemWrite_out /= '0' THEN
            REPORT "FAIL: EX_MemWrite_out incorrect at cycle 4 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- MUL in IF/ID pipeline register
        IF (dbg_IFID_IR /= "00000010001000001000000110110011") THEN
            REPORT "FAIL: IFID_IR incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IFID_NPC /= x"0000000C") THEN
            REPORT "FAIL: IFID_NPC incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- MUL ID combinational outputs
        IF (dbg_ID_IR /= "00000010001000001000000110110011") THEN
            REPORT "FAIL: ID_IR incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_NPC /= x"0000000C") THEN
            REPORT "FAIL: ID_NPC incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_A /= x"00000005") THEN
            REPORT "FAIL: A incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000003") THEN
            REPORT "FAIL: B incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000000") THEN
            REPORT "FAIL: imm incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '0' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUOp /= "10") THEN
            REPORT "FAIL: ALUOp incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUFunc /= "0010") THEN
            REPORT "FAIL: ALUFunc incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Branch /= '0' THEN
            REPORT "FAIL: Branch incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Jump /= '0' THEN
            REPORT "FAIL: Jump incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '0' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 4 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- OR is in IF
        IF (dbg_IF_IR /= "00000000001000001110000110110011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 4 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"00000010") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 4 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 5: EX/MEM pipeline registers latch SUB results
        -------------------------------------------------------------------------------------------------------------------------------
        IF (dbg_EXMEM_ALUResult_out /= x"00000002") THEN
            REPORT "FAIL: EXMEM_ALUResult incorrect at cycle 5 (SUB, expected 2)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_IR_out /= "01000000001000001000000110110011") THEN
            REPORT "FAIL: EXMEM_IR_out incorrect at cycle 5 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_NPC_out /= "00000000000000000000000000001000") THEN
            REPORT "FAIL: EXMEM_NPC_out incorrect at cycle 5 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_BranchTaken /= '0' THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 5 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: EXMEM_RegWrite_out incorrect at cycle 5 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemRead_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemRead_out incorrect at cycle 5 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemWrite_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemWrite_out incorrect at cycle 5 (SUB)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- MUL in ID/EX pipeline register
        IF (dbg_IDEX_IR /= "00000010001000001000000110110011") THEN
            REPORT "FAIL: IDEX_IR incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_NPC /= x"0000000C") THEN
            REPORT "FAIL: IDEX_NPC incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_A /= x"00000005") THEN
            REPORT "FAIL: IDEX_A incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_B /= x"00000003") THEN
            REPORT "FAIL: IDEX_B incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_ALUFunc /= "0010") THEN
            REPORT "FAIL: IDEX_ALUFunc incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_ALUSrc /= '0' THEN
            REPORT "FAIL: IDEX_ALUSrc incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_RegWrite /= '1' THEN
            REPORT "FAIL: IDEX_RegWrite incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemRead /= '0' THEN
            REPORT "FAIL: IDEX_MemRead incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemWrite /= '0' THEN
            REPORT "FAIL: IDEX_MemWrite incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- MUL EX combinational outputs
        IF (dbg_EX_ALUResult_out /= x"0000000F") THEN
            REPORT "FAIL: EX_ALUResult incorrect at cycle 5 (MUL, expected 5*3=15)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_IR_out /= "00000010001000001000000110110011") THEN
            REPORT "FAIL: EX_IR_out incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_NPC_out /= x"0000000C") THEN
            REPORT "FAIL: EX_NPC_out incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemRead_out /= '0' THEN
            REPORT "FAIL: EX_MemRead_out incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemWrite_out /= '0' THEN
            REPORT "FAIL: EX_MemWrite_out incorrect at cycle 5 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- OR in IF/ID pipeline register
        IF (dbg_IFID_IR /= "00000000001000001110000110110011") THEN
            REPORT "FAIL: IFID_IR incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IFID_NPC /= x"00000010") THEN
            REPORT "FAIL: IFID_NPC incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- OR ID combinational outputs
        IF (dbg_ID_IR /= "00000000001000001110000110110011") THEN
            REPORT "FAIL: ID_IR incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_NPC /= x"00000010") THEN
            REPORT "FAIL: ID_NPC incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_A /= x"00000005") THEN
            REPORT "FAIL: A incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000003") THEN
            REPORT "FAIL: B incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000000") THEN
            REPORT "FAIL: imm incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '0' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUOp /= "10") THEN
            REPORT "FAIL: ALUOp incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUFunc /= "0100") THEN
            REPORT "FAIL: ALUFunc incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Branch /= '0' THEN
            REPORT "FAIL: Branch incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Jump /= '0' THEN
            REPORT "FAIL: Jump incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '1' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '0' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 5 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- SW now in IF
        IF (dbg_IF_IR /= "00000000001000001010001110100011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 5 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"00000014") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 5 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 6: EX/MEM pipeline registers latch MUL results
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_EXMEM_ALUResult_out /= x"0000000F") THEN
            REPORT "FAIL: EXMEM_ALUResult incorrect at cycle 6 (MUL, expected 15)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_IR_out /= "00000010001000001000000110110011") THEN
            REPORT "FAIL: EXMEM_IR_out incorrect at cycle 6 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_NPC_out /= x"0000000C") THEN
            REPORT "FAIL: EXMEM_NPC_out incorrect at cycle 6 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_BranchTaken /= '0' THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 6 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: EXMEM_RegWrite_out incorrect at cycle 6 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemRead_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemRead_out incorrect at cycle 6 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemWrite_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemWrite_out incorrect at cycle 6 (MUL)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- OR in ID/EX pipeline register
        IF (dbg_IDEX_IR /= "00000000001000001110000110110011") THEN
            REPORT "FAIL: IDEX_IR incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_NPC /= x"00000010") THEN
            REPORT "FAIL: IDEX_NPC incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_A /= x"00000005") THEN
            REPORT "FAIL: IDEX_A incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_B /= x"00000003") THEN
            REPORT "FAIL: IDEX_B incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_ALUFunc /= "0100") THEN
            REPORT "FAIL: IDEX_ALUFunc incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_ALUSrc /= '0' THEN
            REPORT "FAIL: IDEX_ALUSrc incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_RegWrite /= '1' THEN
            REPORT "FAIL: IDEX_RegWrite incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemRead /= '0' THEN
            REPORT "FAIL: IDEX_MemRead incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemWrite /= '0' THEN
            REPORT "FAIL: IDEX_MemWrite incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- OR EX combinational outputs
        IF (dbg_EX_ALUResult_out /= x"00000007") THEN
            REPORT "FAIL: EX_ALUResult incorrect at cycle 6 (OR, expected 5|3=7)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_IR_out /= "00000000001000001110000110110011") THEN
            REPORT "FAIL: EX_IR_out incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_NPC_out /= x"00000010") THEN
            REPORT "FAIL: EX_NPC_out incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '1' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemRead_out /= '0' THEN
            REPORT "FAIL: EX_MemRead_out incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemWrite_out /= '0' THEN
            REPORT "FAIL: EX_MemWrite_out incorrect at cycle 6 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- SW in IF/ID pipeline register
        IF (dbg_IFID_IR /= "00000000001000001010001110100011") THEN
            REPORT "FAIL: IFID_IR incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IFID_NPC /= x"00000014") THEN
            REPORT "FAIL: IFID_NPC incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_IR /= "00000000001000001010001110100011") THEN
            REPORT "FAIL: ID_IR incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_NPC /= x"00000014") THEN
            REPORT "FAIL: ID_NPC incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_A /= x"00000005") THEN
            REPORT "FAIL: A incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000003") THEN
            REPORT "FAIL: B incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000007") THEN
            REPORT "FAIL: imm incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '1' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUOp /= "00") THEN
            REPORT "FAIL: ALUOp incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUFunc /= "0000") THEN
            REPORT "FAIL: ALUFunc incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Branch /= '0' THEN
            REPORT "FAIL: Branch incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Jump /= '0' THEN
            REPORT "FAIL: Jump incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '0' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '1' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 6 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- BEQ in IF
        IF (dbg_IF_IR /= "00000010100101000000010001100011") THEN
            REPORT "FAIL: IF_IR incorrect at cycle 6 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IF_NPC /= x"00000018") THEN
            REPORT "FAIL: IF_NPC incorrect at cycle 6 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 7: EX/MEM pipeline registers latch OR results
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_EXMEM_ALUResult_out /= x"00000007") THEN
            REPORT "FAIL: EXMEM_ALUResult incorrect at cycle 7 (OR, expected 5|3=7)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_IR_out /= "00000000001000001110000110110011") THEN
            REPORT "FAIL: EXMEM_IR_out incorrect at cycle 7 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_NPC_out /= x"00000010") THEN
            REPORT "FAIL: EXMEM_NPC_out incorrect at cycle 7 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_BranchTaken /= '0' THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 7 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_RegWrite_out /= '1' THEN
            REPORT "FAIL: EXMEM_RegWrite_out incorrect at cycle 7 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemRead_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemRead_out incorrect at cycle 7 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemWrite_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemWrite_out incorrect at cycle 7 (OR)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- SW in ID/EX pipeline register
        IF (dbg_IDEX_IR /= "00000000001000001010001110100011") THEN
            REPORT "FAIL: IDEX_IR incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_NPC /= x"00000014") THEN
            REPORT "FAIL: IDEX_NPC incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_A /= x"00000005") THEN
            REPORT "FAIL: IDEX_A incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_B /= x"00000003") THEN
            REPORT "FAIL: IDEX_B incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_imm /= x"00000007") THEN
            REPORT "FAIL: IDEX_imm incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_ALUSrc /= '1' THEN
            REPORT "FAIL: IDEX_ALUSrc incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_ALUOp /= "00") THEN
            REPORT "FAIL: IDEX_ALUOp incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_ALUFunc /= "0000") THEN
            REPORT "FAIL: IDEX_ALUFunc incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_RegWrite /= '0' THEN
            REPORT "FAIL: IDEX_RegWrite incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemRead /= '0' THEN
            REPORT "FAIL: IDEX_MemRead incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemWrite /= '1' THEN
            REPORT "FAIL: IDEX_MemWrite incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- SW EX combinational outputs
        IF (dbg_EX_ALUResult_out /= x"0000000C") THEN
            REPORT "FAIL: EX_ALUResult incorrect at cycle 7 (SW, expected 5+7=12)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_B_out /= x"00000003") THEN
            REPORT "FAIL: EX_B_out incorrect at cycle 7 (SW, expected x2=3)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_IR_out /= "00000000001000001010001110100011") THEN
            REPORT "FAIL: EX_IR_out incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_NPC_out /= x"00000014") THEN
            REPORT "FAIL: EX_NPC_out incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_BranchTaken /= '0' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '0' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemRead_out /= '0' THEN
            REPORT "FAIL: EX_MemRead_out incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemWrite_out /= '1' THEN
            REPORT "FAIL: EX_MemWrite_out incorrect at cycle 7 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- BEQ in IF/ID pipeline register
        IF (dbg_IFID_IR /= "00000010100101000000010001100011") THEN
            REPORT "FAIL: IFID_IR incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IFID_NPC /= x"00000018") THEN
            REPORT "FAIL: IFID_NPC incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- BEQ ID combinational outputs
        IF (dbg_ID_IR /= "00000010100101000000010001100011") THEN
            REPORT "FAIL: ID_IR incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ID_NPC /= x"00000018") THEN
            REPORT "FAIL: ID_NPC incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_A /= x"00000000") THEN
            REPORT "FAIL: A incorrect at cycle 7 (BEQ, expected x8=0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_B /= x"00000000") THEN
            REPORT "FAIL: B incorrect at cycle 7 (BEQ, expected x9=0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_imm /= x"00000028") THEN
            REPORT "FAIL: imm incorrect at cycle 7 (BEQ, expected x00000028, got " &
                to_hstring(dbg_imm) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_ALUSrc /= '0' THEN
            REPORT "FAIL: ALUSrc incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_ALUOp /= "01") THEN
            REPORT "FAIL: ALUOp incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Branch /= '1' THEN
            REPORT "FAIL: Branch incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_BranchType /= "000") THEN
            REPORT "FAIL: BranchType incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_Jump /= '0' THEN
            REPORT "FAIL: Jump incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_RegWrite /= '0' THEN
            REPORT "FAIL: RegWrite incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemRead /= '0' THEN
            REPORT "FAIL: MemRead incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_MemWrite /= '0' THEN
            REPORT "FAIL: MemWrite incorrect at cycle 7 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 8: EX/MEM pipeline registers latch SW results
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_EXMEM_ALUResult_out /= x"0000000C") THEN
            REPORT "FAIL: EXMEM_ALUResult incorrect at cycle 8 (SW, expected 5+7=12)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_B_out /= x"00000003") THEN
            REPORT "FAIL: EXMEM_B_out incorrect at cycle 8 (SW, expected x2=3)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_IR_out /= "00000000001000001010001110100011") THEN
            REPORT "FAIL: EXMEM_IR_out incorrect at cycle 8 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_NPC_out /= x"00000014") THEN
            REPORT "FAIL: EXMEM_NPC_out incorrect at cycle 8 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_BranchTaken /= '0' THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 8 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_RegWrite_out /= '0' THEN
            REPORT "FAIL: EXMEM_RegWrite_out incorrect at cycle 8 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemRead_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemRead_out incorrect at cycle 8 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemWrite_out /= '1' THEN
            REPORT "FAIL: EXMEM_MemWrite_out incorrect at cycle 8 (SW)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- BEQ in ID/EX pipeline register
        IF (dbg_IDEX_IR /= "00000010100101000000010001100011") THEN
            REPORT "FAIL: IDEX_IR incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_NPC /= x"00000018") THEN
            REPORT "FAIL: IDEX_NPC incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_A /= x"00000000") THEN
            REPORT "FAIL: IDEX_A incorrect at cycle 8 (BEQ, expected x8=0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_B /= x"00000000") THEN
            REPORT "FAIL: IDEX_B incorrect at cycle 8 (BEQ, expected x9=0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_imm /= x"00000028") THEN
            REPORT "FAIL: IDEX_imm incorrect at cycle 8 (BEQ, got " &
                to_hstring(dbg_IDEX_imm) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_ALUSrc /= '0' THEN
            REPORT "FAIL: IDEX_ALUSrc incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_ALUOp /= "01") THEN
            REPORT "FAIL: IDEX_ALUOp incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_Branch /= '1' THEN
            REPORT "FAIL: IDEX_Branch incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_IDEX_BranchType /= "000") THEN
            REPORT "FAIL: IDEX_BranchType incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_RegWrite /= '0' THEN
            REPORT "FAIL: IDEX_RegWrite incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemRead /= '0' THEN
            REPORT "FAIL: IDEX_MemRead incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_IDEX_MemWrite /= '0' THEN
            REPORT "FAIL: IDEX_MemWrite incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- BEQ EX combinational outputs
        IF (dbg_EX_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: EX_ALUResult incorrect at cycle 8 (BEQ, expected 0, got " &
                to_hstring(dbg_EX_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_IR_out /= "00000010100101000000010001100011") THEN
            REPORT "FAIL: EX_IR_out incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EX_NPC_out /= x"00000018") THEN
            REPORT "FAIL: EX_NPC_out incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- branch taken since x8 == x9 (both 0)
        IF dbg_EX_BranchTaken /= '1' THEN
            REPORT "FAIL: EX_BranchTaken incorrect at cycle 8 (BEQ, expected taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- BranchTarget = NPC - 4 + 40 = 0x18 - 4 + 40 = 0x3C
        IF (dbg_EX_BranchTarget /= x"0000003C") THEN
            REPORT "FAIL: EX_BranchTarget incorrect at cycle 8 (BEQ, expected 0x3C, got " &
                to_hstring(dbg_EX_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_RegWrite_out /= '0' THEN
            REPORT "FAIL: EX_RegWrite_out incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemRead_out /= '0' THEN
            REPORT "FAIL: EX_MemRead_out incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EX_MemWrite_out /= '0' THEN
            REPORT "FAIL: EX_MemWrite_out incorrect at cycle 8 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;
        -------------------------------------------------------------------------------------------------------------------------------
        -- cycle 9: EX/MEM pipeline registers latch BEQ results
        -------------------------------------------------------------------------------------------------------------------------------

        IF (dbg_EXMEM_ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: EXMEM_ALUResult incorrect at cycle 9 (BEQ, expected 0, got " &
                to_hstring(dbg_EXMEM_ALUResult_out) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_IR_out /= "00000010100101000000010001100011") THEN
            REPORT "FAIL: EXMEM_IR_out incorrect at cycle 9 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_NPC_out /= x"00000018") THEN
            REPORT "FAIL: EXMEM_NPC_out incorrect at cycle 9 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_BranchTaken /= '1' THEN
            REPORT "FAIL: EXMEM_BranchTaken incorrect at cycle 9 (BEQ, expected taken)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (dbg_EXMEM_BranchTarget /= x"0000003C") THEN
            REPORT "FAIL: EXMEM_BranchTarget incorrect at cycle 9 (BEQ, expected 0x3C, got " &
                to_hstring(dbg_EXMEM_BranchTarget) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_RegWrite_out /= '0' THEN
            REPORT "FAIL: EXMEM_RegWrite_out incorrect at cycle 9 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemRead_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemRead_out incorrect at cycle 9 (BEQ)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF dbg_EXMEM_MemWrite_out /= '0' THEN
            REPORT "FAIL: EXMEM_MemWrite_out incorrect at cycle 9 (BEQ)" SEVERITY error;
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