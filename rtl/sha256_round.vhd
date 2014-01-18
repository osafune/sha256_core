-- ===================================================================
-- TITLE : SHA-256 round function module
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

-- h_init_in = '1'のときh0_in～h7_inの値が内部レジスタにロードされる(0サイクル目)
-- h_init_in = '0'のとき、内部レジスタでラウンド計算を行う(1～63サイクル目)
-- 出力は内部レジスタ出力なので、確定に1クロックのレイテンシがある 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sha256_round is
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
end sha256_round;

architecture RTL of sha256_round is
	function sum0(signal x : in std_logic_vector) return std_logic_vector is
		variable rotr2	: std_logic_vector(31 downto 0);
		variable rotr13	: std_logic_vector(31 downto 0);
		variable rotr22	: std_logic_vector(31 downto 0);
		variable ans	: std_logic_vector(31 downto 0);
	begin
		rotr2  := x(1 downto 0) & x(31 downto 2);
		rotr13 := x(12 downto 0) & x(31 downto 13);
		rotr22 := x(21 downto 0) & x(31 downto 22);
		ans := rotr2 xor rotr13 xor rotr22;
		return ans;
	end sum0;

	function sum1(signal x : in std_logic_vector) return std_logic_vector is
		variable rotr6	: std_logic_vector(31 downto 0);
		variable rotr11	: std_logic_vector(31 downto 0);
		variable rotr25	: std_logic_vector(31 downto 0);
		variable ans : std_logic_vector(31 downto 0);
	begin
		rotr6  := x(5 downto 0) & x(31 downto 6);
		rotr11 := x(10 downto 0) & x(31 downto 11);
		rotr25 := x(24 downto 0) & x(31 downto 25);
		ans := rotr6 xor rotr11 xor rotr25;
		return ans;
	end sum1;

	function ch(signal x : in std_logic_vector;
				signal y : in std_logic_vector;
				signal z : in std_logic_vector) return std_logic_vector is
		variable ans : std_logic_vector(31 downto 0);
	begin
		ans := (x and y) xor (not(x) and z); 
		return ans;
	end ch;

	function maj(signal x : in std_logic_vector;
				 signal y : in std_logic_vector;
				 signal z : in std_logic_vector) return std_logic_vector is
		variable ans : std_logic_vector(31 downto 0);
	begin
		ans := (x and y) xor (x and z) xor (y and z);
		return ans;
	end maj;

	signal a_reg,b_reg,c_reg,d_reg,e_reg,f_reg,g_reg,h_reg : std_logic_vector(31 downto 0);
	signal a_sig,b_sig,c_sig,d_sig,e_sig,f_sig,g_sig,h_sig : std_logic_vector(31 downto 0);
	signal k_reg,w_reg : std_logic_vector(31 downto 0);
	signal temp1_sig,temp2_sig : std_logic_vector(31 downto 0);

begin

	process (clk) begin
		if rising_edge(clk) then
			if (clk_ena = '1') then
				if (h_init_in = '1') then
					a_reg <= h0_in;
					b_reg <= h1_in;
					c_reg <= h2_in;
					d_reg <= h3_in;
					e_reg <= h4_in;
					f_reg <= h5_in;
					g_reg <= h6_in;
					h_reg <= h7_in;
				else
					a_reg <= a_sig;
					b_reg <= b_sig;
					c_reg <= c_sig;
					d_reg <= d_sig;
					e_reg <= e_sig;
					f_reg <= f_sig;
					g_reg <= g_sig;
					h_reg <= h_sig;
				end if;

				k_reg <= k_in;
				w_reg <= w_in;
			end if;
		end if;
	end process;

	temp1_sig <= h_reg + sum1(e_reg) + ch(e_reg, f_reg, g_reg) + k_reg + w_reg;
	temp2_sig <= sum0(a_reg) + maj(a_reg, b_reg, c_reg);

	a_sig <= temp1_sig + temp2_sig;
	b_sig <= a_reg;
	c_sig <= b_reg;
	d_sig <= c_reg;
	e_sig <= d_reg + temp1_sig;
	f_sig <= e_reg;
	g_sig <= f_reg;
	h_sig <= g_reg;

	a_out <= a_reg;
	b_out <= b_reg;
	c_out <= c_reg;
	d_out <= d_reg;
	e_out <= e_reg;
	f_out <= f_reg;
	g_out <= g_reg;
	h_out <= h_reg;


end RTL;
