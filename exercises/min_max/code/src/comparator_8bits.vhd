--<hdlarch>

-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : comparator_8bits.vhd
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

entity Comparator_4bits is
   port( 
      Val_A_i  : in     Std_Logic_Vector ( 3 downto 0 );
      Val_B_i  : in     Std_Logic_Vector ( 3 downto 0 );
      Result_o : out    std_logic
   );

-- Declarations

end Comparator_4bits ;

--</hdlentite>

architecture comport of Comparator_4bits is

begin -- comport

Result_o <= '1' when 	(unsigned(Val_A_i) > unsigned(Val_B_i)) else
            '0';

end comport;

