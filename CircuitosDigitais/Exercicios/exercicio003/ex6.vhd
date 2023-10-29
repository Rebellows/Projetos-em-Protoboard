library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--------------------------------------
-- Descreva Aqui a Entidade
--------------------------------------

entity ex6 is
    Port (
	signal reset, clock, DS : in std_logic := '0' ;
	signal mu : in std_logic_vector(1 downto 0) := "00" ;
	signal X, Y, Z : in std_logic_vector(7 downto 0) := (others=>'0');
	signal RA, RB : out std_logic_vector(7 downto 0) := (others=>'0')
    );
end ex6;

--------------------------------------
-- Descreva aqui a Arquitetura
--------------------------------------

architecture Behavioral of ex6 is
    signal R1, R2, OMUX : std_logic_vector(7 downto 0);
    signal L1, L2 : std_logic;

begin

    OMUX <= X when mu = "11" else
	    Y when mu = "10" else
	    Z when mu = "01" else
	    R2 when mu = "00" else (others => '0');

    L1 <= '1' when DS = '0' else '0';
    L2 <= '1' when DS = '1' else '0';

	process(clock, reset)
	begin
    	if reset='1' then
	        R1 <= (others => '0');
	        R2 <= (others => '0');
	    elsif falling_edge(clock) then
	        if L1='1' then R1 <= OMUX; end if;
	        if L2='1' then R2 <= R1; end if;
	    end if;
	end process;

    RA <= R1;
    RB <= R2;

end Behavioral;