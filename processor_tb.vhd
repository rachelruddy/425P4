-- =============================================================================
-- processor_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- =============================================================================
-- Minimal testbench — only handles clock and reset.
-- Everything else (program loading, memory dump, register dump) is done
-- in testbench.tcl.
-- =============================================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY processor_tb IS
END processor_tb;

ARCHITECTURE behavior OF processor_tb IS

    COMPONENT processor IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '1';

BEGIN

    -- Instantiate processor
    uut : processor
    PORT MAP(
        clk => clk,
        reset => reset
    );

    -- Clock generation: 1 GHz (1 ns period)
    clk <= NOT clk AFTER 0.5 ns;

END behavior;