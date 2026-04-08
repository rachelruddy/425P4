-- if_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- Testbench for: instruction_fetch.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_tb is

end if_tb;

architecture behavior of if_tb is

    component instruction_fetch is
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            cond         : in  std_logic;
            branch_target: in  std_logic_vector(31 downto 0);
            stall        : in  std_logic;
            IR           : out std_logic_vector(31 downto 0);
            NPC          : out std_logic_vector(31 downto 0)
        );
    end component;

    constant CLK_PERIOD : time := 1 ns;  -- 1 GHz clock


    signal clk           : std_logic := '0';
    signal reset         : std_logic := '1';
    signal cond          : std_logic := '0';  -- no branch
    signal branch_target : std_logic_vector(31 downto 0) := (others => '0');
    signal stall         : std_logic := '0';  -- no stall
    signal IR            : std_logic_vector(31 downto 0);
    signal NPC           : std_logic_vector(31 downto 0);

    signal sim_done : boolean := false;

begin

    -- Instantiate the unit under test
    uut : instruction_fetch
        port map(
            clk           => clk,
            reset         => reset,
            cond          => cond,
            branch_target => branch_target,
            stall         => stall,
            IR            => IR,
            NPC           => NPC
        );


    -- Clock generation: 1 GHz (1 ns period)

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

    -- -------------------------------------------------------------------------
    -- Main test process
    -- -------------------------------------------------------------------------
    test_process : process

        -- Helper variables
        variable expected_npc : unsigned(31 downto 0);
        variable actual_npc   : unsigned(31 downto 0);
        variable expected_ir  : unsigned(31 downto 0);
        variable actual_ir    : unsigned(31 downto 0);
        variable pass_count   : integer := 0;
        variable fail_count   : integer := 0;

    begin

        
        -- 1. Apply reset for 2 cycles
        --    After reset, PC should be 0x0 and NPC should be 0x4
        report "=== instruction_fetch_tb starting ===" severity note;
        report "Applying reset..." severity note;

        reset <= '1';
        cond  <= '0';
        stall <= '0';
        wait for CLK_PERIOD * 2;

        -- Release reset
        reset <= '0';
        wait for CLK_PERIOD;

      
        -- 2. Check NPC after reset
        --    PC should be 0x0, so NPC = PC + 4 = 0x00000004

        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;  -- sample in the middle of the clock cycle

        actual_npc   := unsigned(NPC);
        expected_npc := to_unsigned(12, 32);

        if actual_npc = expected_npc then
            report "Test 1 PASSED: NPC after reset = 0x" &
                   to_hstring(NPC) & " (expected 0x00000004)" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 1 FAILED: NPC after reset = 0x" &
                   to_hstring(NPC) & " (expected 0x00000004)" severity error;
            fail_count := fail_count + 1;
        end if;

        -- 3. Check NPC increments by 4 each cycle for 8 cycles
        --    No stall, no branch — PC should go 0, 4, 8, 12, 16, 20, 24, 28
        --    so NPC should go 4, 8, 12, 16, 20, 24, 28, 32
        report "Checking NPC increments by 4 each cycle..." severity note;

        for i in 1 to 8 loop
            wait until rising_edge(clk);
            wait for CLK_PERIOD / 2;

            actual_npc   := unsigned(NPC);
            expected_npc := to_unsigned((i + 3) * 4, 32);

            if actual_npc = expected_npc then
                report "Test 2." & integer'image(i) &
                       " PASSED: NPC = 0x" & to_hstring(NPC) &
                       " (expected 0x" & to_hstring(std_logic_vector(expected_npc)) &
                       ")" severity note;
                pass_count := pass_count + 1;
            else
                report "Test 2." & integer'image(i) &
                       " FAILED: NPC = 0x" & to_hstring(NPC) &
                       " (expected 0x" & to_hstring(std_logic_vector(expected_npc)) &
                       ")" severity error;
                fail_count := fail_count + 1;
            end if;
        end loop;

        -- 4. Check IR is fetched correctly from instruction memory
        --First we reset again

        reset <= '1';
        cond  <= '0';
        stall <= '0';
        wait for CLK_PERIOD * 2;

        -- Release reset
        reset <= '0';
        --wait for CLK_PERIOD;

        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;  -- sample in the middle of the clock cycle

        actual_ir   := unsigned(IR);
        expected_ir := "00000000010100000000010100010011";  -- This should match the instruction at address 0 in your instruction memory
         if actual_ir = expected_ir then
            report "Test 3 PASSED: IR after reset = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 3 FAILED: IR after reset = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;  -- sample in the middle of the clock cycle

        actual_ir   := unsigned(IR);
        expected_ir := "00000001000000000000000011101111";  -- This should match the instruction at address 1 in your instruction memory
         if actual_ir = expected_ir then
            report "Test 3.1 PASSED: IR at cycle 1 = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 3.1 FAILED: IR at cycle 1 = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;  -- sample in the middle of the clock cycle

        actual_ir   := unsigned(IR);
        expected_ir := "00000000000000000000000001101111";  -- This should match the instruction at address 2 in your instruction memory
         if actual_ir = expected_ir then
            report "Test 3.2 PASSED: IR at cycle 2 = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 3.2 FAILED: IR at cycle 2 = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        --5 Introduce a stall and check that IR does not change

        stall <= '1';  -- Introduce a stall
        wait for CLK_PERIOD / 4;

        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;  -- sample in the middle of the clock cycle

        actual_ir   := unsigned(IR);
        expected_ir := "00000000101000000000001010110011";  -- This should match the lastinstruction since we stalled
         if actual_ir = expected_ir then
            report "Test 4 PASSED: IR after stall = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 4 FAILED: IR after stall = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        --6 Release the stall and check that IR advances to the next instruction
        stall <= '0';  -- Release the stall
        wait for CLK_PERIOD / 4;

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;  -- sample in the middle of the clock cycle

        actual_ir   := unsigned(IR);
        expected_ir := "00000000000100000000010100010011";  -- This should match the instruction at address 3 in your instruction memory
         if actual_ir = expected_ir then
            report "Test 4.1 PASSED: IR after releasing stall = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 4.1 FAILED: IR after releasing stall = 0x" &
                   to_hstring(IR) & " (expected 0x" & to_hstring(std_logic_vector(expected_ir)) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        --7. Introduce a branch and check that PC updates to the branch target
        cond <= '1';  -- Take the branch
        branch_target <= x"00000008";  -- Branch target address

        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;  -- sample in the middle of the clock cycle

        actual_npc   := unsigned(NPC);
        expected_npc := to_unsigned(12, 32);  -- NPC should update to 12
        if actual_npc = expected_npc then
            report "Test 5 PASSED: NPC after branch = 0x" &
                   to_hstring(NPC) & " (expected 0x0000000C)" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 5 FAILED: NPC after branch = 0x" &
                   to_hstring(NPC) & " (expected 0x0000000C)" severity error;
            fail_count := fail_count + 1;
        end if;



        -- ---------------------------------------------------------------------
        -- 8. Print summary
        -- ---------------------------------------------------------------------
        report "===================================" severity note;
        report "Results: " &
               integer'image(pass_count) & " passed, " &
               integer'image(fail_count) & " failed." severity note;

        if fail_count = 0 then
            report "All tests PASSED." severity note;
        else
            report "Some tests FAILED - check output above." severity error;
        end if;

        report "=== instruction_fetch_tb done ===" severity note;

        -- Stop simulation
        sim_done <= true;
        wait;

    end process;

end behavior;
