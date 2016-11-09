library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shifter is
 port (SHIFT: in unsigned(4 downto 0);            -- Shift amount, 0-31
       DIRECTION  : in std_logic;                       -- 0 for right, 1 for left
       IS_LOGICAL : in std_logic; -- 1 for logical, 0 for arithematic
       DIN  : in std_logic_vector(31 downto 0);   -- Data inputs
       DOUT : out std_logic_vector(31 downto 0)); -- Data bus output
 
 constant Rlogical: std_logic_vector := "00";
 constant Llogical: std_logic_vector := "01";
 constant Rarith: std_logic_vector := "10";
 constant Larith: std_logic_vector := "11";
 
end Shifter;

architecture structural of Shifter is
  component mux2_1 is
    port(DIN1 : in std_logic;
        DIN2 : in std_logic;
        SEL  : in std_logic;
        DOUT : out std_logic);
  end component;

  signal sig1, sig2, sig3, sig4, sig5 : std_logic_vector(31 downto 0);
  signal DINreversed, sig1reversed, DINm : std_logic_vector(31 downto 0);
  signal padding : std_logic;
  
begin
  -- flip the input
  flip_loop1 : for i in 31 downto 0 generate
    DINreversed(i) <= DIN(31-i);
  end generate flip_loop1;
  
  -- flip the output
  flip_loop2 : for i in 31 downto 0 generate
    sig1reversed(i) <= sig1(31-i);
  end generate flip_loop2;
    
  -- choose the vector
  with DIRECTION select
    DINm <= DIN when '0',
            DINreversed when others;
            
  -- set the output  
  with DIRECTION select
    DOUT <= sig1 when '0',
            sig1reversed when others;
  
  -- set logical or artith
  with IS_LOGICAL select
    padding <= '0' when '1',
               (DIN(31) and (not DIRECTION)) when others;
  
  
  
  
  
  G1: for i in 0 to 30 generate
    MUX_1_i: mux2_1 port map(sig2(i), sig2(i+1), SHIFT(0), sig1(i));
  end generate;
  
--    MUX_1_31: mux2_1 port map(sig2(31), '0', SHIFT(0), sig1(31));
      MUX_1_31: mux2_1 port map(sig2(31), padding, SHIFT(0), sig1(31));
  --
    
  G2: for i in 0 to 29 generate
    MUX_2_i: mux2_1 port map(sig3(i), sig3(i+2), SHIFT(1), sig2(i));
  end generate;
  
--    MUX_2_30: mux2_1 port map(sig3(30), '0', SHIFT(1), sig2(30));
--    MUX_2_31: mux2_1 port map(sig3(31), '0', SHIFT(1), sig2(31));
    MUX_2_30: mux2_1 port map(sig3(30), padding, SHIFT(1), sig2(30));
    MUX_2_31: mux2_1 port map(sig3(31), padding, SHIFT(1), sig2(31));
  --
    
  G3: for i in 0 to 27 generate
    MUX_2_i: mux2_1 port map(sig4(i), sig4(i+4), SHIFT(2), sig3(i));
  end generate;
  
  G3_a: for j in 28 to 31 generate
--    MUX_3_a: mux2_1 port map(sig4(j), '0', SHIFT(2), sig3(j));
      MUX_3_a: mux2_1 port map(sig4(j), padding, SHIFT(2), sig3(j));
  end generate;
  --
    
  G4: for i in 0 to 23 generate
    MUX_2_i: mux2_1 port map(sig5(i), sig5(i+8), SHIFT(3), sig4(i));
  end generate;
  
  G4_a: for j in 24 to 31 generate
--    MUX_4_a: mux2_1 port map(sig5(j), '0', SHIFT(3), sig4(j));
      MUX_4_a: mux2_1 port map(sig5(j), padding, SHIFT(3), sig4(j));
  end generate;
  --
    
  G5: for i in 0 to 15 generate
    MUX_5_i: mux2_1 port map(DINm(i), DIN(i+16), SHIFT(4), sig5(i));
  end generate;
  
  G5_a: for j in 16 to 31 generate
    -- MUX_5_a: mux2_1 port map(DINm(j), '0', SHIFT(4), sig5(j));
      MUX_5_a: mux2_1 port map(DINm(j), padding, SHIFT(4), sig5(j));
  end generate;
end structural;