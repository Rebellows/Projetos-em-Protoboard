library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tranca_digital is
    port( 
        configurar, valido, reset, clock : in  std_logic;
        tranca, configurado, alarme      : out std_logic;
        entrada                          : in std_logic_vector (3 downto 0)
    );
end tranca_digital;

architecture tranca_digital of tranca_digital is

    type states is (DESCONFIGURADO, RE, RE0, RE01, RE010, VALIDADO, OPERACAO, SE0, SE01, SE010, CONFIRMA, DESTRAVA);
    signal EA, PE : states;
    signal controlF, controlS : integer := 0;
    signal count : integer range 0 to 30001 := 0;
    signal P1, P2, P3, A1, A2, A3 : std_logic_vector (3 downto 0) := "0000";
    signal QE, AUX : std_logic_vector (3 downto 0) := "0000";

begin
	
    process (clock, reset)
    begin
       if reset = '1' then
  	        EA <= DESCONFIGURADO;
            controlF <= 0;
            controlS <= 0;
            count <= 0;
       elsif rising_edge(clock) then
          	EA <= PE;
  	        if EA = RE010 then
                controlF <= controlF + 1;
            elsif EA = SE010 then
                controlS <= controlS + 1;
            elsif EA = CONFIRMA then
                controlS <= 0;
            end if;
            if EA = DESTRAVA and count < 30000 then
                count <= count + 1;
            end if;
        end if;
    end process;

    P1 <= "0000" when reset = '1' else
          entrada when EA = RE010 and controlF = 1 else
          P1;
    P2 <= "0000" when reset = '1' else
          entrada when EA = RE010 and controlF = 2 else
          P2;
    P3 <= "0000" when reset = '1' else
          entrada when EA = RE010 and controlF = 3 else
          P3;

    QE <= "0000" when reset = '1' else
          entrada when EA = RE010 and controlF = 0 else
          QE;

    AUX <= "0000" when reset = '1' else
           AUX + "0001" when QE /= "0000" and EA = CONFIRMA and AUX <= QE and (P1 /= A1 or P2 /= A2 or P3 /= A3) else
           "0000" when EA = DESTRAVA else
           AUX;

    A1 <= "0000" when reset = '1' else
          entrada when EA = SE010 and controlS = 0 else
          A1;
    A2 <= "0000" when reset = '1' else
          entrada when EA = SE010 and controlS = 1 else
          A2;
    A3 <= "0000" when reset = '1' else
          entrada when EA = SE010 and controlS = 2 else
          A3;

    configurado <= '0' when reset = '1' else
                   '0' when EA = DESCONFIGURADO else
                   '0' when EA = RE or EA = RE0 or EA = RE01 or EA = RE010 or EA = VALIDADO else
                   '1' when EA = OPERACAO or EA = SE0 or EA = SE01 or EA = SE010 or EA = CONFIRMA or EA = DESTRAVA else
                   '0';

    alarme <= '0' when reset = '1' else
              '0' when EA = DESCONFIGURADO else
              '0' when EA = RE or EA = RE0 or EA = RE01 or EA = RE010 or EA = VALIDADO else
              '1' when (QE /= "0000" and AUX > QE) and (EA = OPERACAO or EA = SE0 or EA = SE01 or EA = SE010 or EA = CONFIRMA) else
              '0';

    tranca <= '1' when reset = '1' else
              '1' when EA = DESCONFIGURADO or EA = RE or EA = RE0 or EA = RE01 or EA = RE010 else
              '0' when (A1 = P1 and A2 = P2 and A3 = P3) and (EA = DESTRAVA) else
              '0' when EA = DESTRAVA and count < 30000 else
              '1'; 
         
    process (EA, configurar, valido, count, QE, P1, P2, P3, AUX, A1, A2, A3)
    begin
        case EA is
            
            when DESCONFIGURADO =>
                if configurar = '1' then
                    PE <= RE;
                else
                    PE <= DESCONFIGURADO;
                end if;

            when RE =>
                if configurar = '0' then
                    PE <= DESCONFIGURADO;
                elsif valido = '0' then
                    PE <= RE0;
                else
                    PE <= RE;
                end if;

            when RE0 =>
                if configurar = '0' then
                    PE <= DESCONFIGURADO;
                elsif valido = '1' then
                    PE <= RE01;
                else
                    PE <= RE0;
                end if;
           
            when RE01 =>
                if configurar = '0' then
                    PE <= DESCONFIGURADO;
                elsif valido = '0' then
                    PE <= RE010;
                else
                    PE <= RE01;
                end if;

            when RE010 =>
                if controlF /= 3 then
                    PE <= RE;
                elsif configurar = '0' then
                    PE <= DESCONFIGURADO;
                else
                    PE <= VALIDADO;
                end if;

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
                if controlS /= 2 then
                    PE <= OPERACAO;
                else
                    PE <= CONFIRMA;
                end if;

            when CONFIRMA =>
                if P1 = A1 and P2 = A2 and P3 = A3 then
                    PE <= DESTRAVA;
                else 
                    PE <= OPERACAO;
                end if;

            when DESTRAVA =>
                if count >= 30000 then 
                    PE <= OPERACAO;
                end if;

            when others =>
                PE <= DESCONFIGURADO;

        end case;
    end process;
end architecture;