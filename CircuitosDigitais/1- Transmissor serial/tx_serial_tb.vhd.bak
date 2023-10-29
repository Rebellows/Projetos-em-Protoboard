library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end tb;

architecture tb of tb is
  signal busy, linha,reset, send: std_logic;
  signal palavra : std_logic_vector(7 downto 0);
  signal clock : std_logic := '0';
begin

  DUT : entity work.transmissor
        port map (clock => clock, reset => reset, send => send,
                  palavra => palavra, busy => busy, linha => linha );

  clock <=  not clock after 10 ns;

  reset <= '1', '0' after 3 ns;

  send <= '0', '1' after 23 ns, '0' after 50 ns, '1' after 300 ns, '0' after 320 ns;

  palavra <= "11010001", "00100110" after 300ns;

end tb;
