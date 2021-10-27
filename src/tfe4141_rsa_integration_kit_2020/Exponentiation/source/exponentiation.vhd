library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		-- input control
		valid_in		: in  STD_LOGIC;
		ready_in		: out STD_LOGIC;

		-- input data
		message 		: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0 );
		key 			: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0 );

		-- ouput control
		ready_out	: in  STD_LOGIC;
		valid_out	: out STD_LOGIC;

		-- output data
		result		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- modulus
		modulus 		: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		-- utility
		clk 			: in STD_LOGIC;
		reset_n 		: in STD_LOGIC
	);
end exponentiation;


architecture expBehave of exponentiation is
begin
	result <= message xor modulus;
	ready_in <= ready_out;
	valid_out <= valid_in;
end expBehave;

architecture mary of exponentiation is

	-- signal
	function modmult(a, b, n : in unsigned(C_block_size-1 downto 0))
	return unsigned(C_block_size-1 downto 0) is
		variable p : unsigned(C_block_size-1 downto 0) := (others => '0');
	begin
		loop : for i in 0 to C_block_size-1 loop
			p := 2 * p + a * unsigned(b(i));
			if p >= n then
				p = p - n;
				if p >= n then
					p = p - n;
				end if;
			end if;
		end loop; -- loop
		return p;
	end function;

begin


	mary : process(clk, reset_n, ready_in, ready_out) is
	variable C : unsigned(C_block_size-1 downto 0);
	constant R : integer := 2; -- group size
	constant S : integer := C_block_size / R; -- number of groups

	type exps is array (0 to R**2)
	of unsigned(C_block_size-1 downto 0);

	variable M : exps := (unsigned(1), unsigned(message));

	type key_groups is array (0 to S-1)
	of unsigned(R-1 downto 0);

	variable F : key_groups;

	begin
		if (reset_n = '0') then
			-- reset
		elsif risingedge(clk) then
			-- Calculate all M^w
			precalc : for w in 2 to R**2-1 loop
				M(w) := modmult(M(w-1), message, modulus);
				end loop; -- precalc

			-- Split key into R sized chunks
			keytoF : for k in 0 to S-1 loop
				F(k) := (unsigned(key(R*k to R*k+R-1)));
			end loop; -- keytoF

			C := M(F(S-1));
			-- Do modular exponentiation
			main : for i in S-2 downto 0 loop
				for j in 0 to R loop
					C := modmult(C, C, modulus);
				end loop; -- 4a
				if (F(i) /= 0) then
					C := modmult(C, M(F(i)), modulus);
				end if; -- 4b
			end loop; -- main
		end if;
	end process; -- mary

end architecture;


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
