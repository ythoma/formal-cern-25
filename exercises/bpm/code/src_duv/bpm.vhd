

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bpm is
    generic (
        MIN_DT_TIME           : integer := 4;
        MIN_OT_TIME           : integer := 4;
        ONTIME_COUNTER_SIZE   : integer := 8;
        DEADTIME_COUNTER_SIZE : integer := 8
    );
    port(
        rst_i       : in     std_logic;
        clk_i       : in     std_logic;
        next_q_i    : in     std_logic_vector(3 downto 0);
        present_q_o : out    std_logic_vector(3 downto 0)
    );
end bpm;

architecture behave of bpm is

    constant STATE_O : std_logic_vector(3 downto 0) := "0110";
    constant STATE_P : std_logic_vector(3 downto 0) := "1100";
    constant STATE_N : std_logic_vector(3 downto 0) := "0011";
    constant STATE_READY_O_P : std_logic_vector(3 downto 0) := "0100";
    constant STATE_READY_O_N : std_logic_vector(3 downto 0) := "0010";

    signal ontime_counter_s        : unsigned(ONTIME_COUNTER_SIZE-1 downto 0);
    signal next_ontime_counter_s   : unsigned(ONTIME_COUNTER_SIZE-1 downto 0);
    signal deadtime_counter_s      : unsigned(DEADTIME_COUNTER_SIZE-1 downto 0);
    signal next_deadtime_counter_s : unsigned(DEADTIME_COUNTER_SIZE-1 downto 0);

    signal present_q_s      : std_logic_vector(3 downto 0);

    type state_t is (READY, O, P, N, READY_O_P, READY_O_N);

    signal state_s : state_t;
    signal next_state_s : state_t;

    signal min_ot_ok_s : std_logic;
    signal min_dt_ok_s : std_logic;

begin

    min_ot_ok_s <= '1' when ontime_counter_s = MIN_OT_TIME-1 else '0';
    min_dt_ok_s <= '1' when deadtime_counter_s = MIN_DT_TIME-1 else '0';

    with state_s select
        present_q_s <= "0000" when READY,
                       STATE_O when O,
                       STATE_P when P,
                       STATE_N when N,
                       STATE_READY_O_P when READY_O_P,
                       STATE_READY_O_N when READY_O_N;

    process(all) is
    begin
        next_deadtime_counter_s <= deadtime_counter_s;
        next_ontime_counter_s <= ontime_counter_s;
        next_state_s <= state_s;

        next_ontime_counter_s <= ontime_counter_s + 1;
        next_deadtime_counter_s <= deadtime_counter_s + 1;

        case state_s is
            when READY =>
                next_deadtime_counter_s <= (others => '0');
                if next_q_i = STATE_READY_O_N then
                    next_state_s <= READY_O_N;
                elsif next_q_i = STATE_READY_O_P then
                    next_state_s <= READY_O_P;
                end if;

            when O =>
                next_deadtime_counter_s <= (others => '0');
                if next_q_i = STATE_READY_O_N and min_ot_ok_s = '1' then
                    next_state_s <= READY_O_N;
                elsif next_q_i = STATE_READY_O_P and min_ot_ok_s = '1' then
                    next_state_s <= READY_O_P;
                end if;

            when P =>
                next_deadtime_counter_s <= (others => '0');
                if next_q_i = STATE_READY_O_P and min_ot_ok_s = '1' then
                    next_state_s <= READY_O_P;
                end if;

            when N =>
                next_deadtime_counter_s <= (others => '0');
                if next_q_i = STATE_READY_O_N and min_ot_ok_s = '1' then
                    next_state_s <= READY_O_N;
                end if;

            when READY_O_P =>
                next_ontime_counter_s <= (others => '0');
                if next_q_i = "0000" and min_dt_ok_s = '1' then
                    next_state_s <= READY;
                elsif next_q_i = STATE_O and min_dt_ok_s = '1' then
                    next_state_s <= O;
                elsif next_q_i = STATE_P and min_dt_ok_s = '1' then
                    next_state_s <= P;
                end if;

            when READY_O_N =>
                next_ontime_counter_s <= (others => '0');
                if next_q_i = "0000" and min_dt_ok_s = '1' then
                    next_state_s <= READY;
                elsif next_q_i = STATE_O and min_dt_ok_s = '1' then
                    next_state_s <= O;
                elsif next_q_i = STATE_N and min_dt_ok_s = '1' then
                    next_state_s <= N;
                end if;
        end case;


    end process;

    --| Registers process |----------------------------------------------------
    process(clk_i, rst_i)
    begin
        if (rst_i = '1') then
            ontime_counter_s <= (others => '0');
            deadtime_counter_s <= (others => '0');
            state_s <= READY;
        elsif Rising_Edge(Clk_i) then
            ontime_counter_s <= next_ontime_counter_s;
            deadtime_counter_s <= next_deadtime_counter_s;
            state_s <= next_state_s;
        end if;
    end process;

    --| Output decode |------------------------------------------------------
    present_q_o  <= present_q_s;

end behave;
