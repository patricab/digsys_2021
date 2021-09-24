entity mux4x1 is
  port (
    a       : in  std_logic;
    b       : in  std_logic;
    c       : in  std_logic;
    d       : in  std_logic;
    sel     : in  std_logic_vector(1 downto 0);
    y       : out std_logic);
end mux4x1;