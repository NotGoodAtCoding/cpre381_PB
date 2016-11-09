library IEEE;
use IEEE.std_logic_1164.all;

entity extender16to32u is
	port(
		i_A : in std_logic_vector(15 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end extender16to32u;


architecture dataflow of extender16to32u is

begin

	o_F <= x"0000" & i_A;

end dataflow;
