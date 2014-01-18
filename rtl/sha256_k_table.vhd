-- ===================================================================
-- TITLE : SHA-256 k table
--
--     DESIGN : S.OSAFUNE (J-7SYSTEM Works)
--     DATE   : 2014/01/13 -> 2014/01/14
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

entity sha256_k_table is
	port(
		clk			: in  std_logic;
		clk_ena		: in  std_logic := '1';
		addr_in		: in  std_logic_vector(5 downto 0);
		k_out		: out std_logic_vector(31 downto 0)
	);
end sha256_k_table;

architecture RTL of sha256_k_table is
	signal addr_reg : std_logic_vector(5 downto 0);

	type MEMARRAY is array(0 to 63) of std_logic_vector(31 downto 0);
	constant K_ROM : MEMARRAY := (
		X"428a2f98", X"71374491", X"b5c0fbcf", X"e9b5dba5",
		X"3956c25b", X"59f111f1", X"923f82a4", X"ab1c5ed5",
		X"d807aa98", X"12835b01", X"243185be", X"550c7dc3",
		X"72be5d74", X"80deb1fe", X"9bdc06a7", X"c19bf174",
		X"e49b69c1", X"efbe4786", X"0fc19dc6", X"240ca1cc",
		X"2de92c6f", X"4a7484aa", X"5cb0a9dc", X"76f988da",
		X"983e5152", X"a831c66d", X"b00327c8", X"bf597fc7",
		X"c6e00bf3", X"d5a79147", X"06ca6351", X"14292967",
		X"27b70a85", X"2e1b2138", X"4d2c6dfc", X"53380d13",
		X"650a7354", X"766a0abb", X"81c2c92e", X"92722c85",
		X"a2bfe8a1", X"a81a664b", X"c24b8b70", X"c76c51a3",
		X"d192e819", X"d6990624", X"f40e3585", X"106aa070",
		X"19a4c116", X"1e376c08", X"2748774c", X"34b0bcb5",
		X"391c0cb3", X"4ed8aa4a", X"5b9cca4f", X"682e6ff3",
		X"748f82ee", X"78a5636f", X"84c87814", X"8cc70208",
		X"90befffa", X"a4506ceb", X"bef9a3f7", X"c67178f2" );

begin

	process (clk) begin
		if rising_edge(clk) then
			if (clk_ena = '1') then
				addr_reg <= addr_in;
			end if;
		end if;
	end process;

	k_out <= K_ROM(conv_integer(addr_reg));


end RTL;

