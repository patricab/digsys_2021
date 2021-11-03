-- *****************************************************************************
-- Name:     dff_clr_tb.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a single positive edge triggered flip flop with
--           synchronous reset.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dff_clr_tb is
end dff_clr_tb;

architecture tb of dff_clr_tb is  
  -- Constants
  constant CLK_PERIOD    : time := 10 ns;
  constant CLR_TIME      : time := 10 ns;

  -- Inputs
  signal clk             : std_logic := '0';
  signal reset_n         : std_logic := '0';
  signal d               : std_logic := '0';

  -- Outputs
  signal q               : std_logic;

begin
  -- DUT instantiation
  dut: entity work.dff_clr
    port map (
      clk           => clk,
      reset_n       => reset_n,
      d             => d,
      q             => q);

  -- Clock generation
  clk <= not clk after CLK_PERIOD/2;

  -- clr generation
  clr_proc: process
  begin
    wait for CLR_TIME;
    reset_n <= '1';
    wait for 25*CLK_PERIOD;
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