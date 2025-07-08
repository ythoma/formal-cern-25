--------------------------------------------------------------------------------
-- HEIG-VD, institute REDS, 1400 Yverdon-les-Bains
-- Project : Elevator
-- File    :
-- Author  : Yann Thoma
-- Date    : 06.07.2025
--
--------------------------------------------------------------------------------
-- Description : MSS simulating an elevator
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity elevator_fsm is
    generic(
        ERRNO : integer := 0
    );
    port(
        clk_i    : in  std_logic;
        rst_i    : in  std_logic;
        call0_i  : in  std_logic;
        call1_i  : in  std_logic;
        open_o   : out std_logic;
        floor0_o : out std_logic;
        floor1_o : out std_logic;
        counter_init_o : out std_logic;
        counter_done_i : in std_logic
        );
end elevator_fsm;

--------------------------------------------------------------------------------
architecture fsm of elevator_fsm is

    type state_t is (
        F0ClOSE,
        F0OPEN,
        F0ARRIVING,
        F1CLOSE,
        F1OPEN,
        F1ARRIVING);

    signal state_s   : state_t;
    signal n_state_s : state_t;
    
begin

    process (clk_i, rst_i) is
    begin
        if rst_i = '1' then
            state_s <= F0CLOSE;
        elsif rising_edge(clk_i) then
            state_s <= n_state_s;
        end if;
    end process;

    next_state_process : process(all)
    begin
        n_state_s <= state_s;
        open_o <= '0';
        floor0_o <= '0';
        floor1_o <= '0';
        counter_init_o <= '0';

        case state_s is

            when F0ClOSE =>
                floor0_o <= '1';

                if call0_i then
                    n_state_s <= F0OPEN;
                    if ERRNO /= 4 then
                        counter_init_o <= '1';
                    end if;
                elsif call1_i then
                    n_state_s <= F1ARRIVING;
                end if;

            when F0OPEN =>
                open_o <= '1';
                floor0_o <= '1';
                if (counter_done_i = '1') then
                    if (call0_i = '0') or (ERRNO = 2) then
                        n_state_s <= F0ClOSE;
                    elsif ERRNO /= 3 then
                        counter_init_o <= '1';
                    end if;
                else
                    if call0_i then
                        counter_init_o <= '1';
                    end if;
                end if;

            when F0ARRIVING =>
                n_state_s <= F0OPEN;
                if ERRNO /= 1 then
                    counter_init_o <= '1';
                end if;

            when F1ClOSE =>
                floor1_o <= '1';

                if call1_i then
                    if ERRNO = 5 then
                        n_state_s <= F0OPEN;
                    else
                        n_state_s <= F1OPEN;
                    end if;
                    counter_init_o <= '1';
                elsif call0_i then
                    n_state_s <= F0ARRIVING;
                end if;

            when F1OPEN =>
                open_o <= '1';
                floor1_o <= '1';
                if (counter_done_i = '1') then
                    if not call1_i then
                        n_state_s <= F1ClOSE;
                    else
                        counter_init_o <= '1';
                    end if;
                else
                    if call1_i then
                        counter_init_o <= '1';
                    end if;
                end if;

            when F1ARRIVING =>
                n_state_s <= F1OPEN;

        end case;

    end process;
    
end fsm;
