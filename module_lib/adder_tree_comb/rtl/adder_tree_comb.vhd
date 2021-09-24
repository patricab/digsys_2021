-- *****************************************************************************
-- Name:     adder_tree_comb.vhd   
-- Created:  13.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A combinational adder tree for summarising 16 16-bit numbers.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.arraypackage.all;

entity adder_tree_comb is
  port (
    numbers_a  : in  slv16_array(0 to 15);
    sum        : out std_logic_vector(19 downto 0));
end adder_tree_comb;

architecture rtl_parantheses of adder_tree_comb is
begin
  sum <= std_logic_vector(to_unsigned(
                          (((to_integer(unsigned(numbers_a(0)))+
                          to_integer(unsigned(numbers_a(1))))+
                          (to_integer(unsigned(numbers_a(2)))+
                          to_integer(unsigned(numbers_a(3)))))+
                          ((to_integer(unsigned(numbers_a(4)))+
                          to_integer(unsigned(numbers_a(5))))+
                          (to_integer(unsigned(numbers_a(6)))+
                          to_integer(unsigned(numbers_a(7))))))+
                          (((to_integer(unsigned(numbers_a(8)))+
                          to_integer(unsigned(numbers_a(9))))+
                          (to_integer(unsigned(numbers_a(10)))+
                          to_integer(unsigned(numbers_a(11)))))+
                          ((to_integer(unsigned(numbers_a(12)))+
                          to_integer(unsigned(numbers_a(13))))+
                          (to_integer(unsigned(numbers_a(14)))+
                          to_integer(unsigned(numbers_a(15))))))
                          , sum'length));
end rtl_parantheses;

architecture rtl_verbose of adder_tree_comb is
  signal s_0_1, s_2_3, s_4_5, s_6_7, s_8_9, s_10_11, s_12_13, s_14_15 : unsigned(16 downto 0);
  signal s_0_1_2_3, s_4_5_6_7, s_8_9_10_11, s_12_13_14_15 : unsigned(17 downto 0);
  signal s_0_1_2_3_4_5_6_7, s_8_9_10_11_12_13_14_15 : unsigned(18 downto 0);
begin
  s_0_1 <= unsigned('0' & numbers_a(0)) + unsigned('0' & numbers_a(1));
  s_2_3 <= unsigned('0' & numbers_a(2)) + unsigned('0' & numbers_a(3));
  s_4_5 <= unsigned('0' & numbers_a(4)) + unsigned('0' & numbers_a(5));
  s_6_7 <= unsigned('0' & numbers_a(6)) + unsigned('0' & numbers_a(7));
  s_8_9 <= unsigned('0' & numbers_a(8)) + unsigned('0' & numbers_a(9));
  s_10_11 <= unsigned('0' & numbers_a(10)) + unsigned('0' & numbers_a(11));
  s_12_13 <= unsigned('0' & numbers_a(12)) + unsigned('0' & numbers_a(13));
  s_14_15 <= unsigned('0' & numbers_a(14)) + unsigned('0' & numbers_a(15));
  
  s_0_1_2_3 <= ('0' & s_0_1) + ('0' & s_2_3);
  s_4_5_6_7 <= ('0' & s_4_5) + ('0' & s_6_7);
  s_8_9_10_11 <= ('0' & s_8_9) + ('0' & s_10_11);
  s_12_13_14_15 <= ('0' & s_12_13) + ('0' & s_14_15);
  
  s_0_1_2_3_4_5_6_7 <= ('0' & s_0_1_2_3) + ('0' & s_4_5_6_7);
  s_8_9_10_11_12_13_14_15 <= ('0' & s_8_9_10_11) + ('0' & s_12_13_14_15);
  
  sum <= std_logic_vector(('0' & s_0_1_2_3_4_5_6_7) + ('0' & s_8_9_10_11_12_13_14_15));
end rtl_verbose;