LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity register_file is
    port(
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;

        -- 2 read ports
        rs1_addr : in STD_LOGIC_VECTOR(4 DOWNTO 0);
        rs2_addr : in STD_LOGIC_VECTOR(4 DOWNTO 0);
        rs1_data : out STD_LOGIC_VECTOR(31 DOWNTO 0);
        rs2_data : out STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- 1 write port
        write_enable : in STD_LOGIC;
        write_addr : in STD_LOGIC_VECTOR(4 DOWNTO 0);
        write_data : in STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end register_file;

architecture rtl of register_file is
    type reg_file_t is array (0 to 31) of STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal regs : reg_file_t := (others => (others => '0'));
begin
    -- asynchronous reads, x0 is hardwired to zero
    -- my understanding is decode needs the read values immediately, so this is combinatorial
    rs1_data <= (others => '0') when rs1_addr = "00000" else regs(to_integer(unsigned(rs1_addr)));
    rs2_data <= (others => '0') when rs2_addr = "00000" else regs(to_integer(unsigned(rs2_addr)));

    -- synchronous write, ignore writes to x0
    -- my understanding is updates to data should occur on the clock
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                regs <= (others => (others => '0'));
            else
                if write_enable = '1' and write_addr /= "00000" then -- protect against rd = 0
                    regs(to_integer(unsigned(write_addr))) <= write_data;
                end if;
                regs(0) <= (others => '0'); -- keeps r0 = 0
            end if;
        end if;
    end process;
end rtl;