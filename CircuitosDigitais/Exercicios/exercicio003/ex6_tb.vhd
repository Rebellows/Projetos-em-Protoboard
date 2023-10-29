library IEEE;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Std_Logic_unsigned.all;

entity tb is
end tb;

architecture tb of tb is
	signal reset, ck, DS : std_logic := '0' ;
	signal mu : std_logic_vector(1 downto 0) := "00" ;
	signal X, Y, Z, RA, RB : std_logic_vector(7 downto 0) := (others=>'0');
begin

	dut: entity work.ex6
         port map(reset=>reset, clock => ck, mu => mu, DS=>DS, 
		          X=>X, Y=>Y, Z=>Z, RA=>RA, RB=>RB);

	ck <= not ck after 10 ns;
	reset <= '1', '0' after 5 ns;

	process (ck)
	begin
		if rising_edge(ck) then
			mu <= mu + 1;
			X <= X + 16;
			Y <= Y + 5;
			Z <= Z + 2;
		end if;
	end process;

	DS <= not DS after 40 ns;

end tb;
