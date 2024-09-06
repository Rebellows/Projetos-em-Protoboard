library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port( 
    clock, reset       : in std_logic;
    stop, split, start : in std_logic;
    an, dec_ddp        : out std_logic_vector(7 downto 0)
  );
end top;

architecture arch_top of top is
  signal clock1cs, out_250ms            : std_logic;
  signal enable, do_split               : std_logic;
  signal centsec, hour                  : std_logic_vector(7 downto 0);
  signal second, minute                 : std_logic_vector(6 downto 0);
  signal deb_stop, deb_reset            : std_logic;
  signal deb_split, deb_start           : std_logic;
  signal d1, d2, d3, d4, d5, d6, d7, d8 : std_logic_vector(5 downto 0);
  signal fsm_state                      : std_logic_vector(2 downto 0);
begin

  debounce_stop : entity work.debounce
    generic map (DELAY => 300000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => stop,
      debkey_o => deb_stop
    );

    debounce_split : entity work.debounce
    generic map (DELAY => 300000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => split,
      debkey_o => deb_split
    );

    debounce_start : entity work.debounce
    generic map (DELAY => 300000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => start,
      debkey_o => deb_start
    );


  clock_div_inst : entity work.clock_divider
    port map (
      clock      => clock,
      reset      => reset,
      clock1cs   => clock1cs,
      out_250ms  => out_250ms
    );

  fsm_inst : entity work.fsm
    port map (
      clock     => clock,
      reset     => reset,
      start     => deb_start,
      stop      => deb_stop,
      split     => deb_split,
      enable    => enable,
      do_split  => do_split,
      fsm_state => fsm_state
    );

  time_counters_inst : entity work.time_counters
    port map (
      clock1cs  => clock1cs,
      reset     => reset,
      enable    => enable,
      do_split  => do_split,
      centsec   => centsec,
      second    => second,
      minute    => minute,
      hour      => hour
    );


  process (reset, clock)
  begin
      if reset = '1' then
          d1 <= (others => '0');
          d2 <= (others => '0');
          d3 <= (others => '0');
          d4 <= (others => '0');
          d5 <= (others => '0');
          d6 <= (others => '0');
          d7 <= (others => '0');
          d8 <= (others => '0');
      elsif rising_edge(clock) then
          if (fsm_state = "101" or fsm_state = "110") then
              if (out_250ms = '0') then
                  d1 <= ('0' & centsec(3 downto 0) & '1');
                  d2 <= ('0' & centsec(7 downto 4) & '1');
                  d3 <= ('0' & second(3 downto 0) & '1');
                  d4 <= ('0' & '0' & second(6 downto 4) & '1');
                  d5 <= ('0' & minute(3 downto 0) & '1');
                  d6 <= ('0' & '0' & minute(6 downto 4) & '1');
                  d7 <= ('0' & hour(3 downto 0) & '1');
                  d8 <= ('0' & hour(7 downto 4) & '1');
              else 
                  d1 <= ('1' & centsec(3 downto 0) & '1');
                  d2 <= ('1' & centsec(7 downto 4) & '1');
                  d3 <= ('1' & second(3 downto 0) & '1');
                  d4 <= ('1' & '0' & second(6 downto 4) & '1');
                  d5 <= ('1' & minute(3 downto 0) & '1');
                  d6 <= ('1' & '0' & minute(6 downto 4) & '1');
                  d7 <= ('1' & hour(3 downto 0) & '1');
                  d8 <= ('1' & hour(7 downto 4) & '1');         
              end if;
          else
              d1 <= ('1' & centsec(3 downto 0) & '1');
              d2 <= ('1' & centsec(7 downto 4) & '1');
              d3 <= ('1' & second(3 downto 0) & '1');
              d4 <= ('1' & '0' & second(6 downto 4) & '1');
              d5 <= ('1' & minute(3 downto 0) & '1');
              d6 <= ('1' & '0' & minute(6 downto 4) & '1');
              d7 <= ('1' & hour(3 downto 0) & '1');
              d8 <= ('1' & hour(7 downto 4) & '1');    
          end if;     
      end if;
  end process;
  
--  d1 <= ('0' & centsec(3 downto 0) & '1') when (fsm_state = "101" or fsm_state = "110") and out_250ms = '0' else ('1' & centsec(3 downto 0) & '1');
--  d2 <= ('0' & centsec(7 downto 4) & '1') when (fsm_state = "101" or fsm_state = "110") and out_250ms = '0' else ('1' & centsec(7 downto 4) & '1');
--  d3 <= ('0' & second(3 downto 0) & '1') when (fsm_state = "101" or fsm_state = "110") and out_250ms = '0' else ('1' & second(3 downto 0) & '1');
--  d4 <= ('0' & '0' & second(6 downto 4) & '1') when (fsm_state = "101" or fsm_state = "110") and out_250ms = '0' else ('1' & '0' & second(6 downto 4) & '1');
--  d5 <= ('0' & minute(3 downto 0) & '1') when (fsm_state = "101" or fsm_state = "110") and out_250ms = '0' else ('1' & minute(3 downto 0) & '1');
--  d6 <= ('0' & '0' & minute(6 downto 4) & '1') when (fsm_state = "101" or fsm_state = "110") and out_250ms = '0' else ('1' & '0' & minute(6 downto 4) & '1');
--  d7 <= ('0' & hour(3 downto 0) & '1') when (fsm_state = "101" or fsm_state = "110") and out_250ms = '0' else ('1' & hour(3 downto 0) & '1');
--  d8 <= ('0' & hour(7 downto 4) & '1') when (fsm_state = "101" or fsm_state = "110") and out_250ms = '0' else ('1' & hour(7 downto 4) & '1'); 

  dspl_drv_inst : entity work.dspl_drv_8dig
    port map (
      clock    => clock,
      reset    => reset,
      d1       => d1,
      d2       => d2,
      d3       => d3,
      d4       => d4,
      d5       => d5,
      d6       => d6,
      d7       => d7,
      d8       => d8,
      an       => an,
      dec_ddp  => dec_ddp
    );

end arch_top;