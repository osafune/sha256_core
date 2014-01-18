-- ===================================================================
-- TITLE : SHA-256 calculation module Test Bench
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM Works)
--     DATE   : 2014/01/16 -> 2014/01/17
--
-- ===================================================================
-- *******************************************************************
--   Copyright (C) 2014, J-7SYSTEM Works.  All rights Reserved.
--
-- * This module is a free sourcecode and there is NO WARRANTY.
-- * No restriction on use. You can use, modify and redistribute it
--   for personal, non-profit or commercial products UNDER YOUR
--   RESPONSIBILITY.
-- * Redistributions of source code must retain the above copyright
--   notice.
-- *******************************************************************


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity tb_sha256 is
end tb_sha256;

architecture TB of tb_sha256 is
	constant clk_period : time := 10 ns;

	component sha256_calc is
	port(
		reset		: in  std_logic;
		clk			: in  std_logic;
		clk_ena		: in  std_logic := '1';

		init		: in  std_logic;
		start		: in  std_logic;
		ready		: out std_logic;
		m_in		: in  std_logic_vector(31 downto 0);
		m_in_ack	: out std_logic;

		hash		: out std_logic_vector(255 downto 0);
		hash_valid	: out std_logic
	);
	end component;

	signal reset_sig	: std_logic;
	signal clk_sig		: std_logic;
	signal clk_ena_sig	: std_logic;
	signal init_sig		: std_logic;
	signal start_sig	: std_logic;
	signal ready_sig	: std_logic;
	signal m_in_sig		: std_logic_vector(31 downto 0);
	signal m_in_ack_sig	: std_logic;
	signal hash_sig		: std_logic_vector(255 downto 0);
	signal hash_valid_sig	: std_logic;

