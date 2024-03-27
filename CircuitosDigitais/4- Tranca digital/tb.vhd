library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture tranca_digital of tb is
    signal clock_tb, reset_tb, valido_tb, configurar_tb : std_logic := '0';
    signal configurado_tb, alarme_tb : std_logic;
    signal tranca_tb : std_logic := '1';
    signal entrada_tb : std_logic_vector (3 downto 0);
    
    constant clk_period : time := 12.5 ns;

begin
     DUT: entity work.tranca_digital
        port map (
            clock => clock_tb,
            reset => reset_tb,
            configurar => configurar_tb,
            valido => valido_tb,
            tranca => tranca_tb,
            configurado => configurado_tb,
            alarme => alarme_tb,
            entrada => entrada_tb
        );


    clock_tb <= not clock_tb after clk_period/2;

    test_case: process
    begin

        reset_tb <= '1', '0' after clk_period/2;

        -- Teste 1: Sequência para configurar a tranca com senha correta (A07)

        wait for clk_period * 60;  -- Aguarda estabilidade do clock e reset

        -- Início da etapa de configuração

        configurar_tb <= '1';
        wait for clk_period * 60;
        entrada_tb <= "0011"; -- Configurando tentativas (3)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "1010"; -- Primeiro dígito da senha (A)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0000"; -- Segundo dígito da senha (0)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0111"; -- Terceiro dígito da senha (7)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';

        -- Início da etapa de validação

        wait for clk_period * 60;

        configurar_tb <= '0';

        wait for clk_period * 60;

        entrada_tb <= "1010"; -- Primeiro dígito da senha (A)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0000"; -- Segundo dígito da senha (0)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0111"; -- Terceiro dígito da senha (7)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 10;        
        
        wait for 395 us;

        assert ((configurado_tb = '1') and (alarme_tb = '0') and (tranca_tb = '1'))
        report "Teste 1 falhou para saída esperada colocando a senha correta" severity error;

      ---------------------------------------------------------------------
      --=================================================================--
      ---------------------------------------------------------------------

        reset_tb <= '1', '0' after clk_period/2;

        -- Teste 2: Sequência errando a senha e depois colocando a correta

        wait for clk_period * 60;  -- Aguarda estabilidade do clock e reset

        -- Início da etapa de configuração

        configurar_tb <= '1';
        wait for clk_period * 60;
        entrada_tb <= "0001"; -- Configurando tentativas (1)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "1010"; -- Primeiro dígito da senha (A)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0000"; -- Segundo dígito da senha (0)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0111"; -- Terceiro dígito da senha (7)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';

        -- Início da etapa de validação

        wait for clk_period * 60;

        configurar_tb <= '0';

        wait for clk_period * 60;

        entrada_tb <= "1000"; -- Primeiro dígito da senha (8)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0010"; -- Segundo dígito da senha (2)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "1100"; -- Terceiro dígito da senha (C)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 10; 

        wait for clk_period * 60;

        entrada_tb <= "1010"; -- Primeiro dígito da senha (A)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0000"; -- Segundo dígito da senha (0)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0111"; -- Terceiro dígito da senha (7)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';

        wait for 395 us;
        
        assert ((configurado_tb = '1') and (alarme_tb = '0') and (tranca_tb = '1'))
        report "Teste 2 falhou para saída esperada colocando a senha correta após tentativa falha" severity error;

      ---------------------------------------------------------------------
      --=================================================================--
      --------------------------------------------------------------------- 
        
        reset_tb <= '1', '0' after clk_period/2;

        -- Teste 3: sequência errando a senha e não colocando nenhuma senha nova

        wait for clk_period * 60;  -- Aguarda estabilidade do clock e reset

        -- Início da etapa de configuração

        configurar_tb <= '1';
        wait for clk_period * 60;
        entrada_tb <= "0001"; -- Configurando tentativas (1)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "1010"; -- Primeiro dígito da senha (A)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0000"; -- Segundo dígito da senha (0)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0111"; -- Terceiro dígito da senha (7)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';

        -- Início da etapa de validação

        wait for clk_period * 60;

        configurar_tb <= '0';

        wait for clk_period * 60;

        entrada_tb <= "1000"; -- Primeiro dígito da senha (8)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "0010"; -- Segundo dígito da senha (2)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 20;
        entrada_tb <= "1100"; -- Terceiro dígito da senha (C)
        wait for clk_period * 10;        
        valido_tb <= '0';
        wait for clk_period * 10;        
        valido_tb <= '1';
        wait for clk_period * 10;
        valido_tb <= '0';
        wait for clk_period * 10; 

        assert ((configurado_tb = '1') and (alarme_tb = '0') and (tranca_tb = '1'))
        report "Teste 3 falhou para saída esperada ao errar a senha e não tentar novamente" severity error;

        wait;

    end process test_case;
end tranca_digital;