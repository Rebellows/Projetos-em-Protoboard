library IEEE; -- last version
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counters_converter is
  port( 
    clock1cs, reset  : in std_logic;
    flag_type        : in std_logic; -- '1' if max = 59 (seconds and minutes) or '0' if max = 99 (centsecs and hours)
    enable, do_split : in std_logic;
    counter          : in std_logic_vector(6 downto 0);
    counter_low      : out std_logic_vector(3 downto 0);
    counter_high     : out std_logic_vector(3 downto 0)
  );
end counters_converter;

architecture arch_cc of counters_converter is
  signal counter_low_sig    : std_logic_vector(3 downto 0);
  signal counter_high_sig   : std_logic_vector(3 downto 0);
  signal counter_low_split  : std_logic_vector(3 downto 0);
  signal counter_high_split : std_logic_vector(3 downto 0);
  signal flag_split         : std_logic;
begin

process (reset, clock1cs)
begin
    if reset = '1' then
        counter_low_sig   <= (others => '0');
        counter_high_sig  <= (others => '0');
        flag_split        <= '0';
    elsif rising_edge(clock1cs) then
          if (do_split = '1' and flag_split = '0') then
              counter_low_split <= counter_low_sig;
              counter_high_split  <= counter_high_sig;
              flag_split    <= '1';
          end if;
          if (do_split = '0') then
              flag_split <= '0';
          end if;
        if enable = '1' then
            if flag_type = '0' then
                if unsigned(counter) > 99 then
                    counter_low_sig  <= (others => '0');
                    counter_high_sig <= (others => '0');
                else
                    counter_low_sig  <= std_logic_vector(resize(unsigned(counter) mod 10, 4));  
                    counter_high_sig <= std_logic_vector(resize(unsigned(counter) / 10, 4));  
                end if;
            else
                if unsigned(counter) > 59 then
                    counter_low_sig  <= (others => '0');
                    counter_high_sig <= (others => '0');
                else
                    counter_low_sig  <= std_logic_vector(resize(unsigned(counter) mod 10, 4)); 
                    counter_high_sig <= std_logic_vector(resize(unsigned(counter) / 10, 4)); 
                end if;
            end if;
         end if;
    end if;
end process;

  counter_low  <= counter_low_split when flag_split = '1' else counter_low_sig;
  counter_high <= counter_high_split when flag_split = '1' else counter_high_sig;

end arch_cc;