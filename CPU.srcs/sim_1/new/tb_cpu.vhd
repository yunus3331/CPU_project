library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cpu is
end tb_cpu;

architecture behavior of tb_cpu is

    ----------------------------------------------------------------
    -- Constants („ÿ«»ﬁ ÿ—«Õ?  Ê)
    ----------------------------------------------------------------
    constant DATA_WIDTH     : integer := 8;   -- CPU 8-bit
    constant ADDR_WIDTH     : integer := 8;   -- PC / memory address
    constant REG_ADDR_WIDTH : integer := 4;   -- 16 registers

    constant CLK_PERIOD : time := 10 ns;

    ----------------------------------------------------------------
    -- Signals
    ----------------------------------------------------------------
    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

begin

    ----------------------------------------------------------------
    -- Clock generation
    ----------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    ----------------------------------------------------------------
    -- DUT (CPU instance)
    ----------------------------------------------------------------
    dut : entity work.cpu
        generic map (
            DATA_WIDTH     => DATA_WIDTH,
            ADDR_WIDTH     => ADDR_WIDTH,
            REG_ADDR_WIDTH => REG_ADDR_WIDTH
        )
        port map (
            clk   => clk,
            reset => reset
        );

    ----------------------------------------------------------------
    -- Stimulus process
    ----------------------------------------------------------------
    stim_proc : process
    begin
        ----------------------------------------------------------------
        -- Reset
        ----------------------------------------------------------------
        reset <= '1';
        wait for 2 * CLK_PERIOD;

        reset <= '0';
        wait for 20 * CLK_PERIOD;

        ----------------------------------------------------------------
        -- Let CPU run
        ----------------------------------------------------------------
        wait;
    end process;

end behavior;
