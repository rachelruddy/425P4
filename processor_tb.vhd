-- =============================================================================
-- processor_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor Testbench
-- =============================================================================
-- This testbench:
--   1. Instantiates the processor (processor.vhd)
--   2. Reads program.txt and loads it into instruction memory word by word
--      by driving the memory bus interface before releasing reset
--   3. Releases reset and lets the processor run for 10,000 clock cycles
--   4. Dumps data memory contents  -> memory.txt        (8192 lines)
--   5. Dumps register file contents -> register_file.txt (32 lines)
--
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- For file I/O
use std.textio.all;
use ieee.std_logic_textio.all;

entity processor_tb is
end processor_tb;

architecture behavior of processor_tb is

    -- -------------------------------------------------------------------------
    -- Constants
    -- -------------------------------------------------------------------------
    constant CLK_PERIOD  : time    := 1 ns;   -- 1 GHz clock
    constant NUM_CYCLES  : integer := 10000;  -- simulation length
    constant MEM_WORDS   : integer := 8192;   -- data memory words (32768 bytes / 4)
    constant NUM_REGS    : integer := 32;     -- number of registers

    -- -------------------------------------------------------------------------
    -- Component declarations
    -- -------------------------------------------------------------------------

    -- Top-level processor
    component processor is
        port(
            clk   : in std_logic;
            reset : in std_logic
        );
    end component;

    -- Memory component (used to instantiate instruction + data memories
    -- separately if they are not already inside processor.vhd)
    component memory is
        generic(
            ram_size     : integer := 8192;
            mem_delay    : time    := 1 ns;
            clock_period : time    := 1 ns
        );
        port(
            clock       : in  std_logic;
            writedata   : in  std_logic_vector(31 downto 0);
            address     : in  integer range 0 to 8191;
            memwrite    : in  std_logic;
            memread     : in  std_logic;
            readdata    : out std_logic_vector(31 downto 0);
            waitrequest : out std_logic
        );
    end component;

    -- -------------------------------------------------------------------------
    -- Signals for the processor
    -- -------------------------------------------------------------------------
    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';  -- start in reset

    -- -------------------------------------------------------------------------
    -- Signals for instruction memory bus (used during program loading)
    -- -------------------------------------------------------------------------
    signal imem_writedata   : std_logic_vector(31 downto 0) := (others => '0');
    signal imem_address     : integer range 0 to 8191       := 0;
    signal imem_memwrite    : std_logic                     := '0';
    signal imem_memread     : std_logic                     := '0';
    signal imem_readdata    : std_logic_vector(31 downto 0);
    signal imem_waitrequest : std_logic;

    -- -------------------------------------------------------------------------
    -- Signals for data memory bus (used during output dumping)
    -- -------------------------------------------------------------------------
    signal dmem_writedata   : std_logic_vector(31 downto 0) := (others => '0');
    signal dmem_address     : integer range 0 to 8191       := 0;
    signal dmem_memwrite    : std_logic                     := '0';
    signal dmem_memread     : std_logic                     := '1';
    signal dmem_readdata    : std_logic_vector(31 downto 0);
    signal dmem_waitrequest : std_logic;

    -- -------------------------------------------------------------------------
    -- Internal helpers
    -- -------------------------------------------------------------------------
    signal sim_done : boolean := false;

