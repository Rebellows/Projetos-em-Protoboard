library IEEE;
use IEEE.std_logic_1164.all;

entity tb is
end tb;

architecture tb of tb is
	signal reset : std_logic;
	signal ck : std_logic := '0' ;
	signal saida : std_logic_vector(7 downto 0);
begin

	reset <= '1', '0' after 5 ns;

	ck <= not ck after 20 ns;

	dut: entity work.ex4 generic map(8)
	     port map(clock => ck, reset => reset,  saida => saida);

end tb;