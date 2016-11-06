library IEEE;
use IEEE.std_logic_1164.all;

entity tb_controlModule is
end tb_controlModule;

architecture behavior of tb_controlModule is
	component controlModule
		port (
			i_instruction : in std_logic_vector(31 downto 0);
 			o_RegDst, o_jump, o_memRead, o_memtoReg, o_memWrite, o_ALUSrc, o_regWrite, o_andLink, o_lui, o_jr, o_bitwise : out std_logic;
			o_ALUBOX_op, o_alu_ctrl : out std_logic_vector(1 downto 0);
			o_ALUOp : out std_logic_vector(3 downto 0);
			o_memOp : out std_logic_vector(2 downto 0)
		);
	end component;

	signal s_instruction : std_logic_vector(31 downto 0);
 	signal s_RegDst, s_jump, s_memRead, s_memtoReg, s_memWrite, s_ALUSrc, s_regWrite, s_andLink, s_lui, s_jr : std_logic;
	signal s_ALUBOX_op, s_alu_ctrl : std_logic_vector(1 downto 0);
	signal s_ALUOp : std_logic_vector(3 downto 0);
	signal s_controlConcat : std_logic_vector(21 downto 0);
	signal s_memOp : std_logic_vector(2 downto 0);
	signal s_bitwise : std_logic;

begin
DUT : controlModule
	port map(
		i_instruction => s_instruction,
		o_RegDst => s_RegDst,
		o_jump => s_jump,
		o_memRead => s_memRead,
		o_memtoReg => s_memtoReg,
		o_memWrite => s_memWrite,
		o_ALUSrc => s_ALUSrc,
		o_regWrite => s_regWrite,
		o_andLink => s_andLink,
		o_lui => s_lui,
		o_jr => s_jr,
		o_ALUBOX_op => s_ALUBOX_op,
		o_alu_ctrl => s_alu_ctrl,
		o_ALUOp => s_ALUOp,
		o_memOP => s_memOP,
		o_bitwise => s_bitwise
	);
	s_controlConcat <= s_RegDst & s_jump & s_memRead & s_memtoReg & s_ALUOp & s_memWrite & s_ALUSrc & s_regWrite & s_alu_ctrl & s_ALUBOX_op & s_andLink & s_lui & s_jr & s_memOP & s_bitwise;

P_TB:
process
	begin
		
	s_instruction <= "00000000000000000000000000100000";
	wait for 10 ns;
	assert (s_controlConcat = "1000000000100000001110") report "add operation failed" severity error;
	wait for 50 ns;

	s_instruction <= "00100000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000000001100000001110") report "test addi failed" severity error;
	wait for 50 ns;

	s_instruction <= "00100100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000000101100000001110") report "test addiu failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000100001";
	wait for 10 ns;
	assert (s_controlConcat = "1000000100100000001110") report "test addu failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000100100";
	wait for 10 ns;
	assert (s_controlConcat = "1000010100100000001111") report "test and failed" severity error;
	wait for 50 ns;

	s_instruction <= "00110000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010101100000001111") report "test andi failed" severity error;
	wait for 50 ns;

	s_instruction <= "00010000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000001000000000001110") report "test beq failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000100000000010000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010000000000001110") report "test bgez failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000100000100010000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010000100001001110") report "test bgezal failed" severity error;
	wait for 50 ns;

	s_instruction <= "00011100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010000000000001110") report "test bgtz failed" severity error;
	wait for 50 ns;

	s_instruction <= "00011000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010000000000001110") report "test blez failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010000000000001110") report "test bltz failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000100000100000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010000100001001110") report "test bltzal failed" severity error;
	wait for 50 ns;

	s_instruction <= "00010100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000001000000000001110") report "test bne failed" severity error;
	wait for 50 ns;

	s_instruction <= "00001000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0100000000000000001110") report "test j failed" severity error;
	wait for 50 ns;

	s_instruction <= "00001100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0100000000100001001110") report "test jal failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000001001";
	wait for 10 ns;
	assert (s_controlConcat = "1100000000100001011110") report "test jalr failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000001000";
	wait for 10 ns;
	assert (s_controlConcat = "1100000000000000011110") report "test jr failed" severity error;
	wait for 50 ns;

	s_instruction <= "10000000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0011000001100000001000") report "test lb failed" severity error;
	wait for 50 ns;

	s_instruction <= "10010000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0011000001100000001100") report "test lbu failed" severity error;
	wait for 50 ns;

	s_instruction <= "10000100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0011000001100000001110") report "test lh failed" severity error;
	wait for 50 ns;

	s_instruction <= "10010100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0011000001100000001010") report "test lhu failed" severity error;
	wait for 50 ns;

	s_instruction <= "00111100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0010000000100000101110") report "test lui failed" severity error;
	wait for 50 ns;

	s_instruction <= "10001100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0011000001100000000110") report "test lw failed" severity error;
	wait for 50 ns;

	s_instruction <= "01110000000000000000000000000010";
	wait for 10 ns;
	assert (s_controlConcat = "1000000000101100001110") report "test mul failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000100111";
	wait for 10 ns;
	assert (s_controlConcat = "1000100100100000001111") report "test nor failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000100101";
	wait for 10 ns;
	assert (s_controlConcat = "1000011000100000001111") report "test or failed" severity error;
	wait for 50 ns;

	s_instruction <= "00110100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000011001100000001111") report "test ori failed" severity error;
	wait for 50 ns;

	s_instruction <= "10100000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000000011000000000000") report "test sb failed" severity error;
	wait for 50 ns;

	s_instruction <= "10100100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000000011000000000010") report "test sh failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "1000000000100010001110") report "test sll failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000000100";
	wait for 10 ns;
	assert (s_controlConcat = "1000000000100010001110") report "test sllv failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000101010";
	wait for 10 ns;
	assert (s_controlConcat = "1000010000100000001110") report "test slt failed" severity error;
	wait for 50 ns;

	s_instruction <= "00101000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010001100000001110") report "test slti failed" severity error;
	wait for 50 ns;

	s_instruction <= "00101100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000010001100000001110") report "test sltiu failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000101011";
	wait for 10 ns;
	assert (s_controlConcat = "1000010000100000001110") report "test sltu failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000000011";
	wait for 10 ns;
	assert (s_controlConcat = "1000000000111010001110") report "test sra failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000000111";
	wait for 10 ns;
	assert (s_controlConcat = "1000000000111010001110") report "test srav failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000000010";
	wait for 10 ns;
	assert (s_controlConcat = "1000000000101010001110") report "test srl failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000000110";
	wait for 10 ns;
	assert (s_controlConcat = "1000000000101010001110") report "test srlv failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000100010";
	wait for 10 ns;
	assert (s_controlConcat = "1000001000100000001110") report "test sub failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000100011";
	wait for 10 ns;
	assert (s_controlConcat = "1000001100100000001110") report "test subu failed" severity error;
	wait for 50 ns;

	s_instruction <= "10101100000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000000011000000000100") report "test sw failed" severity error;
	wait for 50 ns;

	s_instruction <= "00000000000000000000000000100110";
	wait for 10 ns;
	assert (s_controlConcat = "1000011100100000001111") report "test xor failed" severity error;
	wait for 50 ns;

	s_instruction <= "00111000000000000000000000000000";
	wait for 10 ns;
	assert (s_controlConcat = "0000011101100000001111") report "test xori failed" severity error;
	wait for 50 ns;

end process;
end behavior;
