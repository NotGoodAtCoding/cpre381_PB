
library IEEE;
use IEEE.std_logic_1164.all;

entity branch_control is
	port(
		i_zero : in std_logic; 
		i_op   : in std_logic_vector(31 downto 0);
		i_lessThan : in std_logic;
		o_branch : out std_logic
	);
end branch_control;

architecture dataflow of branch_control is

signal s_op : std_logic_vector(5 downto 0);
signal s_rt : std_logic_vector(4 downto 0);
signal s_zero, s_branch, s_lessThan : std_logic;

begin

o_branch <= s_branch;
s_op <= i_op(31 downto 26);
s_rt <= i_op(20 downto 16);
s_zero <= i_zero;
s_lessThan <= i_lessThan;

process(s_op, s_lessThan, s_zero, s_rt)
	begin
	if (s_op = "000100" and s_zero='1' ) then--beq
		s_branch <= '1';
	elsif (s_op = "000001") then
		if (s_rt = "00001" and (s_zero='1' or not s_lessThan='1')) then --bgez
			s_branch <= '1';
		elsif (s_rt = "10001" and (s_zero='1' or not s_lessThan='1')) then --bgezal
			s_branch <= '1';
		elsif (s_rt = "00000" and s_lessThan='1' and s_zero='0') then --bltz -- added not s_zero='1'
			s_branch <= '1';
		elsif (s_rt = "10000" and s_lessThan='1' and s_zero='0') then --bltzal -- added not s_zero='1'
			s_branch <= '1';
		else
			s_branch <= '0';
		end if;
	elsif (s_op = "000111" and not s_lessThan='1' and not s_zero='1') then--bgtz --- added not s_zero='1'
		s_branch <= '1';
	elsif (s_op = "000110" and (s_zero='1' or s_lessThan='1')) then--blez
		s_branch <= '1';
	elsif (s_op = "000101" and not s_zero='1') then--bne
		s_branch <= '1';
	else
		s_branch <= '0';
	end if;
end process;
--if (beq and s_zero) branch
--if (bgez and (s_zero or not s_lessThan))
--if (bgezal and (s_zero or not s_lessThan))
--if (bgtz and not s_lessThan)
--if (blez and (s_zero or s_lessThan))
--if (bltz and s_lessThan)
--if (bltzal and s_lessThan)
--if (bne and not s_zero)

end dataflow;
