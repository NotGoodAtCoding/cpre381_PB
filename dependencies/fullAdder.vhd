Library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is
	port(
		i_A : in std_logic;
		i_B : in std_logic;
		i_C : in std_logic;
		o_F : out std_logic;
		o_C : out std_logic);
end fullAdder;

architecture structure of fullAdder is

component xor2
	port(
		i_A : in std_logic;
		i_B : in std_logic;
		o_F : out std_logic);
end component;


component and2
	port(
		i_A : in std_logic;
		i_B : in std_logic;
		o_F : out std_logic);
end component;

component or2
	port(
		i_A : in std_logic;
		i_B : in std_logic;
		o_F : out std_logic);
end component;

signal sVALUE_ABxor, sVALUE_And1, sVALUE_And2 : std_logic;

begin

g_xor1: xor2
	port map(i_A => i_A,
		 i_B => i_B,
		 o_F => sVALUE_ABxor);

g_xor2: xor2
	port map(i_A => sVALUE_ABxor,
		 i_B => i_C,
		 o_F => o_F);

g_and1: and2
	port map(i_A => sVALUE_ABxor,
		 i_B => i_C,
		 o_F => sVALUE_And1);

g_and2: and2
	port map(i_A => i_A,
		 i_B => i_B,
		 o_F => sVALUE_And2);

g_or: or2
	port map(i_A => sVALUE_And1,
		 i_B => sVALUE_And2,
		 o_F => o_C);

end structure;

