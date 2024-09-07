library IEEE; -- last version
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
  signal centsec, hour                  : std_logic_vector(6 downto 0);
  signal second, minute                 : std_logic_vector(6 downto 0);
  signal deb_stop, deb_reset            : std_logic;
  signal deb_split, deb_start           : std_logic;
  signal d1, d2, d3, d4, d5, d6, d7, d8 : std_logic_vector(5 downto 0);
  signal centsec_low, centsec_high      : std_logic_vector(3 downto 0);
  signal hour_low, hour_high            : std_logic_vector(3 downto 0);
  signal minute_low, minute_high        : std_logic_vector(3 downto 0);
  signal second_low, second_high        : std_logic_vector(3 downto 0);
begin

  debounce_stop : entity work.debounce
    generic map (DELAY => 750000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => stop,
      debkey_o => deb_stop
    );

  debounce_split : entity work.debounce
    generic map (DELAY => 750000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => split,
      debkey_o => deb_split
    );

  debounce_start : entity work.debounce
    generic map (DELAY => 750000)
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
      out_250ms  => out_250ms,
      do_split   => do_split
    );

  fsm_inst : entity work.fsm
    port map (
      clock     => clock,
      reset     => reset,
      start     => deb_start,
      stop      => deb_stop,
      split     => deb_split,
      enable    => enable,
      do_split  => do_split
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

  converter_centsec : entity work.counters_converter
    port map (
      clock1cs     => clock1cs,
      reset        => reset,
      enable       => enable,
      do_split     => do_split,
      flag_type    => '0',
      counter      => centsec,
      counter_low  => centsec_low,
      counter_high => centsec_high
    );

  converter_hour : entity work.counters_converter
    port map (
      clock1cs     => clock1cs,
      reset        => reset,
      enable       => enable,     
      do_split     => do_split,
      flag_type    => '0',
      counter      => hour,
      counter_low  => hour_low,
      counter_high => hour_high
    );

  converter_minute : entity work.counters_converter
    port map (
      clock1cs     => clock1cs,
      reset        => reset,
      enable       => enable,
      do_split     => do_split,
      flag_type    => '1',
      counter      => minute,
      counter_low  => minute_low,
      counter_high => minute_high
    );

  converter_second : entity work.counters_converter
    port map (
      clock1cs     => clock1cs,
      reset        => reset,
      enable       => enable,
      do_split     => do_split,
      flag_type    => '1',
      counter      => second,
      counter_low  => second_low,
      counter_high => second_high
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
          if (do_split = '1') then
              if (out_250ms = '0') then
                  d1 <= ('0' & centsec_low & '1');
                  d2 <= ('0' & centsec_high & '1');
                  d3 <= ('0' & second_low & '1');
                  d4 <= ('0' & second_high & '1');
                  d5 <= ('0' & minute_low & '1');
                  d6 <= ('0' & minute_high & '1');
                  d7 <= ('0' & hour_low & '1');
                  d8 <= ('0' & hour_high & '1');
              else 
                  d1 <= ('1' & centsec_low & '1');
                  d2 <= ('1' & centsec_high & '1');
                  d3 <= ('1' & second_low & '1');
                  d4 <= ('1' & second_high & '1');
                  d5 <= ('1' & minute_low & '1');
                  d6 <= ('1' & minute_high & '1');
                  d7 <= ('1' & hour_low & '1');
                  d8 <= ('1' & hour_high & '1');     
              end if;
          else
              d1 <= ('1' & centsec_low & '1');
              d2 <= ('1' & centsec_high & '1');
              d3 <= ('1' & second_low & '1');
              d4 <= ('1' & second_high & '1');
              d5 <= ('1' & minute_low & '1');
              d6 <= ('1' & minute_high & '1');
              d7 <= ('1' & hour_low & '1');
              d8 <= ('1' & hour_high & '1');      
          end if;     
      end if;
  end process;

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