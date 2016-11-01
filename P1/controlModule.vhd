library IEEE;
use IEEE.std_logic_1164.all;

entity controlModule is
	port(
		i_instruction : in std_logic_vector(31 downto 0);
 		o_RegDst, o_jump, o_memRead, o_memtoReg, o_memWrite, o_ALUSrc, o_regWrite, o_andLink, o_lui, o_jr, o_bitwise : out std_logic;
		o_ALUBOX_op, o_alu_ctrl : out std_logic_vector(1 downto 0);
		o_memOP : out std_logic_vector(2 downto 0);
		o_ALUOp : out std_logic_vector(3 downto 0)
	);
end controlModule;

architecture dataflow of controlModule is

signal s_op, s_func : std_logic_vector(5 downto 0);
signal s_rt : std_logic_vector(4 downto 0);
signal s_alu_ctrl_bit0,s_alu_ctrl_bit1 : std_logic;
signal s_op_cat_func : std_logic_vector(11 downto 0);

begin

--------------- DEFINE SIGNALS --------------------

s_op <= i_instruction(31 downto 26);  -- OPCODE
s_rt <= i_instruction(20 downto 16);  -- TARGET REGISTER
s_func <= i_instruction(5 downto 0);  -- FUNCTION CODE
o_alu_ctrl(0) <= s_alu_ctrl_bit0;     -- ALU CONTROL 0
o_alu_ctrl(1) <= s_alu_ctrl_bit1;     -- ALU CONTROL 1
s_op_cat_func <= s_op & s_func;       -- 


--------------- MEMORY OPERATIONS -------------------

with s_op select o_memOP <=
	"000" when "101000",
	"001" when "101001",
	"010" when "101011",
	"011" when "100011",
	"100" when "100000",
	"101" when "100101",
	"110" when "100100",
	"111" when "100001",
	"111" when others;

	
----------------- REGISTER DESTINATION ----------------
with s_op select o_RegDst <=
	'1' when  "000000", --	add
	'0' when  "001000", --	addi
	'0' when  "001001", --	addiu
	--'1' when  "000000", --	addu
	--'1' when  "000000", --	and
	'0' when  "001100", --	andi
	--'-' when  "000100", --	beq
	--'-' when  "000001", --	bgez
	--'-' when  "000001", --	bgezal
	--'-' when  "000111", --	bgtz
	--'-' when  "000110", --	blez
	--'-' when  "000001", --	bltz
	--'-' when  "000001", --	bltzal
	--'-' when  "000101", --	bne
	--'-' when  "000010", --	j
	--'-' when  "000011", --	jal
	--'-' when  "000000", --	jalr
	--'-' when  "000000", --	jr
	'0' when  "100000", --	lb
	'0' when  "100100", --	lbu
	'0' when  "100001", --	lh
	'0' when  "100101", --	lhu
	'0' when  "001111", --	lui
	'0' when  "100011", --	lw
	'1' when  "011100", --	mul
	--'1' when  "000000", --	nor
	--'1' when  "000000", --	or
	'0' when  "001101", --	ori
	'0' when  "101000", --	sb
	'0' when  "101001", --	sh
	--'1' when  "000000", --	sll
	--'1' when  "000000", --	sllv
	--'1' when  "000000", --	slt
	'0' when  "001010", --	slti
	'0' when  "001011", --	sltiu
	--'1' when  "000000", --	sltu
	--'1' when  "000000", --	sra
	--'1' when  "000000", --	sra
	--'1' when  "000000", --	srl
	--'1' when  "000000", --	srlv
	--'1' when  "000000", --	sub
	--'1' when  "000000", --	subu
	'0' when  "101011", --	sw
	--'1' when  "000000", --	xor
	'0' when  "001110", --	xori
	'0' when others;

--o_jump

---------------- JUMP PROCESS INSTRUCTIONS ----------------
process (s_op, s_func)
begin
	if (s_op = "000010" or s_op = "000011") then --j and jal
		o_jump <= '1';
	elsif (s_op = "000000" and s_func = "001001") then --jalr
		o_jump <= '1';
	elsif (s_op = "000000" and s_func = "001000") then --jr
		o_jump <= '1';
	else
		o_jump <= '0';
	end if;
