library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;

entity tranca_digital is
    port( 
        configurar, valido, reset, clock : in  std_logic;
        tranca, configurado, alarme      : out std_logic;
        entrada                          : in std_logic_vector (3 downto 0)
    );
end tranca_digital;

architecture tranca_digital of tranca_digital is

    type states is (DESCONFIGURADO, RE, RE0, RE01, RE010, VALIDADO, OPERACAO, SE0, SE01, SE010, FIM);
    signal EA, PE : states;
    signal controlF, controlS : std_logic_vector (1 downto 0);
    signal QE, P1, P2, P3, AUX, A1, A2, A3 : std_logic_vector (3 downto 0);
    signal tranca_s : std_logic;

begin

    process (clock, reset)
    begin
       if reset = '1' then
         EA <= DESCONFIGURADO;
       elsif rising_edge(clock) then
         EA <= PE;
       end if;
    end process;

    configurado <= '0' when EA = DESCONFIGURADO OR EA = RE OR EA = RE0 OR EA = RE01 OR EA = RE010 OR EA = VALIDADO else '1';
    tranca <= '0' when (EA = FIM AND P1 = A1 AND P2 = A2 AND P3 = A3) OR QE = 0 else '1';
    alarme <= '1' when AUX = QE else '0';


    process (EA, configurar, valido, controlF, controlS, QE, P1, P2, P3, AUX, A1, A2, A3)
    begin
        case EA is
            
            when DESCONFIGURADO =>
                if configurar = '1' then
                    PE <= RE;
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
                if controlF = "00" then
                    QE <= entrada;
                elsif controlF = "01" then
                    P1 <= entrada;
                elsif controlF = "10" then
                    P2 <= entrada;
                else
                    P3 <= entrada;
                end if;
                controlF <= controlF + '1';

            when VALIDADO =>
                if configurar = '0' then
                    PE <= OPERACAO;
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
              if controlS /= "10" then
                PE <= OPERACAO;
            else
                PE <= FIM;
            end if;
            if controlS = "00" then
                A1 <= entrada;
            elsif controlS = "01" then
                A2 <= entrada;
            else
                A3 <= entrada;
            end if;
            controlS <= controlS + '1';
            
            when FIM =>
                if AUX /= QE + '1' then PE <= OPERACAO;
                    AUX <= AUX + '1';
                else tranca_s <= '1';
                    PE <= OPERACAO;
                    AUX <= QE + '1';
                end if;

            when others =>
                PE <= DESCONFIGURADO;

        end case;
    end process;


    process(clock)
    variable count : integer := 0;
    begin
        if EA = FIM and tranca_s = '0' then
            count := count + 1;
            if count = 30000 then
                tranca <= '1';
                count := 0;
            end if;
        else
            count := 0;
        end if;
    end process;

    tranca <= tranca_s;

end architecture;
