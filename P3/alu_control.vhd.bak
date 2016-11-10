library IEEE;
use IEEE.std_logic_1164.all;


entity alu_control is 
  port(i_alu_op      : in std_logic_vector(3 downto 0);     -- o_zero from ALU
       i_op          : in std_logic_vector(5 downto 0);     -- bits 31 to 26 of the instruction
       o_alu_op      : out std_logic_vector(6 downto 0)   -- Data value output
  );
end alu_control;

architecture dataflow of alu_control is


begin

o_alu_op(5 downto 2) <= i_alu_op; --alu OP code

with i_op select o_alu_op(6) <= --is shift by value
	'0' when "000100", --sllv
	'0' when "000111", --srav
	'0' when "000110", --srlv
	'1' when others;

with i_op select o_alu_op(1) <= --is arithmetic
	'1' when "000011", --sra
	'1' when "000111", --srav
	'0' when others;

with i_op select o_alu_op(0) <= --is shift right
	'1' when "000011", --sra
	'1' when "000111", --srav
	'1' when "000010", --srl
	'1' when "000110", --srlv
	'0' when others;

end dataflow;



