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
        floor1_o : out std_logic
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

        case state_s is

            when F0ClOSE =>
                floor0_o <= '1';

                if call0_i then
                    if ERRNO = 1 then
                        n_state_s <= F1OPEN;
                    else
                        n_state_s <= F0OPEN;
                    end if;
                elsif call1_i then
                    if ERRNO = 2 then
                        n_state_s <= F0ARRIVING;
                    elsif ERRNO = 3 then
                        n_state_s <= F1OPEN;
                    else
                        n_state_s <= F1ARRIVING;
                    end if;
                end if;

                -- wrong priority
                if (ERRNO = 5) and (call1_i = '1') then
                    n_state_s <= F1ARRIVING;
                end if;

                if (ERRNO = 6) then
                    n_state_s <= F0OPEN;
                end if;

            when F0OPEN =>
                open_o <= '1';
                floor0_o <= '1';
                if not call0_i then
                    n_state_s <= F0ClOSE;
                end if;

            when F0ARRIVING =>
                n_state_s <= F0OPEN;

            when F1ClOSE =>
                floor1_o <= '1';

                if call1_i then
                    n_state_s <= F1OPEN;
                elsif call0_i then
                    n_state_s <= F0ARRIVING;
                end if;

            when F1OPEN =>
                open_o <= '1';
                if ERRNO = 4 then
                    floor1_o <= '0';
                else
                    floor1_o <= '1';
                end if;
                if not call1_i then
                    n_state_s <= F1ClOSE;
                end if;

            when F1ARRIVING =>
                n_state_s <= F1OPEN;

        end case;

    end process;
    
end fsm;