begin

	-- Instantiate the Unit Under Test (UUT)

	uut0 : sha256_calc port map(
		reset		=> reset_sig,
		clk			=> clk_sig,
		clk_ena		=> clk_ena_sig,
		init		=> init_sig,
		start		=> start_sig,
		ready		=> ready_sig,
		m_in		=> m_in_sig,
		m_in_ack	=> m_in_ack_sig,
		hash		=> hash_sig,
		hash_valid	=> hash_valid_sig
	);


   -- Clock and Reset

	clk_gen : process begin
		clk_sig <= '1';
		wait for clk_period/2;
		clk_sig <= '0';
		wait for clk_period/2;
	end process;

	reset_gen : process begin
		reset_sig <= '1';
		wait for clk_period*3;
		reset_sig <= '0';
		wait;
	end process;


   -- Stimulus

	stim : process begin
		clk_ena_sig <= '1';
		init_sig <= '0';
		start_sig <= '0';
		m_in_sig <= (others=>'X');

		wait for clk_period*10;
		assert ready_sig = '1' report "[!] Initialization Failed";

		report "* Test Started";

		-- Example from "APPENDIX B: SHA-256 EXAMPLES",
		-- B.1 SHA-256 Example (One-Block Message)
		-- FIPS 180-2

		init_sig <= '1';			wait for clk_period;
		init_sig <= '0';
		assert hash_valid_sig = '0' report "[!] Hash register Initialization Failed";

		start_sig <= '1';			wait for clk_period;
		start_sig <= '0';
		assert ready_sig = '0' report "[!] Failed to start";

		m_in_sig <= X"61626380";	wait for clk_period;	-- M0
		m_in_sig <= X"00000000";	wait for clk_period;	-- M1
		m_in_sig <= X"00000000";	wait for clk_period;	-- M2
		m_in_sig <= X"00000000";	wait for clk_period;	-- M3
		m_in_sig <= X"00000000";	wait for clk_period;	-- M4
		m_in_sig <= X"00000000";	wait for clk_period;	-- M5
		m_in_sig <= X"00000000";	wait for clk_period;	-- M6
		m_in_sig <= X"00000000";	wait for clk_period;	-- M7
		m_in_sig <= X"00000000";	wait for clk_period;	-- M8
		m_in_sig <= X"00000000";	wait for clk_period;	-- M9
		m_in_sig <= X"00000000";	wait for clk_period;	-- M10
		m_in_sig <= X"00000000";	wait for clk_period;	-- M11
		m_in_sig <= X"00000000";	wait for clk_period;	-- M12
		m_in_sig <= X"00000000";	wait for clk_period;	-- M13
		m_in_sig <= X"00000000";	wait for clk_period;	-- M14
		m_in_sig <= X"00000018";	wait for clk_period;	-- M15
		m_in_sig <= (others=>'X');

		wait until ready_sig = '1';
		assert hash_valid_sig = '1' report "[!] Not calculated completion Hash";

		assert hash_sig = X"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
			report "[!] B.1 Hash output ERROR";

		report "* B.1 Hash is OK";
		wait for clk_period*10;


		-- Example from "APPENDIX B: SHA-256 EXAMPLES",
		-- B.1 SHA-256 Example (One-Block Message)
		-- FIPS 180-2

		init_sig <= '1';			wait for clk_period;
		init_sig <= '0';

		start_sig <= '1';			wait for clk_period;
		start_sig <= '0';
		assert ready_sig = '0' report "[!] Failed to start";

		m_in_sig <= X"61626364";	wait for clk_period;	-- M0
		m_in_sig <= X"62636465";	wait for clk_period;	-- M1
		m_in_sig <= X"63646566";	wait for clk_period;	-- M2
		m_in_sig <= X"64656667";	wait for clk_period;	-- M3
		m_in_sig <= X"65666768";	wait for clk_period;	-- M4
		m_in_sig <= X"66676869";	wait for clk_period;	-- M5
		m_in_sig <= X"6768696A";	wait for clk_period;	-- M6
		m_in_sig <= X"68696A6B";	wait for clk_period;	-- M7
		m_in_sig <= X"696A6B6C";	wait for clk_period;	-- M8
		m_in_sig <= X"6A6B6C6D";	wait for clk_period;	-- M9
		m_in_sig <= X"6B6C6D6E";	wait for clk_period;	-- M10
		m_in_sig <= X"6C6D6E6F";	wait for clk_period;	-- M11
		m_in_sig <= X"6D6E6F70";	wait for clk_period;	-- M12
		m_in_sig <= X"6E6F7071";	wait for clk_period;	-- M13
		m_in_sig <= X"80000000";	wait for clk_period;	-- M14
		m_in_sig <= X"00000000";	wait for clk_period;	-- M15
		m_in_sig <= (others=>'X');

		wait until ready_sig = '1';
		assert hash_valid_sig = '1' report "[!] Not calculated completion Hash";

		assert hash_sig = X"85e655d6417a17953363376a624cde5c76e09589cac5f811cc4b32c1f20e533a"
			report "[!] B.2 (Part 1) Hash output ERROR";

		report "* B.2 (Part 1) Hash is OK";
		wait for clk_period;


		start_sig <= '1';			wait for clk_period;
		start_sig <= '0';
		assert ready_sig = '0' report "[!] Failed to start";

		m_in_sig <= X"00000000";	wait for clk_period;	-- M0
		m_in_sig <= X"00000000";	wait for clk_period;	-- M1
		m_in_sig <= X"00000000";	wait for clk_period;	-- M2
		m_in_sig <= X"00000000";	wait for clk_period;	-- M3
		m_in_sig <= X"00000000";	wait for clk_period;	-- M4
		m_in_sig <= X"00000000";	wait for clk_period;	-- M5
		m_in_sig <= X"00000000";	wait for clk_period;	-- M6
		m_in_sig <= X"00000000";	wait for clk_period;	-- M7
		m_in_sig <= X"00000000";	wait for clk_period;	-- M8
		m_in_sig <= X"00000000";	wait for clk_period;	-- M9
		m_in_sig <= X"00000000";	wait for clk_period;	-- M10
		m_in_sig <= X"00000000";	wait for clk_period;	-- M11
		m_in_sig <= X"00000000";	wait for clk_period;	-- M12
		m_in_sig <= X"00000000";	wait for clk_period;	-- M13
		m_in_sig <= X"00000000";	wait for clk_period;	-- M14
		m_in_sig <= X"000001c0";	wait for clk_period;	-- M15
		m_in_sig <= (others=>'X');

		wait until ready_sig = '1';
		assert hash_sig = X"248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1"
			report "[!] B.2 (Part 2) Hash output ERROR";

		report "* B.2 (Part 2) Hash is OK";
		report "* Test Pass";

		wait;
	end process;


end TB;
