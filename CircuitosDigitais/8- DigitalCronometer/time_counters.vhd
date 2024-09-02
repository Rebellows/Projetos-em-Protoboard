library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity time_counters is
  port( 
    clock1cs, reset, start : in std_logic;
    centsec, hour          : out std_logic_vector(7 downto 0);
    second, minute         : out std_logic_vector(6 downto 0)
  );
end time_counters;

architecture arch of time_counters is
    signal centsec_sig, hour_sig  : std_logic_vector(7 downto 0);
    signal second_sig, minute_sig : std_logic_vector(6 downto 0);
begin

  process (reset, clock1cs)
  begin
      if reset = '1' then
          centsec_sig <= (others => '0');
          second_sig  <= (others => '0');
          minute_sig  <= (others => '0');
          hour_sig    <= (others => '0');
      elsif rising_edge(clock1cs) then
          if (start = '1') then
              centsec_sig <= std_logic_vector(unsigned(centsec_sig) + 1);
              if (unsigned(centsec_sig) = 99) then
                  centsec_sig <= (others => '0');
                  second_sig  <= std_logic_vector(unsigned(second_sig) + 1);
              end if;
              if (unsigned(second_sig) = 59) then
                  second_sig <= (others => '0');
                  minute_sig <= std_logic_vector(unsigned(minute_sig) + 1);
              end if;
              if (unsigned(minute_sig) = 59) then
                  minute_sig <= (others => '0');
                  hour_sig   <= std_logic_vector(unsigned(hour_sig) + 1);
              end if;
              if (unsigned(hour_sig) = 99) then
                  hour_sig <= (others => '0');
              end if;
          end if;
      end if;
  end process;

  centsec <= centsec_sig;
  second  <= second_sig;
  minute  <= minute_sig;
  hour    <= hour_sig;

end arch;