LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY execute_tb IS
END execute_tb;

ARCHITECTURE tb OF execute_tb IS

    COMPONENT execute IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Imm : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUSrc : IN STD_LOGIC;
            ALUFunc : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Branch : IN STD_LOGIC;
            BranchType : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Jump : IN STD_LOGIC;
            JumpReg : IN STD_LOGIC;
            MemRead : IN STD_LOGIC;
            MemWrite : IN STD_LOGIC;
            RegWrite : IN STD_LOGIC;
            MemToReg : IN STD_LOGIC;
            ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            B_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            BranchTaken : OUT STD_LOGIC;
            BranchTarget : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            MemRead_out : OUT STD_LOGIC;
            MemWrite_out : OUT STD_LOGIC;
            RegWrite_out : OUT STD_LOGIC;
            MemToReg_out : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';

    -- inputs
    SIGNAL A : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Imm : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL IR : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL NPC : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ALUSrc : STD_LOGIC := '0';
    SIGNAL ALUFunc : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Branch : STD_LOGIC := '0';
    SIGNAL BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Jump : STD_LOGIC := '0';
    SIGNAL JumpReg : STD_LOGIC := '0';
    SIGNAL MemRead : STD_LOGIC := '0';
    SIGNAL MemWrite : STD_LOGIC := '0';
    SIGNAL RegWrite : STD_LOGIC := '0';
    SIGNAL MemToReg : STD_LOGIC := '0';

    -- outputs
    SIGNAL ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL B_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL BranchTaken : STD_LOGIC;
    SIGNAL BranchTarget : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MemRead_out : STD_LOGIC;
    SIGNAL MemWrite_out : STD_LOGIC;
    SIGNAL RegWrite_out : STD_LOGIC;
    SIGNAL MemToReg_out : STD_LOGIC;

    CONSTANT VAL_A : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000005"; -- 5
    CONSTANT VAL_B : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000003"; -- 3
    CONSTANT VAL_NEG : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"FFFFFFFE"; -- -2 signed
    CONSTANT VAL_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000008"; -- PC=4, NPC=8
    CONSTANT VAL_IMM : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000007"; -- imm = 7
    -- branch/jump immediate of +8: offset from PC(4) -> target = 4+8 = 12 = 0xC
    CONSTANT VAL_BR_IMM : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000008"; -- branch offset

    CONSTANT DUMMY_IR : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";

