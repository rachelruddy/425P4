-- rf_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- Testbench for: register_file.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rf_tb is
end rf_tb;

architecture behavior of rf_tb is

    component register_file is
        port(
            clk          : in  STD_LOGIC;
            reset        : in  STD_LOGIC;
            rs1_addr     : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
            rs2_addr     : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
            rs1_data     : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            rs2_data     : out STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_enable : in  STD_LOGIC;
            write_addr   : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
            write_data   : in  STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;

    constant CLK_PERIOD : time := 1 ns;

    -- inputs
    signal clk          : STD_LOGIC := '0';
    signal reset        : STD_LOGIC := '1';
    signal rs1_addr     : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal rs2_addr     : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal write_enable : STD_LOGIC := '0';
    signal write_addr   : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    signal write_data   : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');

    -- outputs
    signal rs1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal rs2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    signal sim_done : boolean := false;

begin

    uut : register_file
        port map(
            clk          => clk,
            reset        => reset,
            rs1_addr     => rs1_addr,
            rs2_addr     => rs2_addr,
            rs1_data     => rs1_data,
            rs2_data     => rs2_data,
            write_enable => write_enable,
            write_addr   => write_addr,
            write_data   => write_data
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
        report "=== register_file_tb starting ===" severity note;

        -- apply reset
        reset <= '1';
        rs1_addr <= "00000";
        rs2_addr <= "00000";
        write_enable <= '0';
        write_addr <= (others => '0');
        write_data <= (others => '0');
        wait for CLK_PERIOD * 2;

        -- =====================================================================
        -- TEST CASES
        -- =====================================================================

        --------------------------------------------------------------------
        -- Test 1: reset keeps registers at zero
        --------------------------------------------------------------------
        if rs1_data = x"00000000" then
            report "RESET Test PASSED: rs1_data = 0" severity note;
            pass_count := pass_count + 1;
        else
            report "RESET Test FAILED: rs1_data = " & to_hstring(rs1_data) &
                   " (expected 0x00000000)" severity error;
            fail_count := fail_count + 1;
        end if;

        if rs2_data = x"00000000" then
            report "RESET Test PASSED: rs2_data = 0" severity note;
            pass_count := pass_count + 1;
        else
            report "RESET Test FAILED: rs2_data = " & to_hstring(rs2_data) &
                   " (expected 0x00000000)" severity error;
            fail_count := fail_count + 1;
        end if;

        reset <= '0';
        wait for CLK_PERIOD;

        --------------------------------------------------------------------
        -- Test 2: x0 is always zero, even if write is attempted
        --------------------------------------------------------------------
        write_enable <= '1';
        write_addr <= "00000";
        write_data <= x"DEADBEEF";
        rs1_addr <= "00000";
        rs2_addr <= "00000";
        wait for CLK_PERIOD;

        if rs1_data = x"00000000" then
            report "X0 Test PASSED: rs1_data = 0" severity note;
            pass_count := pass_count + 1;
        else
            report "X0 Test FAILED: rs1_data = " & to_hstring(rs1_data) &
                   " (expected 0x00000000)" severity error;
            fail_count := fail_count + 1;
        end if;

        --------------------------------------------------------------------
        -- Test 3: write x1 = 5 and read it back
        --------------------------------------------------------------------
        write_addr <= "00001";
        write_data <= x"00000005";
        wait for CLK_PERIOD;

        rs1_addr <= "00001";
        rs2_addr <= "00010";
        wait for CLK_PERIOD;

        if rs1_data = x"00000005" then
            report "WRITE Test PASSED: x1 = 5" severity note;
            pass_count := pass_count + 1;
        else
            report "WRITE Test FAILED: x1 readback = " & to_hstring(rs1_data) &
                   " (expected 0x00000005)" severity error;
            fail_count := fail_count + 1;
        end if;

        if rs2_data = x"00000000" then
            report "WRITE Test PASSED: x2 still = 0" severity note;
            pass_count := pass_count + 1;
        else
            report "WRITE Test FAILED: x2 readback = " & to_hstring(rs2_data) &
                   " (expected 0x00000000)" severity error;
            fail_count := fail_count + 1;
        end if;

        --------------------------------------------------------------------
        -- Test 4: write x2 = 3 and read both operands combinatorially
        --------------------------------------------------------------------
        write_addr <= "00010";
        write_data <= x"00000003";
        wait for CLK_PERIOD;

        rs1_addr <= "00001";
        rs2_addr <= "00010";
        wait for CLK_PERIOD;

        if rs1_data = x"00000005" then
            report "READ Test PASSED: x1 = 5" severity note;
            pass_count := pass_count + 1;
        else
            report "READ Test FAILED: x1 = " & to_hstring(rs1_data) &
                   " (expected 0x00000005)" severity error;
            fail_count := fail_count + 1;
        end if;

        if rs2_data = x"00000003" then
            report "READ Test PASSED: x2 = 3" severity note;
            pass_count := pass_count + 1;
        else
            report "READ Test FAILED: x2 = " & to_hstring(rs2_data) &
                   " (expected 0x00000003)" severity error;
            fail_count := fail_count + 1;
        end if;

        --------------------------------------------------------------------
        -- Test 5: simultaneous read/write to same register after clock edge
        --------------------------------------------------------------------
        write_addr <= "00011";
        write_data <= x"00000007";
        rs1_addr <= "00011";
        rs2_addr <= "00011";
        wait for CLK_PERIOD;

        if rs1_data = x"00000007" then
            report "READ/WRITE Test PASSED: x3 = 7" severity note;
            pass_count := pass_count + 1;
        else
            report "READ/WRITE Test FAILED: x3 = " & to_hstring(rs1_data) &
                   " (expected 0x00000007)" severity error;
            fail_count := fail_count + 1;
        end if;

        --------------------------------------------------------------------
        -- Test 6: x0 remains zero after additional writes
        --------------------------------------------------------------------
        write_addr <= "00000";
        write_data <= x"FFFFFFFF";
        wait for CLK_PERIOD;
        rs1_addr <= "00000";
        wait for CLK_PERIOD;

        if rs1_data = x"00000000" then
            report "X0 PROTECT Test PASSED: x0 stayed zero" severity note;
            pass_count := pass_count + 1;
        else
            report "X0 PROTECT Test FAILED: x0 = " & to_hstring(rs1_data) &
                   " (expected 0x00000000)" severity error;
            fail_count := fail_count + 1;
        end if;

        -- summary
        report "===================================" severity note;
        report "Results: " & integer'image(pass_count) &
               " passed, " & integer'image(fail_count) & " failed." severity note;
        if fail_count = 0 then
            report "All tests PASSED." severity note;
        else
            report "Some tests FAILED - check output above." severity error;
        end if;
        report "=== register_file_tb done ===" severity note;

        sim_done <= true;
        wait;
    end process;

end behavior;
