entity counter is
  generic (
    COUNTER_WIDTH : natural := 8);
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    cnt_en  : in  std_logic;
    y       : out std_logic_vector(COUNTER_WIDTH-1 downto 0));
end counter;