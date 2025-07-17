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

architecture pipelined_rtl of math_computer is
    ---------------
    -- Constants --
    ---------------

    -- The number of sequential operations in the pipeline, here we have 2a+b-c
    -- this is equal to a+a+b-c or 2*a+b-c in either cases 3 operations
    constant NUMBER_OF_OPERATIONS : integer := 3;
    -- There are registers at the entry of the pipeline and after each operation
    constant PIPELINE_DEPTH       : integer := NUMBER_OF_OPERATIONS+1;
    -- a is only needed for the first operation
    constant A_USAGE_DEPTH        : integer := 1;
    -- b is needed for the second operation
    constant B_USAGE_DEPTH        : integer := 2;
    -- c is needed for the third operation
    constant C_USAGE_DEPTH        : integer := 3;

    -----------
    -- Types --
    -----------

    -- Operands such as a,b,c (and the results)
    subtype operand_t is std_logic_vector(DATASIZE-1 downto 0);
    -- Array of operands
    type operands_array_t is array (integer range <>) of operand_t;

    ---------------
    -- Registers --
    ---------------

    -- Validity of the results
    signal valid_s : std_logic_vector(PIPELINE_DEPTH-1 downto 0);
    -- The input data
    signal a_s     : operands_array_t(A_USAGE_DEPTH-1 downto 0);
    signal b_s     : operands_array_t(B_USAGE_DEPTH-1 downto 0);
    signal c_s     : operands_array_t(C_USAGE_DEPTH-1 downto 0);
    -- The results of the operations
    signal r_s     : operands_array_t(NUMBER_OF_OPERATIONS-1 downto 0);

    -------------
    -- Signals --
    -------------

    -- To stall the pipeline if needed
    signal enable_s : std_logic;
begin

    -- Stall the pipeline when an output is valid but reader not ready
    enable_s <= '0' when valid_s(valid_s'high) = '1' and output_itf_in_i.ready = '0' else
                '1';

    -- Valid register process (Registers with reset)
    valid_reg_process : process(clk_i) is
    begin

        if rising_edge(clk_i) then
            if rst_i = '1' then
                valid_s <= (others => '0');
            elsif enable_s = '1' then
                for i in valid_s'range loop
                    if i = 0 then
                        valid_s(0) <= input_itf_in_i.valid;
                    else
                        valid_s(i) <= valid_s(i-1);
                    end if;
                end loop;
            end if;
        end if;

    end process valid_reg_process;

    -- Other registers (Registers without reset)
    reg_process : process(clk_i) is
    begin

        if rising_edge(clk_i) then
            if enable_s = '1' then
                -- Registers for variable a
                for i in a_s'range loop
                    if i = 0 then
                        a_s(0) <= input_itf_in_i.a;
                    else
                        a_s(i) <= a_s(i-1);
                    end if;
                end loop;

                -- Registers for variable b
                for i in b_s'range loop
                    if i = 0 then
                        b_s(0) <= input_itf_in_i.b;
                    else
                        b_s(i) <= b_s(i-1);
                    end if;
                end loop;

                -- Registers for variable c
                for i in c_s'range loop
                    if i = 0 then
                        c_s(0) <= input_itf_in_i.c;
                    else
                        c_s(i) <= c_s(i-1);
                    end if;
                end loop;

                -- Result registers and the specific associated operations
                r_s(0) <= operand_t(unsigned(a_s(0)) + unsigned(a_s(0)));
                r_s(1) <= operand_t(unsigned(r_s(0)) + unsigned(b_s(1)));
                r_s(2) <= operand_t(unsigned(r_s(1)) - unsigned(c_s(2)));
            end if;
        end if;

    end process reg_process;

    -- Outputs
    output_itf_out_o.result <= r_s(r_s'high);
    output_itf_out_o.valid  <= valid_s(valid_s'high);
    input_itf_out_o.ready   <= enable_s;

end pipelined_rtl;
