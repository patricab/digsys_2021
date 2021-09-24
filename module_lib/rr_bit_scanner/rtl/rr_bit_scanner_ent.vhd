entity rr_bit_scanner is
  generic(
    N         : natural := 4);
  port (
    clk       : in std_logic;
    reset_n   : in std_logic;
    req       : in  std_logic_vector(N-1 downto 0);
    gnt       : out std_logic_vector(N-1 downto 0));
end rr_bit_scanner;