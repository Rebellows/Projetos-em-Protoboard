library IEEE; -- last version
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_divider is
  port( 
    clock, reset, do_split : in std_logic;
    clock1cs, out_250ms    : out std_logic
  );
end clock_divider;

architecture arch_cd of clock_divider is
  signal ONECS            : integer := (100000000 / 100 / 2);
  signal int_250MS        : integer := (100000000 / 100 * 50);
  signal counter_1cs      : integer := 0;
  signal counter_250ms    : integer := 0;
  signal clock1cs_sig     : std_logic;
  signal sig_250ms        : std_logic;
begin

  process (reset, clock)
  begin
      if reset = '1' then
          clock1cs_sig  <= '0';
          sig_250ms     <= '0';
          counter_1cs   <= 0;
          counter_250ms <= 0;
      elsif rising_edge(clock) then
          if (do_split = '1') then
              if (counter_250ms <= int_250MS/2) then
                 sig_250ms <= '1';
              else
                 sig_250ms <= '0';
              end if;
              if (counter_250ms = int_250MS) then
                 counter_250ms <= 0;
              else 
                 counter_250ms <= counter_250ms + 1;       
              end if;
          end if;
          if (counter_1cs = ONECS) then
              counter_1cs  <= 0;
              clock1cs_sig <= not clock1cs_sig;
          else 
              counter_1cs <= counter_1cs + 1;
          end if;
      end if;
  end process;

  out_250ms    <= sig_250ms;
  clock1cs     <= clock1cs_sig;

end arch_cd;
