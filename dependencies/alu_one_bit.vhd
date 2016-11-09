library ieee;
use ieee.std_logic_1164.all;

entity alu_one_bit is
  port(i_A, i_B, i_carry, i_less: in std_logic;
       i_OP : in std_logic_vector(3 downto 0);
       o_F, o_set : out std_logic;
       o_carry : out std_logic
       );
end alu_one_bit;

architecture structural of alu_one_bit is

  component inv
    port (
      i_A : in  std_logic;              
      o_F : out std_logic);              
  end component;

  component and2
    port (
      i_A : in  std_logic;               
      i_B : in  std_logic;               
      o_F : out std_logic);             
  end component;

  component or2
    port (
      i_A : in  std_logic;              
      i_B : in  std_logic;               
      o_F : out std_logic);             
  end component;

  component xor2
    port (
      i_A : in  std_logic;              
      i_B : in  std_logic;               
      o_F : out std_logic);             
  end component;

  component nand2
    port (
      i_A : in  std_logic;              
      i_B : in  std_logic;               
      o_F : out std_logic);             
  end component;

  component nor2
    port (
      i_A : in  std_logic;              
      i_B : in  std_logic;               
      o_F : out std_logic);             
  end component;

  component fulladder
    port (
      i_A        : in  std_logic;
      i_B        : in  std_logic;
      i_C        : in  std_logic;
      o_F        : out std_logic;
      o_C        : out std_logic);
  end component;

  signal s_slt, s_fulladd, s_B, s_and2, s_or2, s_xor2, s_nand2, s_nor2 : std_logic; 
  
  begin
    
  and2_1 : and2
    port MAP(
      i_A => i_A,               
      i_B => i_B,
      o_F => s_and2);             
   

  or2_1 : or2
    port MAP(
      i_A => i_A,              
      i_B => i_B,
      o_F => s_or2);             
   

  xor2_1 : xor2
    port MAP(
      i_A => i_A,              
      i_B => i_B,
      o_F => s_xor2);             
   

  nand2_1 : nand2
    port MAP(
      i_A => i_A,              
      i_B => i_B,
      o_F => s_nand2);             
   

  nar2_1 : nor2
    port MAP(
      i_A => i_A,              
      i_B => i_B,
      o_F => s_nor2);             

    fulladder_1 : fulladder
    port MAP(
      i_A        => i_A,
      i_B        => s_B,
      i_C        => i_carry,
      o_F        => s_fulladd,
      o_C        => o_carry);

    s_slt <= i_less;

  with i_op select
    o_F <=
    s_fulladd when "0000",
    s_fulladd when "0001",
    s_fulladd when "0010",
    s_fulladd when "0011",
    s_slt     when "0100",
    s_and2    when "0101",
    s_or2     when "0110",
    s_xor2    when "0111",
    s_nand2   when "1000",
    s_nor2    when "1001",
    'X'       when others;
    
  o_set <= s_fulladd;


  with i_op select
    s_B  <=
      not i_B when "0010",
      not i_B when "0011",
      not i_B when "0100",
          i_B when others;
    
end structural;
