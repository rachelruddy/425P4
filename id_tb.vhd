-- id_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- Testbench for: instruction_decode.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity id_tb is
end id_tb;

architecture behavior of id_tb is

    component instruction_decode is
        port(
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            IR          : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC         : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			A_in        : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			B_in        : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            A           : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            B           : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            Imm         : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            IR_out      : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC_out     : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUSrc      : out STD_LOGIC;
            ALUOp       : out STD_LOGIC_VECTOR(1 DOWNTO 0);
            ALUFunc     : out STD_LOGIC_VECTOR(3 DOWNTO 0);
            Branch      : out STD_LOGIC;
            BranchType  : out STD_LOGIC_VECTOR(2 DOWNTO 0);
            Jump        : out STD_LOGIC;
            JumpReg     : out STD_LOGIC;
            MemRead     : out STD_LOGIC;
            MemWrite    : out STD_LOGIC;
            RegWrite    : out STD_LOGIC;
            MemToReg    : out STD_LOGIC
        );
    end component;

    constant CLK_PERIOD : time := 1 ns;

    -- inputs
    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal IR    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal NPC   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	signal A_in  : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	signal B_in  : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

    -- outputs
    signal A          : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal B          : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal Imm        : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal IR_out     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal NPC_out    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal ALUSrc     : STD_LOGIC;
    signal ALUOp      : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal ALUFunc    : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal Branch     : STD_LOGIC;
    signal BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal Jump       : STD_LOGIC;
    signal JumpReg    : STD_LOGIC;
    signal MemRead    : STD_LOGIC;
    signal MemWrite   : STD_LOGIC;
    signal RegWrite   : STD_LOGIC;
    signal MemToReg   : STD_LOGIC;

    signal sim_done : boolean := false;

