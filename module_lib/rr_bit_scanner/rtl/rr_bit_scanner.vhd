-- *****************************************************************************
-- Name:     rr_bit_scanner.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A combinational bit scanner. LSB has highest priority.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity rr_bit_scanner is
  generic(
    N         : natural := 4);
  port (
    clk       : in std_logic;
    reset_n   : in std_logic;
    req       : in  std_logic_vector(N-1 downto 0);
    gnt       : out std_logic_vector(N-1 downto 0));
end rr_bit_scanner;

architecture rtl_mux of rr_bit_scanner is
  signal gnt_r       : std_logic_vector(N-1 downto 0);
  signal gnt_nxt     : std_logic_vector(N-1 downto 0);
  
  signal gnt_umasked : std_logic_vector(N-1 downto 0);
  signal mask        : std_logic_vector(N-1 downto 0);
  signal req_masked  : std_logic_vector(N-1 downto 0);
  signal gnt_masked  : std_logic_vector(N-1 downto 0);
begin
  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      gnt_r <= (others => '0');
    elsif(clk'event and clk='1') then
      gnt_r <= gnt_nxt;
    end if;
  end process;
  
  gnt <= gnt_r;

  -- Regular bit scanner
  umasked: entity work.bit_scanner(rtl_signed)
    generic map (
      N   => N)
    port map (
      req => req,
      gnt => gnt_umasked);
  
  -- Mask generation
  mask(0) <= '0';
  mask(1) <= gnt_r(0);
  mask_gen: for i in 2 to N-1 generate
    mask(i) <= mask(i-1) or gnt_r(i-1);
  end generate;
  
  -- Masked version of request
  req_masked <= req and mask;
  
  -- Regular bit scanner working on masked request
  masked: entity work.bit_scanner(rtl_signed)
    generic map (
      N   => N)
    port map (
      req => req_masked,
      gnt => gnt_masked);
  
  -- Choose masked version if any grants given there
  gnt_nxt <= gnt_masked when or_reduce(req_masked) = '1' else gnt_umasked;
end rtl_mux;

architecture rtl_no_mux of rr_bit_scanner is
  signal gnt_r       : std_logic_vector(N-1 downto 0);
  signal gnt_nxt     : std_logic_vector(N-1 downto 0);
  
  signal mask        : std_logic_vector(N-1 downto 0);
  signal req_masked  : std_logic_vector(2*N-1 downto 0);
  signal gnt_masked  : std_logic_vector(2*N-1 downto 0);
begin
  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      gnt_r <= (others => '0');
    elsif(clk'event and clk='1') then
      gnt_r <= gnt_nxt;
    end if;
  end process;
  
  gnt <= gnt_r;
  
  -- Mask generation
  mask(0) <= '0';
  mask(1) <= gnt_r(0);
  mask_gen: for i in 2 to N-1 generate
    mask(i) <= mask(i-1) or gnt_r(i-1);
  end generate;
  
  -- Request concatenated with masked version of request
  req_masked <= req & (req and mask);
  
  -- Regular bit scanner working on masked request
  masked: entity work.bit_scanner(rtl_signed)
    generic map (
      N   => 2*N)
    port map (
      req => req_masked,
      gnt => gnt_masked);
  
  -- Oring upper(unmasked) and lower(masked) part of grant to get n bit wide gnt.
  gnt_nxt <= gnt_masked(2*N-1 downto N) or gnt_masked(N-1 downto 0);
end rtl_no_mux;