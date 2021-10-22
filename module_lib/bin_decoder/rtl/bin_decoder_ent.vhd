entity bin_decoder is
  generic(
    INPUT_WIDTH : natural := 2);
  port (
    x           : in  std_logic_vector(INPUT_WIDTH-1 downto 0);
    y           : out std_logic_vector((INPUT_WIDTH**2)-1 downto 0));
end bin_decoder;