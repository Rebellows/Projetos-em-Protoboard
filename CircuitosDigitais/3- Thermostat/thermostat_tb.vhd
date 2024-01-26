library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity thermostat_tb is
end thermostat_tb;

architecture tb of thermostat_tb is
  component thermostat
    port (
      current_temp   : in std_logic_vector(7 downto 0);
      desired_temp   : in std_logic_vector(7 downto 0);
      display_select : in std_logic;
      temp_display   : out std_logic_vector(7 downto 0);
      heat           : in std_logic;
      cool           : in std_logic;
      clock          : in std_logic;
      reset          : in std_logic;
      ac_ready       : in std_logic;
      furnace_hot    : in std_logic;
      fan_on         : in std_logic;
      furnace_on     : out std_logic;
      ac_on          : out std_logic
    );
  end component;

  signal current_temp, desired_temp, temp_display      : std_logic_vector(7 downto 0);
  signal display_select, heat, cool, ac_on, furnace_on : std_logic;
  signal clock, reset, ac_ready, furnace_hot, fan_on   : std_logic := '0';

begin

  clock <= not clock after 5 ns;

  UUT: thermostat
    port map (
      clock          => clock,
      reset          => reset,
      current_temp   => current_temp,
      desired_temp   => desired_temp,
      display_select => display_select,
      temp_display   => temp_display,
      heat           => heat,
      cool           => cool,
      ac_ready       => ac_ready,
      furnace_hot    => furnace_hot,
      fan_on         => fan_on,
      ac_on          => ac_on,
      furnace_on     => furnace_on
    );

  process
  begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;
    current_temp <= "00000000";
    desired_temp <= "11111111";
    display_select <= '0';
    wait for 10 ns;
    display_select <= '1';
    wait for 10 ns;
    heat <= '1';
    wait for 10 ns;
    heat <= '0';
    wait for 10 ns;
    current_temp <= "10000000";
    desired_temp <= "01000000";
    wait for 10 ns;
    cool <= '1';
    wait for 10 ns;
    cool <= '0';
    wait for 10 ns;
    wait;
  end process;
end tb;

