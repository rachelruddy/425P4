LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ALU is
    port(
        A : in STD_LOGIC_VECTOR(31 DOWNTO 0);  --First value for the alu operation
        B : in STD_LOGIC_VECTOR(31 DOWNTO 0);  --Second vlaue for the alu operation
        ALUFunc : in STD_LOGIC_VECTOR(3 DOWNTO 0);  --Which alu function will be performed

        Result : out STD_LOGIC_VECTOR(31 DOWNTO 0);  --The result of the operation
        Eq : out STD_LOGIC;                                   -- A == B
        Lt : out STD_LOGIC                                    -- signed A < signed B
    );
end ALU;

architecture rtl of ALU is
    signal sA : signed(31 DOWNTO 0);
    signal sB : signed(31 DOWNTO 0);
    signal uA : unsigned(31 DOWNTO 0);
    signal uB : unsigned(31 DOWNTO 0);

    signal alu_result : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
    sA <= signed(A);
    sB <= signed(B);
    uA <= unsigned(A);
    uB <= unsigned(B);

    -- combinatorial ALU
    -- 0000 add, 0001 sub, 0010 mul, 0011 and, 0100 or,
    -- 0101 sll, 0110 srl, 0111 sra, 1000 xor, 1001 slt, 1010 lui(pass B)
    process(A, B, ALUFunc, sA, sB, uA, uB)
        variable shiftamt : INTEGER RANGE 0 TO 31; --If shift occurs this is the amount to shift by
    begin
        shiftamt := to_integer(unsigned(B(4 DOWNTO 0)));   
        alu_result <= (others => '0');

        case ALUFunc is
            when "0000" =>
                alu_result <= std_logic_vector(uA + uB);                      -- add

            when "0001" =>
                alu_result <= std_logic_vector(uA - uB);                      -- sub

            when "0010" =>
                -- low 32-bits of signed multiply (RV32 behavior)
                alu_result <= std_logic_vector(resize(sA * sB, 32));          -- mul

            when "0011" =>
                alu_result <= A and B;                                        -- and

            when "0100" =>
                alu_result <= A or B;                                         -- or

            when "0101" =>
                alu_result <= std_logic_vector(shift_left(uA, shiftamt));        -- sll

            when "0110" =>
                alu_result <= std_logic_vector(shift_right(uA, shiftamt));       -- srl

            when "0111" =>
                alu_result <= std_logic_vector(shift_right(sA, shiftamt));       -- sra

            when "1000" =>
                alu_result <= A xor B;                                        -- xor

            when "1001" =>                                                    -- slt (signed)
                if sA < sB then
                    alu_result <= x"00000001";
                else
                    alu_result <= x"00000000";
                end if;

            when "1010" =>
                alu_result <= B;                                              -- lui path (immediate already shifted)

            when others =>
                alu_result <= (others => '0');
        end case;
    end process;

    Result <= alu_result;

    Eq <= '1' when A = B else '0';
    Lt <= '1' when sA < sB else '0';
end rtl;
