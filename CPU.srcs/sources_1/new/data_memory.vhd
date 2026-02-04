library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
    generic (
        DATA_WIDTH : integer := 8;
        ADDR_WIDTH : integer := 8          -- 2^8 = 256
    );
    port (
        clk        : in  std_logic;
        mem_we     : in  std_logic;
        addr       : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        write_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        read_data  : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end data_memory;

architecture rtl of data_memory is

    constant MEM_DEPTH : integer := 2**ADDR_WIDTH;

    type mem_t is array (0 to MEM_DEPTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);

    signal mem : mem_t := (
        0 => std_logic_vector(to_unsigned(5, DATA_WIDTH)),
        1 => std_logic_vector(to_unsigned(3, DATA_WIDTH)),
        others => (others => '0')
    );

begin

    -- synchronous write
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_we = '1' then
                mem(to_integer(unsigned(addr))) <= write_data;
            end if;
        end if;
    end process;

    -- asynchronous read
    read_data <= mem(to_integer(unsigned(addr)));

end rtl;
