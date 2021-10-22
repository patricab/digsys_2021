-- *****************************************************************************
-- Name:     fifo.vhd   
-- Created:  02.03.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  FIFO.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo is
  generic (
    FIFO_DEPTH : natural := 8;
    FIFO_WIDTH : natural := 8);
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    rd      : in  std_logic;
    wr      : in  std_logic;
    d_in    : in  std_logic_vector(FIFO_WIDTH-1 downto 0);
    full    : out std_logic;
    empty   : out std_logic;
    d_out   : out std_logic_vector(FIFO_WIDTH-1 downto 0));
end fifo;

-- Using asynchronous read, and thus distributed ram.
architecture rtl_lut_ram of fifo is
  type ram_type is array (0 to FIFO_DEPTH-1) of std_logic_vector (FIFO_WIDTH-1 downto 0);
  signal RAM         : ram_type;
  signal wr_addr_r   : integer range 0 to FIFO_DEPTH-1;
  signal wr_addr_succ: integer range 0 to FIFO_DEPTH-1;
  signal wr_addr_nxt : integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_r   : integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_succ: integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_nxt : integer range 0 to FIFO_DEPTH-1;
  signal full_r      : std_logic;
  signal full_nxt    : std_logic;
  signal empty_r     : std_logic;
  signal empty_nxt   : std_logic;
  signal operation   : std_logic_vector(1 downto 0);
  
