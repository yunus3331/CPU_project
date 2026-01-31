library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_memory is
    port (
        addr        : in  std_logic_vector(7 downto 0);
        instruction : out std_logic_vector(15 downto 0)
    );
end instruction_memory;

architecture rtl of instruction_memory is

    type rom_t is array (0 to 255) of std_logic_vector(15 downto 0);

    constant ROM : rom_t := (
        0 => x"1123",
        1 => x"2456",
        2 => x"3789",
        3 => x"4000",
        others => x"0000"
    );

begin

    instruction <= ROM(to_integer(unsigned(addr)));

end rtl;
