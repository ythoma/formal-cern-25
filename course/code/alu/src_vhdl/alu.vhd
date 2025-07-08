library ieee;
use ieee.std_logic_1164.all;

entity alu is
    port (
        a : in  std_logic_vector(7 downto 0);
        b : in  std_logic_vector(7 downto 0);
        m : in  std_logic;
        r : out std_logic_vector(7 downto 0)
    );
end entity alu;

architecture behave of alu is
begin

    r <= a or b when m = '0' else a and b;

end architecture behave;
