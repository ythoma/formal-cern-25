-------------------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenierie et de Gestion du canton de Vaud
-- Institut REDS, Reconfigurable & Embedded Digital Systems
--
-- Fichier      : min_max_top.vhd
--
-- Description  : 
-- 
-- Auteur       : REDS_user
-- Date         : 01.11.2012
-- Version      : 0.0
-- 
-- Utilise      : Ce fichier est genere automatiquement par le logiciel 
--              : "HDL Designer Series HDL Designer".
-- 
--| Modifications |------------------------------------------------------------
-- Version   Auteur Date               Description
-- 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

library Aff_Min_Max;

entity Min_Max_top is
   generic(
      ERRNO : integer := 0
   );
   port(
      Com_i  : in     Std_Logic_Vector ( 1 downto 0 );
      Max_i  : in     Std_Logic_Vector ( 3 downto 0 );
      Min_i  : in     Std_Logic_Vector ( 3 downto 0 );
      Osc_i  : in     std_logic;
      Val_i  : in     Std_Logic_Vector ( 3 downto 0 );
      Leds_o : out    std_logic_vector ( 15 downto 0 )
   );

-- Declarations

end Min_Max_top ;


architecture struct of Min_Max_top is

   -- Architecture declarations

   -- Internal signal declarations
   signal Max_Lin_s    : Std_Logic_Vector(15 downto 0);
   signal Minl_Lin_s   : Std_Logic_Vector(15 downto 0);
   signal Val_Lin_s    : Std_Logic_Vector(15 downto 0);
   signal Val_PG_Max_s : std_logic;
   signal Val_PP_Min_s : std_logic;
   
   signal Leds_s1 :  std_logic_vector ( 15 downto 0 );


   -- Component Declarations
   component Affichage
   port (
      Commande_i   : in     Std_Logic_Vector ( 1 downto 0 );
      Freq_i       : in     std_logic ;
      Max_Lin_i    : in     Std_Logic_Vector ( 15 downto 0 );
      Min_Lin_i    : in     Std_Logic_Vector ( 15 downto 0 );
      Val_Lin_i    : in     Std_Logic_Vector ( 15 downto 0 );
      Val_PG_Max_i : in     std_logic ;
      Val_PP_Min_i : in     std_logic ;
      Val_Lin_o    : out    std_logic_vector ( 15 downto 0 )
   );
   end component;
   component Bin_Lin
   port (
      Val_Bin_i : in     Std_Logic_Vector ( 3 downto 0 );
      Val_Lin_o : out    Std_Logic_Vector ( 15 downto 0 )
   );
   end component;
   component Comparator_4bits
   port (
      Val_A_i  : in     Std_Logic_Vector ( 3 downto 0 );
      Val_B_i  : in     Std_Logic_Vector ( 3 downto 0 );
      Result_o : out    std_logic 
   );
   end component;

   -- Optional embedded configurations
   for all : Affichage use entity Aff_Min_Max.Affichage;
   for all : Bin_Lin use entity Aff_Min_Max.Bin_Lin;
   for all : Comparator_4bits use entity Aff_Min_Max.Comparator_4bits;

   signal leds_s : std_logic_vector(15 downto 0);
   signal osci_s : std_logic;

begin

   leds_o <= leds_s1;

   leds_s1 <= (others=>'0') when ERRNO=16 else
			(others=>'1') when ERRNO=17 else
			(0=>not osc_i,others=>'0') when ERRNO=1 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(1=>not osc_i,others=>'0') when ERRNO=2 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(2=>not osc_i,others=>'0') when ERRNO=3 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(3=>not osc_i,others=>'0') when ERRNO=4 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(4=>not osc_i,others=>'0') when ERRNO=5 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(5=>not osc_i,others=>'0') when ERRNO=6 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(6=>not osc_i,others=>'0') when ERRNO=7 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(7=>not osc_i,others=>'0') when ERRNO=8 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(8=>not osc_i,others=>'0') when ERRNO=9 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(9=>not osc_i,others=>'0') when ERRNO=10 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(10=>not osc_i,others=>'0') when ERRNO=11 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(11=>not osc_i,others=>'0') when ERRNO=12 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(12=>not osc_i,others=>'0') when ERRNO=13 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(13=>not osc_i,others=>'0') when ERRNO=14 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(15=>not osc_i,others=>'0') when ERRNO=15 and (unsigned(Max_i)<=unsigned(Min_i)) else
			(1=>'1',others=>'0') when ERRNO=18 and (Com_i="10") else
			(2=>'0',others=>'1') when ERRNO=19 and (Com_i="11") else
			(1=>'1',others=>'0') when ERRNO=20 and (Com_i="01")
			else Leds_s;

   osci_s <= not osc_i when ERRNO=21 else osc_i;

   -- Instance port mappings.
   I4 : Affichage
      port map (
         Commande_i   => Com_i,
         Freq_i       => Osci_s,
         Max_Lin_i    => Max_Lin_s,
         Min_Lin_i    => Minl_Lin_s,
         Val_Lin_i    => Val_Lin_s,
         Val_PG_Max_i => Val_PG_Max_s,
         Val_PP_Min_i => Val_PP_Min_s,
         Val_Lin_o    => Leds_s
      );
   I0 : Bin_Lin
      port map (
         Val_Bin_i => Val_i,
         Val_Lin_o => Val_Lin_s
      );
   I1 : Bin_Lin
      port map (
         Val_Bin_i => Min_i,
         Val_Lin_o => Minl_Lin_s
      );
   I6 : Bin_Lin
      port map (
         Val_Bin_i => Max_i,
         Val_Lin_o => Max_Lin_s
      );
   I2 : Comparator_4bits
      port map (
         Val_A_i  => Min_i,
         Val_B_i  => Val_i,
         Result_o => Val_PP_Min_s
      );
   I3 : Comparator_4bits
      port map (
         Val_A_i  => Val_i,
         Val_B_i  => Max_i,
         Result_o => Val_PG_Max_s
      );

end struct;
