--------------------------------------------------------------------------------
-- Author       : Oystein Gjermundnes
-- Organization : Norwegian University of Science and Technology (NTNU)
--                Department of Electronic Systems
--                https://www.ntnu.edu/ies
-- Course       : TFE4141 Design of digital systems 1 (DDS1)
-- Year         : 2018-2019
-- Project      : RSA accelerator
-- License      : This is free and unencumbered software released into the
--                public domain (UNLICENSE)
--------------------------------------------------------------------------------
-- Purpose:
--   RSA encryption core template. This core currently computes
--   C = M xor key_n
--
--   Replace/change this module so that it implements the function
--   C = M**key_e mod key_n.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rsa_core is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE          : integer := 256
	);
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    :  in std_logic;
		reset_n                :  in std_logic;

		-----------------------------------------------------------------------------
		-- Slave msgin interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgin_valid             : in std_logic;
		-- Slave ready to accept a new message
		msgin_ready             : out std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data              :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgin_last              :  in std_logic;

		-----------------------------------------------------------------------------
		-- Master msgout interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgout_valid            : out std_logic;
		-- Slave ready to accept a new message
		msgout_ready            :  in std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data             : out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgout_last             : out std_logic;

		-----------------------------------------------------------------------------
		-- Interface to the register block
		-----------------------------------------------------------------------------
		key_e_d                 :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		key_n                   :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		rsa_status              : out std_logic_vector(31 downto 0)

	);
end rsa_core;

architecture rtl of rsa_core is
	signal rl_data :std_logic_vector(255 downto 0);
	signal rl_ready :std_logic_vector(47 downto 0);
	signal rl_valid :std_logic_vector(47 downto 0);
	signal ready_in :std_logic_vector(47 downto 0);
	signal ready_out :std_logic_vector(47 downto 0);

	component exponentiation is
		generic (
			C_block_size : integer := 256
		);
		port (
			valid_in		: in  STD_LOGIC;
			ready_in		: out STD_LOGIC;
			message 		: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0 );
			key 			: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0 );
			ready_out	: in  STD_LOGIC;
			valid_out	: out STD_LOGIC;
			result		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);
			modulus 		: in  STD_LOGIC_VECTOR(C_block_size-1 downto 0);
			clk 			: in STD_LOGIC;
			reset_n 		: in STD_LOGIC
		);
	end component;
begin
	-- i_exponentiation : entity work.exponentiation
	-- 	generic map (
	-- 		C_block_size => C_BLOCK_SIZE
	-- 	)
	-- 	port map (
	-- 		message   => msgin_data  ,
	-- 		key       => key_e_d     ,
	-- 		valid_in  => msgin_valid ,
	-- 		ready_in  => msgin_ready ,
	-- 		ready_out => msgout_ready,
	-- 		valid_out => msgout_valid,
	-- 		result    => rl_data,
	-- 		modulus   => key_n       ,
	-- 		clk       => clk         ,
	-- 		reset_n   => reset_n
	-- 	);
	gen: for i in 0 to 47 generate

		element: entity work.exponentiation(rl_binary_rtl) port map(
			message   => msgin_data  ,
			key       => key_e_d     ,
			valid_in  => rl_valid(i) ,
			ready_in  => ready_in(i),
			ready_out => ready_out(i),
			valid_out => rl_ready(i),
			result    => rl_data,
			modulus   => key_n       ,
			clk       => clk         ,
			reset_n   => reset_n
		);
	end generate;

	control : entity work.rsa_control
		generic map (
			C_BLOCK_SIZE => C_BLOCK_SIZE
		)
		port map (
			clk => clk,
			msgin_valid => msgin_valid,
			msgin_ready => msgin_ready,
			msgin_data => msgin_data,
			msgin_last => msgin_last,
			msgout_valid => msgout_valid,
			msgout_ready => msgout_ready,
			msgout_data => msgout_data,
			msgout_last => msgout_last,
			rl_data => rl_data,
			rl_ready => rl_ready,
			rl_valid => rl_valid
		);

	msgout_last  <= msgin_last;
	rsa_status   <= (others => '0');
end rtl;
