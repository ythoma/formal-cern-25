--<hdlarch>

-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : affichage.vhd
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
-- 1.0       GHR    24.10.2012         BSL Laboratory. Linear display of a value
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity Affichage is
   port( 
      Commande_i     : in     Std_Logic_Vector ( 1 downto 0 );
      Val_PG_Max_i   : in     std_logic;
      Val_PP_Min_i   : in     std_logic;
      Freq_i         : in     std_logic;
      Max_Lin_i      : in     Std_Logic_Vector ( 15 downto 0 );
      Min_Lin_i      : in     Std_Logic_Vector ( 15 downto 0 );
      Val_Lin_i      : in     Std_Logic_Vector ( 15 downto 0 );
      Val_Lin_o      : out    std_logic_vector ( 15 downto 0 )
   );
end Affichage ;

architecture comport of Affichage is
  signal Freq_Vect_s : Std_Logic_Vector (15 downto 0 );
  signal SRL_Min_s   : Std_Logic_Vector (15 downto 0 );
  signal SRL_Val_s   : Std_Logic_Vector (15 downto 0 );
  signal Val_Min_s   : Std_Logic_Vector (15 downto 0 );
  signal Val_Max_s   : Std_Logic_Vector (15 downto 0 );
  signal Affichage_s : Std_Logic_Vector (15 downto 0 );

begin -- comport

  -- Transformation bit -> vecteur
  Freq_Vect_s <= (others => Freq_i);
  
  -- Signaux intermediaires pour le calcul des sorties
  SRL_Min_s <= '0' & Min_Lin_i(15 downto 1); -- Shift de 1 a droite
  SRL_Val_s <= '0' & Val_Lin_i(15 downto 1); -- Shift de 1 à droite
  
  -- Vecteur qui contient les valeurs au niveau haut
  Val_Min_s <= (Val_Lin_i xor SRL_Min_s);
  
  -- Vecteur qui contient les valeurs a faibles intensitees
  Val_Max_s <= (Val_Lin_i xor Max_Lin_i) and Freq_Vect_s;
	
  Affichage_s <= (others=>'0') when Val_PP_Min_i = '1'  else -- Val plus petit que Min
                 (others=>'0') when Val_PG_Max_i = '1'  else -- Val plus grand que Max
                 (Val_Min_s or Val_Max_s);

  
  -- Mux de sortie
  with Commande_i select
    Val_Lin_o <= Affichage_s        when "00",		-- Mode normal
                 Val_Lin_i          when "01",		-- Mode linéaire
                 (others => '0')    when "10",		-- Test éteint
                 (others => '1')    when "11",		-- Test allumées
                 (others => 'X')    when others;
                 
end comport;

