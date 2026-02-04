library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        opcode     : in  std_logic_vector(3 downto 0);

        reg_write  : out std_logic;
        mem_write  : out std_logic;
        mem_to_reg : out std_logic;
        alu_src    : out std_logic;                 -- ? «÷«›Â ‘œ
        alu_ctrl   : out std_logic_vector(3 downto 0);
        store      : out std_logic
    );
end control_unit;

architecture rtl of control_unit is
begin
    process(opcode)
    begin
        -- defaults
        reg_write  <= '0';
        mem_write  <= '0';
        mem_to_reg <= '0';
        alu_src    <= '0';                          -- ? default: reg_data2
        alu_ctrl   <= (others => '0');
        store      <= '0';

        case opcode is

            -- R-type ALU ops
            when "0000" =>  -- ADD
                reg_write <= '1';
                alu_ctrl  <= "0000";

            when "0001" =>  -- SUB
                reg_write <= '1';
                alu_ctrl  <= "0001";

            when "0010" =>  -- AND
                reg_write <= '1';
                alu_ctrl  <= "0010";

            when "0011" =>  -- OR
                reg_write <= '1';
                alu_ctrl  <= "0011";

            when "0100" =>  -- XOR
                reg_write <= '1';
                alu_ctrl  <= "0100";

            when "0101" =>  -- NOT
                reg_write <= '1';
                alu_ctrl  <= "0101";

            -- LOAD
            when "0110" =>
                reg_write  <= '1';
                mem_to_reg <= '1';
                alu_src    <= '1';      -- ? imm for address
                alu_ctrl   <= "0000";

            -- STORE
            when "0111" =>
                mem_write <= '1';
                alu_src   <= '1';       -- ? imm for address
                store     <= '1';
                alu_ctrl  <= "0000";

            when others =>
                null;
        end case;
    end process;
end rtl;
