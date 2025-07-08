library ieee;
use ieee.std_logic_1164.all;

entity psl_sequence is
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
    seq_a : entity work.sequencer generic map ("_-______-___") port map (clk, a);
    seq_b : entity work.sequencer generic map ("__----_-____") port map (clk, b);
    seq_c : entity work.sequencer generic map ("__-__-___---") port map (clk, c);
    seq_d : entity work.sequencer generic map ("___--____--_") port map (clk, d);

    assert_success1: assert always {a} |=> {{b[*4]} | {d; c}};
    assert_success2: assert always {a} |=> {{[*1]; d; b} | {d[*2]}};

end architecture psl;