end process;

------------------ FUNCTION CODE HANDLING ---------------------
process (s_op, s_func)
begin
	if(s_op = "000000" and s_func = "100100") then
		o_bitwise <= '1';
	elsif(s_op = "001100") then
		o_bitwise <= '1';
	elsif(s_op = "000000" and s_func = "100111") then
		o_bitwise <= '1';
	elsif(s_op = "000000" and s_func = "100101") then
		o_bitwise <= '1';
	elsif(s_op = "001101") then
		o_bitwise <= '1';
	elsif(s_op = "000000" and s_func = "100110") then
		o_bitwise <= '1';
	elsif(s_op = "001110") then
		o_bitwise <= '1';
	else
		o_bitwise <= '0';
	end if;
end process;


------------------- MEMORY READ OPERATIONS --------------------
with s_op select o_MemRead <=
	'0' when  "000000", --	add
	'0' when  "001000", --	addi
	'0' when  "001001", --	addiu
--	'0' when  "000000", --	addu
--	'0' when  "000000", --	and
	'0' when  "001100", --	andi
	'0' when  "000100", --	beq
	'0' when  "000001", --	bgez
--	'0' when  "000001", --	bgezal
	'0' when  "000111", --	bgtz
	'0' when  "000110", --	blez
--	'0' when  "000001", --	bltz
--	'0' when  "000001", --	bltzal
	'0' when  "000101", --	bne
	'0' when  "000010", --	j
	'0' when  "000011", --	jal
--	'0' when  "000000", --	jalr
--	'0' when  "000000", --	jr
	'1' when  "100000", --	lb
	'1' when  "100100", --	lbu
	'1' when  "100001", --	lh
	'1' when  "100101", --	lhu
	'1' when  "001111", --	lui
	'1' when  "100011", --	lw
	'0' when  "011100", --	mul
--	'0' when  "000000", --	nor
--	'0' when  "000000", --	or
	'0' when  "001101", --	ori
	'0' when  "101000", --	sb
	'0' when  "101001", --	sh
--	'0' when  "000000", --	sll
--	'0' when  "000000", --	sllv--?
--	'0' when  "000000", --	slt
	'0' when  "001010", --	slti
	'0' when  "001011", --	sltiu
--	'0' when  "000000", --	sltu
--	'0' when  "000000", --	sra
--	'0' when  "000000", --	srav--?
--	'0' when  "000000", --	srl
--	'0' when  "000000", --	srlv--?
--	'0' when  "000000", --	sub
--	'0' when  "000000", --	subu
	'0' when  "101011", --	sw
--	'0' when  "000000", --	xor
	'0' when  "001110", --	xori
	'0' when others;

	
----------------------- MEMORY TO REGISTER OPERATIONS -----------------
with s_op select o_MemtoReg <=
	'0' when  "000000", --	add
	'0' when  "001000", --	addi
	'0' when  "001001", --	addiu
--	'0' when  "000000", --	addu
--	'0' when  "000000", --	and
	'0' when  "001100", --	andi
	----'-' when  "000100", --	beq
	----'-' when  "000001", --	bgez
	----'-' when  "000001", --	bgezal
	----'-' when  "000111", --	bgtz
	----'-' when  "000110", --	blez
	----'-' when  "000001", --	bltz
	----'-' when  "000001", --	bltzal
	----'-' when  "000101", --	bne
	----'-' when  "000010", --	j
	----'-' when  "000011", --	jal
	----'-' when  "000000", --	jalr
	----'-' when  "000000", --	jr
	'1' when  "100000", --	lb
	'1' when  "100100", --	lbu
	'1' when  "100001", --	lh
	'1' when  "100101", --	lhu
	----'-' when  "001111", --	lui
	'1' when  "100011", --	lw
	'0' when  "011100", --	mul
