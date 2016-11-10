library IEEE;
use IEEE.std_logic_1164.all;

entity mux2 is
  port (
    i_A : in  std_logic;
    i_B : in  std_logic;
    s   : in  std_logic;
    o_F : out std_logic
  );
end mux2;

architecture structure of mux2 is

-- -- -- External Components

component inv is 
  port (
    i_A : in std_logic;
    o_F : out std_logic
  );
end component;

component and2 is
  port (
    i_A : in std_logic;
    i_B : in std_logic;
    o_F : out std_logic
  );
end component;

component or2 is
  port (
    i_A : in std_logic;
    i_B : in std_logic;
    o_F : out std_logic
  );
end component;

-- -- -- End External Components

-- Internal Signals

signal value_and_i_1, value_and_i_2 : std_logic;
signal value_not_s : std_logic;

-- End internal signals

begin
  g_not: inv 
    port map (
      i_A => s,
      o_F => value_not_s
    );
  
  g_and1: and2 
    port map (
      i_A => value_not_s,
      i_B => i_A,
      o_F => value_and_i_1
    );

  g_and2: and2
    port map (
      i_A => s,
      i_B => i_B,
      o_F => value_and_i_2
    );

  g_or: or2
    port map (
      i_A => value_and_i_1,
      i_B => value_and_i_2,
      o_F => o_F
    );

end structure;
