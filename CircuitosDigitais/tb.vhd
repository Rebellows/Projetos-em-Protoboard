library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity tb is 
end tb;

architecture tranca of tb is
    component tranca_digital
    port (
        signal configurar, valido, reset, clock : std_logic;
        signal tranca, configurado, alarme      : std_logic;
        signal entrada                          : std_logic_vector (3 downto 0)
    );
end component;

signal controlF, controlS : std_logic_vector (1 downto 0);
signal QE, P1, P2, P3, AUX, A1, A2, A3 : std_logic_vector (3 downto 0);
signal tranca_s : std_logic;

begin

clock <= not clock after 12.5 ns;

DUT: entity work.tranca_digital
port map(
            configurar => configurar, 
            valido => valido, 
            reset => reset, 
            clock => clock, 
            tranca => tranca, 
            configurado => configurado, 
            alarme => alarme, 
            entrada => entrada
        );

