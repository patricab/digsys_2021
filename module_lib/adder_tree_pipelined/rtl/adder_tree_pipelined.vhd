-- *****************************************************************************
-- Name:     adder_tree_pipelined.vhd   
-- Created:  13.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A pipelined adder tree for summarising 16 16-bit numbers.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.arraypackage.all;

entity adder_tree_pipelined is
  port (
    clk        : in  std_logic;
    reset_n    : in  std_logic;
    numbers_a  : in  slv16_array(0 to 15);
    sum        : out std_logic_vector(19 downto 0));
end adder_tree_pipelined;

architecture rtl of adder_tree_pipelined is
  signal s_0_1_nxt, s_2_3_nxt, s_4_5_nxt, s_6_7_nxt, s_8_9_nxt, s_10_11_nxt, s_12_13_nxt, s_14_15_nxt : unsigned(16 downto 0);
  signal s_0_1_2_3_nxt, s_4_5_6_7_nxt, s_8_9_10_11_nxt, s_12_13_14_15_nxt : unsigned(17 downto 0);
  signal s_0_1_2_3_4_5_6_7_nxt, s_8_9_10_11_12_13_14_15_nxt : unsigned(18 downto 0);

  signal s_0_1_r, s_2_3_r, s_4_5_r, s_6_7_r, s_8_9_r, s_10_11_r, s_12_13_r, s_14_15_r : unsigned(16 downto 0);
  signal s_0_1_2_3_r, s_4_5_6_7_r, s_8_9_10_11_r, s_12_13_14_15_r : unsigned(17 downto 0);
  signal s_0_1_2_3_4_5_6_7_r, s_8_9_10_11_12_13_14_15_r : unsigned(18 downto 0);
begin

  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      s_0_1_r                   <= (others => '0');
      s_2_3_r                   <= (others => '0');
      s_4_5_r                   <= (others => '0');
      s_6_7_r                   <= (others => '0');
      s_8_9_r                   <= (others => '0');
      s_10_11_r                 <= (others => '0');
      s_12_13_r                 <= (others => '0');
      s_14_15_r                 <= (others => '0');

      s_0_1_2_3_r               <= (others => '0');
      s_4_5_6_7_r               <= (others => '0');
      s_8_9_10_11_r             <= (others => '0');
      s_12_13_14_15_r           <= (others => '0');


      s_0_1_2_3_4_5_6_7_r       <= (others => '0');
      s_8_9_10_11_12_13_14_15_r <= (others => '0');
    elsif (clk'event and clk='1') then
      s_0_1_r                   <= s_0_1_nxt;
      s_2_3_r                   <= s_2_3_nxt;
      s_4_5_r                   <= s_4_5_nxt;
      s_6_7_r                   <= s_6_7_nxt;
      s_8_9_r                   <= s_8_9_nxt;
      s_10_11_r                 <= s_10_11_nxt;
      s_12_13_r                 <= s_12_13_nxt;
      s_14_15_r                 <= s_14_15_nxt;

      s_0_1_2_3_r               <= s_0_1_2_3_nxt;
      s_4_5_6_7_r               <= s_4_5_6_7_nxt;
      s_8_9_10_11_r             <= s_8_9_10_11_nxt;
      s_12_13_14_15_r           <= s_12_13_14_15_nxt;


      s_0_1_2_3_4_5_6_7_r       <= s_0_1_2_3_4_5_6_7_nxt;
      s_8_9_10_11_12_13_14_15_r <= s_8_9_10_11_12_13_14_15_nxt;
    end if;
  end process;

  s_0_1_nxt   <= unsigned('0' & numbers_a(0)) + unsigned('0' & numbers_a(1));
  s_2_3_nxt   <= unsigned('0' & numbers_a(2)) + unsigned('0' & numbers_a(3));
  s_4_5_nxt   <= unsigned('0' & numbers_a(4)) + unsigned('0' & numbers_a(5));
  s_6_7_nxt   <= unsigned('0' & numbers_a(6)) + unsigned('0' & numbers_a(7));
  s_8_9_nxt   <= unsigned('0' & numbers_a(8)) + unsigned('0' & numbers_a(9));
  s_10_11_nxt <= unsigned('0' & numbers_a(10)) + unsigned('0' & numbers_a(11));
  s_12_13_nxt <= unsigned('0' & numbers_a(12)) + unsigned('0' & numbers_a(13));
  s_14_15_nxt <= unsigned('0' & numbers_a(14)) + unsigned('0' & numbers_a(15));
  
  s_0_1_2_3_nxt     <= ('0' & s_0_1_r) + ('0' & s_2_3_r);
  s_4_5_6_7_nxt     <= ('0' & s_4_5_r) + ('0' & s_6_7_r);
  s_8_9_10_11_nxt   <= ('0' & s_8_9_r) + ('0' & s_10_11_r);
  s_12_13_14_15_nxt <= ('0' & s_12_13_r) + ('0' & s_14_15_r);
  
  s_0_1_2_3_4_5_6_7_nxt       <= ('0' & s_0_1_2_3_r) + ('0' & s_4_5_6_7_r);
  s_8_9_10_11_12_13_14_15_nxt <= ('0' & s_8_9_10_11_r) + ('0' & s_12_13_14_15_r);
  
  sum <= std_logic_vector(('0' & s_0_1_2_3_4_5_6_7_r) + ('0' & s_8_9_10_11_12_13_14_15_r));
end rtl;