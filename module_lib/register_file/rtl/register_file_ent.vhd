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