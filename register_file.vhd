LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY register_file IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        -- 2 read ports
        rs1_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rs2_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        rs1_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        rs2_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- 1 write port
        write_enable : IN STD_LOGIC;
        write_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END register_file;

ARCHITECTURE rtl OF register_file IS
    TYPE reg_file_t IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL regs : reg_file_t := (OTHERS => (OTHERS => '0'));
BEGIN
    -- asynchronous reads, x0 is hardwired to zero
    -- my understanding is decode needs the read values immediately, so this is combinatorial
    rs1_data <= (OTHERS => '0') WHEN rs1_addr = "00000" ELSE
        regs(to_integer(unsigned(rs1_addr)));
    rs2_data <= (OTHERS => '0') WHEN rs2_addr = "00000" ELSE
        regs(to_integer(unsigned(rs2_addr)));

    -- synchronous write, ignore writes to x0
    -- my understanding is updates to data should occur on the clock
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                regs <= (OTHERS => (OTHERS => '0'));
            ELSE
                IF write_enable = '1' AND write_addr /= "00000" THEN -- protect against rd = 0
                    regs(to_integer(unsigned(write_addr))) <= write_data;
                END IF;
                regs(0) <= (OTHERS => '0'); -- keeps r0 = 0
            END IF;
        END IF;
    END PROCESS;
END rtl;