BEGIN

    uut : execute
    PORT MAP(
        clk => clk,
        reset => reset,
        A => A,
        B => B,
        Imm => Imm,
        IR => IR,
        NPC => NPC,
        ALUSrc => ALUSrc,
        ALUFunc => ALUFunc,
        Branch => Branch,
        BranchType => BranchType,
        Jump => Jump,
        JumpReg => JumpReg,
        MemRead => MemRead,
        MemWrite => MemWrite,
        RegWrite => RegWrite,
        MemToReg => MemToReg,
        ALUResult_out => ALUResult_out,
        B_out => B_out,
        IR_out => IR_out,
        NPC_out => NPC_out,
        BranchTaken => BranchTaken,
        BranchTarget => BranchTarget,
        MemRead_out => MemRead_out,
        MemWrite_out => MemWrite_out,
        RegWrite_out => RegWrite_out,
        MemToReg_out => MemToReg_out
    );

    -- clock generation
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
        VARIABLE pass_count : INTEGER := 0;
        VARIABLE fail_count : INTEGER := 0;
    BEGIN

        -- -------------------------------------------------------------------
        -- Reset
        -- -------------------------------------------------------------------
        reset <= '1';
        WAIT FOR 1 ns;
        reset <= '0';

        A <= (OTHERS => '0');
        B <= (OTHERS => '0');
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= (OTHERS => '0');
        ALUSrc <= '0';
        ALUFunc <= "0000";
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        -- Flush reset state
        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        --------------------------------------------------------------------
        -- Test: ADD x3, x1, x2
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= VAL_B;
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0000";
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000008") THEN
            REPORT "FAIL: ALUResult_out incorrect for ADD (expected 0x8)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for ADD" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for ADD" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemRead_out /= '0') THEN
            REPORT "FAIL: MemRead_out should be 0 for ADD" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemWrite_out /= '0') THEN
            REPORT "FAIL: MemWrite_out should be 0 for ADD" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (NPC_out /= VAL_NPC) THEN
            REPORT "FAIL: NPC_out not passed through for ADD" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (B_out /= VAL_B) THEN
            REPORT "FAIL: B_out not passed through for ADD" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: SUB x3, x1, x2 (5-3)
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= VAL_B;
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001"; -- SUB
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000002") THEN
            REPORT "FAIL: ALUResult_out incorrect for SUB (expected 0x2)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for SUB" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for SUB" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: MUL x3, x1, x2
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= VAL_B;
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0010"; -- MUL
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"0000000F") THEN
            REPORT "FAIL: ALUResult_out incorrect for MUL (expected 0xF)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for MUL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for MUL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- -----------------------------------------------------------------
        -- Test: OR x3, x1, x2
        -- -----------------------------------------------------------------
        A <= VAL_A;
        B <= VAL_B;
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0100"; -- OR
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000007") THEN
            REPORT "FAIL: ALUResult_out incorrect for OR (expected 0x7)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for OR" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for OR" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: AND x3, x1, x2
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= VAL_B;
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0011"; -- AND
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000001") THEN
            REPORT "FAIL: ALUResult_out incorrect for AND (expected 0x1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for AND" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for AND" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: SLL x3, x1, x2   (rd = rs1 << rs2)
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= VAL_B;
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0101"; -- SLL
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000028") THEN
            REPORT "FAIL: ALUResult_out incorrect for SLL (expected 0x28)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for SLL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for SLL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        --------------------------------------------------------------------
        -- Test: SRL x3, x1, x2  (R-type)
        --------------------------------------------------------------------
        A <= x"00000028"; -- 40
        B <= VAL_B; -- shift by 3
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0110"; -- SRL
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000005") THEN
            REPORT "FAIL: ALUResult_out incorrect for SRL (expected 0x5)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for SRL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for SRL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: SRA x3, x1, x2   (rd = rs1 >> rs2, arithmetic/msb-extends)
        --------------------------------------------------------------------
        A <= x"FFFFFFF8"; -- -8 signed
        B <= x"00000002"; -- shift amount 2
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0111"; -- SRA
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"FFFFFFFE") THEN
            REPORT "FAIL: ALUResult_out incorrect for SRA (expected 0xFFFFFFFE)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for SRA" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for SRA" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: ADDI x3, x1, 7
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= (OTHERS => '0'); -- not used (ALUSrc=1)
        Imm <= VAL_IMM; -- 7
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1'; -- use immediate
        ALUFunc <= "0000"; -- ADD
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"0000000C") THEN
            REPORT "FAIL: ALUResult_out incorrect for ADDI (expected 0xC)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for ADDI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for ADDI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemRead_out /= '0') THEN
            REPORT "FAIL: MemRead_out should be 0 for ADDI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemWrite_out /= '0') THEN
            REPORT "FAIL: MemWrite_out should be 0 for ADDI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: XORI x3, x1, 7
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= (OTHERS => '0');
        Imm <= VAL_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "1000"; -- XOR
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000002") THEN
            REPORT "FAIL: ALUResult_out incorrect for XORI (expected 0x2)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for XORI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for XORI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- -----------------------------------------------------------------
        -- Test: ORI x3, x1, 7
        -- -----------------------------------------------------------------
        A <= VAL_A;
        B <= (OTHERS => '0');
        Imm <= VAL_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "0100"; -- OR
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000007") THEN
            REPORT "FAIL: ALUResult_out incorrect for ORI (expected 0x7)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for ORI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for ORI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: ANDI x3, x1, 7
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= (OTHERS => '0');
        Imm <= VAL_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "0011"; -- AND
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000005") THEN
            REPORT "FAIL: ALUResult_out incorrect for ANDI (expected 0x5)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for ANDI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for ANDI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: SLTI x3, x1, 7   (rd = rs1 < imm ? 1 : 0)
        --------------------------------------------------------------------
        A <= VAL_A; -- 5
        B <= (OTHERS => '0');
        Imm <= VAL_IMM; -- 7
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "1001"; -- SLT
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000001") THEN
            REPORT "FAIL: ALUResult_out incorrect for SLTI 5<7 (expected 0x1)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for SLTI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for SLTI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: SLTI x3, x1, 3
        --------------------------------------------------------------------
        A <= VAL_A; -- 5
        B <= (OTHERS => '0');
        Imm <= VAL_B; -- 3
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "1001"; -- SLT
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000000") THEN
            REPORT "FAIL: ALUResult_out incorrect for SLTI 5<3=false (expected 0x0)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for SLTI false case" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: LW x3, 4(x1)
        --------------------------------------------------------------------
        A <= VAL_A; -- base addr = 5
        B <= (OTHERS => '0');
        Imm <= x"00000004"; -- offset = 4
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "0000"; -- ADD (address calculation)
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '1'; -- load
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '1'; -- write mem data to reg

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000009") THEN
            REPORT "FAIL: ALUResult_out incorrect for LW address (expected 0x9)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for LW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemRead_out /= '1') THEN
            REPORT "FAIL: MemRead_out should be 1 for LW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemWrite_out /= '0') THEN
            REPORT "FAIL: MemWrite_out should be 0 for LW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for LW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemToReg_out /= '1') THEN
            REPORT "FAIL: MemToReg_out should be 1 for LW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: SW x2, 4(x1)
        --------------------------------------------------------------------
        A <= VAL_A; -- base addr = 5
        B <= VAL_B; -- data to store = 3
        Imm <= x"00000004"; -- offset = 4
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "0000"; -- ADD
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '1'; -- store
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00000009") THEN
            REPORT "FAIL: ALUResult_out incorrect for SW address (expected 0x9)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (B_out /= VAL_B) THEN
            REPORT "FAIL: B_out should carry store data for SW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for SW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemWrite_out /= '1') THEN
            REPORT "FAIL: MemWrite_out should be 1 for SW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (MemRead_out /= '0') THEN
            REPORT "FAIL: MemRead_out should be 0 for SW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '0') THEN
            REPORT "FAIL: RegWrite_out should be 0 for SW" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        --------------------------------------------------------------------
        -- Test: BEQ taken  (B-type, rs1==rs2)
        --------------------------------------------------------------------
        A <= VAL_A; -- 5
        B <= VAL_A; -- 5 (equal to A)
        Imm <= VAL_BR_IMM; -- offset 8
        IR <= DUMMY_IR;
        NPC <= VAL_NPC; -- NPC=8, PC=4
        ALUSrc <= '0';
        ALUFunc <= "0001"; -- SUB (generates Eq/Lt flags)
        Branch <= '1';
        BranchType <= "000"; -- BEQ
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for BEQ (equal)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTarget /= x"0000000C") THEN
            REPORT "FAIL: BranchTarget incorrect for BEQ (expected 0xC)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        --------------------------------------------------------------------
        -- Test: BEQ not taken  (B-type, rs1 /= rs2)
        --------------------------------------------------------------------
        A <= VAL_A; -- 5
        B <= VAL_B; -- 3 (not equal)
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "000"; -- BEQ
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for BEQ (not equal)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        --------------------------------------------------------------------
        -- Test: BNE taken  (B-type, rs1 /= rs2)
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= VAL_B;
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "001"; -- BNE
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for BNE (not equal)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTarget /= x"0000000C") THEN
            REPORT "FAIL: BranchTarget incorrect for BNE (expected 0xC)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;
        --------------------------------------------------------------------
        -- Test: BNE not taken  (B-type, rs1 == rs2)
        --------------------------------------------------------------------
        A <= VAL_A;
        B <= VAL_A; -- equal
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "001"; -- BNE
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for BNE (equal)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: BLT taken  (B-type, rs1 < rs2 signed)
        --------------------------------------------------------------------

        A <= VAL_B; -- 3
        B <= VAL_A; -- 5  (A < B)
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "100"; -- BLT
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for BLT (3 < 5)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTarget /= x"0000000C") THEN
            REPORT "FAIL: BranchTarget incorrect for BLT (expected 0xC)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: BLT not taken  (B-type, rs1 >= rs2 signed)
        --------------------------------------------------------------------

        A <= VAL_A; -- 5
        B <= VAL_B; -- 3  (A > B, not less)
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "100"; -- BLT
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for BLT (5 >= 3)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: BLT signed negative test (taken)
        --------------------------------------------------------------------
        A <= VAL_NEG; -- -2
        B <= VAL_A; -- 5
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "100"; -- BLT
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for BLT signed (-2 < 5)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: BGE taken  (B-type, rs1 >= rs2 signed)
        --------------------------------------------------------------------

        A <= VAL_A; -- 5
        B <= VAL_B; -- 3  (A >= B)
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "101"; -- BGE
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for BGE (5 >= 3)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTarget /= x"0000000C") THEN
            REPORT "FAIL: BranchTarget incorrect for BGE (expected 0xC)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: BGE taken on equal  (B-type, rs1 == rs2)
        --------------------------------------------------------------------

        A <= VAL_A;
        B <= VAL_A; -- equal
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "101"; -- BGE
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for BGE (equal)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: BGE not taken  (B-type, rs1 < rs2 signed)
        --------------------------------------------------------------------
        A <= VAL_B; -- 3
        B <= VAL_A; -- 5  (A < B)
        Imm <= VAL_BR_IMM;
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '0';
        ALUFunc <= "0001";
        Branch <= '1';
        BranchType <= "101"; -- BGE
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for BGE (3 < 5)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: JAL  (J-type)
        --------------------------------------------------------------------

        A <= VAL_A;
        B <= (OTHERS => '0');
        Imm <= VAL_BR_IMM; -- offset = 8
        IR <= DUMMY_IR;
        NPC <= VAL_NPC; -- NPC=8, PC=4
        ALUSrc <= '1';
        ALUFunc <= "0000";
        Branch <= '0';
        BranchType <= "000";
        Jump <= '1'; -- JAL
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for JAL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTarget /= x"0000000C") THEN
            REPORT "FAIL: BranchTarget incorrect for JAL (expected 0xC)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- JAL writes NPC (return address) to rd via ALUResult_out
        IF (ALUResult_out /= VAL_NPC) THEN
            REPORT "FAIL: ALUResult_out should be NPC (return addr) for JAL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for JAL" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: JALR  (I-type)
        --------------------------------------------------------------------
        A <= x"00000010"; -- rs1 = 16
        B <= (OTHERS => '0');
        Imm <= x"00000004"; -- imm = 4
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "0000";
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '1'; -- JALR
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for JALR" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTarget /= x"00000014") THEN
            REPORT "FAIL: BranchTarget incorrect for JALR (expected 0x14)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (ALUResult_out /= VAL_NPC) THEN
            REPORT "FAIL: ALUResult_out should be NPC (return addr) for JALR" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for JALR" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: JALR bit-0 clear test
        --------------------------------------------------------------------
        A <= x"00000011"; -- 17 (odd address)
        B <= (OTHERS => '0');
        Imm <= (OTHERS => '0');
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "0000";
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '1';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (BranchTarget /= x"00000010") THEN
            REPORT "FAIL: BranchTarget bit-0 not cleared for JALR (expected 0x10)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '1') THEN
            REPORT "FAIL: BranchTaken should be 1 for JALR (odd addr test)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: LUI  (U-type)
        --------------------------------------------------------------------
        A <= (OTHERS => '0'); -- LUI does not use rs1 (x0)
        B <= (OTHERS => '0');
        Imm <= x"12345000"; -- pre-shifted immediate (imm20<<12)
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "0000"; -- ADD  (0 + Imm)
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"12345000") THEN
            REPORT "FAIL: ALUResult_out incorrect for LUI (expected 0x12345000)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for LUI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for LUI" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        --------------------------------------------------------------------
        -- Test: LW x3, 4(x1)
        --------------------------------------------------------------------

        -- ===================================================================
        -- CYCLE 31  -  AUIPC  (U-type)
        --   AUIPC: rd = PC + (imm20 << 12)
        --   Instruction decode passes A=PC (current PC, not NPC) and
        --   Imm = imm20 << 12.  ALUSrc=1, ALUFunc=ADD.
        --   Here: A=0x00000004 (PC), Imm=0x00001000 (imm20=1, shifted)
        --   Expected ALUResult = 4 + 0x1000 = 0x00001004
        -- ===================================================================
        A <= x"00000004"; -- current PC supplied by ID stage
        B <= (OTHERS => '0');
        Imm <= x"00001000"; -- imm20<<12 = 1<<12 = 0x1000
        IR <= DUMMY_IR;
        NPC <= VAL_NPC;
        ALUSrc <= '1';
        ALUFunc <= "0000"; -- ADD
        Branch <= '0';
        BranchType <= "000";
        Jump <= '0';
        JumpReg <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '1';
        MemToReg <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR 0.1 ns;

        IF (ALUResult_out /= x"00001004") THEN
            REPORT "FAIL: ALUResult_out incorrect for AUIPC (expected 0x1004)" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (BranchTaken /= '0') THEN
            REPORT "FAIL: BranchTaken should be 0 for AUIPC" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        IF (RegWrite_out /= '1') THEN
            REPORT "FAIL: RegWrite_out should be 1 for AUIPC" SEVERITY error;
            fail_count := fail_count + 1;
        ELSE
            pass_count := pass_count + 1;
        END IF;

        -- ===================================================================
        -- Summary report
        -- ===================================================================
        REPORT "======================================" SEVERITY note;
        REPORT "Execute testbench complete." SEVERITY note;
        REPORT "PASS: " & INTEGER'IMAGE(pass_count) SEVERITY note;
        REPORT "FAIL: " & INTEGER'IMAGE(fail_count) SEVERITY note;
        REPORT "======================================" SEVERITY note;

        WAIT;
    END PROCESS;

END tb;