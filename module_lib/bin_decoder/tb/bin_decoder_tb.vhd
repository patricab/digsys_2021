-- *****************************************************************************
-- Name:     bin_decoder_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a parameterisable binary decoder.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_decoder_tb is
end bin_decoder_tb;

architecture tb of bin_decoder_tb is
  -- Constants
  constant INPUT_WIDTH : natural := 2;
  constant PERIOD      : time := 10 ns;

  -- Inputs
  signal x             : std_logic_vector(INPUT_WIDTH-1 downto 0) := (others => '0');

  -- Outputs
  signal y             : std_logic_vector((INPUT_WIDTH**2)-1 downto 0);

begin
  -- DUT instantiation
  dut: entity work.bin_decoder
    generic map(
      INPUT_WIDTH => INPUT_WIDTH)
    port map (
      x           => x,
      y           => y);

  -- Stimuli generation
  stimuli_proc: process
  begin
    wait for PERIOD;
    x <= "00";
    wait for PERIOD;
    x <= "01";
    wait for PERIOD;
    x <= "10";
    wait for PERIOD;
    x <= "11";
    wait for PERIOD;
    x <= "00";
    wait;
  end process;

end tb;