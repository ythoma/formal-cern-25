library ieee;
use ieee.std_logic_1164.all;

entity psl_sequence is
    port (
        clk : in std_logic
    );
end entity psl_sequence;

architecture psl of psl_sequence is

    signal a, b, c: std_logic;

begin

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);


    --                                          012345678901
    seq_a : entity work.sequencer generic map ("_-___-__-___") port map (clk, a);
    seq_b : entity work.sequencer generic map ("__--__-___-_") port map (clk, b);
    seq_c : entity work.sequencer generic map ("__-___-___-_") port map (clk, c);

    assert_success1: assert always (a -> next_event(b)(c));
    assert_success2: assert always (a -> next next_event(b)(c));

end architecture psl;
