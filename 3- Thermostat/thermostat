library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity thermostat is
    port (
        current_temp   : in  std_logic_vector(7 downto 0);
        desired_temp   : in  std_logic_vector(7 downto 0);
        temp_display   : out std_logic_vector(7 downto 0);
        display_select : in  std_logic;
        heat           : in  std_logic;
        cool           : in  std_logic;
        clock          : in  std_logic;
        reset          : in  std_logic;
        ac_ready       : in  std_logic;
        furnace_hot    : in  std_logic;
        fan_on         : in  std_logic;
        furnace_on     : out std_logic;
        ac_on          : out std_logic
    );
end thermostat;

architecture RTL of thermostat is

    signal reg_current_temp    : std_logic_vector(7 downto 0);
    signal reg_desired_temp    : std_logic_vector(7 downto 0);
    signal reg_display_select  : std_logic;
    signal reg_heat            : std_logic;
    signal reg_cool            : std_logic;
    signal reg_furnace_hot     : std_logic;
    signal reg_fan_on          : std_logic;
    signal reg_ac_ready        : std_logic;

    type states is (IDLE, COOLON, HEATON, ACNOWREADY, ACDONE, FURNACENOWHOT, FURNACECOOL);
    signal EA, PE: states;

begin

    process (clock, reset)
    begin
        if reset = '1' then
            EA <= IDLE;
        elsif rising_edge(clock) then
            EA <= PE;
        end if;
    end process;

    process (EA, reg_current_temp, reg_desired_temp, reg_heat, reg_cool, reg_furnace_hot, reg_fan_on, reg_ac_ready)
    begin
        case EA is

            when IDLE =>
                if (reg_current_temp < reg_desired_temp) and reg_heat = '1' then
                    PE <= HEATON;
                elsif (reg_current_temp > reg_desired_temp) and reg_cool = '1' then
                    PE <= COOLON;
                else
                    PE <= IDLE;
                    furnace_on <= '0';
                    ac_on <= '0';
                    fan_on <= '0';
                end if;

            when COOLON =>
                if reg_ac_ready = '1' then
                    PE <= ACNOWREADY;
                else
                    PE <= COOLON;
                    furnace_on <= '0';
                    ac_on <= '1';
                    fan_on <= '0';
                end if;

            when ACNOWREADY =>
                if not ((reg_current_temp > reg_desired_temp) and reg_cool = '1') then
                    PE <= ACDONE;
                else
                    PE <= ACNOWREADY;
                    furnace_on <= '0';
                    ac_on <= '1';
                    fan_on <= '1';
                end if;

            when ACDONE =>
                if reg_ac_ready = '0' then
                    PE <= IDLE;
                else
                    PE <= ACDONE;
                    furnace_on <= '0';
                    ac_on <= '0';
                    fan_on <= '1';
                end if;

            when HEATON =>
                if reg_furnace_hot = '1' then
                    PE <= FURNACENOWHOT;
                else
                    PE <= HEATON;
                    furnace_on <= '1';
                    ac_on <= '0';
                    fan_on <= '0';
                end if;

            when FURNACENOWHOT =>
                if not ((reg_current_temp < reg_desired_temp) and reg_heat = '1') then
                    PE <= FURNACECOOL;
                else
                    PE <= FURNACENOWHOT;
                    furnace_on <= '1';
                    ac_on <= '0';
                    fan_on <= '1';
                end if;

            when FURNACECOOL =>
                if reg_furnace_hot = '0' then
                    PE <= IDLE;
                else
                    PE <= FURNACECOOL;
                    furnace_on <= '0';
                    ac_on <= '0';
                    fan_on <= '1';
                end if;

        end case;
    end process;

end RTL;
