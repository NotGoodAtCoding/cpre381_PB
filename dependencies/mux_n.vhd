library IEEE;
use IEEE.std_logic_1164.all;

entity mux_n is
  generic(N : integer := 32);
  port (
    i_A   : in std_logic_vector(N-1 downto 0);
    i_B   : in std_logic_vector(N-1 downto 0);
    i_sel : in std_logic;
    o_F   : out std_logic_vector(N-1 downto 0)
  );
end mux_n;

architecture structure of mux_n is

component mux2
    port (
    i_A   : in  std_logic;
    i_B   : in  std_logic;
    i_sel : in  std_logic;
    o_F   : out std_logic
  );
end component;

begin
G1: for i in 0 to N-1 generate
  mux_i : mux2
  port map(
     i_A   => i_A(i),
     i_B   => i_B(i),
     i_sel => i_sel,
     o_F   => o_F(i)
  );
  
end generate;
end structure;
