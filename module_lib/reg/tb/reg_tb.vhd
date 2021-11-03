-- *****************************************************************************
-- Name:     reg_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a positive edge triggered register.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_tb is
end reg_tb;

architecture tb of reg_tb is  
  -- Constants
  constant REGISTER_WIDTH : natural := 8;
  constant CLK_PERIOD     : time := 10 ns;

  -- Inputs
  signal clk              : std_logic := '0';
  signal d                : std_logic_vector(REGISTER_WIDTH-1 downto 0) := (others => '0');

  -- Outputs
  signal q                : std_logic_vector(REGISTER_WIDTH-1 downto 0);

begin
  -- DUT instantiation
  dut: entity work.reg
    port map (
      clk           => clk,
      d             => d,
      q             => q);

  -- Clock generation
  clk <= not clk after CLK_PERIOD/2;

  -- Stimuli generation
  stimuli_proc: process
  begin
    wait for 10*CLK_PERIOD;
    d <= x"00";
    wait for 2*CLK_PERIOD;
    d <= x"11";
    wait for 2*CLK_PERIOD;
    d <= x"00";
    wait for 2*CLK_PERIOD;
    d <= x"FF";
    wait for 2*CLK_PERIOD;
    d <= x"AA";
    wait for 2.5*CLK_PERIOD;
    d <= x"00";
    wait;
  end process;

end tb;