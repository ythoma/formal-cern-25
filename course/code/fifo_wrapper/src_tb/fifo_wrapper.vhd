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

entity fifo_wrapper is
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
        data_o     : out   std_logic_vector(DATASIZE-1 downto 0);

        -- For formal verification purpose
        s_data     : in    std_logic_vector(DATASIZE-1 downto 0);
        s_cnt      : in    integer
    );
end fifo_wrapper;

architecture struct of fifo_wrapper is

begin


    duv: entity work.fifo
    generic map(
        FIFOSIZE => FIFOSIZE,
        DATASIZE => DATASIZE)
    port map(
        clk_i => clk_i,
        rst_i => rst_i,
        full_o => full_o,
        empty_o => empty_o,
        wr_i => wr_i,
        rd_i => rd_i,
        data_i => data_i,
        data_o => data_o
        );

end struct;
