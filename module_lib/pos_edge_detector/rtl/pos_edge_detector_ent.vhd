entity pos_edge_detector is
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    x       : in  std_logic;
    y       : out std_logic);
end pos_edge_detector;