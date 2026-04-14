-- mem_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- Testbench for: mem_pipeline.vhd
-- Tests: Store Word (SW) and Load Word (LW)
--
-- How to run:
--   do run_mem_tb.tcl
--
-- Results printed to ModelSim console via report statements.
-- Also check the txt file outputed by the tcl

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mem_tb IS
END mem_tb;

ARCHITECTURE behavior OF mem_tb IS

    COMPONENT mem_stage IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            ALUResult : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            B_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            IR_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            MemRead : IN STD_LOGIC;
            MemWrite : IN STD_LOGIC;
            MemFunc : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            RegWrite : IN STD_LOGIC;
            MemToReg : IN STD_LOGIC;
            LMD_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            RegWrite_out : OUT STD_LOGIC;
            MemToReg_out : OUT STD_LOGIC
        );
    END COMPONENT;

    CONSTANT CLK_PERIOD : TIME := 1 ns;
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';
    SIGNAL ALUResult : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL IR_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL NPC_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL MemRead : STD_LOGIC := '0';
    SIGNAL MemWrite : STD_LOGIC := '0';
    SIGNAL MemFunc : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010"; -- word
    SIGNAL RegWrite : STD_LOGIC := '0';
    SIGNAL MemToReg : STD_LOGIC := '0';
    SIGNAL LMD_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL RegWrite_out : STD_LOGIC;
    SIGNAL MemToReg_out : STD_LOGIC;

    SIGNAL sim_done : BOOLEAN := false;

BEGIN

    -- Instantiate unit under test
    uut : mem_stage
    PORT MAP(
        clk => clk,
        reset => reset,
        ALUResult => ALUResult,
        B_in => B_in,
        IR_in => IR_in,
        NPC_in => NPC_in,
        MemRead => MemRead,
        MemWrite => MemWrite,
        MemFunc => MemFunc,
        RegWrite => RegWrite,
        MemToReg => MemToReg,
        LMD_out => LMD_out,
        ALUResult_out => ALUResult_out,
        IR_out => IR_out,
        NPC_out => NPC_out,
        RegWrite_out => RegWrite_out,
        MemToReg_out => MemToReg_out
    );

    -- Clock generation
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

        VARIABLE pass_count : INTEGER := 0;
        VARIABLE fail_count : INTEGER := 0;
        VARIABLE expected : STD_LOGIC_VECTOR(31 DOWNTO 0);

    BEGIN

        REPORT "=== mem_stage_tb starting ===" SEVERITY note;

        -- Reset for 2 cycles
        reset <= '1';
        MemRead <= '0';
        MemWrite <= '0';
        WAIT FOR CLK_PERIOD * 2;
        reset <= '0';
        WAIT FOR CLK_PERIOD;

        REPORT "Test 1: SW - writing 0xDEADBEEF to address 0x00000010..." SEVERITY note;

        ALUResult <= x"00000010"; -- byte address 16 -> word address 4
        B_in <= x"DEADBEEF"; -- data to write
        MemWrite <= '1';
        MemRead <= '0';
        MemFunc <= "010"; -- word

        -- wait for memory to complete write (waitrequest goes low then high)
        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2;

        -- check ALUResult passes through correctly
        expected := x"00000010";
        IF ALUResult_out = expected THEN
            REPORT "Test 1a PASSED: ALUResult_out = 0x" & to_hstring(ALUResult_out) SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 1a FAILED: ALUResult_out = 0x" & to_hstring(ALUResult_out) &
                " (expected 0x" & to_hstring(expected) & ")" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        -- deassert write
        MemWrite <= '0';
        WAIT FOR CLK_PERIOD;
        REPORT "Test 2: LW - reading back from address 0x00000010..." SEVERITY note;

        ALUResult <= x"00000010"; -- same address
        MemRead <= '1';
        MemWrite <= '0';
        MemFunc <= "010"; -- word

        -- wait for memory read to complete
        WAIT UNTIL rising_edge(clk);
        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2;

        expected := x"DEADBEEF";
        IF LMD_out = expected THEN
            REPORT "Test 2 PASSED: LMD_out = 0x" & to_hstring(LMD_out) &
                " (expected 0xDEADBEEF)" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 2 FAILED: LMD_out = 0x" & to_hstring(LMD_out) &
                " (expected 0xDEADBEEF)" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        MemRead <= '0';
        WAIT FOR CLK_PERIOD;
        REPORT "Test 3: SW then LW at address 0x00000020..." SEVERITY note;

        ALUResult <= x"00000020";
        B_in <= x"12345678";
        MemWrite <= '1';
        MemRead <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2;

        MemWrite <= '0';
        WAIT FOR CLK_PERIOD;

        -- now read it back
        ALUResult <= x"00000020";
        MemRead <= '1';
        MemWrite <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2;

        expected := x"12345678";
        IF LMD_out = expected THEN
            REPORT "Test 3 PASSED: LMD_out = 0x" & to_hstring(LMD_out) &
                " (expected 0x12345678)" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 3 FAILED: LMD_out = 0x" & to_hstring(LMD_out) &
                " (expected 0x12345678)" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        MemRead <= '0';
        WAIT FOR CLK_PERIOD;

        REPORT "Test 4: Verifying address 0x00000010 still holds 0xDEADBEEF..." SEVERITY note;

        ALUResult <= x"00000010";
        MemRead <= '1';
        MemWrite <= '0';

        WAIT UNTIL rising_edge(clk);
        WAIT UNTIL rising_edge(clk);
        WAIT FOR CLK_PERIOD / 2;

        expected := x"DEADBEEF";
        IF LMD_out = expected THEN
            REPORT "Test 4 PASSED: LMD_out = 0x" & to_hstring(LMD_out) &
                " (expected 0xDEADBEEF)" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 4 FAILED: LMD_out = 0x" & to_hstring(LMD_out) &
                " (expected 0xDEADBEEF)" SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        MemRead <= '0';
        REPORT "Test 5: Checking control signal passthrough..." SEVERITY note;

        RegWrite <= '1';
        MemToReg <= '1';
        IR_in <= x"AABBCCDD";
        NPC_in <= x"00000008";
        WAIT FOR CLK_PERIOD;
        WAIT FOR CLK_PERIOD / 2;

        IF RegWrite_out = '1' AND MemToReg_out = '1' AND
            IR_out = x"AABBCCDD" AND NPC_out = x"00000008" THEN
            REPORT "Test 5 PASSED: control signals pass through correctly" SEVERITY note;
            pass_count := pass_count + 1;
        ELSE
            REPORT "Test 5 FAILED: RegWrite_out=" & STD_LOGIC'image(RegWrite_out) &
                " MemToReg_out=" & STD_LOGIC'image(MemToReg_out) &
                " IR_out=0x" & to_hstring(IR_out) &
                " NPC_out=0x" & to_hstring(NPC_out) SEVERITY error;
            fail_count := fail_count + 1;
        END IF;

        -- ---------------------------------------------------------------------
        -- Summary
        -- ---------------------------------------------------------------------
        REPORT "===================================" SEVERITY note;
        REPORT "Results: " & INTEGER'image(pass_count) & " passed, " &
            INTEGER'image(fail_count) & " failed." SEVERITY note;

        IF fail_count = 0 THEN
            REPORT "All tests PASSED." SEVERITY note;
        ELSE
            REPORT "Some tests FAILED - check output above." SEVERITY error;
        END IF;

        REPORT "=== mem_stage_tb done ===" SEVERITY note;

        sim_done <= true;
        WAIT;

    END PROCESS;

END behavior;