library IEEE;
use IEEE.std_logic_1164.all;

entity extender8to32 is
	port(
		i_A : in std_logic_vector(7 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end extender8to32;


architecture dataflow of extender8to32 is

-- mostly taken from online examples

begin
	process (i_A)
	begin
	if i_A(7) = '1' then
		o_F <= x"FFFFFF" & i_A;
	else
		o_F <= x"000000" & i_A;
	end if;
	end process;

end dataflow;
