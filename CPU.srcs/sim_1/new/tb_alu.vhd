library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu is
end entity;

architecture behavior of tb_alu is

    constant DATA_WIDTH : integer := 8;

    signal A, B      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ALUcontrol: std_logic_vector(3 downto 0);
    signal Result    : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal Zero      : std_logic;

begin

    -- Instantiate ALU
    uut: entity work.alu
        generic map (
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            A => A,
            B => B,
            ALUcontrol => ALUcontrol,
            Result => Result,
            Zero => Zero
        );

    -- Stimulus process
    stim_proc: process
    begin
        report "Starting ALU testbench..." severity note;

        -- =====================
        -- ADD test: 5 + 3 = 8
        -- =====================
        A <= std_logic_vector(to_signed(5, DATA_WIDTH));
        B <= std_logic_vector(to_signed(3, DATA_WIDTH));
        ALUcontrol <= "0000"; -- ADD
        wait for 10 ns;
        report "ADD: 5 + 3 = " & integer'image(to_integer(signed(Result))) severity note;

        -- =====================
        -- SUB test: 5 - 3 = 2
        -- =====================
        ALUcontrol <= "0001"; -- SUB
        wait for 10 ns;
        report "SUB: 5 - 3 = " & integer'image(to_integer(signed(Result))) severity note;

        -- =====================
        -- AND test: 5 AND 3 = 1
        -- =====================
        ALUcontrol <= "0010"; -- AND
        wait for 10 ns;
        report "AND: 5 & 3 = " & integer'image(to_integer(unsigned(Result))) severity note;

        -- =====================
        -- OR test: 5 OR 3 = 7
        -- =====================
        ALUcontrol <= "0011"; -- OR
        wait for 10 ns;
        report "OR: 5 | 3 = " & integer'image(to_integer(unsigned(Result))) severity note;

        -- =====================
        -- XOR test: 5 XOR 3 = 6
        -- =====================
        ALUcontrol <= "0100"; -- XOR
        wait for 10 ns;
        report "XOR: 5 xor 3 = " & integer'image(to_integer(unsigned(Result))) severity note;

        -- =====================
        -- NOT test: NOT 5
        -- =====================
        ALUcontrol <= "0101"; -- NOT
        wait for 10 ns;
        report "NOT: ~5 = " & integer'image(to_integer(unsigned(Result))) severity note;

        -- =====================
        -- Zero flag test: 3 - 3 = 0
        -- =====================
        A <= std_logic_vector(to_signed(3, DATA_WIDTH));
        B <= std_logic_vector(to_signed(3, DATA_WIDTH));
        ALUcontrol <= "0001"; -- SUB
        wait for 10 ns;
        report "ZERO TEST: 3 - 3 = " & integer'image(to_integer(signed(Result))) &
               " | Zero flag = " & std_logic'image(Zero) severity note;

        report "ALU testbench finished." severity note;
        wait;
    end process;

end architecture;