--	'0' when  "000000", --	nor
--	'0' when  "000000", --	or
	'0' when  "001101", --	ori
	----'-' when  "101000", --	sb
	----'-' when  "101001", --	sh
--	'0' when  "000000", --	sll
--	'0' when  "000000", --	sllv--?
--	'0' when  "000000", --	slt
	'0' when  "001010", --	slti
	'0' when  "001011", --	sltiu
--	'0' when  "000000", --	sltu
--	'0' when  "000000", --	sra
--	'0' when  "000000", --	srav--?
--	'0' when  "000000", --	srl
--	'0' when  "000000", --	srlv--?
--	'0' when  "000000", --	sub
--	'0' when  "000000", --	subu
	--'-' when  "101011", --	sw
--	'0' when  "000000", --	xor
	'0' when  "001110", --	xori
	'0' when others;


----------------------- ALU OPERATIONS ------------------------------
process(s_op, s_func)
begin

	if (s_op = "000001") then --bgez, bgezal, bltz, bltzal
		o_ALUOp <= "0100";
--		elsif (s_op = "000010") then --j
--			o_ALUOp <= "";
--		elsif (s_op = "000011") then --jal
--			o_ALUOp <= "";
	elsif (s_op = "000100") then --beq
		o_ALUOp <= "0010";
	elsif (s_op = "000101") then --bne
		o_ALUOp <= "0010";
	elsif (s_op = "000110") then --blez
		o_ALUOp <= "0100";
	elsif (s_op = "000111") then --bgtz
		o_ALUOp <= "0100";
	elsif (s_op = "001000") then --addi
		o_ALUOp <= "0000";
	elsif (s_op = "001001") then --addiu
		o_ALUOp <= "0001";
	elsif (s_op = "001010") then --slti
		o_ALUOp <= "0100";
	elsif (s_op = "001011") then --sltiu
		o_ALUOp <= "0100";
	elsif (s_op = "001100") then --andi
		o_ALUOp <= "0101";
	elsif (s_op = "001101") then --ori
		o_ALUOp <= "0110";
	elsif (s_op = "001110") then --xori
		o_ALUOp <= "0111";
--		elsif (s_op = "001111") then --lui
--			o_ALUOp <= "";
	elsif (s_op = "100000") then --lb
		o_ALUOp <= "0000";
	elsif (s_op = "100001") then --lh
		o_ALUOp <= "0000";
	elsif (s_op = "100011") then --lw
		o_ALUOp <= "0000";
	elsif (s_op = "100100") then --lbu
		o_ALUOp <= "0000";
	elsif (s_op = "100101") then --lhu
		o_ALUOp <= "0000";
	elsif (s_op = "101000") then --sb
		o_ALUOp <= "0000";
	elsif (s_op = "101001") then --sh
		o_ALUOp <= "0000";
	elsif (s_op = "101011") then --sw
		o_ALUOp <= "0000";
	elsif (s_op = "000000") then

	--	if (s_func = "000000") then --sll
	--		o_ALUOp <= "";
	--	elsif (s_func = "000010") then --srl or mul
	--		o_ALUOp <= "";
	--	elsif (s_func = "000011") then --sra
	--		o_ALUOp <= "";		
	--	elsif (s_func = "000100") then --sllv
	--		o_ALUOp <= "";		
	--	elsif (s_func = "000110") then --srlv
	--		o_ALUOp <= "";		
	--	elsif (s_func = "000111") then --srav
	--		o_ALUOp <= "";		
	--	elsif (s_func = "001000") then --jr--------
	--		o_ALUOp <= "";------------------
	--	elsif (s_func = "001001") then --jalr------
	--		o_ALUOp <= "";------------------
		if (s_func = "100000") then --add
			o_ALUOp <= "0000";
		elsif (s_func = "100001") then --addu
			o_ALUOp <= "0001";
		elsif (s_func = "100010") then --sub
			o_ALUOp <= "0010";
		elsif (s_func = "100011") then --subu
			o_ALUOp <= "0011";
		elsif (s_func = "100100") then --and
			o_ALUOp <= "0101";
		elsif (s_func = "100101") then --or
			o_ALUOp <= "0110";
		elsif (s_func = "100110") then --xor
			o_ALUOp <= "0111";
		elsif (s_func = "100111") then --nor
			o_ALUOp <= "1001";
		elsif (s_func = "101010") then --slt
			o_ALUOp <= "0100";
		elsif (s_func = "101011") then --sltu
			o_ALUOp <= "0100";
		else
			o_ALUOp <= "0000";
		end if;
	else
		o_ALUOp <= "0000";
	end if;

