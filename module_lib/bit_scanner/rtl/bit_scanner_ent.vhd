entity bit_scanner is
  generic(
    N         : natural := 4);
  port (
    req       : in  std_logic_vector(N-1 downto 0);
    gnt       : out std_logic_vector(N-1 downto 0));
end bit_scanner;