begin

	-- Mock register-file read behavior for decode-only testing.
	--   x1 = 5, x2 = 3, all other registers = 0.
	A_in <= x"00000005" when IR(19 downto 15) = "00001" else
			x"00000003" when IR(19 downto 15) = "00010" else
			(others => '0');

	B_in <= x"00000005" when IR(24 downto 20) = "00001" else
			x"00000003" when IR(24 downto 20) = "00010" else
			(others => '0');

    uut : instruction_decode
        port map(
            clk        => clk,
            reset      => reset,
            IR         => IR,
            NPC        => NPC,
			A_in       => A_in,
			B_in       => B_in,
            A          => A,
            B          => B,
            Imm        => Imm,
            IR_out     => IR_out,
            NPC_out    => NPC_out,
            ALUSrc     => ALUSrc,
            ALUOp      => ALUOp,
            ALUFunc    => ALUFunc,
            Branch     => Branch,
            BranchType => BranchType,
            Jump       => Jump,
            JumpReg    => JumpReg,
            MemRead    => MemRead,
            MemWrite   => MemWrite,
            RegWrite   => RegWrite,
            MemToReg   => MemToReg
        );

    -- clock generation
    clk_process : process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- main test process
    test_process : process
        variable pass_count : integer := 0;
        variable fail_count : integer := 0;
    begin
        report "=== instruction_decode_tb starting ===" severity note;

        -- apply reset
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD;

        -- =====================================================================
        -- TEST CASES
        -- =====================================================================
		  
		   --------------------------------------------------------------------
			-- Test: ADD x3, x1, x2
			--------------------------------------------------------------------
			IR <= "00000000001000001000000110110011";
			wait for CLK_PERIOD;

			-- check A
			if A = x"00000005" then
				 report "ADD Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: A = " & to_hstring(A) & 
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check B
			if B = x"00000003" then
				 report "ADD Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: B = " & to_hstring(B) & 
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check control signals
			-- check ALUSrc
			if ALUSrc = '0' then
				 report "ADD Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check ALUOp
			if ALUOp = "10" then
				 report "ADD Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check ALUFunc
			if ALUFunc = "0000" then
				 report "ADD Test PASSED: ALUFunc = 0000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check RegWrite
			if RegWrite = '1' then
				 report "ADD Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check MemRead
			if MemRead = '0' then
				 report "ADD Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check MemWrite
			if MemWrite = '0' then
				 report "ADD Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check Branch
			if Branch = '0' then
				 report "ADD Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- check Jump
			if Jump = '0' then
				 report "ADD Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADD Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;


			--------------------------------------------------------------------
			-- Test: SUB x3, x1, x2 (5-3)
			--------------------------------------------------------------------
			IR <= "01000000001000001000000110110011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "SUB Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "SUB Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "SUB Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "SUB Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0001" then
				 report "SUB Test PASSED: ALUFunc = 0001" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0001)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "SUB Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "SUB Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "SUB Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "SUB Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "SUB Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SUB Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			
			--------------------------------------------------------------------
			-- Test: MUL x3, x1, x2
			--------------------------------------------------------------------
			IR <= "00000010001000001000000110110011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "MUL Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "MUL Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "MUL Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "MUL Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0010" then
				 report "MUL Test PASSED: ALUFunc = 0010" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0010)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "MUL Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "MUL Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "MUL Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "MUL Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "MUL Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "MUL Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			-- -----------------------------------------------------------------
			-- Test: OR x3, x1, x2
			-- -----------------------------------------------------------------
			IR <= "00000000001000001110000110110011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "OR Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "OR Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "OR Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "OR Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0100" then
				 report "OR Test PASSED: ALUFunc = 0100" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0100)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "OR Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "OR Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "OR Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "OR Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "OR Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "OR Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			
			--------------------------------------------------------------------
			-- Test: AND x3, x1, x2
			--------------------------------------------------------------------
			IR <= "00000000001000001111000110110011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "AND Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "AND Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "AND Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "AND Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0011" then
				 report "AND Test PASSED: ALUFunc = 0011" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0011)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "AND Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "AND Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "AND Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "AND Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "AND Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AND Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: ADDI x3, x1, 7
			--------------------------------------------------------------------
			IR <= "00000000011100001000000110010011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "ADDI Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000007" then
				 report "ADDI Test PASSED: Imm = 7" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000007)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "ADDI Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "ADDI Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0000" then
				 report "ADDI Test PASSED: ALUFunc = 0000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "ADDI Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "ADDI Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "ADDI Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "ADDI Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "ADDI Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ADDI Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: XORI x3, x1, 7
			--------------------------------------------------------------------
			IR <= "00000000011100001100000110010011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "XORI Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000007" then
				 report "XORI Test PASSED: Imm = 7" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000007)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "XORI Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "XORI Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "1000" then
				 report "XORI Test PASSED: ALUFunc = 1000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 1000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "XORI Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "XORI Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "XORI Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "XORI Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "XORI Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "XORI Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			-- -----------------------------------------------------------------
			-- Test: ORI x3, x1, 7
			-- -----------------------------------------------------------------
			IR <= "00000000011100001110000110010011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "ORI Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000007" then
				 report "ORI Test PASSED: Imm = 7" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000007)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "ORI Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "ORI Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0100" then
				 report "ORI Test PASSED: ALUFunc = 0100" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0100)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "ORI Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "ORI Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "ORI Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "ORI Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "ORI Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ORI Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: ANDI x3, x1, 7
			--------------------------------------------------------------------
			IR <= "00000000011100001111000110010011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "ANDI Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000007" then
				 report "ANDI Test PASSED: Imm = 7" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000007)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "ANDI Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "ANDI Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0011" then
				 report "ANDI Test PASSED: ALUFunc = 0011" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0011)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "ANDI Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "ANDI Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "ANDI Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "ANDI Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "ANDI Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "ANDI Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: SW x2, 7(x1)
			--------------------------------------------------------------------
			IR <= "00000000001000001010001110100011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "SW Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "SW Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000007" then
				 report "SW Test PASSED: Imm = 7" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000007)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "SW Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "00" then
				 report "SW Test PASSED: ALUOp = 00" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 00)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0000" then
				 report "SW Test PASSED: ALUFunc = 0000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '0' then
				 report "SW Test PASSED: RegWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "SW Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '1' then
				 report "SW Test PASSED: MemWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "SW Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "SW Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SW Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: BEQ x1, x2, 40
			--------------------------------------------------------------------
	
			-- with encoding, bit 0 of imm value is implicitly 0, so if we want to encode 40 we encode 20 (since implicit lsb 0 is effectively a LSL aka x2)
			IR <= "00000010001000001000010001100011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "BEQ Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "BEQ Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000028" then
				 report "BEQ Test PASSED: Imm = 40" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000028)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "BEQ Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "01" then
				 report "BEQ Test PASSED: ALUOp = 01" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 01)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '1' then
				 report "BEQ Test PASSED: Branch = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if BranchType = "000" then
				 report "BEQ Test PASSED: BranchType = 000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: BranchType = " & to_hstring(BranchType) &
						  " (expected 000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '0' then
				 report "BEQ Test PASSED: RegWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "BEQ Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "BEQ Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "BEQ Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: BEQ x1, x2, 24  (encoded offset = 12, reconstructed = 24)
			--------------------------------------------------------------------

			IR <= "00000000001000001000110001100011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "BEQ Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "BEQ Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000018" then
				 report "BEQ Test PASSED: Imm = 24" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000018)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "BEQ Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "01" then
				 report "BEQ Test PASSED: ALUOp = 01" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 01)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '1' then
				 report "BEQ Test PASSED: Branch = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if BranchType = "000" then
				 report "BEQ Test PASSED: BranchType = 000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: BranchType = " & to_hstring(BranchType) &
						  " (expected 000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '0' then
				 report "BEQ Test PASSED: RegWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "BEQ Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "BEQ Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "BEQ Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BEQ Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			-------------------------------------------------------------------
			-- Test: BNE x1, x2, 24  (encoded offset = 12, reconstructed = 24)
			--------------------------------------------------------------------

			IR <= "00000000001000001001110001100011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "BNE Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "BNE Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000018" then
				 report "BNE Test PASSED: Imm = 24" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000018)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "BNE Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "01" then
				 report "BNE Test PASSED: ALUOp = 01" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 01)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '1' then
				 report "BNE Test PASSED: Branch = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if BranchType = "001" then
				 report "BNE Test PASSED: BranchType = 001" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: BranchType = " & to_hstring(BranchType) &
						  " (expected 001)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '0' then
				 report "BNE Test PASSED: RegWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "BNE Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "BNE Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "BNE Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BNE Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: BLT x1, x2, 24
			--------------------------------------------------------------------
			IR <= "00000000001000001100110001100011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "BLT Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "BLT Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000018" then
				 report "BLT Test PASSED: Imm = 24" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000018)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "BLT Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "01" then
				 report "BLT Test PASSED: ALUOp = 01" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 01)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '1' then
				 report "BLT Test PASSED: Branch = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if BranchType = "100" then
				 report "BLT Test PASSED: BranchType = 100" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: BranchType = " & to_hstring(BranchType) &
						  " (expected 100)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '0' then
				 report "BLT Test PASSED: RegWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "BLT Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "BLT Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "BLT Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BLT Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			-- -----------------------------------------------------------------
			-- Test: BGE x1, x2, 24
			-- -----------------------------------------------------------------
			IR <= "00000000001000001101110001100011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "BGE Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "BGE Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000018" then
				 report "BGE Test PASSED: Imm = 24" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000018)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "BGE Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "01" then
				 report "BGE Test PASSED: ALUOp = 01" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 01)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '1' then
				 report "BGE Test PASSED: Branch = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if BranchType = "101" then
				 report "BGE Test PASSED: BranchType = 101" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: BranchType = " & to_hstring(BranchType) &
						  " (expected 101)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '0' then
				 report "BGE Test PASSED: RegWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "BGE Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "BGE Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "BGE Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "BGE Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: JAL x1, 24  (encoded offset = 12, reconstructed = 24)
			--------------------------------------------------------------------
			IR <= "00000001100000000000000011101111";
			wait for CLK_PERIOD;

			if Imm = x"00000018" then
				 report "JAL Test PASSED: Imm = 24" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000018)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "JAL Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "00" then
				 report "JAL Test PASSED: ALUOp = 00" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 00)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0000" then
				 report "JAL Test PASSED: ALUFunc = 0000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "JAL Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '1' then
				 report "JAL Test PASSED: Jump = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "JAL Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "JAL Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "JAL Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JAL Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: JALR x1, x2, 12
			--------------------------------------------------------------------
			IR <= "00000000110000010000000011100111";
			wait for CLK_PERIOD;

			if A = x"00000003" then
				 report "JALR Test PASSED: A = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"0000000C" then
				 report "JALR Test PASSED: Imm = 12" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x0000000C)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "JALR Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "00" then
				 report "JALR Test PASSED: ALUOp = 00" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 00)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0000" then
				 report "JALR Test PASSED: ALUFunc = 0000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "JALR Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if JumpReg = '1' then
				 report "JALR Test PASSED: JumpReg = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: JumpReg = " & std_logic'image(JumpReg) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "JALR Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "JALR Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "JALR Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "JALR Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "JALR Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: LUI x1, 5   (rd = 5 << 12 = 0x00005000)
			--------------------------------------------------------------------
			IR <= "00000000000000000101000010110111";
			wait for CLK_PERIOD;

			if Imm = x"00005000" then
				 report "LUI Test PASSED: Imm = 0x00005000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00005000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "LUI Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "11" then
				 report "LUI Test PASSED: ALUOp = 11" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 11)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "1010" then
				 report "LUI Test PASSED: ALUFunc = 1010" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 1010)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "LUI Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "LUI Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "LUI Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "LUI Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "LUI Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "LUI Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: SLL x3, x1, x2   (rd = rs1 << rs2)
			--------------------------------------------------------------------
			IR <= "00000000001000001001000110110011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "SLL Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "SLL Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "SLL Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "SLL Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0101" then
				 report "SLL Test PASSED: ALUFunc = 0101" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0101)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "SLL Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "SLL Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "SLL Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "SLL Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "SLL Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLL Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: SRA x3, x1, x2   (rd = rs1 >> rs2, arithmetic/msb-extends)
			--------------------------------------------------------------------
			IR <= "01000000001000001101000110110011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "SRA Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if B = x"00000003" then
				 report "SRA Test PASSED: B = 3" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: B = " & to_hstring(B) &
						  " (expected 0x00000003)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '0' then
				 report "SRA Test PASSED: ALUSrc = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "SRA Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0111" then
				 report "SRA Test PASSED: ALUFunc = 0111" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 0111)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "SRA Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "SRA Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "SRA Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "SRA Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: Branch = " & std_logic'image(Branch) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "SRA Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SRA Test FAILED: Jump = " & std_logic'image(Jump) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: SLTI x3, x1, 7   (rd = rs1 < imm ? 1 : 0)
			--------------------------------------------------------------------
			IR <= "00000000011100001010000110010011";
			wait for CLK_PERIOD;

			if A = x"00000005" then
				 report "SLTI Test PASSED: A = 5" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: A = " & to_hstring(A) &
						  " (expected 0x00000005)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Imm = x"00000007" then
				 report "SLTI Test PASSED: Imm = 7" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: Imm = " & to_hstring(Imm) &
						  " (expected 0x00000007)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "SLTI Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "10" then
				 report "SLTI Test PASSED: ALUOp = 10" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: ALUOp = " & to_hstring(ALUOp) &
						  " (expected 10)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "1001" then
				 report "SLTI Test PASSED: ALUFunc = 1001" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: ALUFunc = " & to_hstring(ALUFunc) &
						  " (expected 1001)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "SLTI Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: RegWrite = " & std_logic'image(RegWrite) &
						  " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "SLTI Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: MemRead = " & std_logic'image(MemRead) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "SLTI Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: MemWrite = " & std_logic'image(MemWrite) &
						  " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "SLTI Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: Branch = " & std_logic'image(Branch) & " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "SLTI Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "SLTI Test FAILED: Jump = " & std_logic'image(Jump) & " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
			
			--------------------------------------------------------------------
			-- Test: AUIPC x1, 5   (rd = PC + (5 << 12) = PC + 0x00005000)
			--------------------------------------------------------------------
			IR <= "00000000000000000101000010010111";
			wait for CLK_PERIOD;

			if Imm = x"00005000" then
				 report "AUIPC Test PASSED: Imm = 0x00005000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: Imm = " & to_hstring(Imm) & " (expected 0x00005000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUSrc = '1' then
				 report "AUIPC Test PASSED: ALUSrc = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: ALUSrc = " & std_logic'image(ALUSrc) & " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUOp = "00" then
				 report "AUIPC Test PASSED: ALUOp = 00" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: ALUOp = " & to_hstring(ALUOp) & " (expected 00)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if ALUFunc = "0000" then
				 report "AUIPC Test PASSED: ALUFunc = 0000" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: ALUFunc = " & to_hstring(ALUFunc) & " (expected 0000)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if RegWrite = '1' then
				 report "AUIPC Test PASSED: RegWrite = 1" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: RegWrite = " & std_logic'image(RegWrite) & " (expected 1)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Branch = '0' then
				 report "AUIPC Test PASSED: Branch = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: Branch = " & std_logic'image(Branch) & " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if Jump = '0' then
				 report "AUIPC Test PASSED: Jump = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: Jump = " & std_logic'image(Jump) & " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemRead = '0' then
				 report "AUIPC Test PASSED: MemRead = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: MemRead = " & std_logic'image(MemRead) & " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;

			if MemWrite = '0' then
				 report "AUIPC Test PASSED: MemWrite = 0" severity note;
				 pass_count := pass_count + 1;
			else
				 report "AUIPC Test FAILED: MemWrite = " & std_logic'image(MemWrite) & " (expected 0)" severity error;
				 fail_count := fail_count + 1;
			end if;
        --======================================================================
        -- summary
        --======================================================================
        report "===================================" severity note;
        report "Results: " & integer'image(pass_count) &
               " passed, " & integer'image(fail_count) & " failed." severity note;
        if fail_count = 0 then
            report "All tests PASSED." severity note;
        else
            report "Some tests FAILED - check output above." severity error;
        end if;
        report "=== instruction_decode_tb done ===" severity note;

        sim_done <= true;
        wait;
    end process;

end behavior;