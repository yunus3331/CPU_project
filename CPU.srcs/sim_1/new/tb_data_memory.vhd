library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_data_memory is
end tb_data_memory;

architecture behavior of tb_data_memory is
    signal clk        : std_logic := '0';
    signal mem_we     : std_logic := '0';
    signal addr       : std_logic_vector(7 downto 0);
    signal write_data : std_logic_vector(7 downto 0);
    signal read_data  : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;
begin
    uut: entity work.data_memory
        port map (
            clk        => clk,
            mem_we     => mem_we,
            addr       => addr,
            write_data => write_data,
            read_data  => read_data
        );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    stim_proc: process
    begin
        mem_we <= '1';
        addr <= x"10";
        write_data <= x"AA";
        wait for clk_period;

        mem_we <= '0';
        wait for 5 ns;

        addr <= x"11";
        wait for 5 ns;

        mem_we <= '1';
        write_data <= x"55";
        wait for clk_period;

        mem_we <= '0';
        addr <= x"10";
        wait for 5 ns;

        addr <= x"11";
        wait for 5 ns;

        wait;
    end process;
end behavior;
