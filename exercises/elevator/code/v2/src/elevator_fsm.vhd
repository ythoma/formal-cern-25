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

    function cmax return integer is
    begin
        if ERRNO = 1 then
            return 10;
        elsif ERRNO = 2 then
            return 8;
        else
            return 9;
        end if;
    end cmax;


    constant COUNTMAX : integer := cmax;
    signal state_s   : state_t;
    signal n_state_s : state_t;
    signal counter_s : integer range 0 to COUNTMAX;
    signal n_counter_s : integer range 0 to COUNTMAX;
    
begin

    process (clk_i, rst_i) is
    begin
        if rst_i = '1' then
            state_s <= F0CLOSE;
            counter_s <= 0;
        elsif rising_edge(clk_i) then
            state_s <= n_state_s;
            counter_s <= n_counter_s;
        end if;
    end process;

    next_state_process : process(all)
    begin
        n_state_s <= state_s;
        n_counter_s <= counter_s;
        open_o <= '0';
        floor0_o <= '0';
        floor1_o <= '0';

        case state_s is

            when F0ClOSE =>
                floor0_o <= '1';

                if call0_i then
                    n_state_s <= F0OPEN;
                elsif call1_i then
                    n_state_s <= F1ARRIVING;
                end if;

            when F0OPEN =>
                open_o <= '1';
                floor0_o <= '1';
                if (counter_s = COUNTMAX) then
                    n_counter_s <= 0;
                    if (call0_i = '0') or (ERRNO = 3) then
                        n_state_s <= F0ClOSE;
                    end if;
                else
                    if (call0_i = '1') or (ERRNO = 4) then
                        n_counter_s <= 0;
                    else
                        n_counter_s <= counter_s + 1;
                    end if;
                end if;

            when F0ARRIVING =>
                n_state_s <= F0OPEN;

            when F1ClOSE =>
                if ERRNO /= 5 then
                    floor1_o <= '1';
                end if;

                if call1_i then
                    n_state_s <= F1OPEN;
                elsif call0_i then
                    n_state_s <= F0ARRIVING;
                end if;

            when F1OPEN =>
                open_o <= '1';
                floor1_o <= '1';
                if (counter_s = COUNTMAX) then
                    n_counter_s <= 0;
                    if not call1_i then
                        n_state_s <= F1ClOSE;
                    end if;
                else
                    if call1_i then
                        n_counter_s <= 0;
                    else
                        n_counter_s <= counter_s + 1;
                    end if;
                end if;

            when F1ARRIVING =>
                n_state_s <= F1OPEN;

        end case;

    end process;
    
end fsm;
