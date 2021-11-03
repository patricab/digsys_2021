-- *****************************************************************************
-- Name:     register_file_tb.vhd   
-- Created:  09.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Testbench for a positive edge triggered register with
--           asynchronous reset, active low.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_utilities.all;

entity register_file_tb is
end register_file_tb;

architecture tb of register_file_tb is  
  -- Constants
  constant REGISTER_WIDTH : natural := 8;
  constant REGISTER_DEPTH : natural := 8;
  constant CLK_PERIOD     : time := 10 ns;
  constant RESET_TIME     : time := 10 ns;

  -- Inputs
  signal clk              : std_logic := '0';
  signal reset_n          : std_logic := '0';
  signal wr_en            : std_logic := '0';

  signal wr_addr          : std_logic_vector(log2c(REGISTER_DEPTH)-1 downto 0);
  signal d_in             : std_logic_vector(REGISTER_WIDTH-1 downto 0);
  signal rd_addr_a        : std_logic_vector(log2c(REGISTER_DEPTH)-1 downto 0);
  signal rd_addr_b        : std_logic_vector(log2c(REGISTER_DEPTH)-1 downto 0);

  -- Outputs
  signal d_out_a          : std_logic_vector(REGISTER_WIDTH-1 downto 0);
  signal d_out_b          : std_logic_vector(REGISTER_WIDTH-1 downto 0);

begin
  -- DUT instantiation
  dut: entity work.register_file
    generic map(
      REGISTER_WIDTH => REGISTER_WIDTH,
      REGISTER_DEPTH => REGISTER_DEPTH)
    port map (
      clk            => clk,
      reset_n        => reset_n,
      wr_en          => wr_en,
      wr_addr        => wr_addr,
      d_in           => d_in,
      rd_addr_a      => rd_addr_a,
      rd_addr_b      => rd_addr_b,
      d_out_a        => d_out_a,
      d_out_b        => d_out_b);

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
    wait for 4*CLK_PERIOD;
    wr_en     <= '1';
    wr_addr   <= "001";
    d_in      <= x"FF";
    rd_addr_a <= "001";
    rd_addr_b <= "000";
    wait for CLK_PERIOD;
    wr_en     <= '1';
    wr_addr   <= "010";
    d_in      <= x"AA";
    rd_addr_a <= "010";
    rd_addr_b <= "001";
    wait;
  end process;

end tb;