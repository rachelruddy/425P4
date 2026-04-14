LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY integration_if_id_tb IS
END;

ARCHITECTURE tb OF integration_if_id_tb IS
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
			dbg_MemToReg : OUT STD_LOGIC
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
		dbg_MemToReg => dbg_MemToReg
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
		-- cycle 1: IF should have first instruction
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
		-- cycle 2: ID should now have ADD x3, x1, x2 instruction 1, IF should have SUB x3, x1, x2 (5-3) instruction 2
		-------------------------------------------------------------------------------------------------------------------------------
		--check IF's output signals
		IF (dbg_IF_IR /= "01000000001000001000000110110011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;
		IF (dbg_IF_NPC /= "00000000000000000000000000001000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;
		--check pipeline registers
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
		-- check ID's output signals
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
			REPORT "FAIL: dbgA incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: dbgB incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000000") THEN
			REPORT "FAIL: imm incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '0' THEN
			REPORT "FAIL: alusrc incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "10") THEN
			REPORT "FAIL: aluop incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0000") THEN
			REPORT "FAIL: alufunc incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: alubranch incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: alujump incorrect at cycle 2" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 3: ID should have SUB x3, x1, x2 (5-3) instruction 2, and IF should have MUL x3, x1, x2 instruction 3
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000010001000001000000110110011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 3" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000001100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 3" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "01000000001000001000000110110011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 3" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000001000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 3" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "01000000001000001000000110110011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 3" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000001000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 3" SEVERITY error;
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

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 4: ID should have MUL x3, x1, x2 (instruction 3), IF should have OR x3, x1, x2 (instruction 4)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000001000001110000110110011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 4" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000010000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 4" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000010001000001000000110110011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 4" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000001100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 4" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000010001000001000000110110011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 4" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000001100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 4" SEVERITY error;
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

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 5: ID should have OR x3, x1, x2 (instruction 4), IF should have AND x3, x1, x2 (instruction 5)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000001000001111000110110011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 5" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000010100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 5" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000001000001110000110110011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 5" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000010000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 5" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000001000001110000110110011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 5" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000010000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 5" SEVERITY error;
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

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 6: ID should have AND x3, x1, x2 (instruction 5), IF should have ADDI x3, x1, 7 (instruction 6)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000011100001000000110010011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 6" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000011000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 6" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000001000001111000110110011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 6" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000010100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 6" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000001000001111000110110011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 6" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000010100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 6" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: B incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000000") THEN
			REPORT "FAIL: imm incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '0' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "10") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0011") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 6 (AND)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 7: ID should have ADDI x3, x1, 7 (instruction 6), IF should have XORI x3, x1, 7 (instruction 7)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000011100001100000110010011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 7" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000011100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 7" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000011100001000000110010011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 7" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000011000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 7" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000011100001000000110010011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 7" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000011000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 7" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000007") THEN
			REPORT "FAIL: imm incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '1' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "10") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0000") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 7 (ADDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 8: ID should have XORI x3, x1, 7 (instruction 7), IF should have ORI x3, x1, 7 (instruction 8)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000011100001110000110010011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 8" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000100000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 8" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000011100001100000110010011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 8" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000011100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 8" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000011100001100000110010011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 8" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000011100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 8" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000007") THEN
			REPORT "FAIL: imm incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '1' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "10") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "1000") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 8 (XORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 9: ID should have ORI x3, x1, 7 (instruction 8), IF should have ANDI x3, x1, 7 (instruction 9)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000011100001111000110010011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 9" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000100100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 9" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000011100001110000110010011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 9" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000100000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 9" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000011100001110000110010011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 9" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000100000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 9" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000007") THEN
			REPORT "FAIL: imm incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '1' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "10") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0100") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 9 (ORI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 10: ID should have ANDI x3, x1, 7 (instruction 9), IF should have SW x2, 7(x1) (instruction 10)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000001000001010001110100011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 10" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000101000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 10" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000011100001111000110010011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 10" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000100100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 10" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000011100001111000110010011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 10" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000100100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 10" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000007") THEN
			REPORT "FAIL: imm incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '1' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "10") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0011") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 10 (ANDI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 11: ID should have SW x2, 7(x1) (instruction 10), IF should have BEQ x1, x2, 24 (instruction 11)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000010001000001000010001100011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 11" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000101100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 11" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000001000001010001110100011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 11" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000101000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 11" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000001000001010001110100011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 11" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000101000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 11" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: B incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000007") THEN
			REPORT "FAIL: imm incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '1' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "00") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0000") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '0' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '1' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 11 (SW)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 12: ID should have BEQ x1, x2, 40 (instruction 11), IF should have BNE x1, x2, 24 (instruction 12)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000001000001001110001100011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 12" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000110000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 12" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000010001000001000010001100011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 12" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000101100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 12" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000010001000001000010001100011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 12" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000101100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 12" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: B incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000028") THEN
			REPORT "FAIL: imm incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '0' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "01") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '1' THEN
			REPORT "FAIL: Branch incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_BranchType /= "000") THEN
			REPORT "FAIL: BranchType incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '0' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 12 (BEQ)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 13: ID should have BNE x1, x2, 24 (instruction 12), IF should have BLT x1, x2, 24 (instruction 13)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000001000001100110001100011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 13" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000110100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 13" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000001000001001110001100011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 13" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000110000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 13" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000001000001001110001100011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 13" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000110000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 13" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: B incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000018") THEN
			REPORT "FAIL: imm incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '0' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "01") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '1' THEN
			REPORT "FAIL: Branch incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_BranchType /= "001") THEN
			REPORT "FAIL: BranchType incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '0' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 13 (BNE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 14: ID should have BLT x1, x2, 24 (instruction 13), IF should have BGE x1, x2, 24 (instruction 14)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000001000001101110001100011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 14" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000111000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 14" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000001000001100110001100011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 14" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000110100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 14" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000001000001100110001100011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 14" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000110100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 14" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: B incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000018") THEN
			REPORT "FAIL: imm incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '0' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "01") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '1' THEN
			REPORT "FAIL: Branch incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_BranchType /= "100") THEN
			REPORT "FAIL: BranchType incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '0' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 14 (BLT)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 15: ID should have BGE x1, x2, 24 (instruction 14), IF should have JAL x1, 24 (instruction 15)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000001100000000000000011101111") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 15" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000000111100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 15" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000001000001101110001100011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 15" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000111000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 15" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000001000001101110001100011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 15" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000111000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 15" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: B incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000018") THEN
			REPORT "FAIL: imm incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '0' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "01") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '1' THEN
			REPORT "FAIL: Branch incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_BranchType /= "101") THEN
			REPORT "FAIL: BranchType incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '0' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 15 (BGE)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 16: ID should have JAL x1, 24 (instruction 15), IF should have JALR x1, x2, 12 (instruction 16)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000110000010000000011100111") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 16" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000001000000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 16" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000001100000000000000011101111") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 16" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000000111100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 16" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000001100000000000000011101111") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 16" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000000111100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 16" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00000018") THEN
			REPORT "FAIL: imm incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '1' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "00") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0000") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '1' THEN
			REPORT "FAIL: Jump incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 16 (JAL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 17: ID should have JALR x1, x2, 12 (instruction 16), IF should have LUI x1, 5 (instruction 17)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000000000000101000010110111") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 17" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000001000100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 17" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000110000010000000011100111") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 17" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000001000000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 17" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000110000010000000011100111") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 17" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000001000000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 17" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"0000000C") THEN
			REPORT "FAIL: imm incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '1' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "00") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0000") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_JumpReg /= '1' THEN
			REPORT "FAIL: JumpReg incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 17 (JALR)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 18: ID should have LUI x1, 5 (instruction 17), IF should have SLL x3, x1, x2 (instruction 18)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000001000001001000110110011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 18" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000001001000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 18" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000000000000101000010110111") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 18" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000001000100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 18" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000000000000101000010110111") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 18" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000001000100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 18" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_imm /= x"00005000") THEN
			REPORT "FAIL: imm incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '1' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "11") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "1010") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 18 (LUI)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 19: ID should have SLL x3, x1, x2 (instruction 18), IF should have SRA x3, x1, x2 (instruction 19)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "01000000001000001101000110110011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 19" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000001001100") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 19" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "00000000001000001001000110110011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 19" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000001001000") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 19" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "00000000001000001001000110110011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 19" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000001001000") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 19" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: B incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '0' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "10") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0101") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 19 (SLL)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		WAIT UNTIL rising_edge(clk);
		WAIT FOR 0.1 ns;

		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 20: ID should have SRA x3, x1, x2 (instruction 19), IF should have SLTI x3, x1, 7 (instruction 20)
		-------------------------------------------------------------------------------------------------------------------------------
		-- check IF's output signals
		IF (dbg_IF_IR /= "00000000011100001010000110010011") THEN
			REPORT "FAIL: IF_IR incorrect at cycle 20" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IF_NPC /= "00000000000000000000000001010000") THEN
			REPORT "FAIL: IF_NPC incorrect at cycle 20" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check pipeline registers
		IF (dbg_IFID_IR /= "01000000001000001101000110110011") THEN
			REPORT "FAIL: IFID_IR incorrect at cycle 20" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_IFID_NPC /= "00000000000000000000000001001100") THEN
			REPORT "FAIL: IFID_NPC incorrect at cycle 20" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		-- check ID's output signals
		IF (dbg_ID_IR /= "01000000001000001101000110110011") THEN
			REPORT "FAIL: ID_IR incorrect at cycle 20" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ID_NPC /= "00000000000000000000000001001100") THEN
			REPORT "FAIL: ID_NPC incorrect at cycle 20" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_A /= x"00000005") THEN
			REPORT "FAIL: A incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_B /= x"00000003") THEN
			REPORT "FAIL: B incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_ALUSrc /= '0' THEN
			REPORT "FAIL: ALUSrc incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUOp /= "10") THEN
			REPORT "FAIL: ALUOp incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF (dbg_ALUFunc /= "0111") THEN
			REPORT "FAIL: ALUFunc incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Branch /= '0' THEN
			REPORT "FAIL: Branch incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_Jump /= '0' THEN
			REPORT "FAIL: Jump incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_RegWrite /= '1' THEN
			REPORT "FAIL: RegWrite incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemRead /= '0' THEN
			REPORT "FAIL: MemRead incorrect at cycle 20 (SRA)" SEVERITY error;
			fail_count := fail_count + 1;
		ELSE
			pass_count := pass_count + 1;
		END IF;

		IF dbg_MemWrite /= '0' THEN
			REPORT "FAIL: MemWrite incorrect at cycle 20 (SRA)" SEVERITY error;
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