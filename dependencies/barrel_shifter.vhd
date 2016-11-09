library IEEE;
use IEEE.std_logic_1164.all;
use work.arrays.all;

entity barrel_shifter is
  
  generic (
    N : integer := 32;                  -- Input bits to the shifter.      
    M : integer := 5);                  -- 2^M bits to shift N by.  M = log_2(N)
  port (
    i_A   : in  std_logic_vector(N-1 downto 0);       -- Input to shift.
    i_shamt : in  std_logic_vector(M-1 downto 0);     -- Input for shift amount.
    i_arithmetic : std_logic;                         -- 0 for logical shift
                                                      -- and 1 for arithmetic shift.
    i_shift_right : std_logic;          -- The shift direction.  0 for left and
                                        -- 1 for right.
    o_F   : out std_logic_vector(N-1 downto 0));      -- Output of shifter
end barrel_shifter;

architecture structure of barrel_shifter is

  component mux2
    port (
      i_A : in  std_logic;          
      i_B : in  std_logic;              
      s   : in  std_logic;              
      o_F : out std_logic);          
  end component;

  component inv
    port (
      i_A : in  std_logic;            
      o_F : out std_logic);          
  end component;

  -- Arrays to hold signals between mux stages.
  signal s_mux_stages : array32_bit(M-2 downto 0);  
  -- s_input matches i_A and s_input_flipped is the same input flipped
  -- to add support for right shift.
  signal s_input, s_input_flipped  : std_logic_vector((N-1) downto 0);
  signal s_mux_out,  s_shift_out, s_shift_out_flipped : std_logic_vector((N-1) downto 0);
  signal s_sign : std_logic; 
  
begin                          

  -- input mapping

  process(i_A)
  begin
    for i in 0 to (N-1) loop
      s_input_flipped(i) <= i_A((N-1)-i);
    end loop;
    s_input <= i_A;
  end process;

  -- Value for the "sign extention" variable for right shift
  process(i_A, i_arithmetic, i_shift_right)
  begin
    
  end process;
  s_sign <= (i_A(31) and i_arithmetic and i_shift_right);
    
  -- Mux for flipped input in the case of a right shift.      
  
  with i_shift_right select
    s_mux_out <=
    s_input_flipped when '1',
    s_input when others;

  mux2_0_first : mux2
    port map (
      i_A => s_mux_out(0),
      i_B => s_sign,
      s   => i_shamt(0),
      o_F => s_mux_stages(0)(0));

  G1 : for i in 1 to N-1 generate
    i_mux_first : mux2
      port MAP(
        i_A => s_mux_out(i),
        i_B => s_mux_out(i-1),
        s   => i_shamt(0),
        o_F =>  s_mux_stages(0)(i)              
        );
  end generate;
  
  G2 : for i in 1 to M-2 generate
    
    G3_0 : for j in 0 to (2**i)-1 generate
                          
      mux2_0 : mux2
        port map (
          i_A => s_mux_stages(i-1)(j),
          i_B => s_sign,
          s   => i_shamt(i),
          o_F => s_mux_stages(i)(j));
      
    end generate;
    
    G3_1 : for k in (2**i) to N-1 generate
      i_mux2 : mux2
        port MAP(
          i_A => s_mux_stages(i-1)(k),
          i_B => s_mux_stages(i-1)(k-(2**i)),
          s   => i_shamt(i),
          o_F =>  s_mux_stages(i)(k)              
          );
      
    end generate;
    
  end generate;
  
  G4_0 : for i in 0 to (2**(M-1)) generate
                        
    mux2_0_last : mux2
      port map (
        i_A => s_mux_stages(M-2)(i),
        i_B => s_sign,
        s   => i_shamt(M-1),
        o_F => s_shift_out(i));
    
  end generate;
  
  G4_1 : for j in (2**(M-1)) to N-1 generate
    i_mux2_last : mux2
      port MAP(
        i_A => s_mux_stages(M-2)(j),
        i_B => s_mux_stages(M-2)(j-(2**(M-1))),
        s   => i_shamt(M-1),
        o_F =>  s_shift_out(j)              
        );
    
  end generate;

  process(s_shift_out)
  begin
    for i in 0 to (N-1) loop
      s_shift_out_flipped(i) <= s_shift_out((N-1)-i);
    end loop;
  end process;
  
  -- Flip the output again if it was flipped previously for a right shift.
  with i_shift_right select
    o_F <=
    s_shift_out_flipped when '1',
    s_shift_out when others;
  
end structure;
