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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_tb is
end mem_tb;

architecture behavior of mem_tb is

    component mem_stage is
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            ALUResult    : in  std_logic_vector(31 downto 0);
            B_in         : in  std_logic_vector(31 downto 0);
            IR_in        : in  std_logic_vector(31 downto 0);
            NPC_in       : in  std_logic_vector(31 downto 0);
            MemRead      : in  std_logic;
            MemWrite     : in  std_logic;
            MemFunc      : in  std_logic_vector(2 downto 0);
            RegWrite     : in  std_logic;
            MemToReg     : in  std_logic;
            LMD_out      : out std_logic_vector(31 downto 0);
            ALUResult_out: out std_logic_vector(31 downto 0);
            IR_out       : out std_logic_vector(31 downto 0);
            NPC_out      : out std_logic_vector(31 downto 0);
            RegWrite_out : out std_logic;
            MemToReg_out : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 1 ns;
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal ALUResult    : std_logic_vector(31 downto 0) := (others => '0');
    signal B_in         : std_logic_vector(31 downto 0) := (others => '0');
    signal IR_in        : std_logic_vector(31 downto 0) := (others => '0');
    signal NPC_in       : std_logic_vector(31 downto 0) := (others => '0');
    signal MemRead      : std_logic := '0';
    signal MemWrite     : std_logic := '0';
    signal MemFunc      : std_logic_vector(2 downto 0) := "010";  -- word
    signal RegWrite     : std_logic := '0';
    signal MemToReg     : std_logic := '0';
    signal LMD_out      : std_logic_vector(31 downto 0);
    signal ALUResult_out: std_logic_vector(31 downto 0);
    signal IR_out       : std_logic_vector(31 downto 0);
    signal NPC_out      : std_logic_vector(31 downto 0);
    signal RegWrite_out : std_logic;
    signal MemToReg_out : std_logic;

    signal sim_done : boolean := false;

begin

    -- Instantiate unit under test
    uut : mem_stage
        port map(
            clk           => clk,
            reset         => reset,
            ALUResult     => ALUResult,
            B_in          => B_in,
            IR_in         => IR_in,
            NPC_in        => NPC_in,
            MemRead       => MemRead,
            MemWrite      => MemWrite,
            MemFunc       => MemFunc,
            RegWrite      => RegWrite,
            MemToReg      => MemToReg,
            LMD_out       => LMD_out,
            ALUResult_out => ALUResult_out,
            IR_out        => IR_out,
            NPC_out       => NPC_out,
            RegWrite_out  => RegWrite_out,
            MemToReg_out  => MemToReg_out
        );

    -- Clock generation
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

        variable pass_count : integer := 0;
        variable fail_count : integer := 0;
        variable expected   : std_logic_vector(31 downto 0);

    begin

        report "=== mem_stage_tb starting ===" severity note;

        -- Reset for 2 cycles
        reset    <= '1';
        MemRead  <= '0';
        MemWrite <= '0';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD;



        report "Test 1: SW - writing 0xDEADBEEF to address 0x00000010..." severity note;

        ALUResult <= x"00000010";       -- byte address 16 -> word address 4
        B_in      <= x"DEADBEEF";       -- data to write
        MemWrite  <= '1';
        MemRead   <= '0';
        MemFunc   <= "010";             -- word

        -- wait for memory to complete write (waitrequest goes low then high)
        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;

        -- check ALUResult passes through correctly
        expected := x"00000010";
        if ALUResult_out = expected then
            report "Test 1a PASSED: ALUResult_out = 0x" & to_hstring(ALUResult_out) severity note;
            pass_count := pass_count + 1;
        else
            report "Test 1a FAILED: ALUResult_out = 0x" & to_hstring(ALUResult_out) &
                   " (expected 0x" & to_hstring(expected) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- deassert write
        MemWrite <= '0';
        wait for CLK_PERIOD;

        
        report "Test 2: LW - reading back from address 0x00000010..." severity note;

        ALUResult <= x"00000010";       -- same address
        MemRead   <= '1';
        MemWrite  <= '0';
        MemFunc   <= "010";             -- word

        -- wait for memory read to complete
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;

        expected := x"DEADBEEF";
        if LMD_out = expected then
            report "Test 2 PASSED: LMD_out = 0x" & to_hstring(LMD_out) &
                   " (expected 0xDEADBEEF)" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 2 FAILED: LMD_out = 0x" & to_hstring(LMD_out) &
                   " (expected 0xDEADBEEF)" severity error;
            fail_count := fail_count + 1;
        end if;

        MemRead <= '0';
        wait for CLK_PERIOD;

    
        report "Test 3: SW then LW at address 0x00000020..." severity note;

        ALUResult <= x"00000020";
        B_in      <= x"12345678";
        MemWrite  <= '1';
        MemRead   <= '0';

        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;

        MemWrite <= '0';
        wait for CLK_PERIOD;

        -- now read it back
        ALUResult <= x"00000020";
        MemRead   <= '1';
        MemWrite  <= '0';

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;

        expected := x"12345678";
        if LMD_out = expected then
            report "Test 3 PASSED: LMD_out = 0x" & to_hstring(LMD_out) &
                   " (expected 0x12345678)" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 3 FAILED: LMD_out = 0x" & to_hstring(LMD_out) &
                   " (expected 0x12345678)" severity error;
            fail_count := fail_count + 1;
        end if;

        MemRead <= '0';
        wait for CLK_PERIOD;

        report "Test 4: Verifying address 0x00000010 still holds 0xDEADBEEF..." severity note;

        ALUResult <= x"00000010";
        MemRead   <= '1';
        MemWrite  <= '0';

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for CLK_PERIOD / 2;

        expected := x"DEADBEEF";
        if LMD_out = expected then
            report "Test 4 PASSED: LMD_out = 0x" & to_hstring(LMD_out) &
                   " (expected 0xDEADBEEF)" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 4 FAILED: LMD_out = 0x" & to_hstring(LMD_out) &
                   " (expected 0xDEADBEEF)" severity error;
            fail_count := fail_count + 1;
        end if;

        MemRead <= '0';

        
        report "Test 5: Checking control signal passthrough..." severity note;

        RegWrite <= '1';
        MemToReg <= '1';
        IR_in    <= x"AABBCCDD";
        NPC_in   <= x"00000008";
        wait for CLK_PERIOD;
        wait for CLK_PERIOD / 2;

        if RegWrite_out = '1' and MemToReg_out = '1' and
           IR_out = x"AABBCCDD" and NPC_out = x"00000008" then
            report "Test 5 PASSED: control signals pass through correctly" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 5 FAILED: RegWrite_out=" & std_logic'image(RegWrite_out) &
                   " MemToReg_out=" & std_logic'image(MemToReg_out) &
                   " IR_out=0x" & to_hstring(IR_out) &
                   " NPC_out=0x" & to_hstring(NPC_out) severity error;
            fail_count := fail_count + 1;
        end if;

        -- ---------------------------------------------------------------------
        -- Summary
        -- ---------------------------------------------------------------------
        report "===================================" severity note;
        report "Results: " & integer'image(pass_count) & " passed, " &
               integer'image(fail_count) & " failed." severity note;

        if fail_count = 0 then
            report "All tests PASSED." severity note;
        else
            report "Some tests FAILED - check output above." severity error;
        end if;

        report "=== mem_stage_tb done ===" severity note;

        sim_done <= true;
        wait;

    end process;

end behavior;