-- *****************************************************************************
-- Name:     adder_tree_pipelined_tb.vhd   
-- Created:  13.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a pipelined adder tree.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.arraypackage.all;

entity adder_tree_pipelined_tb is
end adder_tree_pipelined_tb;

architecture tb of adder_tree_pipelined_tb is
  -- Constants
  constant CLK_PERIOD  : time := 10 ns;
  constant RESET_TIME    : time := 10 ns;

  -- Inputs
  signal clk           : std_logic := '0';
  signal reset_n       : std_logic := '0';
  signal numbers_a     : slv16_array(0 to 15);

  -- Outputs
  signal sum           : std_logic_vector(19 downto 0);

begin
  -- DUT instantiation
  dut: entity work.adder_tree_pipelined
    port map (
      clk           => clk,
      reset_n       => reset_n,
      numbers_a     => numbers_a,
      sum           => sum);

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
    numbers_a <= (others => (others => '0'));
    wait for CLK_PERIOD;
    numbers_a(0) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(1) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(2) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(3) <= x"0001";
    wait for 5*CLK_PERIOD;
    numbers_a(4) <= x"0001";
    numbers_a(5) <= x"0001";
    numbers_a(6) <= x"0001";
    numbers_a(7) <= x"0001";
    wait for 2*CLK_PERIOD;
    numbers_a(8) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(9) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(10) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(11) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(12) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(13) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(14) <= x"0001";
    wait for CLK_PERIOD;
    numbers_a(15) <= x"0001";
    wait for 2*CLK_PERIOD;
    numbers_a <= (others => (others => '1'));
    wait;
  end process;

end tb;