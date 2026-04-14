LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --First value for the alu operation
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --Second vlaue for the alu operation
        ALUFunc : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --Which alu function will be performed

        Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --The result of the operation
        Eq : OUT STD_LOGIC; -- A == B
        Lt : OUT STD_LOGIC -- signed A < signed B
    );
END ALU;

ARCHITECTURE rtl OF ALU IS
    SIGNAL sA : signed(31 DOWNTO 0);
    SIGNAL sB : signed(31 DOWNTO 0);
    SIGNAL uA : unsigned(31 DOWNTO 0);
    SIGNAL uB : unsigned(31 DOWNTO 0);

    SIGNAL alu_result : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    sA <= signed(A);
    sB <= signed(B);
    uA <= unsigned(A);
    uB <= unsigned(B);

    -- combinatorial ALU
    -- 0000 add, 0001 sub, 0010 mul, 0011 and, 0100 or,
    -- 0101 sll, 0110 srl, 0111 sra, 1000 xor, 1001 slt, 1010 lui(pass B)
    PROCESS (A, B, ALUFunc, sA, sB, uA, uB)
        VARIABLE shiftamt : INTEGER RANGE 0 TO 31; --If shift occurs this is the amount to shift by
    BEGIN
        shiftamt := to_integer(unsigned(B(4 DOWNTO 0)));
        alu_result <= (OTHERS => '0');

        CASE ALUFunc IS
            WHEN "0000" =>
                alu_result <= STD_LOGIC_VECTOR(uA + uB); -- add

            WHEN "0001" =>
                alu_result <= STD_LOGIC_VECTOR(uA - uB); -- sub

            WHEN "0010" =>
                -- low 32-bits of signed multiply (RV32 behavior)
                alu_result <= STD_LOGIC_VECTOR(resize(sA * sB, 32)); -- mul

            WHEN "0011" =>
                alu_result <= A AND B; -- and

            WHEN "0100" =>
                alu_result <= A OR B; -- or

            WHEN "0101" =>
                alu_result <= STD_LOGIC_VECTOR(shift_left(uA, shiftamt)); -- sll

            WHEN "0110" =>
                alu_result <= STD_LOGIC_VECTOR(shift_right(uA, shiftamt)); -- srl

            WHEN "0111" =>
                alu_result <= STD_LOGIC_VECTOR(shift_right(sA, shiftamt)); -- sra

            WHEN "1000" =>
                alu_result <= A XOR B; -- xor

            WHEN "1001" => -- slt (signed)
                IF sA < sB THEN
                    alu_result <= x"00000001";
                ELSE
                    alu_result <= x"00000000";
                END IF;

            WHEN "1010" =>
                alu_result <= B; -- lui path (immediate already shifted)

            WHEN OTHERS =>
                alu_result <= (OTHERS => '0');
        END CASE;
    END PROCESS;

    Result <= alu_result;

    Eq <= '1' WHEN A = B ELSE
        '0';
    Lt <= '1' WHEN sA < sB ELSE
        '0';
END rtl;