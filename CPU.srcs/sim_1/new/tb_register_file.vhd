library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_register_file is
end tb_register_file;

architecture behavior of tb_register_file is

    constant DATA_WIDTH : integer := 8;

    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';

    signal read_addr1 : std_logic_vector(3 downto 0);
    signal read_addr2 : std_logic_vector(3 downto 0);
    signal read_data1 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal read_data2 : std_logic_vector(DATA_WIDTH-1 downto 0);

    signal write_addr : std_logic_vector(3 downto 0);
    signal write_data : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal reg_write  : std_logic;

begin

    uut: entity work.register_file
        port map (
            clk        => clk,
            reset      => reset,
            read_addr1 => read_addr1,
            read_addr2 => read_addr2,
            read_data1 => read_data1,
            read_data2 => read_data2,
            write_addr => write_addr,
            write_data => write_data,
            reg_write  => reg_write
        );

    clk <= not clk after 5 ns;

    stim_proc: process
    begin
        reset <= '1';
        reg_write <= '0';
        wait for 10 ns;

        reset <= '0';

        write_addr <= "0001";
        write_data <= x"55";
        reg_write  <= '1';
        wait for 10 ns;

        reg_write <= '0';

        read_addr1 <= "0001";
        read_addr2 <= "0000";
        wait for 10 ns;

        write_addr <= "0000";
        write_data <= x"FF";
        reg_write  <= '1';
        wait for 10 ns;

        reg_write <= '0';

        read_addr1 <= "0000";
        read_addr2 <= "0001";
        wait for 10 ns;

        wait;
    end process;

end behavior;
