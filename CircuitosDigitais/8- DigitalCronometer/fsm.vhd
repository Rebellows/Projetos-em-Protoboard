library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fsm is
    port (
        signal clock, reset       : in std_logic;
        signal start, stop, split : in std_logic;
        signal enable             : out std_logic;
    );
end fsm;

architecture arch of fsm is
    type states is (S_RESET, S_START, S_STOP_HIGH, S_STOP, S_SPLIT_HIGH, S_SPLIT);
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

            when S_START =>
                if (stop = '1') then
                    PE <= S_STOP_HIGH;
                else if (split = '1') then
                    PE <= S_SPLIT_HIGH;
                else
                    PE <= S_START;
                end if;

            when S_STOP_HIGH =>
                if (stop = '0') then
                    PE <= S_STOP;
                end if;

            when S_STOP =>
                if (stop = '1') then
                    PE <= S_START;
                else
                    PE <= S_STOP;
                end if;
  
            when S_SPLIT_HIGH =>
                if (split = '0') then
                    PE <= S_SPLIT;
                end if;
                
            when S_SPLIT =>  
                if (split = '1') then
                    PE <= S_START;
                else
                    PE <= S_SPLIT;
                end if;

        end case;
    end process;

end arch;