-- id_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- Testbench for: instruction_decode.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY id_tb IS
END id_tb;

ARCHITECTURE behavior OF id_tb IS

	COMPONENT instruction_decode IS
		PORT (
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			IR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			NPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			A_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			B_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			Imm : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			ALUSrc : OUT STD_LOGIC;
			ALUOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUFunc : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Branch : OUT STD_LOGIC;
			BranchType : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			Jump : OUT STD_LOGIC;
			JumpReg : OUT STD_LOGIC;
			MemRead : OUT STD_LOGIC;
			MemWrite : OUT STD_LOGIC;
			RegWrite : OUT STD_LOGIC;
			MemToReg : OUT STD_LOGIC
		);
	END COMPONENT;

	CONSTANT CLK_PERIOD : TIME := 1 ns;

	-- inputs
	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL reset : STD_LOGIC := '1';
	SIGNAL IR : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL NPC : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL A_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL B_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

	-- outputs
	SIGNAL A : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL B : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALUSrc : STD_LOGIC;
	SIGNAL ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ALUFunc : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Branch : STD_LOGIC;
	SIGNAL BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL Jump : STD_LOGIC;
	SIGNAL JumpReg : STD_LOGIC;
	SIGNAL MemRead : STD_LOGIC;
	SIGNAL MemWrite : STD_LOGIC;
	SIGNAL RegWrite : STD_LOGIC;
	SIGNAL MemToReg : STD_LOGIC;

	SIGNAL sim_done : BOOLEAN := false;

