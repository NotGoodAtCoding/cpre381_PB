library IEEE;
use IEEE.std_logic_1164.all;
use work.arrays.all;


entity mult32 is
	port(
		i_A, i_B : in std_logic_vector(31 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end mult32;

architecture mixed of mult32 is

	component fullAdder is
		port(
			i_A : in std_logic;
			i_B : in std_logic;
			i_C : in std_logic;
			o_F : out std_logic;
			o_C : out std_logic);
	end component;

	signal s_FAOut, s_FACarryOut, s_AandB : array32_Bit(31 downto 0);
	signal s_F : std_logic_vector(63 downto 0);

	begin
	process (i_A, i_B)
	begin
		for i in 0 to 31 loop
			for j in 0 to 31 loop
			s_AandB(i)(j) <= i_A(i) and i_B(j);
			end loop;
		end loop;
	end process;

	process (s_F)
	begin
		o_F <= s_F(31 downto 0);
	end process;

	FA_0_0 : fullAdder
		port map(i_A => s_AandB(0)(0),
			 i_B => '0',
			 i_C => '0',
			 o_F => s_F(0),
			 o_C => s_FACarryOut(0)(0));


	G1: for j in 1 to 31 generate
	  FA_0_j : fullAdder
		port map(i_A => s_AandB(j)(0),
			 i_B => s_AandB(j-1)(1),
			 i_C => '0',
			 o_F => s_FAOut(0)(j),
			 o_C => s_FACarryOut(0)(j));
	  end generate;

	G2: for i in 1 to 30 generate
	  FA_i_0 : fullAdder
		port map(i_A => s_FAOut(i-1)(1),
			 i_B => '0',
			 i_C => s_FACarryOut(i-1)(0),
			 o_F => s_F(i),
			 o_C => s_FACarryOut(i)(0));

	  	G2_1: for j in 1 to 30 generate
			FA_i_j : fullAdder
			port map(i_A => s_FAOut(i-1)(j+1),
				 i_B => s_AandB(j-1)(i+1),
				 i_C => s_FACarryOut(i-1)(j),
				 o_F => s_FAOut(i)(j),
				 o_C => s_FACarryOut(i)(j));
		end generate;

	  FA_i_31 : fullAdder
		port map(i_A => s_AandB(31)(i),
			 i_B => s_AandB(31-1)(i+1),
			 i_C => s_FACarryOut(i-1)(31),
			 o_F => s_FAOut(i)(31),
			 o_C => s_FACarryOut(i)(31));
	end generate;

	FA_31_0 : fullAdder
		port map(i_A => s_FAOut(30)(1),
			 i_B => '0',
			 i_C => s_FACarryOut(31)(0),
			 o_F => s_F(31),
			 o_C => s_FACarryOut(31)(0));

	
	G3: for j in 1 to 30 generate
	  FA_31_j : fullAdder
		port map(i_A => s_FAOut(30)(j+1),
			 i_B => s_FACarryOut(31)(j-1),
			 i_C => s_FACarryOut(30)(j),
			 o_F => s_F(31+j),
			 o_C => s_FACarryOut(31)(j));
	 end generate;

	FA_31_31 : fullAdder
		port map(i_A => s_AandB(31)(31),
			 i_B => s_FACarryOut(31)(31-1),
			 i_C => s_FACarryOut(30)(31),
			 o_F => s_F(31+31),
			 o_C => s_F(31+31+1));
	 	
end mixed;


