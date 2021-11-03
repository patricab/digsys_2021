-- *****************************************************************************
-- Name:     adder_tree_comb_tb.vhd   
-- Created:  13.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a combinational adder tree.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.arraypackage.all;

entity adder_tree_comb_tb is
end adder_tree_comb_tb;

architecture tb of adder_tree_comb_tb is
  -- Constants
  constant PERIOD  : time := 10 ns;

  -- Inputs
  signal numbers_a : slv16_array(0 to 15);

  -- Outputs
  signal sum       : std_logic_vector(19 downto 0);

begin
  -- DUT instantiation
  dut: entity work.adder_tree_comb(rtl_verbose)
    port map (
      numbers_a     => numbers_a,
      sum           => sum);

  -- Stimuli generation
  stimuli_proc: process
  begin
    numbers_a <= (others => (others => '0'));
    wait for PERIOD;
    numbers_a(0) <= x"FFFF";
    wait for PERIOD;
    numbers_a(1) <= x"FFFF";
    wait for PERIOD;
    numbers_a(2) <= x"FFFF";
    wait for PERIOD;
    numbers_a(3) <= x"FFFF";
    wait for PERIOD;
    numbers_a(4) <= x"FFFF";
    wait for PERIOD;
    numbers_a(5) <= x"FFFF";
    wait for PERIOD;
    numbers_a(6) <= x"FFFF";
    wait for PERIOD;
    numbers_a(7) <= x"FFFF";
    wait for PERIOD;
    numbers_a(8) <= x"FFFF";
    wait for PERIOD;
    numbers_a(9) <= x"FFFF";
    wait for PERIOD;
    numbers_a(10) <= x"FFFF";
    wait for PERIOD;
    numbers_a(11) <= x"FFFF";
    wait for PERIOD;
    numbers_a(12) <= x"FFFF";
    wait for PERIOD;
    numbers_a(13) <= x"FFFF";
    wait for PERIOD;
    numbers_a(14) <= x"FFFF";
    wait for PERIOD;
    numbers_a(15) <= x"FFFF";
    wait;
  end process;

end tb;