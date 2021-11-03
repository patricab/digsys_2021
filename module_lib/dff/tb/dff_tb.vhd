-- *****************************************************************************
-- Name:     dff_tb.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a single positive edge triggered flip flop.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dff_tb is
end dff_tb;

architecture tb of dff_tb is  
  -- Constants
  constant CLK_PERIOD    : time := 10 ns;

  -- Inputs
  signal clk             : std_logic := '0';
  signal d               : std_logic := '0';

  -- Outputs
  signal q               : std_logic;

begin
  -- DUT instantiation
  dut: entity work.dff
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
    d <= '0';
    wait for 2*CLK_PERIOD;
    d <= '1';
    wait for 2*CLK_PERIOD;
    d <= '0';
    wait for 2*CLK_PERIOD;
    d <= '1';
    wait for 2*CLK_PERIOD;
    d <= '0';
    wait for 2.5*CLK_PERIOD;
    d <= '1';
    wait;
  end process;

end tb;