entity shift_register is
  generic (
    REGISTER_WIDTH : natural := 8);
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    d       : in  std_logic;
    q       : out std_logic_vector(REGISTER_WIDTH-1 downto 0));
end shift_register;