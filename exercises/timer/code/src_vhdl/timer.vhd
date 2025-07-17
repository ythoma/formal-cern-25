/*******************************************************************************
HEIG-VD
Haute Ecole d'Ingenerie et de Gestion du Canton de Vaud
School of Business and Engineering in Canton de Vaud
********************************************************************************
REDS Institute
Reconfigurable Embedded Digital Systems
********************************************************************************

File     : timer.sv
Author   : Yann Thoma
Date     : 15.11.2024

Context  : Example of assertions usage for formal verification

********************************************************************************
Description : A simple timer, started when activating an input. 
              It can count 6 or 28 cycles, depending on its mode.

********************************************************************************
Dependencies : -

********************************************************************************
Modifications :
Ver   Date        Person     Comments
1.0   15.11.2024  YTA        Initial version
1.1   06.07.2025  YTA        Adding ERRNO

*******************************************************************************/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
generic(
    ERRNO : integer := 0
);
port(
    clk_i     : in  std_logic;
    rst_i     : in  std_logic;
    start_i   : in  std_logic;
    mode_i    : in  std_logic;
    trigger_o : out std_logic;
    value_o   : out std_logic_vector(7 downto 0)
);
end timer;


architecture behave of timer is

    signal count: unsigned(7 downto 0);
    signal finished: std_logic;
    
begin

/*
    ERRNO:
    0: no error
    1: error
    2: error
    3: error on value
    4: error
    5: error
*/    

    process(clk_i, rst_i) is
    begin
        if rst_i = '1' then
            count <= to_unsigned(0, 8);
            finished <= '1';
            trigger_o <= '0';
        elsif rising_edge(clk_i) then
            if start_i = '1' then
                finished <= '0';
                if ERRNO /= 4 then
                    trigger_o <= '0';
                end if;
                if mode_i = '0' then
                    if ERRNO = 1 then
                        count <= to_unsigned(4, 8);
                    elsif ERRNO = 2 then
                        count <= to_unsigned(6, 8);
                    elsif ERRNO = 3 then
                        count <= to_unsigned(10, 8);
                    else
                        count <= to_unsigned(5, 8);
                    end if;
                else
                    count <= to_unsigned(27, 8);
                end if;
            else
                if count > 0 then
                    if ERRNO = 3 then
                        count <= count - 2;
                    else
                        count <= count - 1;
                    end if;
                end if;
                if ((finished = '0') and (count = 1)) or ((ERRNO = 3) and (finished = '0') and (count = 2)) or ((ERRNO = 5) and (finished = '0') and (count = 3)) then
                    trigger_o <= '1';
                    finished <= '1';
                end if;
            end if;
        end if;
    end process;

    value_o <= std_logic_vector(count);

end behave;
