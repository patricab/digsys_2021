library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.slv_arr_p.all;
--------------------------------------------------------------------------------
entity mod_mult is
	 generic (
		  C_block_size: integer := 256
	 );
	 port (
	 -- input data
		  a, b, n : in  std_logic_vector(C_Block_size-1 downto 0);
	 -- output result
		  p       : out std_logic_vector(C_Block_size-1 downto 0);
	 -- utility
		  clk     : in  std_logic;
		  reset_n : in  std_logic;
	 -- control
		  enable  : in  std_logic;
		  valid   : out std_logic
	 );
end mod_mult;
--------------------------------------------------------------------------------
architecture rtl of mod_mult is
-- signal declaration:
	signal cnt: unsigned(8 downto 0);

	signal rst_cnt : std_logic;

   signal b_array : slv_array_t(0 to C_block_size-1)(0 downto 0);

   signal bi : std_logic_vector(0 downto 0);

	signal mid0, mid1, mid2 : std_logic_vector(C_block_size-1 downto 0);

	component counter
		generic (bit : integer := 8);
		port (
			clk, rst, en : in  std_logic;
			val          : out unsigned(bit-1 downto 0)
		);
	end component;

	component mux
		generic (
			num : natural := 32;
			bit : natural :=  1
		);
		port (
			input  : in  slv_array_t(0 to num-1)(bit-1 downto 0);
			sel    : in  natural range 0 to num-1;
			output : out std_logic_vector(bit-1 downto 0)
		);
	end component;

   component adder
      generic (
         bits : natural := 256
      );
      port (
         a, b : in  std_logic_vector(bits-1 downto 0);
         y    : out std_logic_vector(bits-1 downto 0)
      );
   end component;

   component mod_sub
      generic (
         bits : natural := 256
      );
      port (
         input, modular : in  std_logic_vector(bits-1 downto 0);
         output         : out std_logic_vector(bits-1 downto 0)
      );
   end component;

begin---------------------------------------------------------------------------

b_gen : for i in 0 to C_Block_size-1 generate
   b_array(i) <= b(i downto i);
end generate;

main : process( clk, reset_n, valid, enable )
begin
   if( reset_n = '0' ) then
      rst_cnt <= '0';

   elsif( rising_edge(clk) and enable = '1' ) then
      rst_cnt <= valid and enable;

      if (bi(0) = '1') then
         mid0 <= a;
      else
         mid0 <= (others => '0');
      end if;

      valid <= cnt(8);

   end if ;
end process ; -- main


b_sel_cnt : entity work.counter(down)
   generic map (bit => 9)
   port map (
      clk => clk,
      rst => rst_cnt,
      en  => enable,
      val => cnt
   );

b_sel_mux : mux
   generic map (
      num => C_Block_size,
      bit => 1
   )
   port map (
      input  => b_array,
      sel    => to_integer(cnt(7 downto 0)),
      output => bi
   );

add : adder
   generic map (bits => C_Block_size)
   port map (
      a => p(C_Block_size-2 downto 0) & '0',
      b => mid0,
      y => mid1
   );

mod_sub1 : mod_sub
   generic map (bits => C_Block_size)
   port map (
      input   => mid1,
      modular => n,
      output  => mid2
   );

mod_sub2 : mod_sub
   generic map (bits => C_Block_size)
   port map (
      input   => mid2,
      modular => n,
      output  => p
   );

end architecture;
--------------------------------------------------------------------------------
