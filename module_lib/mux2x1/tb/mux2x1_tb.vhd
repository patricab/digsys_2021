-- *****************************************************************************
-- Name:     mux2x1_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a two input mux with an input bit width of 1.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2x1_tb is
end mux2x1_tb;

architecture tb of mux2x1_tb is
  -- Constants
  constant PERIOD      : time := 10 ns;

  -- Inputs
  signal a             : std_logic := '0';
  signal b             : std_logic := '0';
  signal sel           : std_logic := '0';

  -- Outputs
  signal y             : std_logic;

begin
  -- DUT instantiation
  dut: entity work.mux2x1
    port map (
      a           => a,
      b           => b,
      sel         => sel,
      y           => y);

  -- Stimuli generation
  stimuli_proc: process
  begin
    wait for PERIOD;
    a   <= '0';
    b   <= '0';
    sel <= '0';
    wait for PERIOD;
    a   <= '0';
    b   <= '0';
    sel <= '1';
    wait for PERIOD;
    a   <= '0';
    b   <= '1';
    sel <= '1';
    wait for PERIOD;
    a   <= '1';
    b   <= '0';
    sel <= '0';
    wait for PERIOD;
    a   <= '0';
    b   <= '0';
    sel <= '0';
    wait for PERIOD;
    a   <= '0';
    b   <= '1';
    sel <= '0';
    wait;
  end process;

end tb;