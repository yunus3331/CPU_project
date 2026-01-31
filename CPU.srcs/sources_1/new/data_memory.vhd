library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
    port (
        clk        : in  std_logic;
        mem_we     : in  std_logic;
        addr       : in  std_logic_vector(7 downto 0);
        write_data : in  std_logic_vector(7 downto 0);
        read_data  : out std_logic_vector(7 downto 0)
    );
end data_memory;

architecture rtl of data_memory is
    type ram_t is array (0 to 255) of std_logic_vector(7 downto 0);
    signal ram : ram_t := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_we = '1' then
                ram(to_integer(unsigned(addr))) <= write_data;
            end if;
        end if;
    end process;

    read_data <= ram(to_integer(unsigned(addr)));
end rtl;
