library ieee;
use ieee.std_logic_1164.all;

entity alu is
    generic (
        SIZE : integer := 8
    );
    port (
        a : in  std_logic_vector(SIZE-1 downto 0);
        b : in  std_logic_vector(SIZE-1 downto 0);
        m : in  std_logic;
        r : out std_logic_vector(SIZE-1 downto 0)
    );
end entity alu;

architecture behave of alu is
begin

    assert ((SIZE =1) or (SIZE =2) or (SIZE =4) or (SIZE=16));
    r <= a or b when m = '0' else a and b;

end architecture behave;
