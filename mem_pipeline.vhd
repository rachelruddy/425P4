LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mem_stage IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        ALUResult : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        NPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        MemRead : IN STD_LOGIC;
        MemWrite : IN STD_LOGIC;
        RegWrite : IN STD_LOGIC;
        MemToReg : IN STD_LOGIC;
        Jump : IN STD_LOGIC;
        JumpReg : IN STD_LOGIC;

        ALUOutput : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        LMD : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        RegWrite_out : OUT STD_LOGIC;
        MemToReg_out : OUT STD_LOGIC;
        Jump_out : OUT STD_LOGIC;
        JumpReg_out : OUT STD_LOGIC;
        rd_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END mem_stage;

ARCHITECTURE rtl OF mem_stage IS

    COMPONENT memory IS
        GENERIC (
            ram_size : INTEGER := 8192;
            mem_delay : TIME := 1 ns;
            clock_period : TIME := 1 ns
        );
        PORT (
            clock : IN STD_LOGIC;
            writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            address : IN INTEGER RANGE 0 TO ram_size - 1;
            memwrite : IN STD_LOGIC;
            memread : IN STD_LOGIC;
            readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            waitrequest : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL word_addr : INTEGER RANGE 0 TO 8191;
    SIGNAL byte_offset : INTEGER RANGE 0 TO 3;

    SIGNAL mem_writedata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_readdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_waitreq : STD_LOGIC;

    SIGNAL raw_word : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL load_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_word : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL funct3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL rd : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

    funct3 <= IR(14 DOWNTO 12);
    rd <= IR(11 DOWNTO 7);

    word_addr <= to_integer(unsigned(ALUResult(14 DOWNTO 2)));
    byte_offset <= to_integer(unsigned(ALUResult(1 DOWNTO 0)));

    raw_word <= mem_readdata;

    PROCESS (MemWrite, funct3, byte_offset, B, raw_word)
    BEGIN
        write_word <= B;

        IF MemWrite = '1' THEN
            CASE funct3 IS
                WHEN "000" =>
                    write_word <= raw_word;
                    CASE byte_offset IS
                        WHEN 0 => write_word(7 DOWNTO 0) <= B(7 DOWNTO 0);
                        WHEN 1 => write_word(15 DOWNTO 8) <= B(7 DOWNTO 0);
                        WHEN 2 => write_word(23 DOWNTO 16) <= B(7 DOWNTO 0);
                        WHEN 3 => write_word(31 DOWNTO 24) <= B(7 DOWNTO 0);
                        WHEN OTHERS => NULL;
                    END CASE;

                WHEN "001" =>
                    write_word <= raw_word;
                    CASE byte_offset IS
                        WHEN 0 => write_word(15 DOWNTO 0) <= B(15 DOWNTO 0);
                        WHEN 2 => write_word(31 DOWNTO 16) <= B(15 DOWNTO 0);
                        WHEN OTHERS => NULL;
                    END CASE;

                WHEN "010" =>
                    write_word <= B;

                WHEN OTHERS =>
                    write_word <= B;
            END CASE;
        END IF;
    END PROCESS;

    mem_writedata <= write_word;

    data_mem : memory
    GENERIC MAP(
        ram_size => 8192,
        mem_delay => 1 ns,
        clock_period => 1 ns
    )
    PORT MAP(
        clock => clk,
        writedata => mem_writedata,
        address => word_addr,
        memwrite => MemWrite,
        memread => MemRead,
        readdata => mem_readdata,
        waitrequest => mem_waitreq
    );

    PROCESS (MemRead, funct3, byte_offset, mem_readdata)
        VARIABLE byte_val : STD_LOGIC_VECTOR(7 DOWNTO 0);
        VARIABLE half_val : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        load_data <= (OTHERS => '0');
        byte_val := (OTHERS => '0');
        half_val := (OTHERS => '0');

        IF MemRead = '1' THEN
            CASE funct3 IS
                WHEN "000" =>
                    CASE byte_offset IS
                        WHEN 0 => byte_val := mem_readdata(7 DOWNTO 0);
                        WHEN 1 => byte_val := mem_readdata(15 DOWNTO 8);
                        WHEN 2 => byte_val := mem_readdata(23 DOWNTO 16);
                        WHEN 3 => byte_val := mem_readdata(31 DOWNTO 24);
                        WHEN OTHERS => NULL;
                    END CASE;
                    load_data <= STD_LOGIC_VECTOR(resize(signed(byte_val), 32));

                WHEN "001" =>
                    CASE byte_offset IS
                        WHEN 0 => half_val := mem_readdata(15 DOWNTO 0);
                        WHEN 2 => half_val := mem_readdata(31 DOWNTO 16);
                        WHEN OTHERS => NULL;
                    END CASE;
                    load_data <= STD_LOGIC_VECTOR(resize(signed(half_val), 32));

                WHEN "010" =>
                    load_data <= mem_readdata;

                WHEN "100" =>
                    CASE byte_offset IS
                        WHEN 0 => byte_val := mem_readdata(7 DOWNTO 0);
                        WHEN 1 => byte_val := mem_readdata(15 DOWNTO 8);
                        WHEN 2 => byte_val := mem_readdata(23 DOWNTO 16);
                        WHEN 3 => byte_val := mem_readdata(31 DOWNTO 24);
                        WHEN OTHERS => NULL;
                    END CASE;
                    load_data <= STD_LOGIC_VECTOR(resize(unsigned(byte_val), 32));

                WHEN "101" =>
                    CASE byte_offset IS
                        WHEN 0 => half_val := mem_readdata(15 DOWNTO 0);
                        WHEN 2 => half_val := mem_readdata(31 DOWNTO 16);
                        WHEN OTHERS => NULL;
                    END CASE;
                    load_data <= STD_LOGIC_VECTOR(resize(unsigned(half_val), 32));

                WHEN OTHERS =>
                    load_data <= mem_readdata;
            END CASE;
        END IF;
    END PROCESS;

    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            ALUOutput <= (OTHERS => '0');
            LMD <= (OTHERS => '0');
            IR_out <= (OTHERS => '0');
            NPC_out <= (OTHERS => '0');
            RegWrite_out <= '0';
            MemToReg_out <= '0';
            Jump_out <= '0';
            JumpReg_out <= '0';
            rd_out <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            ALUOutput <= ALUResult;
            LMD <= load_data;
            IR_out <= IR;
            NPC_out <= NPC;
            RegWrite_out <= RegWrite;
            MemToReg_out <= MemToReg;
            Jump_out <= Jump;
            JumpReg_out <= JumpReg;
            rd_out <= rd;
        END IF;
    END PROCESS;

END rtl;