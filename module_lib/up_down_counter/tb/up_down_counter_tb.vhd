-- *****************************************************************************
-- Name:     up_down_counter_tb.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for an up/down counter.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_down_counter_tb is
end up_down_counter_tb;

architecture tb of up_down_counter_tb is  
  -- Constants
  constant COUNTER_WIDTH : natural := 8;
  constant CLK_PERIOD    : time := 10 ns;
  constant RESET_TIME    : time := 10 ns;

  -- Inputs
  signal clk             : std_logic := '0';
  signal reset_n         : std_logic := '0';
  signal cnt_en          : std_logic := '1';
  signal cnt_up          : std_logic := '1';

  -- Outputs
  signal y               : std_logic_vector(COUNTER_WIDTH-1 downto 0);

begin
  -- DUT instantiation
  -- Choose between architectures rtl_alt1, rtl_alt2 and rtl_alt3
  dut: entity work.up_down_counter(rtl_alt1)
    generic map (
      COUNTER_WIDTH => COUNTER_WIDTH)
    port map (
      clk           => clk,
      reset_n       => reset_n,
      cnt_en        => cnt_en,
      cnt_up        => cnt_up,
      y             => y);

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
    wait for 10*CLK_PERIOD;
    cnt_en <= '0';
    wait for 2*CLK_PERIOD;
    cnt_en <= '1';
    wait for 2*CLK_PERIOD;
    cnt_up <= '0';
    wait for 5*CLK_PERIOD;
    cnt_en <= '0';
    wait for 2*CLK_PERIOD;
    cnt_en <= '1';
    wait;
  end process;

end tb;