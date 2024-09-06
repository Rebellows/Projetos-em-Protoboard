library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    port (
        signal clock, reset       : in std_logic;
        signal start, stop, split : in std_logic;
        signal enable, do_split   : out std_logic;
        signal fsm_state          : out std_logic_vector(2 downto 0)
    );
end fsm;

architecture arch_fsm of fsm is
    type states is (S_RESET, S_START_HIGH, S_START, S_STOP_HIGH, S_STOP, S_SPLIT_HIGH, S_SPLIT);
    signal EA, PE : states;
begin

    process (clock, reset)
    begin
        if reset = '1' then
            EA <= S_RESET;
        elsif rising_edge(clock) then
            EA <= PE;
        end if;
    end process;

    process (EA, start, stop, split)
    begin
        case EA is

            when S_RESET =>
                if (start = '1') then
                    PE <= S_START;
                else
                    PE <= S_RESET;
                end if;

            when S_START_HIGH =>
                if (split = '0' and start = '0' and stop = '0') then
                    PE <= S_START;
                end if;

            when S_START =>
                if (stop = '1') then
                    PE <= S_STOP_HIGH;
                elsif (split = '1') then
                    PE <= S_SPLIT_HIGH;
                else
                    PE <= S_START;
                end if;

            when S_STOP_HIGH =>
                if (stop = '0') then
                    PE <= S_STOP;
                end if;

            when S_STOP =>
                if (start = '1') then
                    PE <= S_START_HIGH;
                else
                    PE <= S_STOP;
                end if;
  
            when S_SPLIT_HIGH =>
                if (split = '0') then
                    PE <= S_SPLIT;
                end if;
                
            when S_SPLIT =>  
                if (split = '1') then
                    PE <= S_START_HIGH;
                else
                    PE <= S_SPLIT;
                end if;

            when others =>
                PE <= S_RESET;

        end case;
    end process;

    process (EA, start, stop, split)
    begin
        case EA is

            when S_RESET =>
                enable <= '0';
                do_split <= '0';

            when S_START_HIGH =>
                enable <= '1';
                do_split <= '0';
                
            when S_START =>
                enable <= '1';
                do_split <= '0';

            when S_STOP_HIGH =>
                enable <= '0';
                do_split <= '0';

            when S_STOP =>
                enable <= '0';
                do_split <= '0';

            when S_SPLIT_HIGH =>
                enable <= '1';
                do_split <= '1';
                
            when S_SPLIT =>  
                enable <= '1';
                do_split <= '1';

            when others =>
                enable <= '0';
                do_split <= '0';

        end case;
    end process;   

    fsm_state <= "000" when EA = S_RESET else
                 "001" when EA = S_START_HIGH else
                 "010" when EA = S_START else
                 "011" when EA = S_STOP_HIGH else
                 "100" when EA = S_STOP else
                 "101" when EA = S_SPLIT_HIGH else "110";
end arch_fsm;