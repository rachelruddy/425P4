LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Execute stage
-- Responsibilities:
--   1. Compute ALU result for ALU instructions (A op B or A op Imm)
--   2. Compute memory address for loads/stores (A + Imm)
--   3. Compute branch target (NPC + Imm) and evaluate branch condition
--   4. Compute jump target (NPC + Imm for JAL, A + Imm for JALR)
--   5. Pass NPC forward as ALUResult for JAL/JALR writeback
--   6. Latch all outputs 

ENTITY execute IS
    PORT (
        clk        : IN STD_LOGIC;
        reset      : IN STD_LOGIC;

        -- datapath inputs from ID/EX pipeline register
        A          : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- rs1 value
        B          : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- rs2 value
        Imm        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- sign extended immediate
        IR         : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- instruction carried forward
        NPC        : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- PC+4 carried forward

        -- control signal inputs from ID/EX pipeline register
        ALUSrc     : IN STD_LOGIC;                      -- 0: use B, 1: use Imm
        ALUFunc    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);   -- ALU operation
        Branch     : IN STD_LOGIC;                      -- is this a branch?
        BranchType : IN STD_LOGIC_VECTOR(2 DOWNTO 0);  -- branch condition type
        Jump       : IN STD_LOGIC;                      -- is this JAL?
        JumpReg    : IN STD_LOGIC;                      -- is this JALR?
        MemRead    : IN STD_LOGIC;                      -- passed through to MEM
        MemWrite   : IN STD_LOGIC;                      -- passed through to MEM
        RegWrite   : IN STD_LOGIC;                      -- passed through to WB
        MemToReg   : IN STD_LOGIC;                      -- passed through to WB

        
        ALUResult_out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        B_out          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        IR_out         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        NPC_out        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        BranchTaken    : OUT STD_LOGIC;
        BranchTarget   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		  --new added to forward to wb
		  Jump_out    : OUT STD_LOGIC;
        JumpReg_out : OUT STD_LOGIC;

        -- control signals passed through to MEM/WB
        MemRead_out    : OUT STD_LOGIC;
        MemWrite_out   : OUT STD_LOGIC;
        RegWrite_out   : OUT STD_LOGIC;
        MemToReg_out   : OUT STD_LOGIC
    );
END execute;

ARCHITECTURE rtl OF execute IS

    -- ALU component declaration matching ALU.vhd exactly
    COMPONENT ALU IS
        PORT (
            A       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            B       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUFunc : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            Result  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Eq      : OUT STD_LOGIC;   -- A == B
            Lt      : OUT STD_LOGIC    -- signed A < signed B
        );
    END COMPONENT;

    -- BranchType constants matching instruction_decode.vhd encoding
    -- these must match funct3 values from the RISC-V reference card
    CONSTANT BR_BEQ : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT BR_BNE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT BR_BLT : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    CONSTANT BR_BGE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

    -- ALU input signals
    signal alu_in_A  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal alu_in_B  : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- ALU output signals
    signal alu_result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal alu_eq     : STD_LOGIC;   -- A == B
    signal alu_lt     : STD_LOGIC;   -- signed A < signed B

    -- branch/jump internal signals
    signal branch_cond   : STD_LOGIC;
    signal branch_taken  : STD_LOGIC;
    signal branch_target : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- the value that will be written to ALUResult_out
    -- for JAL/JALR this is NPC (return address)
    -- for all others this is alu_result
    signal result_to_latch : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
	-- combinatorial logic
	ALUResult_out  <= result_to_latch;
	B_out          <= B;
	IR_out         <= IR;
	NPC_out        <= NPC;
	BranchTaken    <= branch_taken;
	BranchTarget   <= branch_target;
	MemRead_out    <= MemRead;
	MemWrite_out   <= MemWrite;
	RegWrite_out   <= RegWrite;
	MemToReg_out   <= MemToReg;
	Jump_out       <= Jump;
   JumpReg_out    <= JumpReg;

    -- ALU input mux
    -- ALUSrc=0: use register values A and B (R-type, branches)
    -- ALUSrc=1: use A and immediate (I-type, loads, stores, JAL, JALR, AUIPC)
    -- special case: AUIPC needs NPC+Imm, but we handle that via ALUFunc
    alu_in_A <= A;
    alu_in_B <= Imm WHEN ALUSrc = '1' ELSE B;

    -- ALU instantiation
    alu_inst : ALU
        PORT MAP(
            A       => alu_in_A,
            B       => alu_in_B,
            ALUFunc => ALUFunc,
            Result  => alu_result,
            Eq      => alu_eq,
            Lt      => alu_lt
        );

    -- branch condition evaluation using ALU flags
    -- BranchType matches funct3 from instruction_decode.vhd
    PROCESS(BranchType, alu_eq, alu_lt)
    BEGIN
        CASE BranchType IS
            WHEN BR_BEQ => branch_cond <= alu_eq;
            WHEN BR_BNE => branch_cond <= NOT alu_eq;
            WHEN BR_BLT => branch_cond <= alu_lt;
            WHEN BR_BGE => branch_cond <= NOT alu_lt;
            WHEN OTHERS => branch_cond <= '0';
        END CASE;
    END PROCESS;

    -- branch/jump target and taken signal computation
    -- JAL:  target = NPC + Imm (PC relative, NPC = PC+4 so we use NPC-4+Imm)
    --       note: NPC here is PC+4, imm is already the full offset from PC
    --       so correct target = (NPC - 4) + Imm
    -- JALR: target = (A + Imm) with bit 0 cleared
    -- branch: target = NPC + Imm (Imm already encodes offset from PC,
    --         but since NPC=PC+4 we need (NPC-4)+Imm)
    PROCESS(Branch, branch_cond, Jump, JumpReg, A, Imm, NPC)
        VARIABLE pc        : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE jalr_raw  : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        -- recover PC from NPC
        pc := STD_LOGIC_VECTOR(UNSIGNED(NPC) - 4);

        IF Jump = '1' THEN
            -- JAL: unconditional, target = PC + Imm, writeback NPC to rd
            branch_taken  <= '1';
            branch_target <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(Imm));

        ELSIF JumpReg = '1' THEN
            -- JALR: unconditional, target = (A + Imm) with bit 0 cleared
            jalr_raw := STD_LOGIC_VECTOR(SIGNED(A) + SIGNED(Imm));
            jalr_raw(0) := '0';
            branch_taken  <= '1';
            branch_target <= jalr_raw;

        ELSIF Branch = '1' AND branch_cond = '1' THEN
            -- conditional branch taken: target = PC + Imm
            branch_taken  <= '1';
            branch_target <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(Imm));

        ELSE
            branch_taken  <= '0';
            branch_target <= (OTHERS => '0');
        END IF;
    END PROCESS;

    -- for JAL and JALR, ALUResult carries NPC (return address) forward to WB
    -- for all other instructions, ALUResult carries the ALU computation result
    result_to_latch <= NPC WHEN (Jump = '1' OR JumpReg = '1') ELSE alu_result;

   
    

END rtl;