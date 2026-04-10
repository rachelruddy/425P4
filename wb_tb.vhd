-- wb_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- Testbench for: writeback.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_tb is

end wb_tb;

architecture behavior of wb_tb is

    component writeback is
        port(
            clk                : in  STD_LOGIC;
            reset              : in  STD_LOGIC;
            MemToReg           : in  STD_LOGIC;
            RegWrite           : in  STD_LOGIC;
            Jump               : in  STD_LOGIC;
            JumpReg            : in  STD_LOGIC;
            rd                 : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
            ALUOutput          : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            mem_data           : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC                : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
				
            regfile_write_en   : out STD_LOGIC;
            regfile_write_addr : out STD_LOGIC_VECTOR(4 DOWNTO 0);
            regfile_write_data : out STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;

    constant CLK_PERIOD : time := 1 ns;

    -- inputs
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '1';
    signal MemToReg  : STD_LOGIC := '0';
    signal RegWrite  : STD_LOGIC := '0';
    signal Jump      : STD_LOGIC := '0';
    signal JumpReg   : STD_LOGIC := '0';
    signal rd        : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal ALUOutput : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal mem_data  : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal NPC       : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

    -- outputs
    signal regfile_write_en   : STD_LOGIC;
    signal regfile_write_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal regfile_write_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    signal sim_done : boolean := false;

begin

    uut : writeback
        port map(
            clk                => clk,
            reset              => reset,
            MemToReg           => MemToReg,
            RegWrite           => RegWrite,
            Jump               => Jump,
            JumpReg            => JumpReg,
            rd                 => rd,
            ALUOutput          => ALUOutput,
            mem_data           => mem_data,
            NPC                => NPC,
            regfile_write_en   => regfile_write_en,
            regfile_write_addr => regfile_write_addr,
            regfile_write_data => regfile_write_data
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
        report "=== writeback_tb starting ===" severity note;

        -- apply reset
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD;

        -- =====================================================================
        -- TEST CASES 
        -- =====================================================================

			-- =========================================================
			-- TEST 1: RESET BEHAVIOR
			-- =========================================================

			reset <= '1';

			-- apply some random non-zero inputs to make sure reset overrides everything
			MemToReg  <= '1';
			RegWrite  <= '1';
			Jump      <= '1';
			JumpReg   <= '1';
			rd        <= "10101";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000020";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '0') then
				 report "FAIL: Reset did not clear write enable" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_addr /= "00000") then
				 report "FAIL: Reset did not clear write address" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_data /= x"00000000") then
				 report "FAIL: Reset did not clear write data" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			reset <= '0';
			wait for CLK_PERIOD;
			
			-- =========================================================
			-- TEST 2: ALU writeback example
			-- =========================================================
			MemToReg  <= '0';
			RegWrite  <= '1';
			Jump      <= '0';
			JumpReg   <= '0';
			rd        <= "00001";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000020";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '1') then
				 report "FAIL: ALU instr should be reg file write enabled" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_addr /= "00001") then
				 report "FAIL: ALU instr produced incorrect reg file address" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_data /= x"DEADBEEF") then
				 report "FAIL: ALU instr produced incorrect reg file data" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- =========================================================
			-- TEST 3: Load from memory
			-- =========================================================
			MemToReg  <= '1';
			RegWrite  <= '1';
			Jump      <= '0';
			JumpReg   <= '0';
			rd        <= "00010";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000020";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '1') then
				 report "FAIL: Load instr should be reg file write enabled" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_addr /= "00010") then
				 report "FAIL: Load instr produced incorrect reg file address" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_data /= x"12345678") then
				 report "FAIL: Load instr produced incorrect reg file data" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- =========================================================
			-- TEST 4: Jump instruction
			-- =========================================================
			MemToReg  <= '1';
			RegWrite  <= '1';
			Jump      <= '1';
			JumpReg   <= '0';
			rd        <= "00100";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000020";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '1') then
				 report "FAIL: jump instr should be reg file write enabled" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_addr /= "00100") then
				 report "FAIL: jump instr produced incorrect reg file address" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_data /= x"00000020") then
				 report "FAIL: jump instr produced incorrect reg file data" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- =========================================================
			-- TEST 5: JALR instruction- write data is NPC
			-- =========================================================
			MemToReg  <= '0';
			RegWrite  <= '1';
			Jump      <= '0';
			JumpReg   <= '1';
			rd        <= "00001";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000024";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '1') then
				 report "FAIL: jalr instr should be reg file write enabled" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_addr /= "00001") then
				 report "FAIL: jalr instr produced incorrect reg file address" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_data /= x"00000024") then
				 report "FAIL: jalr instr produced incorrect reg file data" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- =========================================================
			-- TEST 6: edge case- both jump and jumpreg = 1
			-- =========================================================
			MemToReg  <= '0';
			RegWrite  <= '1';
			Jump      <= '1';
			JumpReg   <= '1';
			rd        <= "00011";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000028";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '1') then
				 report "FAIL: edge instr should be reg file write enabled" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_addr /= "00011") then
				 report "FAIL: edge instr produced incorrect reg file address" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_data /= x"00000028") then
				 report "FAIL: edge instr produced incorrect reg file data" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- =========================================================
			-- TEST 7: store (no writing to register)
			-- =========================================================
			MemToReg  <= '0';
			RegWrite  <= '0';
			Jump      <= '0';
			JumpReg   <= '0';
			rd        <= "00010";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000028";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '0') then
				 report "FAIL: store instr should be reg file write disabled" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- dont care about the other outputs
			
			-- =========================================================
			-- TEST 8: writing to x0 -> should be prohibited
			-- =========================================================
			MemToReg  <= '0';
			RegWrite  <= '1';
			Jump      <= '0';
			JumpReg   <= '0';
			rd        <= "00000";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000028";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '0') then
				 report "FAIL: write to x0 should be reg file write disabled" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- dont care about the other outputs
			
			-- =========================================================
			-- TEST 2: ALU writeback example after en = 0
			-- =========================================================
			MemToReg  <= '0';
			RegWrite  <= '1';
			Jump      <= '0';
			JumpReg   <= '0';
			rd        <= "00001";
			ALUOutput <= x"DEADBEEF";
			mem_data  <= x"12345678";
			NPC       <= x"00000020";

			wait for CLK_PERIOD;
			
			-- assertions
			if (regfile_write_en /= '1') then
				 report "FAIL: ALU instr should be reg file write enabled" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_addr /= "00001") then
				 report "FAIL: ALU instr produced incorrect reg file address" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (regfile_write_data /= x"DEADBEEF") then
				 report "FAIL: ALU instr produced incorrect reg file data" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;


        -- =====================================================================
        -- summary
        -- =====================================================================
        report "===================================" severity note;
        report "Results: " & integer'image(pass_count) &
               " passed, " & integer'image(fail_count) & " failed." severity note;
        if fail_count = 0 then
            report "All tests PASSED." severity note;
        else
            report "Some tests FAILED - check output above." severity error;
        end if;
        report "=== writeback_tb done ===" severity note;

        sim_done <= true;
        wait;
    end process;

end behavior;