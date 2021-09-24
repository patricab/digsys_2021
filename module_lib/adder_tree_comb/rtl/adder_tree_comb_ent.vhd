entity adder_tree_comb is
  port (
    numbers_a  : in  slv16_array(0 to 15);
    sum        : out std_logic_vector(19 downto 0));
end adder_tree_comb;