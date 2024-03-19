library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity tranca_digital is
    port( 
        configurar, valido, reset, clock : in  std_logic;
        tranca, configurado, alarme      : out std_logic;
        entrada                          : in std_logic_vector (3 downto 0);
    );
end tranca_digital;

architecture tranca_digital of tranca_digital is

    type states is (DESCONFIGURADO, RE, RE0, RE01, RE010, VALIDADO, OPERACAO, SE0, SE01, SE010, FIM);
    signal EA, PE : states;
    signal controlF, controlS : std_logic_vector (1 downto 0);
    signal QE, P1, P2, P3, AUX, A1, A2, A3 : std_logic_vector (3 downto 0);
    constant tempo_375us : integer := 30000;

begin

    process (clock, reset)
    begin
       if reset = '1' then
         EA <= DESCONFIGURADO;
       elsif rising_edge(clock) then
         EA <= PE;
       end if;
    end process;

    process (EA, DESCONFIGURADO, RE, RE0, RE01, RE010, VALIDADO, OPERACAO, SE0, SE01, SE010, FIM)
    begin
        case EA is
            
            when DESCONFIGURADO =>
                if configurar = '1' then
                    PE <= RE;
                    configurado <= '0';
                    tranca <= '1';
                    alarme <= '0';
                else
                    PE <= DESCONFIGURADO;
                end if;

            when RE =>
                if valido = '0' then
                    PE <= RE0;
                elsif configurar = '0' then
                    PE <= DESCONFIGURADO;
                else
                    PE <= RE;
                end if;

            when RE0 =>
                if valido = '1' then
                    PE <= RE01;
                elsif configurar = '0' then
                    PE <= DESCONFIGURADO;
                else
                    PE <= RE0;
                end if;
           
            when RE01 =>
                if valido = '0' then
                    PE <= RE010;
                elsif configurar = '0' then
                    PE <= DESCONFIGURADO;
                else
                    PE <= RE01;
                end if; 

            when RE010 =>
                if controlF <= "11" then
                    PE <= RE;
                elsif configurar = '0' then
                    PE <= DESCONFIGURADO;
                else
                    PE <= VALIDADO;
                end if;
                if control = "00" then
                    QE <= entrada;
                elsif control = "01" then
                    P1 <= entrada;
                elsif control = "10" then
                    P2 <= entrada;
                else
                    P3 <= entrada;
                end if;
                controlF <= controlF + '1';

            when VALIDADO =>
                if configurar = '0' then
                    PE <= OPERACAO;
                    configurado <= '1';
                else
                    PE <= VALIDADO;
                end if;

            when OPERACAO =>
                if valido = '0' then
                    PE <= SE0;
                else
                    PE <= OPERACAO;
                end if;
                          
            when SE0 =>
                if valido = '1' then
                    PE <= SE01;
                else
                    PE <= SE0;
                end if;

            when SE01 =>
                if valido = '0' then
                    PE <= SE010;
                else
                    PE <= SE01;
                end if;
           
            when SE010 =>
              if controlS /= "11" then
                PE <= OPERACAO;
            else
                PE <= FIM;
            end if;
            if control = "00" then
                A1 <= entrada;
            elsif control = "01" then
                A2 <= entrada;
            else
                A3 <= entrada;
            end if;
            controlS <= controlS + '1';
            
            when FIM =>
                if P1 = A1 and P2 = A2 and P3 = A3 or QE = 0 then
                    tranca <= '0';
                elsif AUX /= QE then PE <= OPERACAO;
                AUX <= AUX + '1';
              else tranca <= '1';
                  PE <= OPERACAO;
                  AUX <= QE + '1';
                end if;

        end case;
    end process;

    process(clock)
    variable count : integer := 0;
    begin
        if EA = FIM and tranca = '0' then
            count := count + 1;
            if count = tempo_375us then
                tranca <= '1';
                count := 0;
            end if;
        else
            count := 0;
        end if;
    end process;

end architecture;
