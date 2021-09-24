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