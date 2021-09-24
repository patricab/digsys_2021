-- *****************************************************************************
-- Name:     fifo_tb.vhd   
-- Created:  02.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a FIFO.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_tb is
end fifo_tb;

architecture tb of fifo_tb is  
  -- Constants
  constant FIFO_DEPTH     : natural := 8;
  constant FIFO_WIDTH     : natural := 8;
  constant CLK_PERIOD     : time := 10 ns;
  constant RESET_TIME     : time := 10 ns;

  -- Inputs
  signal clk              : std_logic := '0';
  signal reset_n          : std_logic := '0';
  signal rd               : std_logic;
  signal wr               : std_logic;
  signal d_in             : std_logic_vector(FIFO_WIDTH-1 downto 0);

  -- Outputs
  signal full             : std_logic;
  signal empty            : std_logic;
  signal d_out            : std_logic_vector(FIFO_WIDTH-1 downto 0);

begin
  -- DUT instantiation
  dut: entity work.fifo(rtl_block_ram_no_d1)
    generic map (
      FIFO_DEPTH    => FIFO_DEPTH,
      FIFO_WIDTH    => FIFO_WIDTH)
    port map (
      clk           => clk,
      reset_n       => reset_n,
      rd            => rd,
      wr            => wr,
      d_in          => d_in,
      full          => full,
      empty         => empty,
      d_out         => d_out
      );

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
    rd   <= '0';
    wr   <= '0';
    d_in <= x"00";
    wait for 5.51*CLK_PERIOD;
    rd   <= '0';
    wr   <= '1';
    d_in <= x"AA";
    wait for CLK_PERIOD;
    rd   <= '1';
    wr   <= '1';
    d_in <= x"BB";
    wait for CLK_PERIOD;
    rd   <= '1';
    wr   <= '0';
    d_in <= x"FF";
    wait for CLK_PERIOD;
    rd   <= '0';
    wr   <= '0';
    d_in <= x"FF";
    wait for 8*CLK_PERIOD;
    rd   <= '0';
    wr   <= '1';
    d_in <= x"AA";
    wait for 2*CLK_PERIOD;
    rd   <= '1';
    wr   <= '0';
    d_in <= x"FF";
    wait for 10*CLK_PERIOD;
    rd   <= '1';
    wr   <= '1';
    d_in <= x"BB";
    wait for 1*CLK_PERIOD;
    rd   <= '1';
    wr   <= '1';
    d_in <= x"CC";
    wait for 10*CLK_PERIOD;
    rd   <= '0';
    wr   <= '1';
    d_in <= x"BB";
    wait for 10*CLK_PERIOD;
    rd   <= '1';
    wr   <= '1';
    d_in <= x"FF";
    wait;
  end process;

end tb;