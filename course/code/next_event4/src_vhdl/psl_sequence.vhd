library ieee;
use ieee.std_logic_1164.all;

entity psl_sequence is
    generic (
        EXPECT_FAIL : boolean := false
    );
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
    seq_a : entity work.sequencer generic map ("_-__________") port map (clk, a);
    seq_b : entity work.sequencer generic map ("___--_-_--__") port map (clk, b);
    seq_c : entity work.sequencer generic map ("____-_-_--__") port map (clk, c);

    assert_success1: assert always (a -> next next_event(b)[3](c));
    assert_success2: assert always (a -> next next_event_a(b)[2 to 4](c));
    assert_success3: assert always (a -> next next_event_a(b)[2 to 5](c));
    assert_success4: assert always (a -> next next_event_e(b)[1 to 2](c));

    gen_fail : if EXPECT_FAIL generate
        assert_fail: assert always (a -> next_event(b)(c));
    end generate;

end architecture psl;
