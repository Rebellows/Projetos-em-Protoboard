library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--------------------------------------
-- Descreva Aqui a Entidade
--------------------------------------

entity ex8 is
 	port( clock, reset, send, req : in std_logic;
	    entrada : in std_logic_vector(3 downto 0);
	    saida : out std_logic_vector (3 downto 0)
	     );
end ex8;

--------------------------------------
-- Descreva aqui a Arquitetura
--------------------------------------

architecture a1 of ex8 is
 	signal A, B, C, D : STD_LOGIC_VECTOR (3 downto 0);
 	signal contIn : STD_LOGIC_VECTOR (1 downto 0);
	signal soma, regSoma : STD_LOGIC_VECTOR (17 downto 0) := (others=>'0');
	signal contOut : STD_LOGIC_VECTOR(1 downto 0) := "11";
	signal acumula : std_logic;


begin

 -- registrador de deslocamento controlado pelo send

	process (clock, reset)
	    begin
 		if reset = '1' then
			 contIn <= (others=>'0');
			 A <= (others => '0');
			 B <= (others => '0');
			 C <= (others => '0');
			 D <= (others => '0');
		 elsif rising_edge(clock) then
		      if send= '1' then
			 A <= entrada;
			 B <= A;
			 C <= B;
			 D <= C;
			 contIn <= contIn + 1;
		      end if;
		 end if;
	end process;

	soma <= regSoma + ("00" & A & B & C & D);

	acumula <= contIn(0) nor contIn(1);

	process (acumula, reset)
		begin
		    if reset = '1' then
			 regSoma <= (others=>'0');
		    elsif rising_edge(acumula) then
 			 regSoma <= soma ;
		    end if;
	end process;

	process (req)
		begin
		    if req = '1' then
        		if contOut = "00" then
            			contOut <= "01";
        		elsif contOut = "01" then
            			contOut <= "10";
        		elsif contOut = "10" then
            			contOut <= "11";
        		end if;
    		    end if;
	end process;

	saida <= regSoma(5 downto 2) when contOut = "00" else
         	regSoma(9 downto 6) when contOut = "01" else
         	regSoma(13 downto 10) when contOut = "10" else
         	regSoma(17 downto 14);

end a1;
