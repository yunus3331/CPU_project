library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pc is
end tb_pc;

architecture behavior of tb_pc is

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal pc_en   : std_logic := '0';
    signal pc_next : std_logic_vector(7 downto 0);
    signal pc_out  : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instantiate PC
    uut: entity work.pc
        port map (
            clk     => clk,
            reset   => reset,
            pc_en   => pc_en,
            pc_next => pc_next,
            pc_out  => pc_out
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process
    stim_proc: process
    begin
        -- Reset
        reset <= '1';
        pc_en <= '0';
        pc_next <= x"00";
        wait for 20 ns;

        reset <= '0';

        -- PC = 1
        pc_en <= '1';
        pc_next <= x"01";
        wait for clk_period;

        -- PC = 2
        pc_next <= x"02";
        wait for clk_period;

        -- Disable PC (should stay at 2)
        pc_en <= '0';
        pc_next <= x"05";
        wait for clk_period;

        -- Enable again (PC = 3)
        pc_en <= '1';
        pc_next <= x"03";
        wait for clk_period;

        wait;
    end process;

end behavior;
