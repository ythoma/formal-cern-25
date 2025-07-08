-----------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenerie et de Gestion du Canton de Vaud
-- Institut REDS
--
-- Composant :  counter
-- Description  : Counter with enable and parallel load
-- Author       : Yann Thoma
-- Date         : 18 mars 2010
-- Version      : 1.0
--
-----------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity counter is
generic (
    SIZE  : integer := 8;
    ERRNO : integer := 0);
port(
    rst_i      : in  std_logic;
    clk_i      : in  std_logic;
    d_i        : in  std_logic_vector(SIZE-1 downto 0);
    en_i       : in  std_logic;
    up_ndown_i : in  std_logic;
    load_i     : in  std_logic;
    value_o    : out std_logic_vector(SIZE-1 downto 0)
);
end counter ;

architecture behave of counter is

    signal reg_pres, reg_fut : unsigned(SIZE-1 downto 0);

begin

    process(all) is
    begin
        reg_fut <= reg_pres;
        if load_i then
            if ERRNO /= 1 then
                reg_fut <= unsigned(d_i);
            end if;
        elsif en_i then
            if up_ndown_i then
                if ERRNO /= 2 then
                    if (ERRNO = 4) and (reg_pres = 2**SIZE - 2) then
                        reg_fut <= reg_pres + 2;
                    else
                        reg_fut <= reg_pres + 1;
                    end if;
                end if;
            else
                if ERRNO /= 3 then
                    reg_fut <= reg_pres - 1;
                end if;
            end if;
        end if;
    end process;
  
    process(clk_i, rst_i)
    begin
        if (rst_i = '1') then
            reg_pres <= (others=>'0');
        elsif rising_Edge(Clk_i) then
            reg_pres <= reg_fut;
        end if;
    end process;

    value_o  <= std_logic_vector(reg_pres);

end behave;
