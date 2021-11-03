entity adder_tree_pipelined is
  port (
    clk        : in  std_logic;
    reset_n    : in  std_logic;
    numbers_a  : in  slv16_array(0 to 15);
    sum        : out std_logic_vector(19 downto 0));
end adder_tree_pipelined;