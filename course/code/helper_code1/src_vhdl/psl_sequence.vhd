library ieee;
use ieee.std_logic_1164.all;

entity psl_sequence is
    port (
        clk : in std_logic
    );
end entity psl_sequence;

architecture psl of psl_sequence is

signal wr: std_logic;
signal full: std_logic;

    -- helper code
    signal nb_write: integer := 0;

begin

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);

    --                                             012345678901234
    seq_wr : entity work.sequencer generic map   ("__-___--_-__-") port map (clk, wr);
    seq_full : entity work.sequencer generic map ("____-_____---") port map (clk, full);
    

    -- helper code
    process(clk) is
    begin
        if rising_edge(clk) then
            if wr = '1' then
                nb_write <= nb_write + 1;
            end if;
        end if;
    end process;

    assume always (nb_write < 5);

	assert_success: assert always ((nb_write > 3) -> (full = '1'));

    assert always (nb_write < 7);
    cover {nb_write > 3};
end architecture psl;
