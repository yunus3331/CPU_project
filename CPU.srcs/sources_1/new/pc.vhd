library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        pc_en   : in  std_logic;
        pc_next : in  std_logic_vector(7 downto 0);
        pc_out  : out std_logic_vector(7 downto 0)
    );
end pc;

architecture rtl of pc is
    signal pc_reg : std_logic_vector(7 downto 0);
begin

    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            if pc_en = '1' then
                pc_reg <= pc_next;
            end if;
        end if;
    end process;

    pc_out <= pc_reg;

end rtl;
