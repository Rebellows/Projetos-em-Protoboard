library IEEE; -- last version
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity time_counters is
  port( 
    clock1cs, reset, enable    : in std_logic;
    do_split                   : in std_logic;
    centsec, hour              : out std_logic_vector(6 downto 0);
    second, minute             : out std_logic_vector(6 downto 0)
  );
end time_counters;

architecture arch_tc of time_counters is
    signal centsec_sig, hour_sig      : std_logic_vector(6 downto 0);
    signal second_sig, minute_sig     : std_logic_vector(6 downto 0);
    signal centsec_split, hour_split  : std_logic_vector(6 downto 0);
    signal second_split, minute_split : std_logic_vector(6 downto 0);    
    signal flag_split                 : std_logic;
begin

  process (reset, clock1cs)
  begin
      if reset = '1' then
          centsec_sig   <= (others => '0');
          second_sig    <= (others => '0');
          minute_sig    <= (others => '0');
          hour_sig      <= (others => '0');
          flag_split    <= '0';
          centsec_split <= (others => '0');
          second_split  <= (others => '0');
          minute_split  <= (others => '0');
          hour_split    <= (others => '0');
      elsif rising_edge(clock1cs) then
          if (do_split = '1' and flag_split = '0') then
              centsec_split <= centsec_sig;
              second_split  <= second_sig;
              minute_split  <= minute_sig;
              hour_split    <= hour_sig;
              flag_split    <= '1';
          end if;
          if (do_split = '0') then
              flag_split <= '0';
          end if;
          if (enable = '1') then
              if (unsigned(hour_sig) > 99) then
                  hour_sig <= (others => '0');
              end if;
              if (unsigned(minute_sig) > 59) then
                  minute_sig <= (others => '0');
                  hour_sig   <= std_logic_vector(unsigned(hour_sig) + 1);
              end if;
              if (unsigned(second_sig) > 59) then
                  second_sig <= (others => '0');
                  minute_sig <= std_logic_vector(unsigned(minute_sig) + 1);
              end if;
              if (unsigned(centsec_sig) > 99) then
                  centsec_sig <= (others => '0');
                  second_sig  <= std_logic_vector(unsigned(second_sig) + 1);
              else 
                  centsec_sig <= std_logic_vector(unsigned(centsec_sig) + 1);
              end if;          
          end if;
      end if;
  end process;

  centsec <= centsec_split when flag_split = '1' else centsec_sig;
  second  <= second_split when flag_split = '1' else second_sig;
  minute  <= minute_split when flag_split = '1' else minute_sig;
  hour    <= hour_split when flag_split = '1' else hour_sig;

end arch_tc;