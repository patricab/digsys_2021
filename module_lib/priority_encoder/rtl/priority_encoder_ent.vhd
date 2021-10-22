entity priority_encoder is
  generic(
    OUTPUT_WIDTH : natural := 2);
  port (
    x            : in  std_logic_vector(OUTPUT_WIDTH**2-1 downto 0);
    y            : out std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    valid        : out std_logic);
end priority_encoder;