-- *****************************************************************************
-- Name:     up_down_counter.vhd   
-- Created:  13.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  An up/down counter. Counts if cnt_en is asserted. Direction is
--           controlled by cnt_up.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_down_counter is
  generic (
    COUNTER_WIDTH : natural := 8);
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    cnt_en  : in  std_logic;
    cnt_up  : in  std_logic;
    y       : out std_logic_vector(COUNTER_WIDTH-1 downto 0));
end up_down_counter;

-- Naive implementation
architecture rtl_alt1 of up_down_counter is
  signal value : unsigned(COUNTER_WIDTH-1 downto 0);
begin
  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      value <= (others => '0');
    elsif (clk'event and clk='1') then
      if (cnt_en = '1') then
        if (cnt_up = '1') then
          value <= value + 1;
        else
          value <= value - 1;
        end if;
      end if;
    end if;
  end process;
  y <= std_logic_vector(value);
end rtl_alt1;


-- Logic separation
architecture rtl_alt2 of up_down_counter is
  signal value_r   : unsigned(COUNTER_WIDTH-1 downto 0);
  signal value_nxt : unsigned(COUNTER_WIDTH-1 downto 0);
begin
  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      value_r <= (others => '0');
    elsif (clk'event and clk='1') then
      if (cnt_en = '1') then
        value_r <= value_nxt;
      end if;
    end if;
  end process;
  
  process(cnt_up, value_r)
  begin
    if (cnt_up = '1') then
      value_nxt <= value_r + 1;
    else
      value_nxt <= value_r - 1;
    end if;
  end process;
  
  y <= std_logic_vector(value_r);
end rtl_alt2;


-- Functionality sharing and logic separation
architecture rtl_alt3 of up_down_counter is
  signal value_r   : unsigned(COUNTER_WIDTH-1 downto 0);
  signal value_nxt : unsigned(COUNTER_WIDTH-1 downto 0);
  signal delta     : integer range -1 to 1;
begin
  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      value_r <= (others => '0');
    elsif (clk'event and clk='1') then
      if (cnt_en = '1') then
        value_r <= value_nxt;
      end if;
    end if;
  end process;
  
  value_nxt <= value_r + delta;
  
  process(cnt_up, value_r)
  begin
    if (cnt_up = '1') then
      delta <= 1;
    else
      delta <= -1;
    end if;
  end process;
  
  y <= std_logic_vector(value_r);
end rtl_alt3;