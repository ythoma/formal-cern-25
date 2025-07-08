--------------------------------------------------------------------------------
-- HEIG-VD
-- Haute Ecole d'Ingenerie et de Gestion du Canton de Vaud
-- School of Business and Engineering in Canton de Vaud
--------------------------------------------------------------------------------
-- REDS Institute
-- Reconfigurable Embedded Digital Systems
--------------------------------------------------------------------------------
--
-- File     : shiftregister_tb.vhd
-- Author   : Yann Thoma
-- Date     : 25.02.2021
--
-- Context  :
--
--------------------------------------------------------------------------------
-- Description : This module is a simple VHDL testbench for a shift register.
--               It instantiates the DUV and proposes a TESTCASE generic to
--               select which test to start.
--               TESTCASE:
--               0 : Tests the reset
--               1 : Tests the load
--               2 : Tests the shift right, by inserting 1s
--               3 : Tests the shift left, by inserting 1s
--               4 : Tests the hold
--               5 : Tests the shift right, by inserting 0s
--               others : Generates an error
--
--               The testbench is very light, its purpose it to be used
--               as a demo for vrun and testplans
--------------------------------------------------------------------------------
-- Dependencies : -
--
--------------------------------------------------------------------------------
-- Modifications :
-- Ver   Date        Person     Comments
-- 0.1   25.02.2021  YTA        Initial version
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftregister_tb is
    generic (
        DATASIZE : integer := 8;
        TESTCASE : integer := 0
        );

end shiftregister_tb;

architecture testbench of shiftregister_tb is

    constant CLK_PERIOD : time := 10 ns;

    signal clk_sti          : std_logic;
    signal rst_sti          : std_logic;


    signal mode_sti       : std_logic_vector(1 downto 0);
    signal load_value_sti : std_logic_vector(DATASIZE-1 downto 0);
    signal ser_in_msb_sti : std_logic;
    signal ser_in_lsb_sti : std_logic;
    signal value_obs      : std_logic_vector(DATASIZE-1 downto 0);

    signal sim_end_s : boolean := false;

    constant ALLZERO : std_logic_vector(DATASIZE - 1 downto 0)
                     := (others => '0');

begin

    stimuli_proc : process is
        variable value_v : std_logic_vector(DATASIZE - 1 downto 0);
    begin
        -- Default values, and reset applied
        rst_sti <= '1';
        mode_sti <= "00";
        load_value_sti <= (others => '0');
        ser_in_lsb_sti <= '0';
        ser_in_msb_sti <= '0';
        wait for 3 * CLK_PERIOD;

        if TESTCASE = 0 then
            if value_obs /= ALLZERO then
                report "Error with reset" severity error;
            end if;
            sim_end_s <= true;
        end if;

        rst_sti <= '0';
        wait for 1 * CLK_PERIOD;

        case TESTCASE is
        when 0 => null; -- reset already handled

        when 1 => -- test load
            for i in 1 to 10 loop
                mode_sti <= "11";
                load_value_sti <= std_logic_vector(to_unsigned(i, DATASIZE));
                wait for CLK_PERIOD;
                if unsigned(value_obs) /= i then
                    report "Error with load" severity error;
                end if;
            end loop;

        when 2 => -- test shift right and insert 1
            mode_sti <= "10";
            value_v := value_obs;
            for i in 0 to DATASIZE loop
                ser_in_msb_sti <= '0';
                wait for CLK_PERIOD;
                value_v := ser_in_msb_sti & value_v(DATASIZE-1 downto 1);
                if value_v /= value_obs then
                    report "Error with right shift" severity error;
                end if;
            end loop;

        when 5 => -- test shift right and insert 0
            mode_sti <= "10";
            value_v := value_obs;
            for i in 0 to DATASIZE loop
                ser_in_msb_sti <= '0';
                wait for CLK_PERIOD;
                value_v := ser_in_msb_sti & value_v(DATASIZE-1 downto 1);
                if value_v /= value_obs then
                    report "Error with right shift" severity error;
                end if;
            end loop;

        when 3 => -- test shift left
            mode_sti <= "01";
            value_v := value_obs;
            for i in 0 to DATASIZE loop
                ser_in_msb_sti <= '1';
                wait for CLK_PERIOD;
                value_v := value_v(DATASIZE-2 downto 0) & ser_in_lsb_sti;
                if value_v /= value_obs then
                    report "Error with right shift" severity error;
                end if;
            end loop;

        when 4 => -- hold
            mode_sti <= "00";
            value_v := value_obs;
            for i in 0 to DATASIZE loop
                ser_in_msb_sti <= '1';
                wait for CLK_PERIOD;
                if value_v /= value_obs then
                    report "Error with load" severity error;
                end if;
            end loop;

        when others =>
            report "TESTCASE not supported" severity error;
        end case;

        sim_end_s <= true;
        wait;
    end process;

    clk_proc : process is
    begin
        clk_sti <= '0';
        wait for CLK_PERIOD / 2;
        clk_sti <= '1';
        wait for CLK_PERIOD / 2;
        if sim_end_s then
            wait;
        end if;
    end process;


    duv : entity work.shiftregister
    generic map (
        DATASIZE => DATASIZE
    )
    port map (
        clk_i        => clk_sti,
        rst_i        => rst_sti,
        mode_i       => mode_sti,
        load_value_i => load_value_sti,
        ser_in_lsb_i => ser_in_lsb_sti,
        ser_in_msb_i => ser_in_msb_sti,
        value_o      => value_obs
    );

end testbench;
