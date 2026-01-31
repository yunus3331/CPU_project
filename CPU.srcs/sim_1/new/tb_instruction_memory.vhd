library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_instruction_memory is
end tb_instruction_memory;

architecture behavior of tb_instruction_memory is

    signal addr        : std_logic_vector(7 downto 0);
    signal instruction : std_logic_vector(15 downto 0);

begin

    uut: entity work.instruction_memory
        port map (
            addr        => addr,
            instruction => instruction
        );

    process
    begin
        addr <= x"00"; wait for 10 ns;
        addr <= x"01"; wait for 10 ns;
        addr <= x"02"; wait for 10 ns;
        addr <= x"03"; wait for 10 ns;
        addr <= x"04"; wait for 10 ns;
        wait;
    end process;

end behavior;
