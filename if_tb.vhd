-- if_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- Testbench for: instruction_fetch.vhd
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY if_tb IS

END if_tb;

ARCHITECTURE behavior OF if_tb IS

    COMPONENT instruction_fetch IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            cond : IN STD_LOGIC;
            branch_target : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            stall : IN STD_LOGIC;
            IR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT CLK_PERIOD : TIME := 1 ns; -- 1 GHz clock
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';
    SIGNAL cond : STD_LOGIC := '0'; -- no branch
    SIGNAL branch_target : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL stall : STD_LOGIC := '0'; -- no stall
    SIGNAL IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL sim_done : BOOLEAN := false;

BEGIN

    -- Instantiate the unit under test
    uut : instruction_fetch
    PORT MAP(
        clk => clk,
        reset => reset,
        cond => cond,
        branch_target => branch_target,
        stall => stall,
        IR => IR,
        NPC => NPC
    );
    -- Clock generation: 1 GHz (1 ns period)

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

    -- -------------------------------------------------------------------------
    -- Main test process
    -- -------------------------------------------------------------------------
    test_process : PROCESS

        -- Helper variables
        VARIABLE expected_npc : unsigned(31 DOWNTO 0);
        VARIABLE actual_npc : unsigned(31 DOWNTO 0);
        VARIABLE expected_ir : unsigned(31 DOWNTO 0);
        VARIABLE actual_ir : unsigned(31 DOWNTO 0);
        VARIABLE pass_count : INTEGER := 0;
        VARIABLE fail_count : INTEGER := 0;

    BEGIN
        -- 1. Apply reset for 2 cycles
        --    After reset, PC should be 0x0 and NPC should be 0x4
        REPORT "=== instruction_fetch_tb starting ===" SEVERITY note;
        REPORT "Applying reset..." SEVERITY note;

        reset <= '1';
        cond <= '0';
        stall <= '0';
        WAIT FOR CLK_PERIOD * 2;

        -- Release reset
        reset <= '0';
        WAIT FOR CLK_PERIOD;
        -- 2. Check NPC after reset
        --    PC should be 0x0, so NPC = PC + 4 = 0x00000004

        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2; -- sample in the middle of the clock cycle

        actual_npc := unsigned(NPC);
        expected_npc := to_unsigned(12, 32);

        IF actual_npc = expected_npc THEN
            REPORT "Test 1 PASSED: NPC after reset = 0x" &
                to_hstring(NPC) & " (expected 0x00000004)" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 1 FAILED: NPC after reset = 0x" &
                to_hstring(NPC) & " (expected 0x00000004)" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        -- 3. Check NPC increments by 4 each cycle for 8 cycles
        --    No stall, no branch — PC should go 0, 4, 8, 12, 16, 20, 24, 28
        --    so NPC should go 4, 8, 12, 16, 20, 24, 28, 32
        REPORT "Checking NPC increments by 4 each cycle..." SEVERITY note;

        FOR i IN 1 TO 8 LOOP
            WAIT UNTIL rising_edge(clk);
            WAIT FOR CLK_PERIOD / 2;

            actual_npc := unsigned(NPC);
            expected_npc := to_unsigned((i + 3) * 4, 32);

            IF actual_npc = expected_npc THEN
                REPORT "Test 2." & INTEGER'image(i) &
                    " PASSED: NPC = 0x" & to_hstring(NPC) &
                    " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_npc)) &
                    ")" SEVERITY note;
                pass_count := pass_count + 1;
            ELSE
                REPORT "Test 2." & INTEGER'image(i) &
                    " FAILED: NPC = 0x" & to_hstring(NPC) &
                    " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_npc)) &
                    ")" SEVERITY error;
                fail_count := fail_count + 1;
            END IF;
        END LOOP;

        -- 4. Check IR is fetched correctly from instruction memory
        --First we reset again

        reset <= '1';
        cond <= '0';
        stall <= '0';
        WAIT FOR CLK_PERIOD * 2;

        -- Release reset
        reset <= '0';
        --wait for CLK_PERIOD;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2; -- sample in the middle of the clock cycle

        actual_ir := unsigned(IR);
        expected_ir := "00000000010100000000010100010011"; -- This should match the instruction at address 0 in your instruction memory
        IF actual_ir = expected_ir THEN
            REPORT "Test 3 PASSED: IR after reset = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 3 FAILED: IR after reset = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2; -- sample in the middle of the clock cycle

        actual_ir := unsigned(IR);
        expected_ir := "00000001000000000000000011101111"; -- This should match the instruction at address 1 in your instruction memory
        IF actual_ir = expected_ir THEN
            REPORT "Test 3.1 PASSED: IR at cycle 1 = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 3.1 FAILED: IR at cycle 1 = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2; -- sample in the middle of the clock cycle

        actual_ir := unsigned(IR);
        expected_ir := "00000000000000000000000001101111"; -- This should match the instruction at address 2 in your instruction memory
        IF actual_ir = expected_ir THEN
            REPORT "Test 3.2 PASSED: IR at cycle 2 = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 3.2 FAILED: IR at cycle 2 = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        --5 Introduce a stall and check that IR does not change

        stall <= '1'; -- Introduce a stall
        WAIT FOR CLK_PERIOD / 4;

        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2; -- sample in the middle of the clock cycle

        actual_ir := unsigned(IR);
        expected_ir := "00000000101000000000001010110011"; -- This should match the lastinstruction since we stalled
        IF actual_ir = expected_ir THEN
            REPORT "Test 4 PASSED: IR after stall = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 4 FAILED: IR after stall = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        --6 Release the stall and check that IR advances to the next instruction
        stall <= '0'; -- Release the stall
        WAIT FOR CLK_PERIOD / 4;

        WAIT UNTIL rising_edge(clk);
        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2; -- sample in the middle of the clock cycle

        actual_ir := unsigned(IR);
        expected_ir := "00000000000100000000010100010011"; -- This should match the instruction at address 3 in your instruction memory
        IF actual_ir = expected_ir THEN
            REPORT "Test 4.1 PASSED: IR after releasing stall = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 4.1 FAILED: IR after releasing stall = 0x" &
                to_hstring(IR) & " (expected 0x" & to_hstring(STD_LOGIC_VECTOR(expected_ir)) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        --7. Introduce a branch and check that PC updates to the branch target
        cond <= '1'; -- Take the branch
        branch_target <= x"00000008"; -- Branch target address

        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2; -- sample in the middle of the clock cycle

        actual_npc := unsigned(NPC);
        expected_npc := to_unsigned(12, 32); -- NPC should update to 12
        IF actual_npc = expected_npc THEN
            REPORT "Test 5 PASSED: NPC after branch = 0x" &
                to_hstring(NPC) & " (expected 0x0000000C)" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 5 FAILED: NPC after branch = 0x" &
                to_hstring(NPC) & " (expected 0x0000000C)" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        -- ---------------------------------------------------------------------
        -- 8. Print summary
        -- ---------------------------------------------------------------------
        REPORT "===================================" SEVERITY note;
        REPORT "Results: " &
            INTEGER'image(pass_count) & " passed, " &
            INTEGER'image(fail_count) & " failed." SEVERITY note;

        IF fail_count = 0 THEN
            REPORT "All tests PASSED." SEVERITY note;
        ELSE
            REPORT "Some tests FAILED - check output above." SEVERITY error;
        END IF;

        REPORT "=== instruction_fetch_tb done ===" SEVERITY note;

        -- Stop simulation
        sim_done <= true;
        WAIT;

    END PROCESS;

END behavior;