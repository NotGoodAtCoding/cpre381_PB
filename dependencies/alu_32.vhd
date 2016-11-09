
library IEEE;
use IEEE.std_logic_1164.all;

entity alu_32 is
  port(
    i_A, i_B : in std_logic_vector(31 downto 0);
    i_op : in std_logic_vector(3 downto 0);
    o_F : out std_logic_vector(31 downto 0);
    o_carry, o_overflow, o_zero : out std_logic
  );
end alu_32;

architecture mixed of alu_32 is 
  component alu_one_bit is
    port(
      i_A, i_B, i_carry, i_less : in std_logic;
      i_OP                      : in std_logic_vector(3 downto 0);
      o_F, o_set                       : out std_logic;
      o_carry                   : out std_logic
    );
  end component;

  signal s_carry : std_logic_vector(30 downto 0);
  signal s_F : std_logic_vector(31 downto 0);
  signal s_less, s_firstCarry, s_zero, s_set, s_setXorOverflow, s_overflow : std_logic;

  begin
  
  with i_op select
    s_firstCarry <=
      '0' when "0000",
      '0' when "0001",
      '1' when "0010",
      '1' when "0011",
      '1' when "0100",
      '0' when others;

  o_carry <= s_carry(0);

  alu_one_bit_1 : alu_one_bit
    port map(
      i_carry => s_firstCarry,
      i_less  => s_setXorOverflow,
      i_A     => i_A(0),
      i_B     => i_B(0),
      o_carry => s_carry(0),
      o_F     => s_F(0),
      i_op    => i_op
    );
  
  s_setXorOverflow <= s_set xor s_overflow;    


    G1: for i in 1 to 30 generate
      alu_one_bit_i : alu_one_bit
        port map(
          i_less  => '0',
          i_A     => i_A(i),
          i_B     => i_B(i),
          i_carry => s_carry(i-1),
          o_carry => s_carry(i),
          o_F     => s_F(i),
          i_op    => i_op
        );
    end generate;

  alu_one_bit_31 : alu_one_bit
  port map(
    i_less  => '0',
    o_carry => s_less,
    i_A     => i_A(31),
    i_B     => i_B(31),
    i_carry => s_carry(30),
    o_F     => s_F(31),
    i_op    => i_op,
    o_set   => s_set
  ); 

  with i_op select
    s_overflow <=
      s_less xor s_carry(30) when "0000",
      s_less xor s_carry(30) when "0010",
      s_less xor s_carry(30) when "0100",
      '0' when others;
  
  o_overflow <= s_overflow;

  o_F <= s_F;

 o_zero <= not (s_F(0) or s_F(1) or s_F(2) or s_F(3) or s_F(4)
  or s_F(5) or s_F(6) or s_F(7) or s_F(8) or s_F(9) or s_F(10)
   or s_F(11) or s_F(12) or s_F(13) or s_F(14) or s_F(15) or s_F(16)
    or s_F(17) or s_F(18) or s_F(19) or s_F(20) or s_F(21) or s_F(22)
     or s_F(23) or s_F(24) or s_F(25) or s_F(26) or s_F(27) or s_F(28)
      or s_F(29) or s_F(30) or s_F(31));


end mixed;
