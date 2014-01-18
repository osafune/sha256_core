-- ===================================================================
-- TITLE : SHA-256 w generate module
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM Works)
--     DATE   : 2014/01/14 -> 2014/01/17
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

-- m_load = '1'Ç…ÇµÇƒm_inÇ…m0,m1,ÅdÅd,m15ÇèáÇ…ìäì¸ÅBw_outÇ…ÇÕm_inÇ™ÇªÇÃÇ‹Ç‹èoÇÈ(w0Å`15)
-- m_load = '0'Ç…Ç∑ÇÈÇ∆w_outÇ…w16,w17,ÅdÅd,w63Ç™èoóÕÅBm_inÇÕïsíËÇ≈OK

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sha256_w_gen is
	port(
		clk			: in  std_logic;
		clk_ena		: in  std_logic := '1';
		m_load		: in  std_logic;
		m_in		: in  std_logic_vector(31 downto 0);
		w_out		: out std_logic_vector(31 downto 0)
	);
end sha256_w_gen;

architecture RTL of sha256_w_gen is
	function sigma0(signal x : in std_logic_vector) return std_logic_vector is
		variable rotr7	: std_logic_vector(31 downto 0);
		variable rotr18	: std_logic_vector(31 downto 0);
		variable shr3	: std_logic_vector(31 downto 0);
		variable ans	: std_logic_vector(31 downto 0);
	begin
		rotr7  := x(6 downto 0) & x(31 downto 7);
		rotr18 := x(17 downto 0) & x(31 downto 18);
		shr3   := "000" & x(31 downto 3);
		ans := rotr7 xor rotr18 xor shr3;
		return ans;
	end sigma0;

	function sigma1(signal x : in std_logic_vector) return std_logic_vector is
		variable rotr17	: std_logic_vector(31 downto 0);
		variable rotr19	: std_logic_vector(31 downto 0);
		variable shr10	: std_logic_vector(31 downto 0);
		variable ans	: std_logic_vector(31 downto 0);
	begin
		rotr17 := x(16 downto 0) & x(31 downto 17);
		rotr19 := x(18 downto 0) & x(31 downto 19);
		shr10  := "0000000000" & x(31 downto 10);
		ans := rotr17 xor rotr19 xor shr10;
		return ans;
	end sigma1;

	type MES_ARRAY is array(0 to 15) of std_logic_vector(31 downto 0);
	signal m_reg : MES_ARRAY;
	signal m_in_sig	: std_logic_vector(31 downto 0);
	signal w_sig	: std_logic_vector(31 downto 0);

begin

	m_in_sig <= m_in when(m_load = '1') else w_sig;

	process (clk) begin
		if rising_edge(clk) then
			if (clk_ena = '1') then
				m_reg(0) <= m_in_sig;

				for i in 1 to 15 loop
					m_reg(i) <= m_reg(i-1);
				end loop;
			end if;
		end if;
	end process;

	w_sig <= sigma1(m_reg(1)) + m_reg(6) + sigma0(m_reg(14)) + m_reg(15);

	w_out <= m_in_sig;


end RTL;

