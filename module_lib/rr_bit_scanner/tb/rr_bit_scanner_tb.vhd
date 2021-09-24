-- *****************************************************************************
-- Name:     rr_bit_scanner_tb.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a two input mux with an input bit width of 1.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rr_bit_scanner_tb is
end rr_bit_scanner_tb;

architecture tb of rr_bit_scanner_tb is
  -- Constants
  constant CLK_PERIOD  : time    := 10 ns;
  constant RESET_TIME  : time    := 10 ns;
  constant N           : natural := 4;

  -- Inputs
  signal clk           : std_logic := '0';
  signal reset_n       : std_logic := '0';
  signal req           : std_logic_vector(N-1 downto 0) := (others => '0');

  -- Outputs
  signal gnt           : std_logic_vector(N-1 downto 0);

begin
  -- DUT instantiation
  dut: entity work.rr_bit_scanner(rtl_no_mux)
    generic map (
      N   => N)
    port map (
      clk     => clk,
      reset_n => reset_n,
      req     => req,
      gnt     => gnt);
      
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
    req <= x"0";
    wait for CLK_PERIOD;
    req <= x"1";
    wait for CLK_PERIOD;
    req <= x"2";
    wait for CLK_PERIOD;
    req <= x"3";
    wait for CLK_PERIOD;
    req <= x"4";
    wait for CLK_PERIOD;
    req <= x"5";
    wait for CLK_PERIOD;
    req <= x"6";
    wait for CLK_PERIOD;
    req <= x"7";
    wait for CLK_PERIOD;
    req <= x"8";
    wait for CLK_PERIOD;
    req <= x"9";
    wait for CLK_PERIOD;
    req <= x"A";
    wait for CLK_PERIOD;
    req <= x"B";
    wait for CLK_PERIOD;
    req <= x"C";
    wait for CLK_PERIOD;
    req <= x"D";
    wait for CLK_PERIOD;
    req <= x"E";
    wait for CLK_PERIOD;
    req <= x"F";
    wait;
  end process;

end tb;