-- *****************************************************************************
-- Name:     bit_scanner_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a two input mux with an input bit width of 1.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bit_scanner_tb is
end bit_scanner_tb;

architecture tb of bit_scanner_tb is
  -- Constants
  constant PERIOD      : time    := 10 ns;
  constant N           : natural := 4;

  -- Inputs
  signal req           : std_logic_vector(N-1 downto 0) := (others => '0');

  -- Outputs
  signal gnt           : std_logic_vector(N-1 downto 0);

begin
  -- DUT instantiation
  dut: entity work.bit_scanner(rtl_signed)
    generic map (
      N   => N)
    port map (
      req => req,
      gnt => gnt);

  -- Stimuli generation
  stimuli_proc: process
  begin
    req <= x"0";
    wait for PERIOD;
    req <= x"1";
    wait for PERIOD;
    req <= x"2";
    wait for PERIOD;
    req <= x"3";
    wait for PERIOD;
    req <= x"4";
    wait for PERIOD;
    req <= x"5";
    wait for PERIOD;
    req <= x"6";
    wait for PERIOD;
    req <= x"7";
    wait for PERIOD;
    req <= x"8";
    wait for PERIOD;
    req <= x"9";
    wait for PERIOD;
    req <= x"A";
    wait for PERIOD;
    req <= x"B";
    wait for PERIOD;
    req <= x"C";
    wait for PERIOD;
    req <= x"D";
    wait for PERIOD;
    req <= x"E";
    wait for PERIOD;
    req <= x"F";
    wait;
  end process;

end tb;