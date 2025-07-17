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

    signal req, ack : std_logic;

begin

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);

    --                                          0123456789
    seq_a : entity work.sequencer generic map ("_-_-_-______") port map (clk, req);
    seq_b : entity work.sequencer generic map ("________-___") port map (clk, ack);

    assert_cannot_fail1: assert always ((req -> next[3](ack))) abort req;
    assert_cannot_fail2: assert always ((req -> next[3](ack)) abort req);
    assert_cannot_fail3: assert always (req -> ((next[3](ack)) abort req));

    assert_success: assert always (req -> next ((next[2](ack)) abort req));

    gen_fail : if EXPECT_FAIL generate
        assert_fail: assert always (req -> (next[3](ack)));
    end generate;

end architecture psl;
