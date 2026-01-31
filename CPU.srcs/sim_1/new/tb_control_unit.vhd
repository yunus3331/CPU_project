library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_control_unit is
end tb_control_unit;

architecture behavior of tb_control_unit is

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal opcode      : std_logic_vector(3 downto 0) := (others => '0');
    signal zero        : std_logic := '0';
    signal pc_en       : std_logic;
    signal ir_we       : std_logic;
    signal reg_write   : std_logic;
    signal mem_we      : std_logic;
    signal mem_to_reg  : std_logic;
    signal branch      : std_logic;
    signal alu_control : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: entity work.control_unit
        port map (
            clk         => clk,
            reset       => reset,
            opcode      => opcode,
            zero        => zero,
            pc_en       => pc_en,
            ir_we       => ir_we,
            reg_write   => reg_write,
            mem_we      => mem_we,
            mem_to_reg  => mem_to_reg,
            branch      => branch,
            alu_control => alu_control
        );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc : process
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        opcode <= "0000";
        wait for 50 ns;

        opcode <= "0110";
        wait for 50 ns;

        opcode <= "0111";
        wait for 50 ns;

        opcode <= "1000";
        zero <= '1';
        wait for 30 ns;

        zero <= '0';
        wait for 50 ns;

        wait;
    end process;

end behavior;
