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

    signal a, b, c, d: std_logic;

begin

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);


    --                                          012345678901
    seq_a : entity work.sequencer generic map ("-____-__-___") port map (clk, a);
    seq_b : entity work.sequencer generic map ("_-___-___-__") port map (clk, b);
    seq_c : entity work.sequencer generic map ("__-____-__-_") port map (clk, c);
    seq_d : entity work.sequencer generic map ("___-__-____-") port map (clk, d);

    assert_success: assert always({a;b} |=> {c;d});

    gen_fail : if EXPECT_FAIL generate
        assert_fail: assert always({a;b} |-> {c;d});
    end generate;

end architecture psl;