end process;


----------------------------- WRITE MEMORY OPERATIONS ----------------
with s_op select o_MemWrite <=
	'0' when  "000000", --	add
	'0' when  "001000", --	addi
	'0' when  "001001", --	addiu
--	'0' when  "000000", --	addu
--	'0' when  "000000", --	and
	'0' when  "001100", --	andi
	'0' when  "000100", --	beq
	'0' when  "000001", --	bgez
--	'0' when  "000001", --	bgezal
	'0' when  "000111", --	bgtz
	'0' when  "000110", --	blez
--	'0' when  "000001", --	bltz
--	'0' when  "000001", --	bltzal
	'0' when  "000101", --	bne
	'0' when  "000010", --	j
	'0' when  "000011", --	jal
--	'0' when  "000000", --	jalr
--	'0' when  "000000", --	jr
	'0' when  "100000", --	lb
	'0' when  "100100", --	lbu
	'0' when  "100001", --	lh
	'0' when  "100101", --	lhu
	'0' when  "001111", --	lui
	'0' when  "100011", --	lw
	'0' when  "011100", --	mul
--	'0' when  "000000", --	nor
--	'0' when  "000000", --	or
	'0' when  "001101", --	ori
	'1' when  "101000", --	sb
	'1' when  "101001", --	sh
--	'0' when  "000000", --	sll
--	'0' when  "000000", --	sllv--?
--	'0' when  "000000", --	slt
	'0' when  "001010", --	slti
	'0' when  "001011", --	sltiu
--	'0' when  "000000", --	sltu
--	'0' when  "000000", --	sra
--	'0' when  "000000", --	srav--?
--	'0' when  "000000", --	srl
--	'0' when  "000000", --	srlv--?
--	'0' when  "000000", --	sub
--	'0' when  "000000", --	subu
	'1' when  "101011", --	sw
--	'0' when  "000000", --	xor
	'0' when  "001110", --	xori
	'0' when others;

	
	------------------------- ALU SOURCE OPERATIONS -------------------
with s_op select o_ALUSrc <=
	'0' when  "000000", --	add
	'1' when  "001000", --	addi
	'1' when  "001001", --	addiu
--	'0' when  "000000", --	addu
--	'0' when  "000000", --	and
	'1' when  "001100", --	andi
	'0' when  "000100", --	beq
	'0' when  "000001", --	bgez
--	'0' when  "000001", --	bgezal
	'0' when  "000111", --	bgtz
	'0' when  "000110", --	blez
--	'0' when  "000001", --	bltz
--	'0' when  "000001", --	bltzal
	'0' when  "000101", --	bne
	--'-' when  "000010", --	j
	--'-' when  "000011", --	jal
	--'-' when  "000000", --	jalr
	--'-' when  "000000", --	jr
	'1' when  "100000", --	lb
	'1' when  "100100", --	lbu
	'1' when  "100001", --	lh
	'1' when  "100101", --	lhu
	--'-' when  "001111", --	lui
	'1' when  "100011", --	lw
	'0' when  "011100", --	mul
--	'0' when  "000000", --	nor
--	'0' when  "000000", --	or
	'1' when  "001101", --	ori
	'1' when  "101000", --	sb
	'1' when  "101001", --	sh
	--'-' when  "000000", --	sll
	--'-' when  "000000", --	sllv--?
--	'0' when  "000000", --	slt
	'1' when  "001010", --	slti
	'1' when  "001011", --	sltiu
--	'0' when  "000000", --	sltu
	--'-' when  "000000", --	sra
	--'-' when  "000000", --	srav--?
	--'-' when  "000000", --	srl
	--'-' when  "000000", --	srlv--?
