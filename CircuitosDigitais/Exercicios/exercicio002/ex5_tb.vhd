library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Std_Logic_unsigned.all;

entity tb is
end tb;

architecture tb of tb is
    signal clock : std_logic := '0';
	signal reset, SA, enableA, SB, enableB : std_logic;
	signal X, Y : std_logic_vector (7 downto 0);
	signal RB :  std_logic_vector (7 downto 0);
begin

	dut: entity work.ex5
         port map(reset=>reset, clock=>clock, SA=>SA, 
		          enableA=>enableA, SB=>SB, enableB=>enableB,
		          X=>X, Y=>Y, RB=>RB);

	reset <= '1', '0' after 7 ns;

	clock <= not clock after 10 ns;

	SA <= '0', '1' after 40 ns, '0' after 100 ns, '1' after 150 ns;
	enableA <= '0', '1' after 25 ns, '0' after 150 ns;
	SB <= '0', '1' after 50 ns, '0' after 110 ns, '1' after 160 ns;
	enableB <= '0', '1' after 35 ns, '0' after 150 ns, '1' after 170 ns;
    X <= x"20", x"32" after 60 ns, x"43" after 120 ns, x"54" after 180 ns; 
    Y <= x"44", x"55" after 60 ns, x"66" after 120 ns, x"77" after 180 ns; 


end tb;
