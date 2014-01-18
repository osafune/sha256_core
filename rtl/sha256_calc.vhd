-- ===================================================================
-- TITLE : SHA-256 calculation module
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

entity sha256_calc is
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
end sha256_calc;

architecture RTL of sha256_calc is
	type DEF_STATE is (IDLE,CYCLE,DONE);
	signal state : DEF_STATE;
	signal count_reg	: std_logic_vector(6 downto 0);
	signal init_sig		: std_logic;
	signal done_sig		: std_logic;
	signal ack_reg		: std_logic;
	signal clkena_sig	: std_logic;
	signal hload_reg	: std_logic;

	component sha256_k_table is
	port(
		clk			: in  std_logic;
		clk_ena		: in  std_logic := '1';
		addr_in		: in  std_logic_vector(5 downto 0);
		k_out		: out std_logic_vector(31 downto 0)
	);
	end component;
	signal addr_in_sig	: std_logic_vector(5 downto 0);
	signal k_out_sig	: std_logic_vector(31 downto 0);

	component sha256_w_gen is
	port(
		clk			: in  std_logic;
		clk_ena		: in  std_logic := '1';
		m_load		: in  std_logic;
		m_in		: in  std_logic_vector(31 downto 0);
		w_out		: out std_logic_vector(31 downto 0)
	);
	end component;
	signal m_in_sig		: std_logic_vector(31 downto 0);
	signal w_out_sig	: std_logic_vector(31 downto 0);

	component sha256_round is
	port(
		clk			: in  std_logic;
		clk_ena		: in  std_logic := '1';

		h_init_in	: in  std_logic;
		h0_in		: in  std_logic_vector(31 downto 0);
		h1_in		: in  std_logic_vector(31 downto 0);
		h2_in		: in  std_logic_vector(31 downto 0);
		h3_in		: in  std_logic_vector(31 downto 0);
		h4_in		: in  std_logic_vector(31 downto 0);
		h5_in		: in  std_logic_vector(31 downto 0);
		h6_in		: in  std_logic_vector(31 downto 0);
		h7_in		: in  std_logic_vector(31 downto 0);
		k_in		: in  std_logic_vector(31 downto 0);
		w_in		: in  std_logic_vector(31 downto 0);

		a_out		: out std_logic_vector(31 downto 0);
		b_out		: out std_logic_vector(31 downto 0);
		c_out		: out std_logic_vector(31 downto 0);
		d_out		: out std_logic_vector(31 downto 0);
		e_out		: out std_logic_vector(31 downto 0);
		f_out		: out std_logic_vector(31 downto 0);
		g_out		: out std_logic_vector(31 downto 0);
		h_out		: out std_logic_vector(31 downto 0)
	);
	end component;
	signal aout_sig,bout_sig,cout_sig,dout_sig,eout_sig,fout_sig,gout_sig,hout_sig : std_logic_vector(31 downto 0);

	signal h0_reg,h1_reg,h2_reg,h3_reg,h4_reg,h5_reg,h6_reg,h7_reg : std_logic_vector(31 downto 0);
	signal hvalid_reg	: std_logic;

begin

	ready <= '1' when(state = IDLE) else '0';

	process (clk,reset) begin
		if (reset = '1') then
			state <= IDLE;
			ack_reg <= '0';
			hload_reg <= '0';

		elsif rising_edge(clk) then
			if (clk_ena = '1') then
				case state is
				when IDLE =>
					if (start = '1') then
						state <= CYCLE;
						count_reg <= (others=>'0');
					end if;

				when CYCLE =>
					if (count_reg = 0) then
						ack_reg <= '1';
					elsif (count_reg = 16) then
						ack_reg <= '0';
					end if;

					if (count_reg = 0) then
						hload_reg <= '1';
					else
						hload_reg <= '0';
					end if;

					if (count_reg = 65) then
						state <= DONE;
					end if;

					count_reg <= count_reg + 1;

				when DONE =>
					state <= IDLE;

				end case;

			end if;
		end if;
	end process;


	clkena_sig <= clk_ena when(state /= IDLE) else '0';
	init_sig   <= '1' when(state = IDLE and init = '1') else '0';
	done_sig   <= '1' when(state = DONE) else '0';

	addr_in_sig <= count_reg(5 downto 0);
	m_in_sig <= m_in;
	m_in_ack <= ack_reg;

	k_table_inst : sha256_k_table port map(
		clk			=> clk,
		clk_ena		=> clkena_sig,
		addr_in		=> addr_in_sig,
		k_out		=> k_out_sig
	);

	w_gen_inst : sha256_w_gen port map(
		clk			=> clk,
		clk_ena		=> clkena_sig,
		m_load		=> ack_reg,
		m_in		=> m_in_sig,
		w_out		=> w_out_sig
	);

	round_inst : sha256_round port map(
		clk			=> clk,
		clk_ena		=> clkena_sig,

		h_init_in	=> hload_reg,
		h0_in		=> h0_reg,
		h1_in		=> h1_reg,
		h2_in		=> h2_reg,
		h3_in		=> h3_reg,
		h4_in		=> h4_reg,
		h5_in		=> h5_reg,
		h6_in		=> h6_reg,
		h7_in		=> h7_reg,
		k_in		=> k_out_sig,
		w_in		=> w_out_sig,

		a_out		=> aout_sig,
		b_out		=> bout_sig,
		c_out		=> cout_sig,
		d_out		=> dout_sig,
		e_out		=> eout_sig,
		f_out		=> fout_sig,
		g_out		=> gout_sig,
		h_out		=> hout_sig
	);


	process (clk,reset) begin
		if (reset = '1') then
			hvalid_reg <= '0';

		elsif rising_edge(clk) then
			if (clk_ena = '1') then
				if (init_sig = '1') then
					h0_reg <= X"6a09e667";
					h1_reg <= X"bb67ae85";
					h2_reg <= X"3c6ef372";
					h3_reg <= X"a54ff53a";
					h4_reg <= X"510e527f";
					h5_reg <= X"9b05688c";
					h6_reg <= X"1f83d9ab";
					h7_reg <= X"5be0cd19";
					hvalid_reg <= '0';

				elsif (done_sig = '1') then
					h0_reg <= h0_reg + aout_sig;
					h1_reg <= h1_reg + bout_sig;
					h2_reg <= h2_reg + cout_sig;
					h3_reg <= h3_reg + dout_sig;
					h4_reg <= h4_reg + eout_sig;
					h5_reg <= h5_reg + fout_sig;
					h6_reg <= h6_reg + gout_sig;
					h7_reg <= h7_reg + hout_sig;
					hvalid_reg <= '1';

				end if;
			end if;
		end if;
	end process;

	hash <= h0_reg & h1_reg & h2_reg & h3_reg & h4_reg & h5_reg & h6_reg & h7_reg;
	hash_valid <= hvalid_reg;


end RTL;