--	'0' when  "000000", --	sub
--	'0' when  "000000", --	subu
	'1' when  "101011", --	sw
--	'0' when  "000000", --	xor
	'1' when  "001110", --	xori
	'0' when others;

-------------------- REGISTER WRITE OPERATIONS ----------------------
process(s_op, s_func,s_rt)
begin

	if (s_op = "000001") then 
		if (s_rt = "10001") then--bgezal
  		o_RegWrite <= '1';
		elsif (s_rt = "10000") then--bltzal
  		o_RegWrite <= '1';
		else
  		o_RegWrite <= '0';--bgez, bltz
		end if;
	elsif (s_op = "000010") then --j
		o_RegWrite <= '0';
	elsif (s_op = "000011") then --jal
		o_RegWrite <= '1';
	elsif (s_op = "000100") then --beq
		o_RegWrite <= '0';
	elsif (s_op = "000101") then --bne
		o_RegWrite <= '0';
	elsif (s_op = "000110") then --blez
		o_RegWrite <= '0';
	elsif (s_op = "000111") then --bgtz
		o_RegWrite <= '0';
	elsif (s_op = "001000") then --addi
		o_RegWrite <= '1';
	elsif (s_op = "001001") then --addiu
		o_RegWrite <= '1';
	elsif (s_op = "001010") then --slti
		o_RegWrite <= '1';
	elsif (s_op = "001011") then --sltiu
		o_RegWrite <= '1';
	elsif (s_op = "001100") then --andi
		o_RegWrite <= '1';
	elsif (s_op = "001101") then --ori
		o_RegWrite <= '1';
	elsif (s_op = "001110") then --xori
		o_RegWrite <= '1';
	elsif (s_op = "001111") then --lui
		o_RegWrite <= '1';
	elsif (s_op = "100000") then --lb
		o_RegWrite <= '1';
	elsif (s_op = "100001") then --lh
		o_RegWrite <= '1';
	elsif (s_op = "100011") then --lw
		o_RegWrite <= '1';
	elsif (s_op = "100100") then --lbu
		o_RegWrite <= '1';
	elsif (s_op = "100101") then --lhu
		o_RegWrite <= '1';
	elsif (s_op = "101000") then --sb
		o_RegWrite <= '0';
	elsif (s_op = "101001") then --sh
		o_RegWrite <= '0';
	elsif (s_op = "101011") then --sw
		o_RegWrite <= '0';
	elsif (s_op = "011100") then --mul
		o_RegWrite <= '1';
	elsif (s_op = "000000") then 
		if (s_func = "000000") then --sll
			o_RegWrite <= '1';
		elsif (s_func = "000010") then --srl
			o_RegWrite <= '1';		
		elsif (s_func = "000011") then --sra
			o_RegWrite <= '1';		
		elsif (s_func = "000100") then --sllv
			o_RegWrite <= '1';		
		elsif (s_func = "000110") then --srlv
			o_RegWrite <= '1';		
		elsif (s_func = "000111") then --srav
			o_RegWrite <= '1';		
		elsif (s_func = "001000") then --jr--------
			o_RegWrite <= '0';------------------
		elsif (s_func = "001001") then --jalr------
			o_RegWrite <= '1';------------------
		elsif (s_func = "100000") then --add
			o_RegWrite <= '1';		
		elsif (s_func = "100001") then --addu
			o_RegWrite <= '1';		
		elsif (s_func = "100010") then --sub
			o_RegWrite <= '1';		
		elsif (s_func = "100011") then --subu
			o_RegWrite <= '1';		
		elsif (s_func = "100100") then --and
			o_RegWrite <= '1';		
		elsif (s_func = "100101") then --or
			o_RegWrite <= '1';		
		elsif (s_func = "100110") then --xor
			o_RegWrite <= '1';		
		elsif (s_func = "100111") then --nor
			o_RegWrite <= '1';		
		elsif (s_func = "101010") then --slt
			o_RegWrite <= '1';		
		elsif (s_func = "101011") then --sltu
			o_RegWrite <= '1';		
		else
			o_RegWrite <= '0';
		end if;		
	else
		o_RegWrite <= '0';
	end if;

