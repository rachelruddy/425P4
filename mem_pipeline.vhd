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

    -- address inside memory
    SIGNAL word_address : INTEGER RANGE 0 TO 8191;

    -- which byte inside the 32-bit word (0 to 3)
    SIGNAL byte_select : INTEGER RANGE 0 TO 3;

    SIGNAL data_to_memory : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data_from_memory : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memory_wait : STD_LOGIC;

    SIGNAL current_word : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL loaded_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL store_value : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL instruction_type : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL destination_reg : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

    instruction_type <= IR(14 DOWNTO 12);
    destination_reg <= IR(11 DOWNTO 7);

    word_address <= to_integer(unsigned(ALUResult(14 DOWNTO 2)));
    byte_select <= to_integer(unsigned(ALUResult(1 DOWNTO 0)));

    current_word <= data_from_memory;

    PROCESS (MemWrite, instruction_type, byte_select, B, current_word)
    BEGIN
        store_value <= B;

        IF MemWrite = '1' THEN
            CASE instruction_type IS

                WHEN "000" =>
                    store_value <= current_word;

                    CASE byte_select IS
                        WHEN 0 => store_value(7 DOWNTO 0) <= B(7 DOWNTO 0);
                        WHEN 1 => store_value(15 DOWNTO 8) <= B(7 DOWNTO 0);
                        WHEN 2 => store_value(23 DOWNTO 16) <= B(7 DOWNTO 0);
                        WHEN 3 => store_value(31 DOWNTO 24) <= B(7 DOWNTO 0);
                        WHEN OTHERS => NULL;
                    END CASE;

                WHEN "001" =>
                    store_value <= current_word;

                    CASE byte_select IS
                        WHEN 0 => store_value(15 DOWNTO 0) <= B(15 DOWNTO 0);
                        WHEN 2 => store_value(31 DOWNTO 16) <= B(15 DOWNTO 0);
                        WHEN OTHERS => NULL;
                    END CASE;

                WHEN "010" =>
                    store_value <= B;

                WHEN OTHERS =>
                    store_value <= B;

            END CASE;
        END IF;
    END PROCESS;

    data_to_memory <= store_value;

    data_mem : memory
    GENERIC MAP(
        ram_size => 8192,
        mem_delay => 1 ns,
        clock_period => 1 ns
    )
    PORT MAP(
        clock => clk,
        writedata => data_to_memory,
        address => word_address,
        memwrite => MemWrite,
        memread => MemRead,
        readdata => data_from_memory,
        waitrequest => memory_wait
    );

    PROCESS (MemRead, instruction_type, byte_select, data_from_memory)
        VARIABLE byte_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
        VARIABLE half_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        loaded_value <= (OTHERS => '0');
        byte_data := (OTHERS => '0');
        half_data := (OTHERS => '0');

        IF MemRead = '1' THEN
            CASE instruction_type IS

                WHEN "000" =>
                    CASE byte_select IS
                        WHEN 0 => byte_data := data_from_memory(7 DOWNTO 0);
                        WHEN 1 => byte_data := data_from_memory(15 DOWNTO 8);
                        WHEN 2 => byte_data := data_from_memory(23 DOWNTO 16);
                        WHEN 3 => byte_data := data_from_memory(31 DOWNTO 24);
                        WHEN OTHERS => NULL;
                    END CASE;

                    loaded_value <= STD_LOGIC_VECTOR(resize(signed(byte_data), 32));

                WHEN "001" =>
                    CASE byte_select IS
                        WHEN 0 => half_data := data_from_memory(15 DOWNTO 0);
                        WHEN 2 => half_data := data_from_memory(31 DOWNTO 16);
                        WHEN OTHERS => NULL;
                    END CASE;

                    loaded_value <= STD_LOGIC_VECTOR(resize(signed(half_data), 32));

                WHEN "010" =>
                    loaded_value <= data_from_memory;

                WHEN "100" =>
                    CASE byte_select IS
                        WHEN 0 => byte_data := data_from_memory(7 DOWNTO 0);
                        WHEN 1 => byte_data := data_from_memory(15 DOWNTO 8);
                        WHEN 2 => byte_data := data_from_memory(23 DOWNTO 16);
                        WHEN 3 => byte_data := data_from_memory(31 DOWNTO 24);
                        WHEN OTHERS => NULL;
                    END CASE;

                    loaded_value <= STD_LOGIC_VECTOR(resize(unsigned(byte_data), 32));

                WHEN "101" =>
                    CASE byte_select IS
                        WHEN 0 => half_data := data_from_memory(15 DOWNTO 0);
                        WHEN 2 => half_data := data_from_memory(31 DOWNTO 16);
                        WHEN OTHERS => NULL;
                    END CASE;

                    loaded_value <= STD_LOGIC_VECTOR(resize(unsigned(half_data), 32));

                WHEN OTHERS =>
                    loaded_value <= data_from_memory;

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
            LMD <= loaded_value;
            IR_out <= IR;
            NPC_out <= NPC;
            RegWrite_out <= RegWrite;
            MemToReg_out <= MemToReg;
            Jump_out <= Jump;
            JumpReg_out <= JumpReg;
            rd_out <= destination_reg;
        END IF;
    END PROCESS;

END rtl;