entity mux8x1 is
  port (
    a   : in  std_logic;
    b   : in  std_logic;
    c   : in  std_logic;
    d   : in  std_logic;
    e   : in  std_logic;
    f   : in  std_logic;
    g   : in  std_logic;
    h   : in  std_logic;
    sel : in  std_logic_vector(2 downto 0);
    y   : out std_logic);
end mux8x1;