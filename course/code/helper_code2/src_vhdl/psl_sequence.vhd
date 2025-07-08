library ieee;
use ieee.std_logic_1164.all;

entity psl_sequence is
    port (
        clk : in std_logic
    );
end entity psl_sequence;

architecture psl of psl_sequence is

signal wr: std_logic;
signal rd: std_logic;
signal full: std_logic;

    -- helper code
    signal nb_write: integer := 0;
    signal nb_read : integer := 0;

begin

    -- All is sensitive to rising edge of clk
    default clock is rising_edge(clk);

    --                                             012345678901234
    seq_wr : entity work.sequencer generic map   ("__-___--_-__-") port map (clk, wr);
    seq_rd : entity work.sequencer generic map   ("__________---") port map (clk, rd);
    seq_full : entity work.sequencer generic map ("____-_____-__") port map (clk, full);
    

    -- helper code
    process(clk) is
    begin
        if rising_edge(clk) then
            if wr = '1' then
                nb_write <= nb_write + 1;
            end if;
            if rd = '1' then
                nb_read <= nb_read + 1;
            end if;
            report integer'image(nb_write);
        end if;
    end process;

    assume always (nb_write < 5);

	assert_success: assert always ((nb_write - nb_read > 3) -> (full = '1'));

    assert always (nb_write < 7);
    cover {nb_write > 3};
end architecture psl;
