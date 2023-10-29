library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--------------------------------------
-- Descreva Aqui a Entidade
--------------------------------------

entity ex4 is
    generic(N : integer := 8);
    port(
        clock, reset : in std_logic;
        saida : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end ex4;

--------------------------------------
-- Descreva aqui a Arquitetura
--------------------------------------

architecture a1 of ex4 is
    signal opA, opB, soma: STD_LOGIC_VECTOR (N-1 downto 0);
begin
    process (clock, reset)
    begin
        if reset = '1' then
            opA <= (others => '0');
            opB <= (others => '0');
        elsif rising_edge(clock) then
            opA <= opA + "1";
            opB <= soma;
        end if;
    end process;
    
    soma <= opA + opB;
    saida <= soma;
end a1;