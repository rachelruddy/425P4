-- =============================================================================
-- processor_tb.vhd
-- ECSE 425 - Pipelined RISC-V Processor
-- =============================================================================
-- Minimal testbench — only handles clock and reset.
-- Everything else (program loading, memory dump, register dump) is done
-- in testbench.tcl.
-- =============================================================================

library ieee;
use ieee.std_logic_1164.all;

entity processor_tb is
end processor_tb;

architecture behavior of processor_tb is

    component processor is
        port(
            clk   : in std_logic;
            reset : in std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

begin

    -- Instantiate processor
    uut : processor
        port map(
            clk   => clk,
            reset => reset
        );

    -- Clock generation: 1 GHz (1 ns period)
    clk <= not clk after 0.5 ns;

end behavior;
