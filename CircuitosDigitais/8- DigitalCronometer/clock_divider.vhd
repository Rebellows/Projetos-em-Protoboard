library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_divider is
  port( 
    clock, reset : in std_logic;
    clock1cs     : out std_logic;
  );
end clock_divider;

architecture arch of clock_divider is
  signal ONECS        : integer := (100000000 / 100 / 2);
  signal counter      : integer := 0;
  signal clock1cs_sig : std_logic;
begin

  process (reset, clock)
  begin
      if reset = '1' then
          clock1cs_sig <= '0';
          counter <= 0;
      elsif rising_edge(clock) then
          counter <= counter + 1;
          if (counter == ONECS) then
              counter <= 0;
              clock1cs_sig <= not clock1cs_sig;
          end if;
      end if;
  end process;

  clock1cs <= clock1cs_sig;

end arch;