begin

    -- -------------------------------------------------------------------------
    -- Instantiate the processor
    -- -------------------------------------------------------------------------

    uut : processor
        port map(
            clk   => clk,
            reset => reset
        );

    -- -------------------------------------------------------------------------
    -- Instantiate instruction memory
    -- -------------------------------------------------------------------------
    instr_mem : memory
        generic map(
            ram_size     => 8192,
            mem_delay    => 1 ns,
            clock_period => 1 ns
        )
        port map(
            clock       => clk,
            writedata   => imem_writedata,
            address     => imem_address,
            memwrite    => imem_memwrite,
            memread     => imem_memread,
            readdata    => imem_readdata,
            waitrequest => imem_waitrequest
        );

    -- -------------------------------------------------------------------------
    -- Instantiate data memory
    -- -------------------------------------------------------------------------
    data_mem : memory
        generic map(
            ram_size     => 8192,
            mem_delay    => 1 ns,
            clock_period => 1 ns
        )
        port map(
            clock       => clk,
            writedata   => dmem_writedata,
            address     => dmem_address,
            memwrite    => dmem_memwrite,
            memread     => dmem_memread,
            readdata    => dmem_readdata,
            waitrequest => dmem_waitrequest
        );

    -- -------------------------------------------------------------------------
    -- Clock generation: 1 GHz (1 ns period, 0.5 ns high / 0.5 ns low)
    -- -------------------------------------------------------------------------
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
    -- Main simulation process
    -- -------------------------------------------------------------------------
    main_process : process

        -- File handles
        file     program_file  : text;
        file     mem_file      : text;
        file     reg_file      : text;

        -- Line buffers
        variable prog_line     : line;
        variable out_line      : line;

        -- Temp storage
        variable instr_bits    : std_logic_vector(31 downto 0);
        variable word_addr     : integer := 0;
        variable cycle_count   : integer := 0;

        -- For reading register file via examine (see note below)
        -- ADAPT: If your register file is not accessible via the memory
        --        interface, you may need to read it differently.
        --        One approach: add a debug read port to register_file.vhd.

    begin

   
        reset <= '1';
        wait for CLK_PERIOD * 2;

        file_open(program_file, "program.txt", read_mode);
        word_addr := 0;

        while not endfile(program_file) loop
            readline(program_file, prog_line);

            -- Skip blank lines
            if prog_line'length = 0 then
                next;
            end if;

            -- Read 32-bit binary instruction from the line
            read(prog_line, instr_bits);

            -- Drive the instruction memory write interface
            imem_address   <= word_addr;
            imem_writedata <= instr_bits;
            imem_memwrite  <= '1';
            imem_memread   <= '0';

            -- Wait for memory to acknowledge (waitrequest goes low)
            wait until falling_edge(imem_waitrequest);
            wait for CLK_PERIOD;

            imem_memwrite <= '0';
            word_addr     := word_addr + 1;
        end loop;

        file_close(program_file);

        -- Stop driving instruction memory
        imem_memwrite <= '0';
        imem_memread  <= '0';

        -- ---------------------------------------------------------------------
        -- Release reset and run for 10,000 clock cycles
        -- ---------------------------------------------------------------------
        reset <= '0';

        for i in 1 to NUM_CYCLES loop
            wait for CLK_PERIOD;
        end loop;

        -- ---------------------------------------------------------------------
        --  Dump data memory -> memory.txt
        -- ---------------------------------------------------------------------
        file_open(mem_file, "memory.txt", write_mode);

        for i in 0 to MEM_WORDS - 1 loop
            -- Drive read address on data memory bus
            dmem_address  <= i;
            dmem_memread  <= '1';
            dmem_memwrite <= '0';

            -- Wait for data to be ready
            wait until falling_edge(dmem_waitrequest);
            wait for CLK_PERIOD;

            -- Write the word as a binary string
            write(out_line, dmem_readdata);
            writeline(mem_file, out_line);
        end loop;

        dmem_memread <= '0';
        file_close(mem_file);

        -- ---------------------------------------------------------------------
        -- This may need to be changed based on how the register file is implemented.
        -- ---------------------------------------------------------------------
        file_open(reg_file, "register_file.txt", write_mode);

        for i in 0 to NUM_REGS - 1 loop
            -- Currently just writing zeros since we don't have a way to read the register file, but .tcl should be able to read it via examine and write to a file.
            write(out_line, std_logic_vector(to_unsigned(0, 32)));
            writeline(reg_file, out_line);
        end loop;

        file_close(reg_file);

        -- ---------------------------------------------------------------------
        -- End simulation
        -- ---------------------------------------------------------------------
        sim_done <= true;
        report "Simulation complete. Output written to memory.txt and register_file.txt.";
        wait;

    end process;

end behavior;