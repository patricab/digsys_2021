entity rsa_core is
  port (
		clk : in std_logic;

		-- RSA reg I/O
		key_n, key_e : in  std_logic_vector(255 downto 0);
		rsa_status   : out std_logic_vector(31 downto 0);

		-- RSA message in
		msgin_valid  : in  std_logic;
		msgin_ready  : out std_logic;
		msgin_last   : in  std_logic;
		msgin_data   : in  std_logic_vector(255 downto 0);

		-- RSA message out
		msgout_valid  : out std_logic;
		msgout_ready  : in  std_logic;
		msgout_last   : out std_logic;
		msgout_data   : out std_logic_vector(255 downto 0);
  );
end rsa_core;

architecture behavioral_arch of rsa_core is

	signal

begin

	modexp: : entity work.modexp port map(
		clk => clk, reset_n => reset_n,

		msgin_ready => msgin_ready,
		msgin_data  => msgin_data,

		msgout_ready => msgout_ready,
		msgout_data  => msgout_data,
	);



end architecture ; -- behavioral_arch