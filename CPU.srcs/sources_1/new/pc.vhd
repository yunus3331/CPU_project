library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    generic (
        ADDR_WIDTH : integer := 8
    );
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        pc_out : out std_logic_vector(ADDR_WIDTH-1 downto 0)
    );
end pc;

architecture rtl of pc is
    signal pc_reg : unsigned(ADDR_WIDTH-1 downto 0);
begin

    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');

        elsif rising_edge(clk) then
            pc_reg <= pc_reg + 1;
        end if;
    end process;

    pc_out <= std_logic_vector(pc_reg);

end rtl;
