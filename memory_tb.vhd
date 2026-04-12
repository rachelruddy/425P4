LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memory_tb IS
END memory_tb;

ARCHITECTURE behavior OF memory_tb IS

    COMPONENT memory IS
        GENERIC (
            ram_size : INTEGER := 8192;
            mem_delay : TIME := 0.1 ns;
            clock_period : TIME := 1 ns
        );
        PORT (
            clock : IN STD_LOGIC;
            writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            address : IN INTEGER RANGE 0 TO 8191;
            memwrite : IN STD_LOGIC;
            memread : IN STD_LOGIC;
            readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            waitrequest : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    CONSTANT clk_period : TIME := 1 ns;

    SIGNAL writedata : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL address : INTEGER RANGE 0 TO 8191 := 0;
    SIGNAL memwrite : STD_LOGIC := '0';
    SIGNAL memread : STD_LOGIC := '0';
    SIGNAL readdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL waitrequest : STD_LOGIC;

BEGIN

    dut : memory
    GENERIC MAP(
        ram_size => 8192,
        mem_delay => 0.1 ns,
        clock_period => 1 ns
    )
    PORT MAP(
        clock => clk,
        writedata => writedata,
        address => address,
        memwrite => memwrite,
        memread => memread,
        readdata => readdata,
        waitrequest => waitrequest
    );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    test_process : PROCESS

        PROCEDURE write_word(
            addr : IN INTEGER RANGE 0 TO 8191;
            data : IN STD_LOGIC_VECTOR(31 DOWNTO 0)) IS
        BEGIN
            address <= addr;
            writedata <= data;
            memread <= '0';
            memwrite <= '1';

            WAIT UNTIL rising_edge(clk);
            memwrite <= '0';
            WAIT UNTIL rising_edge(clk);
        END PROCEDURE;

        PROCEDURE read_word(addr : IN INTEGER RANGE 0 TO 8191) IS
        BEGIN
            address <= addr;
            memwrite <= '0';
            memread <= '1';

            WAIT UNTIL rising_edge(clk);
            memread <= '0';
            WAIT UNTIL rising_edge(clk);
        END PROCEDURE;

    BEGIN

        REPORT "Begginging memory tests";

        WAIT FOR 5 ns;

        write_word(0, x"DEADBEEF");
        read_word(0);
        ASSERT (readdata = x"DEADBEEF")
        REPORT "FAIL Case 1: basic write/read at address 0" SEVERITY error;
        REPORT "--------------------------------Case 1 done--------------------------------";

        write_word(0, x"12345678");
        read_word(0);
        ASSERT (readdata = x"12345678")
        REPORT "FAIL Case 2: overwrite at address 0 did not update correctly" SEVERITY error;
        REPORT "--------------------------------Case 2 done--------------------------------";

        write_word(0, x"AAAAAAAA");
        write_word(1, x"BBBBBBBB");

        read_word(0);
        ASSERT (readdata = x"AAAAAAAA")
        REPORT "FAIL Case 3a: addr 0 corrupted by write to addr 1" SEVERITY error;

        read_word(1);
        ASSERT (readdata = x"BBBBBBBB")
        REPORT "FAIL Case 3b: addr 1 corrupted by write to addr 0" SEVERITY error;

        REPORT "--------------------------------Case 3 done--------------------------------";

        write_word(2, x"FFFFFFFF");
        write_word(2, x"00000000");

        read_word(2);
        ASSERT (readdata = x"00000000")
        REPORT "FAIL Case 4: explicit zero write not stored" SEVERITY error;

        REPORT "--------------------------------Case 4 done--------------------------------";

        write_word(8191, x"AABBCCDD");
        read_word(8191);
        ASSERT (readdata = x"AABBCCDD")
        REPORT "FAIL Case 5: write/read at last address (8191)" SEVERITY error;

        REPORT "--------------------------------Case 5 done--------------------------------";

        write_word(10, x"00000001");
        write_word(11, x"00000002");
        write_word(12, x"00000003");

        read_word(10);
        ASSERT (readdata = x"00000001")
        REPORT "FAIL Case 6a: address 10 corrupted" SEVERITY error;

        read_word(11);
        ASSERT (readdata = x"00000002")
        REPORT "FAIL Case 6b: address 11 corrupted" SEVERITY error;

        read_word(12);
        ASSERT (readdata = x"00000003")
        REPORT "FAIL Case 6c: address 12 corrupted" SEVERITY error;

        REPORT "--------------------------------Case 6 done--------------------------------";

        read_word(500);
        ASSERT (readdata = x"00000000")
        REPORT "FAIL Case 7: unwritten address not zero" SEVERITY error;

        REPORT "--------------------------------Case 7 done--------------------------------";

        write_word(30, x"11223344");
        write_word(31, x"55667788");

        address <= 30;
        WAIT FOR 0.2 ns;
        ASSERT (readdata = x"11223344")
        REPORT "FAIL Case 8a: combinatorial read at address 30 wrong" SEVERITY error;

        address <= 31;
        WAIT FOR 0.2 ns;
        ASSERT (readdata = x"55667788")
        REPORT "FAIL Case 8b: combinatorial read at address 31 wrong" SEVERITY error;

        REPORT "--------------------------------Case 8 done--------------------------------";

        write_word(0, x"FACE0001");
        write_word(8191, x"FACE8191");

        read_word(0);
        ASSERT (readdata = x"FACE0001")
        REPORT "FAIL Case 9a: address 0 aliased with address 8191" SEVERITY error;

        read_word(8191);
        ASSERT (readdata = x"FACE8191")
        REPORT "FAIL Case 9b: address 8191 aliased with address 0" SEVERITY error;

        REPORT "--------------------------------Case 9 done--------------------------------";

        write_word(50, x"01020304");
        read_word(50);
        ASSERT (readdata = x"01020304")
        REPORT "FAIL Case 10: byte-lane pattern mismatch" SEVERITY error;

        REPORT "--------------------------------Case 10 done--------------------------------";

        write_word(40, x"11111111");
        write_word(40, x"22222222");
        write_word(40, x"33333333");

        read_word(40);
        ASSERT (readdata = x"33333333")
        REPORT "FAIL Case 11: last write did not win" SEVERITY error;

        REPORT "--------------------------------Case 11 done--------------------------------";

        write_word(60, x"CAFE1234");
        write_word(61, x"BEEF5678");
        write_word(62, x"DEAD9ABC");

        read_word(60);
        ASSERT (readdata = x"CAFE1234")
        REPORT "FAIL Case 12: addrress 60 corrupted by writes to 61 and62" SEVERITY error;

        REPORT "--------------------------------Case 12 done--------------------------------";

        REPORT "Tests completed";

        WAIT;

    END PROCESS;

END behavior;