end process;

----------------------- SHIFT FUNCTIONS ------------------
with s_func select s_alu_ctrl_bit0 <=
	'0' when  "000000", --	sll
	'0' when  "101010", --	sllv--?
	'1' when  "000011", --	sra
	'1' when  "000111", --	srav--?
	'1' when  "000010", --	srl
	'1' when  "000110", --	srlv--?
	'0' when others;

with s_func select s_alu_ctrl_bit1  <=
	'0' when  "000000", --	sll
	'0' when  "000100", --	sllv--?
	'1' when  "000011", --	sra
	'1' when  "000111", --	srav--?
	'0' when  "000010", --	srl
	'0' when  "000110", --	srlv--?
	'0' when others;

----------------------- SPECIAL CASES (MULT) -----------------------
with s_op_cat_func select o_ALUBOX_op <=
	"10" when  "011100000010", --	mul
	"01" when  "000000000000", --	sll
	"01" when  "000000000100", --	sllv
	"01" when  "000000000011", --	sra
	"01" when  "000000000111", --	srav
	"01" when  "000000000010", --	srl
	"01" when  "000000000110", --	srlv
	"00" when others;

process(s_op, s_rt, s_func)
begin
	if (s_op = "000001" and (s_rt = "10001" or s_rt = "10000")) then --bgezal and bltzal
		o_andLink <= '1';
  elsif (s_op = "000011") then --jal
    o_andLink <= '1';
	elsif (s_func = "001001" and s_op = "000000") then --jalr
		o_andLink <= '1';
	else
		o_andLink <= '0';
	end if;
end process;

----------------------- LOAD UPPER IMMEDIATE CASES -----------------------
with s_op select o_lui <=
	'0' when  "000000", --	add
	'0' when  "001000", --	addi
	'0' when  "001001", --	addiu
	--'0' when  "000000", --	addu
	--'0' when  "000000", --	and
	'0' when  "001100", --	andi
	'0' when  "000100", --	beq
	'0' when  "000001", --	bgez
--	'0' when  "000001", --	bgezal
	'0' when  "000111", --	bgtz
	'0' when  "000110", --	blez
--	'0' when  "000001", --	bltz
--	'0' when  "000001", --	bltzal
	'0' when  "000101", --	bne
	'0' when  "000010", --	j
	'0' when  "000011", --	jal
	--'0' when  "000000", --	jalr
	--'0' when  "000000", --	jr
	'0' when  "100000", --	lb
	'0' when  "100100", --	lbu
	'0' when  "100001", --	lh
	'0' when  "100101", --	lhu
	'1' when  "001111", --	lui
	'0' when  "100011", --	lw
	'0' when  "011100", --	mul
	--'0' when  "000000", --	nor
	--'0' when  "000000", --	or
	'0' when  "001101", --	ori
	'0' when  "101000", --	sb
	'0' when  "101001", --	sh
	--'0' when  "000000", --	sll
	--'0' when  "000000", --	sllv--?
	--'0' when  "000000", --	slt
	'0' when  "001010", --	slti
	'0' when  "001011", --	sltiu
	--'0' when  "000000", --	sltu
	--'0' when  "000000", --	sra
	--'0' when  "000000", --	srav--?
--	'0' when  "000000", --	srl
--	'0' when  "000000", --	srlv--?
--	'0' when  "000000", --	sub
--	'0' when  "000000", --	subu
	'0' when  "101011", --	sw
--	'0' when  "000000", --	xor
	'0' when  "001110", --	xori
	'0' when others;

----------------------- JUMP OPERATION CASES -----------------------
process (s_op, s_func)
begin
	if (s_op = "000000" and s_func = "001001") then --jalr
		o_jr <= '1';
	elsif (s_op = "000000" and s_func = "001000") then --jr
		o_jr <= '1';
	else
		o_jr <= '0';
	end if;
end process;

end dataflow;
