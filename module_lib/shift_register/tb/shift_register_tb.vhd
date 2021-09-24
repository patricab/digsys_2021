-- *****************************************************************************
-- Name:     shift_register_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a positive edge triggered shift register with
--           asynchronous reset, active low.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register_tb is
end shift_register_tb;

architecture tb of shift_register_tb is  
  -- Constants
  constant REGISTER_WIDTH : natural := 8;
  constant CLK_PERIOD     : time := 10 ns;
  constant RESET_TIME     : time := 10 ns;

  -- Inputs
  signal clk              : std_logic := '0';
  signal reset_n          : std_logic := '0';
  signal d                : std_logic := '0';

  -- Outputs
  signal q                : std_logic_vector(REGISTER_WIDTH-1 downto 0);

begin
  -- DUT instantiation
  dut: entity work.shift_register
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
    d <= '1';
    wait for 10*CLK_PERIOD;
    d <= '0';
    wait for CLK_PERIOD;
    d <= '1';
    wait for CLK_PERIOD;
    d <= '0';
    wait for CLK_PERIOD;
    d <= '1';
    wait for CLK_PERIOD;
    d <= '0';
    wait for CLK_PERIOD;
    d <= '1';
    wait for CLK_PERIOD;
    d <= '0';
    wait for CLK_PERIOD;
    d <= '1';
    wait for CLK_PERIOD;
    d <= '0';
    wait for CLK_PERIOD;
    d <= '1';
    wait for CLK_PERIOD;
    d <= '1';
    wait;
  end process;

end tb;