library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.math_computer_pkg.all;

entity math_computer_datapath is
    generic (
        DATASIZE : integer := 8
        );
    port (
        clk_i                 : in  std_logic;
        rst_i                 : in  std_logic;
        control_to_datapath_i : in  control_to_datapath_t;
        datapath_to_control_o : out datapath_to_control_t;
        a_i                   : in  std_logic_vector(DATASIZE-1 downto 0);
        b_i                   : in  std_logic_vector(DATASIZE-1 downto 0);
        c_i                   : in  std_logic_vector(DATASIZE-1 downto 0);
        result_o              : out std_logic_vector(DATASIZE-1 downto 0)
        );
end math_computer_datapath;

architecture behave of math_computer_datapath is

    signal reg0_s      : std_logic_vector(DATASIZE-1 downto 0);
    signal reg1_s      : std_logic_vector(DATASIZE-1 downto 0);
    signal reg2_s      : std_logic_vector(DATASIZE-1 downto 0);
    signal reg3_s      : std_logic_vector(DATASIZE-1 downto 0);
    signal next_reg0_s : std_logic_vector(DATASIZE-1 downto 0);
    signal next_reg1_s : std_logic_vector(DATASIZE-1 downto 0);
    signal next_reg2_s : std_logic_vector(DATASIZE-1 downto 0);
    signal next_reg3_s : std_logic_vector(DATASIZE-1 downto 0);

    signal add0_s       : std_logic_vector(DATASIZE-1 downto 0);
    signal sub1_s       : std_logic_vector(DATASIZE-1 downto 0);
    signal mult2_s      : std_logic_vector(DATASIZE-1 downto 0);
    signal mult2_full_s : std_logic_vector(2*DATASIZE-1 downto 0);

begin

    add0_s       <= std_logic_vector(unsigned(reg0_s) + unsigned(reg1_s));
    sub1_s       <= std_logic_vector(unsigned(reg1_s) - unsigned(reg2_s));
    mult2_full_s <= std_logic_vector(unsigned(reg2_s) * unsigned(reg3_s));

    mult2_s <= mult2_full_s(DATASIZE-1 downto 0);

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            reg0_s <= (others => '0');
            reg1_s <= (others => '0');
            reg2_s <= (others => '0');
            reg3_s <= (others => '0');
        elsif rising_edge(clk_i) then
            reg0_s <= next_reg0_s;
            reg1_s <= next_reg1_s;
            reg2_s <= next_reg2_s;
            reg3_s <= next_reg3_s;
        end if;
    end process;

    with control_to_datapath_i.sel_output select result_o <=
        reg0_s when "000",
        reg1_s when "001",
        reg2_s when "010",
        reg3_s when others;

    with control_to_datapath_i.sel0 select next_reg0_s <=
        reg0_s          when "000",
        a_i             when "001",
        b_i             when "010",
        c_i             when "011",
        add0_s          when "100",
        sub1_s          when "101",
        mult2_s         when "110",
        (others => '0') when others;

    with control_to_datapath_i.sel1 select next_reg1_s <=
        reg1_s          when "000",
        a_i             when "001",
        b_i             when "010",
        c_i             when "011",
        add0_s          when "100",
        sub1_s          when "101",
        mult2_s         when "110",
        (others => '0') when others;

    with control_to_datapath_i.sel2 select next_reg2_s <=
        reg2_s          when "000",
        a_i             when "001",
        b_i             when "010",
        c_i             when "011",
        add0_s          when "100",
        sub1_s          when "101",
        mult2_s         when "110",
        (others => '0') when others;


    with control_to_datapath_i.sel3 select next_reg3_s <=
        reg3_s          when "000",
        a_i             when "001",
        b_i             when "010",
        c_i             when "011",
        add0_s          when "100",
        sub1_s          when "101",
        mult2_s         when "110",
        (others => '0') when others;

end behave;
