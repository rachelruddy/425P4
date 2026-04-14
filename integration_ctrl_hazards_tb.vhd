LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY integration_ctrl_hazards_tb IS
END;

ARCHITECTURE tb OF integration_ctrl_hazards_tb IS
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
	BEGIN
		-- reset
		reset <= '1';
		WAIT FOR 1 ns;
		reset <= '0';

		-- =====================================================================

		-- =====================================================================
		-------------------------------------------------------------------------------------------------------------------------------
		-- integration_ctrl_hazards_bin.txt contains instr1: beq (taken), all intermediate instr are ADD (not executed), last instr is xor (branch target). this works!
		-- integration_ctrl_...........2 also works, contains:
		-- addi x1, x0, 10       -- set x1 = 10
		-- nop x5                 -- enough nops so no data hazard
		-- jal x3, [skip 3]       -- jump forward, save return address in x3
		-- addi x10, x0, 99      -- : should be flushed, x10 stays 0
		-- addi x11, x0, 99      -- : should be flushed, x11 stays 0
		-- addi x12, x0, 99      -- : should be flushed, x12 stays 0
		-- addi x4, x0, 20       -- jump lands here, x4 = 20
		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 1 -beq in if
		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-- cycle 2 -beq in id
		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;
		REPORT "DEBUG BEQ in ID: IFID_IR=" & to_hstring(dbg_IFID_IR) SEVERITY note;
		REPORT "DEBUG BEQ in ID: imm=" & to_hstring(dbg_imm) SEVERITY note;
		REPORT "DEBUG BEQ in ID: IR(30:25)=" & to_hstring("00" & dbg_IFID_IR(30 DOWNTO 25)) SEVERITY note;
		REPORT "DEBUG BEQ in ID: IR(11:8)=" & to_hstring("0000" & dbg_IFID_IR(11 DOWNTO 8)) SEVERITY note;
		REPORT "DEBUG BEQ in ID: IR(7)=" & STD_LOGIC'image(dbg_IFID_IR(7)) SEVERITY note;
		REPORT "DEBUG BEQ in ID: IR(31)=" & STD_LOGIC'image(dbg_IFID_IR(31)) SEVERITY note;

		-- cycle 3 -beq in ex
		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;
		REPORT "DEBUG BEQ in EX: EX_BranchTarget=" & to_hstring(dbg_EX_BranchTarget) SEVERITY note;
		REPORT "DEBUG BEQ in EX: EX_BranchTaken=" & STD_LOGIC'image(dbg_EX_BranchTaken) SEVERITY note;
		WAIT;
	END PROCESS;

END;