begin
  wr_addr_succ <= (wr_addr_r + 1) mod FIFO_DEPTH; -- The mod will be optimized away if FIFO_DEPTH is a power of 2.
  rd_addr_succ <= (rd_addr_r + 1) mod FIFO_DEPTH;
  full  <= full_r; 
  empty <= empty_r;

  process(clk, reset_n)
  begin
    if (reset_n = '0') then
      full_r <= '0';
      empty_r <= '1';
      wr_addr_r <= 0;
      rd_addr_r <= 0;
    elsif (clk'event and clk='1') then
      -- A clock enable here could reduce energy consumption. At least in ASIC.
      full_r <= full_nxt;
      empty_r <= empty_nxt;
      wr_addr_r <= wr_addr_nxt;
      rd_addr_r <= rd_addr_nxt;
    end if;
  end process;
  
  -- Next state and address logic
  operation <= wr & rd;
  process(operation, full_r, empty_r, wr_addr_r, rd_addr_r, wr_addr_succ, rd_addr_succ)
  begin
    full_nxt    <= full_r;
    empty_nxt   <= empty_r;
    wr_addr_nxt <= wr_addr_r;
    rd_addr_nxt <= rd_addr_r;
    case operation is
      when "00" => -- nop
      when "10" => -- write
        if (full_r='0') then
          wr_addr_nxt <= wr_addr_succ;
          empty_nxt   <= '0';
          if (wr_addr_succ = rd_addr_r) then
            full_nxt <= '1';
          end if;
        end if;
      when "01" => -- read
        if (empty_r='0') then
          rd_addr_nxt <= rd_addr_succ;
          full_nxt   <= '0';
          if (rd_addr_succ = wr_addr_r) then
            empty_nxt <= '1';
          end if;
        end if;
      when others => -- read and write
        wr_addr_nxt <= wr_addr_succ;
        rd_addr_nxt <= rd_addr_succ;
    end case;
  end process;
  
  d_out <= RAM(rd_addr_r); -- This asynchronous read forces inference of distributed RAM instead of BRAM.
  
  process(clk)
  begin
    if (clk'event and clk='1') then
      if (wr='1' and (full_r='0' or rd='1')) then
        RAM(wr_addr_r) <= d_in;
      end if;
    end if;
  end process;
end rtl_lut_ram;

-- Avoids using asynchronous read, and can therefore be implemented using block ram.
architecture rtl_block_ram of fifo is
  type ram_type is array (0 to FIFO_DEPTH-1) of std_logic_vector (FIFO_WIDTH-1 downto 0);
  signal RAM         : ram_type;
  signal wr_addr_r   : integer range 0 to FIFO_DEPTH-1;
  signal wr_addr_succ: integer range 0 to FIFO_DEPTH-1;
  signal wr_addr_nxt : integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_r   : integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_succ: integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_nxt : integer range 0 to FIFO_DEPTH-1;
  signal full_r      : std_logic;
  signal full_nxt    : std_logic;
  signal empty_r     : std_logic;
  signal empty_nxt   : std_logic;
  signal operation   : std_logic_vector(1 downto 0);
  
  signal ram_out     : std_logic_vector(FIFO_WIDTH-1 downto 0);
  signal d_in_d1     : std_logic_vector(FIFO_WIDTH-1 downto 0);
  signal wr_d1       : std_logic;
  
begin
  wr_addr_succ <= (wr_addr_r + 1) mod FIFO_DEPTH; -- The mod will be optimized away if FIFO_DEPTH is a power of 2.
  rd_addr_succ <= (rd_addr_r + 1) mod FIFO_DEPTH;
  full  <= full_r; 
  empty <= empty_r;

  process(clk, reset_n)
  begin
    if (reset_n = '0') then
      full_r <= '0';
      empty_r <= '1';
      wr_addr_r <= 0;
      rd_addr_r <= 0;
      wr_d1 <= '0';
      d_in_d1 <= (others => '0');
    elsif (clk'event and clk='1') then
      full_r <= full_nxt;
      empty_r <= empty_nxt;
      wr_addr_r <= wr_addr_nxt;
      rd_addr_r <= rd_addr_nxt;
      wr_d1 <= wr;
      d_in_d1 <= d_in;
    end if;
  end process;
      
  operation <= wr & rd;
  process(operation, full_r, empty_r, wr_addr_r, rd_addr_r, wr_addr_succ, rd_addr_succ)
  begin
    full_nxt    <= full_r;
    empty_nxt   <= empty_r;
    wr_addr_nxt <= wr_addr_r;
    rd_addr_nxt <= rd_addr_r;
    case operation is
      when "00" => -- nop
      when "10" => -- write
        if (full_r='0') then
          wr_addr_nxt <= wr_addr_succ;
          empty_nxt   <= '0';
          if (wr_addr_succ = rd_addr_r) then
            full_nxt <= '1';
          end if;
        end if;
      when "01" => -- read
        if (empty_r='0') then
          rd_addr_nxt <= rd_addr_succ;
          full_nxt   <= '0';
          if (rd_addr_succ = wr_addr_r) then
            empty_nxt <= '1';
          end if;
        end if;
      when others => -- read and write
        wr_addr_nxt <= wr_addr_succ;
        rd_addr_nxt <= rd_addr_succ;
    end case;
  end process;
  
  -- If the fifo is full, and we wrote last clock cycle, use delayed version of d_in instead of BRAM output.
  -- This allows for inference of BRAM while staying in spec.
  d_out <= d_in_d1 when (rd_addr_succ = wr_addr_r) and wr_d1='1' else ram_out;
  process(clk)
  begin
    if (clk'event and clk='1') then
      if (wr='1' and (full_r='0' or rd='1')) then
        RAM(wr_addr_r) <= d_in;
      end if;
      ram_out <= RAM(rd_addr_nxt);
    end if;
  end process;
end rtl_block_ram;

-- Avoids using asynchronous read, and can therefore be implemented using block ram. Avoid using separate register for d_in_d1.
architecture rtl_block_ram_no_d1 of fifo is
  type ram_type is array (0 to FIFO_DEPTH-1) of std_logic_vector (FIFO_WIDTH-1 downto 0);
  signal RAM         : ram_type;
  signal wr_addr_r   : integer range 0 to FIFO_DEPTH-1;
  signal wr_addr_succ: integer range 0 to FIFO_DEPTH-1;
  signal wr_addr_nxt : integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_r   : integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_succ: integer range 0 to FIFO_DEPTH-1;
  signal rd_addr_nxt : integer range 0 to FIFO_DEPTH-1;
  signal full_r      : std_logic;
  signal full_nxt    : std_logic;
  signal empty_r     : std_logic;
  signal empty_nxt   : std_logic;
  signal operation   : std_logic_vector(1 downto 0);
  
  signal ram_out     : std_logic_vector(FIFO_WIDTH-1 downto 0);
  signal written_data: std_logic_vector(FIFO_WIDTH-1 downto 0);
  signal wr_d1       : std_logic;
  
begin
  wr_addr_succ <= (wr_addr_r + 1) mod FIFO_DEPTH; -- The mod will be optimized away if FIFO_DEPTH is a power of 2.
  rd_addr_succ <= (rd_addr_r + 1) mod FIFO_DEPTH;
  full  <= full_r; 
  empty <= empty_r;

  process(clk, reset_n)
  begin
    if (reset_n = '0') then
      full_r <= '0';
      empty_r <= '1';
      wr_addr_r <= 0;
      rd_addr_r <= 0;
      wr_d1 <= '0';
    elsif (clk'event and clk='1') then
      full_r <= full_nxt;
      empty_r <= empty_nxt;
      wr_addr_r <= wr_addr_nxt;
      rd_addr_r <= rd_addr_nxt;
      wr_d1 <= wr;
    end if;
  end process;
      
  operation <= wr & rd;
  process(operation, full_r, empty_r, wr_addr_r, rd_addr_r, wr_addr_succ, rd_addr_succ)
  begin
    full_nxt    <= full_r;
    empty_nxt   <= empty_r;
    wr_addr_nxt <= wr_addr_r;
    rd_addr_nxt <= rd_addr_r;
    case operation is
      when "00" => -- nop
      when "10" => -- write
        if (full_r='0') then
          wr_addr_nxt <= wr_addr_succ;
          empty_nxt   <= '0';
          if (wr_addr_succ = rd_addr_r) then
            full_nxt <= '1';
          end if;
        end if;
      when "01" => -- read
        if (empty_r='0') then
          rd_addr_nxt <= rd_addr_succ;
          full_nxt   <= '0';
          if (rd_addr_succ = wr_addr_r) then
            empty_nxt <= '1';
          end if;
        end if;
      when others => -- read and write
        wr_addr_nxt <= wr_addr_succ;
        rd_addr_nxt <= rd_addr_succ;
    end case;
  end process;
  
  -- If the fifo is full, and we wrote last clock cycle, use delayed version of d_in instead of BRAM output.
  -- This allows for inference of BRAM while staying in spec.
  d_out <= written_data when (rd_addr_succ = wr_addr_r) and wr_d1='1' else ram_out;
  process(clk)
  begin
    if (clk'event and clk='1') then
      if (wr='1' and (full_r='0' or rd='1')) then
        RAM(wr_addr_r) <= d_in;
        written_data <= d_in;
      else
        written_data <= RAM(wr_addr_r);
      end if;
      ram_out <= RAM(rd_addr_nxt);
    end if;
  end process;
end rtl_block_ram_no_d1;