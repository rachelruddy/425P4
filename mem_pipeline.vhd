LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mem_stage IS
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
            address : IN INTEGER RANGE 0 TO 8191;
            memwrite : IN STD_LOGIC;
            memread : IN STD_LOGIC;
            readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            waitrequest : OUT STD_LOGIC
        );
    END COMPONENT;

    CONSTANT MF_BYTE : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    CONSTANT MF_HALF : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
    CONSTANT MF_WORD : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
    CONSTANT MF_BYTE_U : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
    CONSTANT MF_HALF_U : STD_LOGIC_VECTOR(2 DOWNTO 0) := "101";

    SIGNAL word_addr : INTEGER RANGE 0 TO 8191;
    SIGNAL byte_offset : STD_LOGIC_VECTOR(1 DOWNTO 0);

    SIGNAL mem_writedata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_write_en : STD_LOGIC;
    SIGNAL mem_read_en : STD_LOGIC;
    SIGNAL mem_readdata : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mem_waitrequest : STD_LOGIC;

    SIGNAL lmd_comb : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rmw_word : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    word_addr <= TO_INTEGER(UNSIGNED(ALUResult(14 DOWNTO 2)));
    byte_offset <= ALUResult(1 DOWNTO 0);

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
        memwrite => mem_write_en,
        memread => mem_read_en,
        readdata => mem_readdata,
        waitrequest => mem_waitrequest
    );

    mem_read_en <= MemRead;

    PROCESS (MemWrite, MemFunc, B_in, byte_offset, mem_readdata)
    BEGIN
        mem_write_en <= '0';
        mem_writedata <= (OTHERS => '0');
        rmw_word <= mem_readdata;

        IF MemWrite = '1' THEN
            mem_write_en <= '1';

            CASE MemFunc IS

                WHEN MF_BYTE =>
                    rmw_word <= mem_readdata;
                    CASE byte_offset IS
                        WHEN "00" => rmw_word(7 DOWNTO 0) <= B_in(7 DOWNTO 0);
                        WHEN "01" => rmw_word(15 DOWNTO 8) <= B_in(7 DOWNTO 0);
                        WHEN "10" => rmw_word(23 DOWNTO 16) <= B_in(7 DOWNTO 0);
                        WHEN OTHERS => rmw_word(31 DOWNTO 24) <= B_in(7 DOWNTO 0);
                    END CASE;
                    mem_writedata <= rmw_word;

                WHEN MF_HALF =>
                    rmw_word <= mem_readdata;
                    IF byte_offset(1) = '0' THEN
                        rmw_word(15 DOWNTO 0) <= B_in(15 DOWNTO 0);
                    ELSE
                        rmw_word(31 DOWNTO 16) <= B_in(15 DOWNTO 0);
                    END IF;
                    mem_writedata <= rmw_word;

                WHEN OTHERS =>
                    mem_writedata <= B_in;

            END CASE;
        END IF;
    END PROCESS;

    PROCESS (MemRead, MemFunc, mem_readdata, byte_offset)
        VARIABLE raw_byte : STD_LOGIC_VECTOR(7 DOWNTO 0);
        VARIABLE raw_half : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        lmd_comb <= (OTHERS => '0');

        IF MemRead = '1' THEN
            CASE MemFunc IS

                WHEN MF_BYTE =>
                    CASE byte_offset IS
                        WHEN "00" => raw_byte := mem_readdata(7 DOWNTO 0);
                        WHEN "01" => raw_byte := mem_readdata(15 DOWNTO 8);
                        WHEN "10" => raw_byte := mem_readdata(23 DOWNTO 16);
                        WHEN OTHERS => raw_byte := mem_readdata(31 DOWNTO 24);
                    END CASE;
                    lmd_comb <= STD_LOGIC_VECTOR(resize(SIGNED(raw_byte), 32));

                WHEN MF_BYTE_U =>
                    CASE byte_offset IS
                        WHEN "00" => raw_byte := mem_readdata(7 DOWNTO 0);
                        WHEN "01" => raw_byte := mem_readdata(15 DOWNTO 8);
                        WHEN "10" => raw_byte := mem_readdata(23 DOWNTO 16);
                        WHEN OTHERS => raw_byte := mem_readdata(31 DOWNTO 24);
                    END CASE;
                    lmd_comb <= STD_LOGIC_VECTOR(resize(UNSIGNED(raw_byte), 32));

                WHEN MF_HALF =>
                    IF byte_offset(1) = '0' THEN
                        raw_half := mem_readdata(15 DOWNTO 0);
                    ELSE
                        raw_half := mem_readdata(31 DOWNTO 16);
                    END IF;
                    lmd_comb <= STD_LOGIC_VECTOR(resize(SIGNED(raw_half), 32));

                WHEN MF_HALF_U =>
                    IF byte_offset(1) = '0' THEN
                        raw_half := mem_readdata(15 DOWNTO 0);
                    ELSE
                        raw_half := mem_readdata(31 DOWNTO 16);
                    END IF;
                    lmd_comb <= STD_LOGIC_VECTOR(resize(UNSIGNED(raw_half), 32));

                WHEN OTHERS =>
                    lmd_comb <= mem_readdata;

            END CASE;
        END IF;
    END PROCESS;

    pipeline_reg : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                LMD_out <= (OTHERS => '0');
                ALUResult_out <= (OTHERS => '0');
                IR_out <= x"00000013";
                NPC_out <= (OTHERS => '0');
                RegWrite_out <= '0';
                MemToReg_out <= '0';
            ELSE
                LMD_out <= lmd_comb;
                ALUResult_out <= ALUResult;
                IR_out <= IR_in;
                NPC_out <= NPC_in;
                RegWrite_out <= RegWrite;
                MemToReg_out <= MemToReg;
            END IF;
        END IF;
    END PROCESS pipeline_reg;