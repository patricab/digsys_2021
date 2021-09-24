-- *****************************************************************************
-- Name:     mux4x1_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a four input mux with an input bit width of 1.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4x1_tb is
end mux4x1_tb;

architecture tb of mux4x1_tb is
  -- Constants
  constant PERIOD      : time := 10 ns;

  -- Inputs
  signal a             : std_logic := '0';
  signal b             : std_logic := '0';
  signal c             : std_logic := '0';
  signal d             : std_logic := '0';
  signal sel           : std_logic_vector(1 downto 0) := (others => '0');

  -- Outputs
  signal y             : std_logic;

begin
  -- DUT instantiation
  dut: entity work.mux4x1
    port map (
      a           => a,
      b           => b,
      c           => c,
      d           => d,
      sel         => sel,
      y           => y);

  -- Stimuli generation
  stimuli_proc: process
  begin
    wait for PERIOD;
    a   <= '0';
    b   <= '0';
    c   <= '0';
    d   <= '0';
    sel <= "00";
    wait for PERIOD;
    sel <= "01";
    wait for PERIOD;
    sel <= "10";
    wait for PERIOD;
    sel <= "11";
    wait for PERIOD;
    a   <= '1';
    b   <= '1';
    c   <= '1';
    d   <= '1';
    sel <= "00";
    wait for PERIOD;
    sel <= "01";
    wait for PERIOD;
    sel <= "10";
    wait for PERIOD;
    sel <= "11";
    wait for PERIOD;
    a   <= '0';
    b   <= '0';
    c   <= '0';
    d   <= '0';
    sel <= "00";
    wait;
  end process;

end tb;