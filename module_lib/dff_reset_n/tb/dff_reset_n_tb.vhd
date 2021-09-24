-- *****************************************************************************
-- Name:     dff_reset_n_tb.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a single positive edge triggered flip flop with
--           asynchronous reset, active low.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dff_reset_n_tb is
end dff_reset_n_tb;

architecture tb of dff_reset_n_tb is  
  -- Constants
  constant CLK_PERIOD    : time := 10 ns;
  constant RESET_TIME    : time := 10 ns;

  -- Inputs
  signal clk             : std_logic := '0';
  signal reset_n         : std_logic := '0';
  signal d               : std_logic := '0';

  -- Outputs
  signal q               : std_logic;

begin
  -- DUT instantiation
  dut: entity work.dff_reset_n
    port map (
      clk           => clk,
      reset_n       => reset_n,
      d             => d,
      q             => q);

  -- Clock generation
  clk <= not clk after CLK_PERIOD/2;

  -- Reset generation
  reset_proc: process
  begin
    wait for RESET_TIME;
    reset_n <= '1';
    wait for 20*CLK_PERIOD;
    reset_n <= '0';
    wait for 2*CLK_PERIOD;
    reset_n <= '1';
    wait;
  end process;

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