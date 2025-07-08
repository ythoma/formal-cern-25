library ieee;
use ieee.std_logic_1164.all;

entity psl_sequence is
    port (
        clk : in std_logic
    );
end entity psl_sequence;

architecture psl of psl_sequence is

    signal a, b: std_logic;

begin

    default clock is rising_edge(clk);

    --                                          0123456789
    seq_a : entity work.sequencer generic map ("_-_-__-___") port map (clk, a);
    seq_b : entity work.sequencer generic map ("_----_-___") port map (clk, b);
    
    property prop_impl is always (a -> b);
    assert_success1: assert prop_impl;

    assert_success2: assert always (a -> b);

end architecture psl;
