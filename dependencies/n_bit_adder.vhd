library IEEE;
use IEEE.std_logic_1164.all;

entity n_bit_adder is
  generic(N : integer := 32);
  port (
    a  : in  std_logic_vector(N-1 downto 0);
    b  : in  std_logic_vector(N-1 downto 0);
    ci : in  std_logic;
    co : out std_logic;
    s  : out std_logic_vector(N-1 downto 0)
  );
end n_bit_adder;

architecture structure of n_bit_adder is

component full_adder
  port (
    a  : in  std_logic;
    b  : in  std_logic;
    ci : in  std_logic;
    co : out std_logic;
    s  : out std_logic
  );
end component;

signal carry : std_logic_vector(N downto 0);

begin

carry(0) <= ci;
co <= carry(N);

G1: for i in 0 to N-1 generate
  adder_i : full_adder
  port map(
    co => carry(i+1),
    ci => carry(i),
    a => a(i),
    b => b(i),
    s => s(i)
  );
  
end generate;
end structure;