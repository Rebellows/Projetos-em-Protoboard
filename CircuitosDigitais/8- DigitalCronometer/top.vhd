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
begin

  debounce_stop : entity work.debounce
    generic map (DELAY => 500000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => stop,
      debkey_o => deb_stop
    );

    debounce_split : entity work.debounce
    generic map (DELAY => 500000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => split,
      debkey_o => deb_split
    );

    debounce_reset : entity work.debounce
    generic map (DELAY => 500000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => reset,
      debkey_o => deb_reset
    );

    debounce_start : entity work.debounce
    generic map (DELAY => 500000)
    port map (
      clk_i    => clock,
      rstn_i   => reset,
      key_i    => start,
      debkey_o => deb_start
    );


  clock_div_inst : entity work.clock_divider
    port map (
      clock      => clock,
      reset      => deb_reset,
      clock1cs   => clock1cs,
      out_250ms  => out_250ms
    );

  fsm_inst : entity work.fsm
    port map (
      clock     => clock,
      reset     => deb_reset,
      start     => deb_start,
      stop      => deb_stop,
      split     => deb_split,
      enable    => enable,
      do_split  => do_split
    );

  time_counters_inst : entity work.time_counters
    port map (
      clock1cs  => clock1cs,
      reset     => deb_reset,
      enable    => enable,
      do_split  => do_split,
      in_250ms  => out_250ms,
      centsec   => centsec,
      second    => second,
      minute    => minute,
      hour      => hour
    );

  d1 <= ('1' & centsec(3 downto 0) & '1');
  d2 <= ('1' & centsec(7 downto 4) & '1');
  d3 <= ('1' & second(3 downto 0) & '1');
  d4 <= ('1' & second(6 downto 4) & '1');
  d5 <= ('1' & minute(3 downto 0) & '1');
  d6 <= ('1' & minute(6 downto 4) & '1');
  d7 <= ('1' & hour(3 downto 0) & '1');
  d8 <= ('1' & hour(7 downto 4) & '1'); 

  dspl_drv_inst : entity work.dspl_drv_8dig
    port map (
      clock    => clock,
      reset    => deb_reset,
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
