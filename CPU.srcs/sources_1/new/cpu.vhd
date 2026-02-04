library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    generic (
        DATA_WIDTH     : integer := 8;
        ADDR_WIDTH     : integer := 8;
        REG_ADDR_WIDTH : integer := 4   -- 16 registers
    );
    port (
        clk   : in std_logic;
        reset : in std_logic
    );
end cpu;

architecture rtl of cpu is

    -- =====================
    -- PC
    -- =====================
    signal pc_out : std_logic_vector(ADDR_WIDTH-1 downto 0);

    -- =====================
    -- Instruction
    -- =====================
    signal instr  : std_logic_vector(15 downto 0);

    -- =====================
    -- Decode (ISA fixed 4-bit fields)
    -- =====================
    signal opcode : std_logic_vector(3 downto 0);
    signal rd_i   : std_logic_vector(3 downto 0);
    signal rs_i   : std_logic_vector(3 downto 0);
    signal rt_i   : std_logic_vector(3 downto 0);

    signal rd     : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal rs     : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);
    signal rt     : std_logic_vector(REG_ADDR_WIDTH-1 downto 0);

    -- =====================
    -- Register File
    -- =====================
    signal reg_data1 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal reg_data2 : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- =====================
    -- Immediate
    -- =====================
    signal imm_ext : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- =====================
    -- ALU
    -- =====================
    signal alu_b      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal alu_result : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal alu_zero   : std_logic;

    -- =====================
    -- Memory
    -- =====================
    signal mem_data : std_logic_vector(DATA_WIDTH-1 downto 0);

    -- =====================
    -- Control
    -- =====================
    signal reg_write  : std_logic;
    signal mem_write  : std_logic;
    signal mem_to_reg : std_logic;
    signal alu_src    : std_logic;
    signal alu_ctrl   : std_logic_vector(3 downto 0);
    signal store      : std_logic;

    -- =====================
    -- Write Back
    -- =====================
    signal wb_data : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

    -- =====================
    -- PC
    -- =====================
    pc_inst : entity work.pc
        generic map (
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk    => clk,
            reset  => reset,
            pc_out => pc_out
        );

    -- =====================
    -- Instruction Memory (combinational)
    -- =====================
    imem_inst : entity work.instruction_memory
        port map (
            addr        => pc_out,
            instruction => instr
        );

    -- =====================
    -- Decode
    -- =====================
    opcode <= instr(15 downto 12);

    -- ? STORE has different field roles
    -- STORE:  rs = base , rt = data
    -- others: rs, rt normal
    rd_i <= instr(11 downto 8);

    rs_i <= instr(7 downto 4);
    rt_i <= instr(11 downto 8)  when store = '1' else instr(3 downto 0);

    rd <= rd_i(REG_ADDR_WIDTH-1 downto 0);
    rs <= rs_i(REG_ADDR_WIDTH-1 downto 0);
    rt <= rt_i(REG_ADDR_WIDTH-1 downto 0);

    -- =====================
    -- Immediate Extend (zero-extend)
    -- =====================
    imm_ext <= std_logic_vector(
                   resize(unsigned(instr(3 downto 0)), DATA_WIDTH)
               );

    -- =====================
    -- Control Unit (single-cycle, combinational)
    -- =====================
    cu_inst : entity work.control_unit
        port map (
            opcode     => opcode,
            reg_write  => reg_write,
            mem_write  => mem_write,
            mem_to_reg => mem_to_reg,
            alu_src    => alu_src,
            alu_ctrl   => alu_ctrl,
            store      => store
        );

    -- =====================
    -- Register File
    -- =====================
    rf_inst : entity work.register_file
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            REG_COUNT  => 2**REG_ADDR_WIDTH
        )
        port map (
            clk        => clk,
            reset      => reset,
            read_addr1 => rs,
            read_addr2 => rt,
            read_data1 => reg_data1,
            read_data2 => reg_data2,
            write_addr => rd,
            write_data => wb_data,
            reg_write  => reg_write
        );

    -- =====================
    -- ALU B-input MUX
    -- =====================
    alu_b <= imm_ext when alu_src = '1' else reg_data2;

    -- =====================
    -- ALU
    -- =====================
    alu_inst : entity work.alu
        generic map (
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            A          => reg_data1,
            B          => alu_b,
            ALUcontrol => alu_ctrl,
            Result     => alu_result,
            Zero       => alu_zero
        );

    -- =====================
    -- Data Memory
    -- =====================
    dmem_inst : entity work.data_memory
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk        => clk,
            mem_we     => mem_write,
            addr       => alu_result(ADDR_WIDTH-1 downto 0), -- rs + imm
            write_data => reg_data2,   -- ? correct STORE value
            read_data  => mem_data
        );

    -- =====================
    -- Write Back
    -- =====================
    wb_data <= mem_data when mem_to_reg = '1' else alu_result;

end rtl;
