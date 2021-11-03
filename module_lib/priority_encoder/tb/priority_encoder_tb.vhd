-- *****************************************************************************
-- Name:     priority_encoder_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a parameterisable priority encoder.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity priority_encoder_tb is
end priority_encoder_tb;

architecture tb of priority_encoder_tb is
  -- Constants
  constant OUTPUT_WIDTH : natural := 2;
  constant PERIOD       : time := 10 ns;

  -- Inputs
  signal x              : std_logic_vector(OUTPUT_WIDTH**2-1 downto 0) := (others => '0');

  -- Outputs
  signal y              : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
  signal valid          : std_logic;

begin
  -- DUT instantiation
  dut: entity work.priority_encoder
    generic map(
      OUTPUT_WIDTH => OUTPUT_WIDTH)
    port map (
      x           => x,
      y           => y,
      valid       => valid);

  -- Stimuli generation
  stimuli_proc: process
  begin
    wait for PERIOD;
    x <= "0000";
    wait for PERIOD;
    x <= "0001";
    wait for PERIOD;
    x <= "0010";
    wait for PERIOD;
    x <= "0011";
    wait for PERIOD;
    x <= "0100";
    wait for PERIOD;
    x <= "0101";
    wait for PERIOD;
    x <= "0110";
    wait for PERIOD;
    x <= "0111";
    wait for PERIOD;
    x <= "1000";
    wait for PERIOD;
    x <= "1001";
    wait for PERIOD;
    x <= "1010";
    wait for PERIOD;
    x <= "1011";
    wait for PERIOD;
    x <= "1100";
    wait for PERIOD;
    x <= "1101";
    wait for PERIOD;
    x <= "1110";
    wait for PERIOD;
    x <= "1111";
    wait for PERIOD;
    x <= "0000";
    wait;
  end process;

end tb;