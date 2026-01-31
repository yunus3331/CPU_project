library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    generic (
        DATA_WIDTH : integer := 8;
        REG_COUNT  : integer := 16
    );
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;

        read_addr1 : in  std_logic_vector(3 downto 0);
        read_addr2 : in  std_logic_vector(3 downto 0);
        read_data1 : out std_logic_vector(DATA_WIDTH-1 downto 0);
        read_data2 : out std_logic_vector(DATA_WIDTH-1 downto 0);

        write_addr : in  std_logic_vector(3 downto 0);
        write_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        reg_write  : in  std_logic
    );
end register_file;

architecture rtl of register_file is

    type reg_array_t is array (0 to REG_COUNT-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);

    signal reg_array : reg_array_t := (others => (others => '0'));

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                reg_array <= (others => (others => '0'));
            else
                if reg_write = '1' then
                    if unsigned(write_addr) /= 0 then
                        reg_array(to_integer(unsigned(write_addr))) <= write_data;
                    end if;
                end if;
            end if;
        end if;
    end process;

    read_data1 <= (others => '0') when unsigned(read_addr1) = 0 else
                  reg_array(to_integer(unsigned(read_addr1)));

    read_data2 <= (others => '0') when unsigned(read_addr2) = 0 else
                  reg_array(to_integer(unsigned(read_addr2)));

end rtl;
