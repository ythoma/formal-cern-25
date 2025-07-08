library ieee;
use ieee.std_logic_1164.all;

entity psl_sequence is
    port (
        clk : in std_logic
    );
end entity psl_sequence;

architecture psl of psl_sequence is

signal req, ack: std_logic;

begin

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);


  --                              012345678901234
  seq_req : entity work.sequencer generic map ("__-___-__-___") port map (clk, req);
  seq_ack : entity work.sequencer generic map ("____-_____-__") port map (clk, ack);

  assert_success: assert always (req -> eventually! ack);

end architecture psl;
