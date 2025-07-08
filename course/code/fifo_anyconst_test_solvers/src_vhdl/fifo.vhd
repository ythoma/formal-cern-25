-----------------------------------------------------------------------
-- HEIG-VD, Haute Ecole d'Ingenerie et de Gestion du Canton de Vaud
-- Institut REDS
--
-- Composant      : fifo
-- Description    : A simple FIFO.
--                  Generic parameters : FIFO size, and data size
--                  Two flags : empty and full
--
-- Auteur         : Yann Thoma
-- Date           : 17.09.2018
-- Version        : 1.0
--
-- Modification : -
--
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
    generic (
        FIFOSIZE   : integer := 8;
        DATASIZE   : integer := 8
    );
    port (
        clk_i      : in    std_logic;
        rst_i      : in    std_logic;
        full_o     : out   std_logic;
        empty_o    : out   std_logic;
        wr_i       : in    std_logic;
        rd_i       : in    std_logic;
        data_i     : in    std_logic_vector(DATASIZE-1 downto 0);
        data_o     : out   std_logic_vector(DATASIZE-1 downto 0)
    );
end fifo;

architecture behave of fifo is

    type fifo_type is array(0 to FIFOSIZE-1) of std_logic_vector(DATASIZE-1 downto 0);

    signal fifo_s             : fifo_type;
    signal fifo_counter_in_s  : integer range 0 to FIFOSIZE-1;
    signal fifo_counter_out_s : integer range 0 to FIFOSIZE-1;
    signal fifo_full_s        : std_logic;
    signal fifo_empty_s       : std_logic;
    signal fifo_rd_s          : std_logic;
    signal fifo_wr_s          : std_logic;
    signal fifo_out_s         : std_logic_vector(DATASIZE-1 downto 0);

    signal internal_counter_s : integer;

begin

    -- Assign outputs
    data_o     <= fifo_out_s;
    empty_o    <= fifo_empty_s;
    full_o     <= fifo_full_s;

    -- Get inputs
    fifo_wr_s  <= wr_i;
    fifo_rd_s  <= rd_i;

    fifo_out_s <= fifo_s(fifo_counter_out_s);

    process(clk_i,rst_i)
    begin
        if rst_i='1' then
            fifo_counter_in_s  <= 0;
            fifo_counter_out_s <= 0;
            fifo_full_s        <= '0';
            fifo_empty_s       <= '1';
            internal_counter_s <= 0;
        elsif rising_edge(clk_i) then

            -- First manage the read operation
            if fifo_rd_s = '1' and fifo_empty_s = '0' then
                -- Read from the FIFO
                if fifo_wr_s = '0' then

                    -- If no write occurs, then the FIFO could be empty
                    if ((fifo_counter_out_s + 1) mod FIFOSIZE) = fifo_counter_in_s then
                        fifo_empty_s <= '1';
                    end if;

                    -- If no write occurs, then the FIFO can not be full after a read
                    fifo_full_s <= '0';
                end if;

                -- Update the reads pointer
                fifo_counter_out_s <= (fifo_counter_out_s + 1) mod FIFOSIZE;
            end if;

            -- Then manage the write operation
            if fifo_wr_s = '1' and fifo_full_s = '0' then
                -- Write to the FIFO

                -- The FIFO can not be empty if a write occurs
                fifo_empty_s <= '0';

                -- If there is no read opration, the FIFO could become full
                if ((fifo_counter_in_s + 1) mod FIFOSIZE) = fifo_counter_out_s then
                    if fifo_rd_s = '0' then
                        fifo_full_s <= '1';
                    end if;
                end if;

                --if not (internal_counter_s = 3*FIFOSIZE) then
                -- Update the writes pointer
                    fifo_counter_in_s <= (fifo_counter_in_s + 1) mod FIFOSIZE;
                --end if;

                internal_counter_s <= internal_counter_s + 1;

                -- Update the FIFO memory
                fifo_s(fifo_counter_in_s) <= data_i;
            end if;
        end if;
    end process;

end behave;
