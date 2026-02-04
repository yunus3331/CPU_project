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
    type mem_t is array (0 to 255) of std_logic_vector(15 downto 0);
    signal mem : mem_t := (
        
        0  => "0110000100000000",
        
        1  => "0110001000000001",
        
        2  => "0000001100010010",
        
        3  => "0001010000010010",
        
        4  => "0011010100110100",
        
        5  => "0010011001010010",
        
        6  => "0100011101010100",
        
        7  => "0101100001110000",
        
        8  => "0111100000000010",
        
        9  => "0110100100000010",
        
        10 => "0001101010010101",
        
        11 => "0111101000000100",
        
        others => (others => '0')
    );
begin
    instruction <= mem(to_integer(unsigned(addr)));
end rtl;
