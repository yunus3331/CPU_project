library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    generic (
        DATA_WIDTH : integer := 8
    );
    port (
        A          : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        B          : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        ALUcontrol : in  std_logic_vector(3 downto 0);
        Result     : out std_logic_vector(DATA_WIDTH-1 downto 0);
        Zero       : out std_logic
    );
end alu;

architecture Behavioral of alu is
    signal result_int : std_logic_vector(DATA_WIDTH-1 downto 0);
begin

    process(A,B,ALUcontrol)
    begin

        result_int <= (others => '0');

        case ALUcontrol is
            when "0000" =>
                result_int <= std_logic_vector(signed(A) + signed(B));
            when "0001" =>
                result_int <= std_logic_vector(signed(A) - signed(B));
            when "0010" =>
                result_int <= A and B;
            when "0011" =>
                result_int <= A or B;
            when "0100" =>
                result_int <= A xor B;
            when "0101" =>
                result_int <= not A;
            when others =>
                result_int <= (others => '0');
        end case;
    end process;

    Result <= result_int;
    Zero   <= '1' when unsigned(result_int) = 0 else '0';


end Behavioral;