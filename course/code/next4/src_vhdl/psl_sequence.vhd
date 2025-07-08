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

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);


    --                                          012345678901
    seq_a : entity work.sequencer generic map ("_-__-__--___") port map (clk, a);
    seq_b : entity work.sequencer generic map ("___---------") port map (clk, b);

    assert_success1: assert always (a -> next[2](b));
    assert_success2: assert always (a -> next_a[2 to 4](b));
    assert_success3: assert always (a -> next_e[2 to 4](b));

end architecture psl;
