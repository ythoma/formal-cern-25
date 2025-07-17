library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_computer_pkg.all;

entity math_computer is
    generic (
        DATASIZE : integer := 8
        );
    port (
        clk_i            : in  std_logic;
        rst_i            : in  std_logic;
        input_itf_in_i   : in  math_input_itf_in_t;
        input_itf_out_o  : out math_input_itf_out_t;
        output_itf_in_i  : in  math_output_itf_in_t;
        output_itf_out_o : out math_output_itf_out_t
        );
end math_computer;

architecture struct of math_computer is


    component math_computer_control is
        port (
            clk_i                 : in  std_logic;
            rst_i                 : in  std_logic;
            control_to_datapath_o : out control_to_datapath_t;
            datapath_to_control_i : in  datapath_to_control_t;
            start_i               : in  std_logic;
            ready_i               : in  std_logic;
            valid_o               : out std_logic;
            ready_o               : out std_logic
            );
    end component;


    component math_computer_datapath is
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
    end component;

    signal control_to_datapath_s : control_to_datapath_t;
    signal datapath_to_control_s : datapath_to_control_t;

    signal a_s      : std_logic_vector(DATASIZE-1 downto 0);
    signal b_s      : std_logic_vector(DATASIZE-1 downto 0);
    signal c_s      : std_logic_vector(DATASIZE-1 downto 0);
    signal result_s : std_logic_vector(DATASIZE-1 downto 0);

begin

    a_s                     <= input_itf_in_i.a;
    b_s                     <= input_itf_in_i.b;
    c_s                     <= input_itf_in_i.c;
    output_itf_out_o.result <= result_s;

    assert input_itf_in_i.a'length = DATASIZE report "SIZE" severity error;
    assert input_itf_in_i.b'length = DATASIZE report "SIZE" severity error;
    assert input_itf_in_i.c'length = DATASIZE report "SIZE" severity error;
    assert output_itf_out_o.result'length = DATASIZE report "SIZE" severity error;

    control : math_computer_control
        port map(
            clk_i                 => clk_i,
            rst_i                 => rst_i,
            control_to_datapath_o => control_to_datapath_s,
            datapath_to_control_i => datapath_to_control_s,
            start_i               => input_itf_in_i.valid,
            ready_i               => output_itf_in_i.ready,
            valid_o               => output_itf_out_o.valid,
            ready_o               => input_itf_out_o.ready
            );

    datapath : math_computer_datapath
        generic map(DATASIZE => DATASIZE)
        port map(
            clk_i                 => clk_i,
            rst_i                 => rst_i,
            control_to_datapath_i => control_to_datapath_s,
            datapath_to_control_o => datapath_to_control_s,
            a_i                   => a_s,      --input_itf_in_i.a,
            b_i                   => b_s,      --input_itf_in_i.b,
            c_i                   => c_s,      --input_itf_in_i.c,
            result_o              => result_s  --output_itf_out_o.result
            );
end struct;
