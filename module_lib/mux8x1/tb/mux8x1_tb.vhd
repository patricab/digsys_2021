-- *****************************************************************************
-- Name:     mux8x1_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for an eight input mux with an input bit width of 1.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8x1_tb is
end mux8x1_tb;

architecture tb of mux8x1_tb is
  -- Constants
  constant PERIOD      : time := 10 ns;

  -- Inputs
  signal a             : std_logic := '0';
  signal b             : std_logic := '0';
  signal c             : std_logic := '0';
  signal d             : std_logic := '0';
  signal e             : std_logic := '0';
  signal f             : std_logic := '0';
  signal g             : std_logic := '0';
  signal h             : std_logic := '0';
  signal sel           : std_logic_vector(2 downto 0) := "000";

  -- Outputs
  signal y             : std_logic;

begin
  -- DUT instantiation
  dut: entity work.mux8x1
    port map (
      a           => a,
      b           => b,
      c           => c,
      d           => d,
      e           => e,
      f           => f,
      g           => g,
      h           => h,
      sel         => sel,
      y           => y);

  -- Stimuli generation
  stimuli_proc: process
  begin  -- worst test ever
    wait for PERIOD;
    sel <= "000";
    wait for PERIOD;
    sel <= "001";
    wait for PERIOD;
    sel <= "010";
    wait for PERIOD;
    sel <= "011";
    wait for PERIOD;
    sel <= "100";
    wait for PERIOD;
    sel <= "101";
    wait for PERIOD;
    sel <= "110";
    wait for PERIOD;
    sel <= "111";
    wait for PERIOD;
    a   <= '1';
    b   <= '1';
    c   <= '1';
    d   <= '1';
    e   <= '1';
    f   <= '1';
    g   <= '1';
    h   <= '1';
    sel <= "000";
    wait for PERIOD;
    sel <= "001";
    wait for PERIOD;
    sel <= "010";
    wait for PERIOD;
    sel <= "011";
    wait for PERIOD;
    sel <= "100";
    wait for PERIOD;
    sel <= "101";
    wait for PERIOD;
    sel <= "110";
    wait for PERIOD;
    sel <= "111";
    wait;
  end process;

end tb;