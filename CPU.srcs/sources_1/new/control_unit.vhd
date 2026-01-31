library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        opcode      : in  std_logic_vector(3 downto 0);
        zero        : in  std_logic;
        pc_en       : out std_logic;
        ir_we       : out std_logic;
        reg_write   : out std_logic;
        mem_we      : out std_logic;
        mem_to_reg  : out std_logic;
        branch      : out std_logic;
        alu_control : out std_logic_vector(3 downto 0)
    );
end control_unit;

architecture rtl of control_unit is

    type state_t is (IFETCH, IDECODE, EXECUTE, MEMACC, WRITEBACK);
    signal state : state_t := IFETCH;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IFETCH;

        elsif rising_edge(clk) then

            pc_en       <= '0';
            ir_we       <= '0';
            reg_write   <= '0';
            mem_we      <= '0';
            mem_to_reg  <= '0';
            branch      <= '0';
            alu_control <= "0000";

            case state is

                when IFETCH =>
                    pc_en <= '1';
                    ir_we <= '1';
                    alu_control <= "0000";
                    state <= IDECODE;

                when IDECODE =>
                    state <= EXECUTE;

                when EXECUTE =>
                    case opcode is
                        when "0000" => alu_control <= "0000"; state <= WRITEBACK;
                        when "0001" => alu_control <= "0001"; state <= WRITEBACK;
                        when "0010" => alu_control <= "0010"; state <= WRITEBACK;
                        when "0011" => alu_control <= "0011"; state <= WRITEBACK;
                        when "0100" => alu_control <= "0100"; state <= WRITEBACK;
                        when "0101" => alu_control <= "0101"; state <= WRITEBACK;
                        when "0110" | "0111" =>
                            alu_control <= "0000";
                            state <= MEMACC;
                        when "1000" =>
                            alu_control <= "0001";
                            branch <= '1';
                            if zero = '1' then
                                pc_en <= '1';
                            end if;
                            state <= IFETCH;
                        when others =>
                            state <= IFETCH;
                    end case;

                when MEMACC =>
                    if opcode = "0110" then
                        state <= WRITEBACK;
                    elsif opcode = "0111" then
                        mem_we <= '1';
                        state <= IFETCH;
                    else
                        state <= IFETCH;
                    end if;

                when WRITEBACK =>
                    reg_write <= '1';
                    if opcode = "0110" then
                        mem_to_reg <= '1';
                    else
                        mem_to_reg <= '0';
                    end if;
                    state <= IFETCH;

            end case;
        end if;
    end process;

end rtl;
