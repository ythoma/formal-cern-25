-----------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenerie et de Gestion du Canton de Vaud
-- Institut REDS
--
-- Composant    : alu
-- Description  : Unité arithmétique et logique capable d'effectuer
--                8 opérations. Un paramètre générique permet de forcer
--                des erreurs.
-- Auteur       : Yann Thoma
-- Date         : 28.02.2012
-- Version      : 1.0
--
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
generic (
	SIZE  : integer := 8;
	ERRNO : integer range 0 to 31 := 0
);
port (
	a_i    : in  std_logic_vector(SIZE-1 downto 0);
	b_i    : in  std_logic_vector(SIZE-1 downto 0);
	s_o    : out std_logic_vector(SIZE-1 downto 0);
	c_o    : out std_logic;
	mode_i : in  std_logic_vector(2 downto 0)
);
end alu;

architecture behave of alu is

	signal a_s: std_logic_vector(SIZE downto 0);
	signal b_s: std_logic_vector(SIZE downto 0);
	signal s_s: std_logic_vector(SIZE downto 0);

begin

	a_s<="0" & a_i;
	b_s<="0" & b_i;

	s_o<=s_s(SIZE-1 downto 0);

	process(a_s,b_s,mode_i)
	begin
		s_s<=(others=>'0');
		case mode_i is
			when "000"=>
				s_s <= std_logic_vector(unsigned(a_s)+unsigned(b_s));
				if ERRNO=17 then
					s_s <= std_logic_vector(unsigned(a_s)-unsigned(b_s));
				end if;
						
			when "001"=>
				s_s <= std_logic_vector(unsigned(a_s)-unsigned(b_s));
				if ERRNO=18 then
					s_s <= std_logic_vector(unsigned(a_s)+unsigned(b_s));
				end if;
				
			when "010"=> 
				s_s <= a_s or b_s;
				if ERRNO=19 then
					s_s <= a_s and b_s;
				end if;
				
			when "011"=> 
				s_s <= a_s and b_s;
				if ERRNO=20 then
					s_s <= a_s or b_s;
				end if;
				
			when "100"=> 
				s_s <= a_s;
				if ERRNO=21 then
					s_s <= b_s;
				end if;
				
			when "101"=> 
				s_s <= b_s;
				if ERRNO=22 then
					s_s<=a_s;
				end if;
				
			when "110"=> 
				if (a_s=b_s) then
					s_s(0) <= '1';
				else
					s_s(0) <= '0';
				end if;
				if ERRNO=23 then
					if (a_s=b_s) then
						s_s(0) <= '0';
					else
						s_s(0) <= '1';
					end if;
				end if;
				if ERRNO<16 then
					if SIZE<5 then
						s_s(SIZE-1 downto 1)<=std_logic_vector(to_unsigned(ERRNO,SIZE-1));
					else
						s_s(4 downto 1)<=std_logic_vector(to_unsigned(ERRNO,4));
					end if;
				end if;
		
		when others=> 
			s_s <= (others=>'0');
			if ERRNO=24 then
				s_s <= (others=>'1');
			end if;
		end case;
				
	end process;
	
	process(s_s,mode_i)
	begin
		if ((ERRNO mod 2)=0) then
			c_o<='0';
		else
			c_o<='1';
		end if;
		if (mode_i(2 downto 1)="00") then
			c_o<=s_s(SIZE);
			if ERRNO=16 then
				c_o <= not s_s(SIZE);
			end if;
		end if;
	end process;

end behave;
