library IEEE;
use IEEE.std_logic_1164.all;

entity extenderModule is
	port(
		i_op : in std_logic_vector(2 downto 0);
		i_memData : in std_logic_vector(31 downto 0);
		o_data : out std_logic_vector(31 downto 0));
end extenderModule;

architecture mixed of extenderModule is

component extender8to32 is
	port(
		i_A : in std_logic_vector(7 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end component;

component extender8to32u is
	port(
		i_A : in std_logic_vector(7 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end component;

component extender16to32 is
	port(
		i_A : in std_logic_vector(15 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end component;

component extender16to32u is
	port(
		i_A : in std_logic_vector(15 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end component;

signal s_8to32, s_8to32u, s_16to32, s_16to32u : std_logic_vector(31 downto 0);
begin

ext8to32: extender8to32
	port map(i_A => i_memData(7 downto 0),
		 o_F => s_8to32);

ext8to32u: extender8to32u
	port map(i_A => i_memData(7 downto 0),
		 o_F => s_8to32u);

ext16to32: extender16to32
	port map(i_A => i_memData(15 downto 0),
		 o_F => s_16to32);

ext16to32u: extender16to32u
	port map(i_A => i_memData(15 downto 0),
		 o_F => s_16to32u);

-- reference 

--opcode format: 000 = sb
--		 001 = sh
--		 010 = sw
--		 011 = lw
--		 100 = lb
--		 101 = lhu
--		 110 = lbu
--		 111 = lh

with i_op select
	o_data <=
		i_memData when "011", -- lw
		s_8to32 when "100",   -- lb
		s_16to32u when "101", -- lhu
		s_8to32u when "110",  -- lbu
		s_16to32 when "111",  -- lh
		x"00000000" when others;
end mixed; --magic





