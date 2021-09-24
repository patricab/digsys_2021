-- *****************************************************************************
-- Name:     pos_edge_detector_tb.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for an positive edge detector.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pos_edge_detector_tb is
end pos_edge_detector_tb;

architecture tb of pos_edge_detector_tb is  
  -- Constants
  constant CLK_PERIOD    : time := 10 ns;
  constant RESET_TIME    : time := 10 ns;

  -- Inputs
  signal clk             : std_logic := '0';
  signal reset_n         : std_logic := '0';
  signal x               : std_logic := '0';

  -- Outputs
  signal y               : std_logic;

begin
  -- DUT instantiation
  dut: entity work.pos_edge_detector
    port map (
      clk           => clk,
      reset_n       => reset_n,
      x             => x,
      y             => y);

  -- Clock generation
  clk <= not clk after CLK_PERIOD/2;

  -- Reset generation
  reset_proc: process
  begin
    wait for RESET_TIME;
    reset_n <= '1';
    wait;
  end process;

  -- Stimuli generation
  stimuli_proc: process
  begin
    wait for 10*CLK_PERIOD;
    x <= '0';
    wait for 2*CLK_PERIOD;
    x <= '1';
    wait for 2*CLK_PERIOD;
    x <= '0';
    wait for 2*CLK_PERIOD;
    x <= '1';
    wait for 2*CLK_PERIOD;
    x <= '0';
    wait for 2.5*CLK_PERIOD;
    x <= '1';
    wait;
  end process;

end tb;