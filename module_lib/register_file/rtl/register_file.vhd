-- *****************************************************************************
-- Name:     register_file.vhd   
-- Created:  09.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  Positive edge triggered register file with asynchronous reset,
--           active low.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_utilities.all;

entity register_file is
  generic (
    REGISTER_WIDTH : natural := 8;
    REGISTER_DEPTH : natural := 8); -- Change to Address width?
  port (
    clk       : in  std_logic;
    reset_n   : in  std_logic;
    wr_en     : in  std_logic;

    wr_addr   : in  std_logic_vector(log2c(REGISTER_DEPTH)-1 downto 0);
    d_in      : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);

    rd_addr_a : in  std_logic_vector(log2c(REGISTER_DEPTH)-1 downto 0);
    rd_addr_b : in  std_logic_vector(log2c(REGISTER_DEPTH)-1 downto 0);
    d_out_a   : out std_logic_vector(REGISTER_WIDTH-1 downto 0);
    d_out_b   : out std_logic_vector(REGISTER_WIDTH-1 downto 0));
end register_file;

architecture rtl of register_file is
  type reg_file_type is array (0 to REGISTER_DEPTH-1) of std_logic_vector (REGISTER_WIDTH-1 downto 0);
  signal reg_file : reg_file_type;
begin
  d_out_a <= reg_file(to_integer(unsigned(rd_addr_a)));
  d_out_b <= reg_file(to_integer(unsigned(rd_addr_b)));

  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      reg_file <= (others => (others =>'0'));
    elsif (clk'event and clk='1') then
      if(wr_en='1') then
        reg_file(to_integer(unsigned(wr_addr))) <= d_in;
      end if;
    end if;
  end process;
end rtl;