BEGIN

	-- Mock register-file read behavior for decode-only testing.
	--   x1 = 5, x2 = 3, all other registers = 0.
	A_in <= x"00000005" WHEN IR(19 DOWNTO 15) = "00001" ELSE
		x"00000003" WHEN IR(19 DOWNTO 15) = "00010" ELSE
		(OTHERS => '0');

	B_in <= x"00000005" WHEN IR(24 DOWNTO 20) = "00001" ELSE
		x"00000003" WHEN IR(24 DOWNTO 20) = "00010" ELSE
		(OTHERS => '0');

	uut : instruction_decode
	PORT MAP(
		clk => clk,
		reset => reset,
		IR => IR,
		NPC => NPC,
		A_in => A_in,
		B_in => B_in,
		A => A,
		B => B,
		Imm => Imm,
		IR_out => IR_out,
		NPC_out => NPC_out,
		ALUSrc => ALUSrc,
		ALUOp => ALUOp,
		ALUFunc => ALUFunc,
		Branch => Branch,
		BranchType => BranchType,
		Jump => Jump,
		JumpReg => JumpReg,
		MemRead => MemRead,
		MemWrite => MemWrite,
		RegWrite => RegWrite,
		MemToReg => MemToReg
	);

	-- clock generation
	clk_process : PROCESS
	BEGIN
		WHILE NOT sim_done LOOP
			clk <= '0';
			WAIT FOR CLK_PERIOD / 2;
			clk <= '1';
			WAIT FOR CLK_PERIOD / 2;
		END LOOP;
		WAIT;
	END PROCESS;

	-- main test process
	test_process : PROCESS
		VARIABLE pass_count : INTEGER := 0;
		VARIABLE fail_count : INTEGER := 0;
	BEGIN
		REPORT "=== instruction_decode_tb starting ===" SEVERITY note;

		-- apply reset
		reset <= '1';
		WAIT FOR CLK_PERIOD * 2;
		reset <= '0';
		WAIT FOR CLK_PERIOD;

		-- =====================================================================
		-- TEST CASES
		-- =====================================================================

		--------------------------------------------------------------------
		-- Test: ADD x3, x1, x2
		--------------------------------------------------------------------
		IR <= "00000000001000001000000110110011";
		WAIT FOR CLK_PERIOD;

		-- check A
		IF A = x"00000005" THEN
			REPORT "ADD Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check B
		IF B = x"00000003" THEN
			REPORT "ADD Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check control signals
		-- check ALUSrc
		IF ALUSrc = '0' THEN
			REPORT "ADD Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check ALUOp
		IF ALUOp = "10" THEN
			REPORT "ADD Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check ALUFunc
		IF ALUFunc = "0000" THEN
			REPORT "ADD Test PASSED: ALUFunc = 0000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check RegWrite
		IF RegWrite = '1' THEN
			REPORT "ADD Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check MemRead
		IF MemRead = '0' THEN
			REPORT "ADD Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check MemWrite
		IF MemWrite = '0' THEN
			REPORT "ADD Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check Branch
		IF Branch = '0' THEN
			REPORT "ADD Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- check Jump
		IF Jump = '0' THEN
			REPORT "ADD Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADD Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;
		--------------------------------------------------------------------
		-- Test: SUB x3, x1, x2 (5-3)
		--------------------------------------------------------------------
		IR <= "01000000001000001000000110110011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "SUB Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "SUB Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "SUB Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "SUB Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0001" THEN
			REPORT "SUB Test PASSED: ALUFunc = 0001" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0001)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "SUB Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "SUB Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "SUB Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "SUB Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "SUB Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SUB Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;
		--------------------------------------------------------------------
		-- Test: MUL x3, x1, x2
		--------------------------------------------------------------------
		IR <= "00000010001000001000000110110011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "MUL Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "MUL Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "MUL Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "MUL Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0010" THEN
			REPORT "MUL Test PASSED: ALUFunc = 0010" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0010)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "MUL Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "MUL Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "MUL Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "MUL Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "MUL Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "MUL Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- -----------------------------------------------------------------
		-- Test: OR x3, x1, x2
		-- -----------------------------------------------------------------
		IR <= "00000000001000001110000110110011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "OR Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "OR Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "OR Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "OR Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0100" THEN
			REPORT "OR Test PASSED: ALUFunc = 0100" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0100)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "OR Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "OR Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "OR Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "OR Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "OR Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "OR Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;
		--------------------------------------------------------------------
		-- Test: AND x3, x1, x2
		--------------------------------------------------------------------
		IR <= "00000000001000001111000110110011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "AND Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "AND Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "AND Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "AND Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0011" THEN
			REPORT "AND Test PASSED: ALUFunc = 0011" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0011)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "AND Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "AND Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "AND Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "AND Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "AND Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AND Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: ADDI x3, x1, 7
		--------------------------------------------------------------------
		IR <= "00000000011100001000000110010011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "ADDI Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000007" THEN
			REPORT "ADDI Test PASSED: Imm = 7" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000007)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "ADDI Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "ADDI Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0000" THEN
			REPORT "ADDI Test PASSED: ALUFunc = 0000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "ADDI Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "ADDI Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "ADDI Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "ADDI Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "ADDI Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ADDI Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: XORI x3, x1, 7
		--------------------------------------------------------------------
		IR <= "00000000011100001100000110010011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "XORI Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000007" THEN
			REPORT "XORI Test PASSED: Imm = 7" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000007)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "XORI Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "XORI Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "1000" THEN
			REPORT "XORI Test PASSED: ALUFunc = 1000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 1000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "XORI Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "XORI Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "XORI Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "XORI Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "XORI Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "XORI Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- -----------------------------------------------------------------
		-- Test: ORI x3, x1, 7
		-- -----------------------------------------------------------------
		IR <= "00000000011100001110000110010011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "ORI Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000007" THEN
			REPORT "ORI Test PASSED: Imm = 7" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000007)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "ORI Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "ORI Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0100" THEN
			REPORT "ORI Test PASSED: ALUFunc = 0100" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0100)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "ORI Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "ORI Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "ORI Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "ORI Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "ORI Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ORI Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: ANDI x3, x1, 7
		--------------------------------------------------------------------
		IR <= "00000000011100001111000110010011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "ANDI Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000007" THEN
			REPORT "ANDI Test PASSED: Imm = 7" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000007)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "ANDI Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "ANDI Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0011" THEN
			REPORT "ANDI Test PASSED: ALUFunc = 0011" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0011)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "ANDI Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "ANDI Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "ANDI Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "ANDI Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "ANDI Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "ANDI Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: SW x2, 7(x1)
		--------------------------------------------------------------------
		IR <= "00000000001000001010001110100011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "SW Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "SW Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000007" THEN
			REPORT "SW Test PASSED: Imm = 7" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000007)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "SW Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "00" THEN
			REPORT "SW Test PASSED: ALUOp = 00" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 00)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0000" THEN
			REPORT "SW Test PASSED: ALUFunc = 0000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '0' THEN
			REPORT "SW Test PASSED: RegWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "SW Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '1' THEN
			REPORT "SW Test PASSED: MemWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "SW Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "SW Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SW Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: BEQ x1, x2, 40
		--------------------------------------------------------------------

		-- with encoding, bit 0 of imm value is implicitly 0, so if we want to encode 40 we encode 20 (since implicit lsb 0 is effectively a LSL aka x2)
		IR <= "00000010001000001000010001100011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "BEQ Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "BEQ Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000028" THEN
			REPORT "BEQ Test PASSED: Imm = 40" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000028)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "BEQ Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "01" THEN
			REPORT "BEQ Test PASSED: ALUOp = 01" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 01)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '1' THEN
			REPORT "BEQ Test PASSED: Branch = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF BranchType = "000" THEN
			REPORT "BEQ Test PASSED: BranchType = 000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: BranchType = " & to_hstring(BranchType) &
				" (expected 000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '0' THEN
			REPORT "BEQ Test PASSED: RegWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "BEQ Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "BEQ Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "BEQ Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: BEQ x1, x2, 24  (encoded offset = 12, reconstructed = 24)
		--------------------------------------------------------------------

		IR <= "00000000001000001000110001100011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "BEQ Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "BEQ Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000018" THEN
			REPORT "BEQ Test PASSED: Imm = 24" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000018)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "BEQ Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "01" THEN
			REPORT "BEQ Test PASSED: ALUOp = 01" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 01)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '1' THEN
			REPORT "BEQ Test PASSED: Branch = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF BranchType = "000" THEN
			REPORT "BEQ Test PASSED: BranchType = 000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: BranchType = " & to_hstring(BranchType) &
				" (expected 000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '0' THEN
			REPORT "BEQ Test PASSED: RegWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "BEQ Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "BEQ Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "BEQ Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BEQ Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-------------------------------------------------------------------
		-- Test: BNE x1, x2, 24  (encoded offset = 12, reconstructed = 24)
		--------------------------------------------------------------------

		IR <= "00000000001000001001110001100011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "BNE Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "BNE Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000018" THEN
			REPORT "BNE Test PASSED: Imm = 24" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000018)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "BNE Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "01" THEN
			REPORT "BNE Test PASSED: ALUOp = 01" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 01)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '1' THEN
			REPORT "BNE Test PASSED: Branch = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF BranchType = "001" THEN
			REPORT "BNE Test PASSED: BranchType = 001" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: BranchType = " & to_hstring(BranchType) &
				" (expected 001)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '0' THEN
			REPORT "BNE Test PASSED: RegWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "BNE Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "BNE Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "BNE Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BNE Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: BLT x1, x2, 24
		--------------------------------------------------------------------
		IR <= "00000000001000001100110001100011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "BLT Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "BLT Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000018" THEN
			REPORT "BLT Test PASSED: Imm = 24" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000018)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "BLT Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "01" THEN
			REPORT "BLT Test PASSED: ALUOp = 01" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 01)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '1' THEN
			REPORT "BLT Test PASSED: Branch = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF BranchType = "100" THEN
			REPORT "BLT Test PASSED: BranchType = 100" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: BranchType = " & to_hstring(BranchType) &
				" (expected 100)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '0' THEN
			REPORT "BLT Test PASSED: RegWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "BLT Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "BLT Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "BLT Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BLT Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		-- -----------------------------------------------------------------
		-- Test: BGE x1, x2, 24
		-- -----------------------------------------------------------------
		IR <= "00000000001000001101110001100011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "BGE Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "BGE Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000018" THEN
			REPORT "BGE Test PASSED: Imm = 24" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000018)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "BGE Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "01" THEN
			REPORT "BGE Test PASSED: ALUOp = 01" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 01)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '1' THEN
			REPORT "BGE Test PASSED: Branch = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF BranchType = "101" THEN
			REPORT "BGE Test PASSED: BranchType = 101" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: BranchType = " & to_hstring(BranchType) &
				" (expected 101)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '0' THEN
			REPORT "BGE Test PASSED: RegWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "BGE Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "BGE Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "BGE Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "BGE Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: JAL x1, 24  (encoded offset = 12, reconstructed = 24)
		--------------------------------------------------------------------
		IR <= "00000001100000000000000011101111";
		WAIT FOR CLK_PERIOD;

		IF Imm = x"00000018" THEN
			REPORT "JAL Test PASSED: Imm = 24" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000018)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "JAL Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "00" THEN
			REPORT "JAL Test PASSED: ALUOp = 00" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 00)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0000" THEN
			REPORT "JAL Test PASSED: ALUFunc = 0000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "JAL Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '1' THEN
			REPORT "JAL Test PASSED: Jump = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "JAL Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "JAL Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "JAL Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JAL Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: JALR x1, x2, 12
		--------------------------------------------------------------------
		IR <= "00000000110000010000000011100111";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000003" THEN
			REPORT "JALR Test PASSED: A = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"0000000C" THEN
			REPORT "JALR Test PASSED: Imm = 12" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x0000000C)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "JALR Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "00" THEN
			REPORT "JALR Test PASSED: ALUOp = 00" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 00)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0000" THEN
			REPORT "JALR Test PASSED: ALUFunc = 0000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "JALR Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF JumpReg = '1' THEN
			REPORT "JALR Test PASSED: JumpReg = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: JumpReg = " & STD_LOGIC'image(JumpReg) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "JALR Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "JALR Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "JALR Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "JALR Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "JALR Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: LUI x1, 5   (rd = 5 << 12 = 0x00005000)
		--------------------------------------------------------------------
		IR <= "00000000000000000101000010110111";
		WAIT FOR CLK_PERIOD;

		IF Imm = x"00005000" THEN
			REPORT "LUI Test PASSED: Imm = 0x00005000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00005000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "LUI Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "11" THEN
			REPORT "LUI Test PASSED: ALUOp = 11" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 11)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "1010" THEN
			REPORT "LUI Test PASSED: ALUFunc = 1010" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 1010)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "LUI Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "LUI Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "LUI Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "LUI Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "LUI Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "LUI Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: SLL x3, x1, x2   (rd = rs1 << rs2)
		--------------------------------------------------------------------
		IR <= "00000000001000001001000110110011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "SLL Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "SLL Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "SLL Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "SLL Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0101" THEN
			REPORT "SLL Test PASSED: ALUFunc = 0101" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0101)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "SLL Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "SLL Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "SLL Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "SLL Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "SLL Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLL Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: SRA x3, x1, x2   (rd = rs1 >> rs2, arithmetic/msb-extends)
		--------------------------------------------------------------------
		IR <= "01000000001000001101000110110011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "SRA Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF B = x"00000003" THEN
			REPORT "SRA Test PASSED: B = 3" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: B = " & to_hstring(B) &
				" (expected 0x00000003)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '0' THEN
			REPORT "SRA Test PASSED: ALUSrc = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "SRA Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0111" THEN
			REPORT "SRA Test PASSED: ALUFunc = 0111" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 0111)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "SRA Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "SRA Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "SRA Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "SRA Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: Branch = " & STD_LOGIC'image(Branch) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "SRA Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SRA Test FAILED: Jump = " & STD_LOGIC'image(Jump) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: SLTI x3, x1, 7   (rd = rs1 < imm ? 1 : 0)
		--------------------------------------------------------------------
		IR <= "00000000011100001010000110010011";
		WAIT FOR CLK_PERIOD;

		IF A = x"00000005" THEN
			REPORT "SLTI Test PASSED: A = 5" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: A = " & to_hstring(A) &
				" (expected 0x00000005)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Imm = x"00000007" THEN
			REPORT "SLTI Test PASSED: Imm = 7" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: Imm = " & to_hstring(Imm) &
				" (expected 0x00000007)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "SLTI Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "10" THEN
			REPORT "SLTI Test PASSED: ALUOp = 10" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
				" (expected 10)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "1001" THEN
			REPORT "SLTI Test PASSED: ALUFunc = 1001" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
				" (expected 1001)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "SLTI Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) &
				" (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "SLTI Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "SLTI Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) &
				" (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "SLTI Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: Branch = " & STD_LOGIC'image(Branch) & " (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "SLTI Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "SLTI Test FAILED: Jump = " & STD_LOGIC'image(Jump) & " (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		--------------------------------------------------------------------
		-- Test: AUIPC x1, 5   (rd = PC + (5 << 12) = PC + 0x00005000)
		--------------------------------------------------------------------
		IR <= "00000000000000000101000010010111";
		WAIT FOR CLK_PERIOD;

		IF Imm = x"00005000" THEN
			REPORT "AUIPC Test PASSED: Imm = 0x00005000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: Imm = " & to_hstring(Imm) & " (expected 0x00005000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUSrc = '1' THEN
			REPORT "AUIPC Test PASSED: ALUSrc = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: ALUSrc = " & STD_LOGIC'image(ALUSrc) & " (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUOp = "00" THEN
			REPORT "AUIPC Test PASSED: ALUOp = 00" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: ALUOp = " & to_hstring(ALUOp) & " (expected 00)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF ALUFunc = "0000" THEN
			REPORT "AUIPC Test PASSED: ALUFunc = 0000" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: ALUFunc = " & to_hstring(ALUFunc) & " (expected 0000)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF RegWrite = '1' THEN
			REPORT "AUIPC Test PASSED: RegWrite = 1" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: RegWrite = " & STD_LOGIC'image(RegWrite) & " (expected 1)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Branch = '0' THEN
			REPORT "AUIPC Test PASSED: Branch = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: Branch = " & STD_LOGIC'image(Branch) & " (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF Jump = '0' THEN
			REPORT "AUIPC Test PASSED: Jump = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: Jump = " & STD_LOGIC'image(Jump) & " (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemRead = '0' THEN
			REPORT "AUIPC Test PASSED: MemRead = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: MemRead = " & STD_LOGIC'image(MemRead) & " (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;

		IF MemWrite = '0' THEN
			REPORT "AUIPC Test PASSED: MemWrite = 0" SEVERITY note;
			pass_count := pass_count + 1;
		ELSE
			REPORT "AUIPC Test FAILED: MemWrite = " & STD_LOGIC'image(MemWrite) & " (expected 0)" SEVERITY error;
			fail_count := fail_count + 1;
		END IF;
		--======================================================================
		-- summary
		--======================================================================
		REPORT "===================================" SEVERITY note;
		REPORT "Results: " & INTEGER'image(pass_count) &
			" passed, " & INTEGER'image(fail_count) & " failed." SEVERITY note;
		IF fail_count = 0 THEN
			REPORT "All tests PASSED." SEVERITY note;
		ELSE
			REPORT "Some tests FAILED - check output above." SEVERITY error;
		END IF;
		REPORT "=== instruction_decode_tb done ===" SEVERITY note;

		sim_done <= true;
		WAIT;
	END PROCESS;

END behavior;