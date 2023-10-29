library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--------------------------------------
-- Descreva Aqui a Entidade
--------------------------------------

entity ex5 is
    Port (
    signal clock : in std_logic := '0';
	signal reset, SA, enableA, SB, enableB : in std_logic;
	signal X, Y : in std_logic_vector (7 downto 0);
	signal RB : out std_logic_vector (7 downto 0)
    );
end ex5;

--------------------------------------
-- Descreva aqui a Arquitetura
--------------------------------------

architecture Behavioral of ex5 is
    signal regA, regB : std_logic_vector(7 downto 0);
    signal xmux, ymux : std_logic_vector(7 downto 0);

begin

    xmux <= X when SA = '1' else regB when SA = '0' else (others => '0');
    ymux <= Y when SB = '1' else regA when SB = '0' else (others => '0');
    process (clock, reset)
    begin
        if reset = '1' then
            regA <= (others => '0');
	    regB <= (others => '0');
        elsif rising_edge(clock) then
            if enableA = '1' then
		    regA <= xmux;
            end if;

            if enableB = '1' then
		    regB <= ymux;
            end if;
        end if;
    end process;

    RB <= regB;
end Behavioral;