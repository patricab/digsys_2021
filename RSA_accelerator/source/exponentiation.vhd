library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.slv_arr_p.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		-- input control
		valid_in    	: in  STD_LOGIC;
		ready_in    	: out STD_LOGIC;

		-- input data
		message, key	: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- ouput control
		ready_out   	: in  STD_LOGIC;
		valid_out   	: out STD_LOGIC;

		-- output data
		result      	: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- modulus
		modulus     	: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- utility
		clk, reset_n	: in STD_LOGIC
	);
end exponentiation;


-- architecture expBehave of exponentiation is
-- begin
-- 	result <= message xor modulus;
-- 	ready_in <= ready_out;
-- 	valid_out <= valid_in;
-- end expBehave;



architecture rl_binary_rtl of exponentiation is

	component counter
		generic (bit : integer := 8);
		port (
			clk	: in 	std_logic;
			rst	: in 	std_logic;
			en 	: in 	std_logic;
			val	: out	unsigned(bit-1 downto 0)
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

	component mod_mult
		generic (C_block_size : integer := 256);
		port (
			clk, reset_n : in  std_logic;
			a, b, n      : in  std_logic_vector(C_block_size-1 downto 0);
			p            : out std_logic_vector(C_block_size-1 downto 0);
			ready        : in  std_logic;
			valid        : out std_logic
		);
	end component;

	shared variable log_size : integer := 8;
	-- log_size := to_integer(log2(real(C_block_size)));

	signal key_array : slv_array_t(0 to C_block_size-1)(0 downto 0);

	signal run, done : std_logic;
	signal en : std_logic_vector(0 downto 0);
	signal cnt : unsigned(8 downto 0);
	signal c, c_d, c_q, p, p_d, p_q : std_logic_vector(C_block_size-1 downto 0);
	signal c_en, p_en : std_logic;

begin

	key_gen : for i in 0 to C_block_size-1 generate
		key_array(i) <= key(i downto i);
	end generate; -- key_gen

	main : process(all)
	begin
		if( reset_n = '0' ) then
			ready_in <= '1';
			c <= (others => '0');
			p <= (others => '0');
		elsif( rising_edge(clk) ) then

			done <= cnt(log_size);
			ready_in <= done;
			if (ready_in and valid_in) then
				run <= '1';
				ready_in <= '0';
			end if;
			if (done = '1') then
				run <= '0';
				ready_in <= '1';
			end if;

			if c_en then
				c <= c_d;
			end if;
			if p_en then
				p <= p_d;
			end if;


		end if;
	end process; -- main

	key_sel_counter: counter
		generic map (bit => log_size + 1)
		port map (
			clk => clk,
			rst => reset_n,
			en  => run,
			val => cnt
		);

	key_mux: mux
		generic map (
			num => C_block_size,
			bit => 1
		)
		port map (
			input  => key_array,
			sel    => to_integer(cnt),
			output => en
		);

	C_mult: mod_mult
		generic map (C_block_size => C_block_size)
		port map (
			clk     => clk,
			reset_n => reset_n,
			n       => modulus,
			a       => c_q,
			b       => p_q,
			ready   => run,
			valid   => c_en,
			p       => c_d
		);

	P_mult: mod_mult
		generic map (C_block_size => C_block_size)
		port map (
			clk     => clk,
			reset_n => reset_n,
			n       => modulus,
			a       => p_q,
			b       => p_q,
			ready   => run,
			valid   => p_en,
			p       => p_d
		);

end architecture;



-- architecture mary_rtl of exponentiation is

-- 	component counter
-- 		generic (bit : integer := 8);
-- 		port (
-- 			clk	: in 	std_logic;
-- 			rst	: in 	std_logic;
-- 			en 	: in 	std_logic;
-- 			val	: out	std_logic_vector(bit-1 downto 0)
-- 		);
-- 	end component;

-- 	component mux
-- 		generic (
-- 			num : natural := 32;
-- 			bit : natural :=  1
-- 		);
-- 		port (
-- 			input  : in slv_array_t(0 to num-1)(bit-1 downto 0);
-- 			sel    : in  natural range 0 to num-1;
-- 			output : out std_logic_vector(bit-1 downto 0)
-- 		);
-- 	end component;

-- 	component modmult is
-- 		generic (
-- 			C_Block_size: integer := 256
-- 		);
-- 		port (

-- 			b: in std_logic_vector(C_Block_size-1 downto 0);
-- 			a: in std_logic_vector(C_Block_size-1 downto 0);
-- 			n: in std_logic_vector(C_Block_size-1 downto 0);

-- 			p: out std_logic_vector(C_Block_size-1 downto 0);

-- 			clk: in std_logic;
-- 			overflow: out std_logic);

-- 	end component;

-- 	constant r  : integer := 4;
-- 	constant r2 : integer := 16; -- r^2
-- 	constant s  : integer := C_block_size / r;
-- 	constant log_size : integer := 6;-- integer(log2(s));

-- 	signal start, en : std_logic;

-- 	signal m : slv_array_t(0 to r2-1)(C_block_size-1 downto 0);

-- 	signal f : unsigned(r-1 downto 0); -- range 0 to r-1;

-- 	signal mf : std_logic_vector(C_BLOCK_SIZE-1 downto 0);

-- 	signal cnt : unsigned(log_size downto 0);
-- 	signal c, c_d, c_q : std_logic_vector(C_block_size-1 downto 0);
-- 	signal c_en : std_logic;

-- 	signal key_array : slv_array_t(0 to s-1)(r-1 downto 0);

-- 	signal mux_out : std_logic_vector(C_block_size-1 downto 0);

-- 	signal c_sel : slv_array_t(0 to 1)(C_block_size-1 downto 0);

-- begin

-- 	key_gen : for i in 0 to s-1 generate
-- 		key_array(i) <= key(i*r + r-1 downto i*r);
-- 	end generate; -- key_gen

-- 	c_sel <= (mf, c);

-- 	ready_in <= cnt(log_size);
-- 	start <= ready_in and valid_in;

-- 	main : process( clk, reset_n )
-- 	begin
-- 		if( reset_n = '0' ) then
-- 			c <= (others => '0');
-- 		elsif( rising_edge(clk) ) then
-- 			if c_en then
-- 				c <= c_d;
-- 			end if;
-- 		end if;
-- 	end process; -- main

-- 	m_reg_demux : entity work.demux(rtl)
-- 		generic map (
-- 			num => r2,
-- 			bit => C_block_size
-- 		)
-- 		port map (
-- 			input  => c,
-- 			sel    => to_integer(cnt(3 downto 0)),
-- 			output => m
-- 		);

-- 	c_sel_mux: entity work.mux(rtl)
-- 		generic map (
-- 			num => 2,
-- 			bit => C_block_size
-- 		)
-- 		port map (
-- 			input  => c_sel,
-- 			sel    => to_integer(unsigned'('0' & start)),
-- 			output => c_d
-- 		);

-- 	key_sel_counter: entity work.counter(rtl)
-- 		generic map (bit => log_size) -- 64 => 6bit
-- 		port map(
-- 			clk => clk,
-- 			rst => reset_n,
-- 			en  => start,
-- 			val => cnt(log_size-1 downto 0)
-- 		);

-- 	mod_mult_inp_sel_Counter: entity work.counter(rtl)
-- 		generic map (bit => 3) -- integer(log2(r))4 => 2bit +1
-- 		port map (
-- 			clk => clk,
-- 			rst => reset_n,
-- 			en  => to_integer(start),
-- 			val => cnt(2 downto 0)
-- 		);

-- 	key_mux: entity work.mux(rtl)
-- 		generic map (
-- 			num => s,
-- 			bit => r
-- 		)
-- 		port map (
-- 			input  => key_array,
-- 			sel    => to_integer(cnt),
-- 			std_logic_vector(output) => f
-- 		);

-- 	key_mux2: entity work.mux(rtl)
-- 		generic map (
-- 			num => r2,
-- 			bit => C_block_size
-- 		)
-- 		port map (
-- 			input  => m,
-- 			sel    => to_integer(f),
-- 			output => mf
-- 		);

-- 	C_mod_mult: entity work.mod_mult(modmult_arch)
-- 		generic map (C_block_size => C_block_size)
-- 		port map (
-- 			clk      => clk,
-- 			reset_n  => reset_n,
-- 			n        => modulus,
-- 			a        => c_q,
-- 			b        => mux_out,
-- 			overflow => c_en,
-- 			p        => c
-- 		);

-- end architecture;



-- architecture mary_behave of exponentiation is

-- 	-- signal
-- 	function modmult(a, b, n : in unsigned(C_block_size-1 downto 0))
-- 	return unsigned(C_block_size-1 downto 0) is
-- 		variable p : unsigned(C_block_size-1 downto 0) := (others => '0');
-- 	begin
-- 		loop : for i in 0 to C_block_size-1 loop
-- 			p := 2 * p + a * unsigned(b(i));
-- 			if p >= n then
-- 				p = p - n;
-- 				if p >= n then
-- 					p = p - n;
-- 				end if;
-- 			end if;
-- 		end loop; -- loop
-- 		return p;
-- 	end function;

-- begin


-- 	mary : process(clk, reset_n, ready_in, ready_out) is
-- 	variable C : unsigned(C_block_size-1 downto 0);
-- 	constant R : integer := 2; -- group size
-- 	constant S : integer := C_block_size / R; -- number of groups

-- 	type exps is array (0 to R**2)
-- 	of unsigned(C_block_size-1 downto 0);

-- 	variable M : exps := (unsigned(1), unsigned(message));

-- 	type key_groups is array (0 to S-1)
-- 	of unsigned(R-1 downto 0);

-- 	variable F : key_groups;

-- 	begin
-- 		if (reset_n = '0') then
-- 			-- reset
-- 		elsif risingedge(clk) then
-- 			-- Calculate all M^w
-- 			precalc : for w in 2 to R**2-1 loop
-- 				M(w) := modmult(M(w-1), message, modulus);
-- 				end loop; -- precalc

-- 			-- Split key into R sized chunks
-- 			keytoF : for k in 0 to S-1 loop
-- 				F(k) := (unsigned(key(R*k to R*k+R-1)));
-- 			end loop; -- keytoF

-- 			C := M(F(S-1));
-- 			-- Do modular exponentiation
-- 			main : for i in S-2 downto 0 loop
-- 				for j in 0 to R loop
-- 					C := modmult(C, C, modulus);
-- 				end loop; -- 4a
-- 				if (F(i) /= 0) then
-- 					C := modmult(C, M(F(i)), modulus);
-- 				end if; -- 4b
-- 			end loop; -- main
-- 		end if;
-- 	end process; -- mary

-- end architecture;


-- State machine

-- state machine : process( clock )
-- begin
-- 	if( rising_edge(clock) ) then

-- 	end if ;
-- end process ; -- state machine

-- cur_state := IDLE;
-- nxt_state <= RESET;

-- IDLE -- wait for ready valid reset signal
-- RESET -- reset
-- PRECALC -- find M[w]
-- CALC	-- calculate
