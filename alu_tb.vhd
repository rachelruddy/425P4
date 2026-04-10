-- alu_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- Testbench for: ALU.vhd


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is

end alu_tb;

architecture behavioral of alu_tb is

    -- Component declaration for the ALU
    component alu is
        port (
            A : in std_logic_vector(31 downto 0);
            B : in std_logic_vector(31 downto 0);
            ALUFunc : in std_logic_vector(3 downto 0);

            Result : out std_logic_vector(31 downto 0);
            Eq : out std_logic;
            Lt : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 1 ns;

    -- Test signals
    signal A, B, Result : std_logic_vector(31 downto 0);
    signal ALUFunc : std_logic_vector(3 downto 0);
    signal Eq : std_logic;
    signal Lt : std_logic;


begin
    -- Instantiate the ALU
    uut: alu
        port map (
            A => A,
            B => B,
            ALUFunc => ALUFunc,
            Result => Result,
            Eq => Eq,
            Lt => Lt
        );

    -- Main test process
    test_process : process

    variable actual_result : unsigned(31 downto 0);
    variable expected_result : unsigned(31 downto 0);
    variable actual_eq : std_logic;
    variable expected_eq : std_logic;
    variable actual_lt : std_logic;
    variable expected_lt : std_logic;
    variable pass_count : integer := 0;
    variable fail_count : integer := 0;

    begin
        -- Test 1: ADD
        A <= x"00000005";  -- 5
        B <= x"00000003";  -- 3
        ALUFunc <= "0000"; -- ADD

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000008";
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 1 PASSED: ADD operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 1 FAILED: ADD operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 2: SUB
        ALUFunc <= "0001"; -- SUB

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000002";
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 2 PASSED: SUB operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 2 FAILED: SUB operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 3: MUL
        ALUFunc <= "0010"; -- MUL

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"0000000F";  -- 15
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 3 PASSED: MUL operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 3 FAILED: MUL operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 4: EQ
        A <= x"00000005";  -- 5
        B <= x"00000005";  -- 5
        ALUFunc <= "0000"; -- ADD

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"0000000a";
        actual_eq := Eq;
        expected_eq := '1';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 4 PASSED: EQ flag" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 4 FAILED: EQ flag. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 5: LT
        A <= x"00000003";  -- 3
        B <= x"00000005";  -- 5
        ALUFunc <= "0000"; -- ADD

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000008";
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '1';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 5 PASSED: LT flag" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 5 FAILED: LT flag. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 6: AND
        A <= x"0000000B";  -- 11
        B <= x"00000007";  -- 7
        ALUFunc <= "0011"; -- AND

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000003";  -- 3 (0b1011 AND 0b0111 = 0b0011)
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 6 PASSED: AND operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 6 FAILED: AND operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 7: OR
        ALUFunc <= "0100"; -- OR

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"0000000F";  -- 15 (0b1011 OR 0b0111 = 0b1111)
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 7 PASSED: OR operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 7 FAILED: OR operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 8: Logical Shift Left
        A <= x"0000000C";  -- 12
        B <= x"00000003";  -- 3
        ALUFunc <= "0101"; -- Logical Shift Left

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000060";  -- 96 (0b1100 SLL 0b0011 = 0b1100000)
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 8 PASSED: Logical Shift Left operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 8 FAILED: Logical Shift Left operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 9: Logical Shift Right
        A <= x"0000000C";  -- 12
        B <= x"00000003";  -- 3
        ALUFunc <= "0110"; -- Logical Shift Right

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000001";  -- 1 (0b1100 SRL 0b0011 = 0b0001)
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 9 PASSED: Logical Shift Right operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 9 FAILED: Logical Shift Right operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

         -- Test 10: Arithmetic Shift Right
        A <= x"0000000C";  -- 12
        B <= x"00000003";  -- 3
        ALUFunc <= "0111"; -- Arithmetic Shift Right

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000001";  -- 1 (0b1100 SRL 0b0011 = 0b0001)
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 10 PASSED: Arithmetic Shift Right operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 10 FAILED: Arithmetic Shift Right operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 11: XOR
        A <= x"0000000E";  -- 12
        B <= x"00000003";  -- 3
        ALUFunc <= "1000"; -- XOR

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"0000000D";  -- 13 (0b1110 XOR 0b0011 = 0b1101)
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 11 PASSED: XOR operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 11 FAILED: XOR operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 12: SLT
        A <= x"FFFFFFFF";  -- 12
        B <= x"00000003";  -- 3
        ALUFunc <= "1001"; -- SLT

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000001";  -- 1 (0b1111 < 0b0011 = 0b0001)
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '1';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 12 PASSED: SLT operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 12 FAILED: SLT operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        -- Test 13: LUI {return B}
        A <= x"0000000E";  -- 12
        B <= x"00000003";  -- 3
        ALUFunc <= "1010"; -- LUI

        wait for CLK_PERIOD;

        actual_result := unsigned(Result);
        expected_result := x"00000003";  -- 3 (LUI should return B)
        actual_eq := Eq;
        expected_eq := '0';
        actual_lt := Lt;
        expected_lt := '0';

        if actual_result = expected_result and actual_eq = expected_eq and actual_lt = expected_lt then
            report "Test 13 PASSED: LUI operation" severity note;
            pass_count := pass_count + 1;
        else
            report "Test 13 FAILED: LUI operation. Got Result=0x" & to_hstring(Result) &
                   ", Eq=" & std_logic'image(Eq) & ", Lt=" & std_logic'image(Lt) &
                   " (expected Result=0x" & to_hstring(std_logic_vector(expected_result)) &
                   ", Eq=" & std_logic'image(expected_eq) & ", Lt=" & std_logic'image(expected_lt) & ")" severity error;
            fail_count := fail_count + 1;
        end if;

        report "===================================" severity note;
        report "Results: " &
               integer'image(pass_count) & " passed, " &
               integer'image(fail_count) & " failed." severity note;

        if fail_count = 0 then
            report "All tests PASSED." severity note;
        else
            report "Some tests FAILED - check output above." severity error;
        end if;

        report "=== alu_tb done ===" severity note;



        
    end process;
    

end behavioral;