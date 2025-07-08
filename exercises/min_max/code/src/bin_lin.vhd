--<hdlarch>

-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : bin_lin.vhd
--
-- Description  : 
-- 
-- Auteur       : gilles.habegger
-- Date         : 24.10.2012
-- Version      : 0.0
-- 
-- Utilise      : Ce fichier est genere automatiquement par le logiciel 
--              : \"HDL Designer Series HDL Designer\".
-- 
--| Modifications |------------------------------------------------------------
-- Version   Auteur Date               Description
-- 
-------------------------------------------------------------------------------

--<hdlentite>
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity Bin_Lin is
   port( 
      Val_Bin_i : in     Std_Logic_Vector ( 3 downto 0 );
      Val_Lin_o : out    Std_Logic_Vector ( 15 downto 0 )
   );

-- Declarations

end Bin_Lin ;

--</hdlentite>

architecture tdv of Bin_Lin is

begin -- tdv
  with Val_Bin_i select
    Val_Lin_o <= "0000000000000001" when "0000",
                 "0000000000000011" when "0001",
                 "0000000000000111" when "0010",
                 "0000000000001111" when "0011",
                 "0000000000011111" when "0100",
                 "0000000000111111" when "0101",
                 "0000000001111111" when "0110",
                 "0000000011111111" when "0111",
                 "0000000111111111" when "1000",
                 "0000001111111111" when "1001",
                 "0000011111111111" when "1010",
                 "0000111111111111" when "1011",
                 "0001111111111111" when "1100",
                 "0011111111111111" when "1101",
                 "0111111111111111" when "1110",
                 "1111111111111111" when "1111",
                 "XXXXXXXXXXXXXXXX" when others;

	

end tdv;

