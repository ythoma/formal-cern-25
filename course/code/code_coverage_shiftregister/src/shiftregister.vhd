-----------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenerie et de Gestion du Canton de Vaud
-- Institut REDS
--
-- Composant      : shiftregister
-- Description    : A simple shift register. Action depends on the mode:
--                  00 => hold
--                  01 => shift left
--                  10 => shift right
--                  11 => load
--
-- Auteur         : Yann Thoma
-- Date           : 03.11.2017
-- Version        : 1.0
--
-- Modification : -
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity shiftregister is
generic (DATASIZE : integer := 8);
port ( clk_i         : in std_logic;
        rst_i        : in std_logic;
        mode_i       : in std_logic_vector(1 downto 0);
        load_value_i : in std_logic_vector(DATASIZE-1 downto 0);
        ser_in_msb_i : in std_logic;
        ser_in_lsb_i : in std_logic;
        value_o      : out std_logic_vector(DATASIZE-1 downto 0)
);
end shiftregister;

architecture behave of shiftregister is

    signal reg_s : std_logic_vector(DATASIZE-1 downto 0);

begin

    process(clk_i, rst_i) is
    begin
        if (rst_i = '1') then
            reg_s <= (others => '0');
        elsif rising_edge(clk_i) then
            case mode_i is
                when "11" => reg_s <= load_value_i;
                when "01" => reg_s <= reg_s(DATASIZE-2 downto 0) & ser_in_lsb_i;
                when "10" => reg_s <= ser_in_msb_i & reg_s(DATASIZE-1 downto 1);
                when others => null;
            end case;
        end if;
    end process;

    value_o <= reg_s;


end behave;
