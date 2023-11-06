--------------------------------------------------------------------------------
-- RELOGIO DE XADREZ
-- Author - Fernando Moraes - 25/out/2023
-- Revision - Iaçanã Ianiski Weber - 30/out/2023
--------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity relogio_xadrez is
    port( 
	    init_time                  : in std_logic_vector(7 downto 0);
	    contj1, contj2             : out std_logic_vector(15 downto 0);
	    load, j1, j2, reset, clock : in std_logic;
	    winJ1, winJ2               : out std_logic := '0'
    );
end relogio_xadrez;

architecture relogio_xadrez of relogio_xadrez is
    -- DECLARACAO DOS ESTADOS
    type states is (INIT, WAITING, JOG1, JOG2, WINNER1, WINNER2);
    signal EA, PE : states;
    signal enable1, enable2 : std_logic;
    signal sig_contj1, sig_contj2 : std_logic_vector(15 downto 0);
begin

    -- INSTANCIACAO DOS CONTADORES
    contador1 : entity work.temporizador port map (
		clock => clock,
		reset => reset,
		load => load,
		en => enable1, 
		init_time => init_time,
		cont => sig_contj1
    );
    contador2 : entity work.temporizador port map (
		clock => clock,
		reset => reset,
		load => load,
		en => enable2,
		init_time => init_time,
		cont => sig_contj2
    );

    contj1 <= sig_contj1;
    contj2 <= sig_contj2;

    -- PROCESSO DE TROCA DE ESTADOS
    process (clock, reset)
    begin
       if reset = '1' then
         EA <= INIT;
       elsif rising_edge(clock) then
         EA <= PE;
       end if;
    end process;

    -- PROCESSO PARA DEFINIR O PROXIMO ESTADO
    process (EA, load, j1, j2, sig_contj1, sig_contj2)
    begin
        case EA is
            
            when INIT    =>  if load = '1' then  PE <= WAITING;
                                           else  PE <= INIT;
                             end if;

            when WAITING =>  if j1 = '1'   then  PE      <= JOG1;
				                 enable1 <= '1';
                            			 enable2 <= '0';
                                           else  PE      <= WAITING;
                             end if;

            when JOG1    =>  if j1 = '1'                     then  PE <= JOG2;
				                             enable1 <= '0';
                            				     enable2 <= '1';
                             elsif sig_contj1 = x"0000"      then  PE <= WINNER2;
				                             enable1 <= '0';
                            				     enable2 <= '0';
							     else  PE <= JOG1;
                             end if;
           
            when JOG2    =>  if j2 = '1'                     then  PE <= JOG1;
				                             enable1 <= '1';
                            				     enable2 <= '0';
                             elsif sig_contj2 = x"0000"      then  PE <= WINNER1;
				                             enable1 <= '0';
                            				     enable2 <= '0';
							     else  PE <= JOG2;
                             end if; 

            when WINNER1 =>  winJ1 <= '1';   
            
            when WINNER2 =>  winJ2 <= '1';

        end case;
    end process;
	
end relogio_xadrez;
