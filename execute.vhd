LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY execute IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Imm : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        NPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALUSrc : IN STD_LOGIC;
        ALUFunc : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        AUSrc : IN STD_LOGIC;
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
END execute;

ARCHITECTURE rtl OF execute IS

    COMPONENT alu IS
        PORT (
            A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUFunc : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Zero : OUT STD_LOGIC;
            Negative : OUT STD_LOGIC;
            Carry : OUT STD_LOGIC;
            Overflow : OUT STD_LOGIC
        );
    END COMPONENT;

    CONSTANT BR_BEQ : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT BR_BNE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT BR_BLT : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT BR_BGE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
    CONSTANT BR_BLTU : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    CONSTANT BR_BGEU : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

    SIGNAL alu_in_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_in_B : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL alu_result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_zero : STD_LOGIC;
    SIGNAL alu_negative : STD_LOGIC;
    SIGNAL alu_carry : STD_LOGIC;
    SIGNAL alu_overflow : STD_LOGIC;

    SIGNAL branch_cond : STD_LOGIC;
    SIGNAL branch_taken : STD_LOGIC;
    SIGNAL branch_target : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL lt_signed : STD_LOGIC;
    SIGNAL lt_unsigned : STD_LOGIC;

BEGIN

    alu_in_A <= NPC WHEN AUSrc = '1' ELSE
        A;

    alu_in_B <= Imm WHEN ALUSrc = '1' ELSE
        B;

    alu_inst : alu
    PORT MAP(
        A => alu_in_A,
        B => alu_in_B,
        ALUFunc => ALUFunc,
        Result => alu_result,
        Zero => alu_zero,
        Negative => alu_negative,
        Carry => alu_carry,
        Overflow => alu_overflow
    );

    lt_signed <= alu_negative XOR alu_overflow;
    lt_unsigned <= NOT alu_carry;

    PROCESS (Branch, BranchType, alu_zero, lt_signed, lt_unsigned)
    BEGIN
        CASE BranchType IS
            WHEN BR_BEQ => branch_cond <= alu_zero;
            WHEN BR_BNE => branch_cond <= NOT alu_zero;
            WHEN BR_BLT => branch_cond <= lt_signed;
            WHEN BR_BGE => branch_cond <= NOT lt_signed;
            WHEN BR_BLTU => branch_cond <= lt_unsigned;
            WHEN BR_BGEU => branch_cond <= NOT lt_unsigned;
            WHEN OTHERS => branch_cond <= '0';
        END CASE;
    END PROCESS;

    PROCESS (Branch, branch_cond, Jump, JumpReg, A, Imm, NPC)
        VARIABLE jalr_raw : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        IF Jump = '1' THEN
            branch_taken <= '1';
            branch_target <= STD_LOGIC_VECTOR(
                UNSIGNED(NPC) + UNSIGNED(Imm));

        ELSIF JumpReg = '1' THEN
            jalr_raw := STD_LOGIC_VECTOR(
                SIGNED(A) + SIGNED(Imm));
            jalr_raw(0) := '0';
            branch_taken <= '1';
            branch_target <= jalr_raw;

        ELSIF Branch = '1' AND branch_cond = '1' THEN
            branch_taken <= '1';
            branch_target <= STD_LOGIC_VECTOR(
                UNSIGNED(NPC) + UNSIGNED(Imm));

        ELSE
            branch_taken <= '0';
            branch_target <= (OTHERS => '0');
        END IF;
    END PROCESS;

    pipeline_reg : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                ALUResult_out <= (OTHERS => '0');
                B_out <= (OTHERS => '0');
                IR_out <= x"00000013";
                NPC_out <= (OTHERS => '0');
                BranchTaken <= '0';
                BranchTarget <= (OTHERS => '0');
                MemRead_out <= '0';
                MemWrite_out <= '0';
                RegWrite_out <= '0';
                MemToReg_out <= '0';
            ELSE
                ALUResult_out <= alu_result;
                B_out <= B;
                IR_out <= IR;
                NPC_out <= NPC;
                BranchTaken <= branch_taken;
                BranchTarget <= branch_target;
                MemRead_out <= MemRead;
                MemWrite_out <= MemWrite;
                RegWrite_out <= RegWrite;
                MemToReg_out <= MemToReg;
            END IF;
        END IF;
    END PROCESS pipeline_reg;

END rtl;