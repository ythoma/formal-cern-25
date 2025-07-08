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

/*
architecture psl of psl_sequence is

    signal a, b : std_logic;

    attribute anyseq : boolean;
    attribute anyseq of a : signal is true;
    attribute anyseq of b : signal is true;

    signal c : std_logic;

begin

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);

    restrict {rst;(not rst)[*]};

    restrict {not a;not a;a;not a;not a;not a;a;not a;not a;not a;not a};
    restrict {not b;not b;not b;not b;b;not b;not b;b;not b;not b;not b};


    assert_success: assert always (a -> next (b before a));

    assert_fail: assert always (a -> (b before a));
    assert_fail2: assert always (c -> (b before a) abort rst);

end architecture psl;
*/



architecture psl of psl_sequence is

    signal req, ack, ack2 : std_logic;

begin

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);

    --                                          0123456789
    seq_a : entity work.sequencer generic map ("__-___-____") port map (clk, req);
    seq_b : entity work.sequencer generic map ("____-__-___") port map (clk, ack);
    seq_c : entity work.sequencer generic map ("_______-___") port map (clk, ack2);

    assert_success: assert always (req -> next (ack before req));

    gen_fail : if EXPECT_FAIL generate
        assert_fail: assert always (req -> next (ack2 before req));
    end generate;

end architecture psl;
