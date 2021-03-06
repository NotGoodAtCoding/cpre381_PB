library IEEE;
use IEEE.std_logic_1164.all;

entity add_sub is
  generic(N : integer := 32);
  port (
    i_a        : in  std_logic_vector(N-1 downto 0);
    i_b        : in  std_logic_vector(N-1 downto 0);
    i_nAdd_Sub : in  std_logic;
    o_co       : out std_logic;
    o_s        : out std_logic_vector(N-1 downto 0)
  );
end add_sub;

architecture structure of add_sub is

component n_bit_adder
  generic(N : integer := 32);
  port (
    a  : in  std_logic_vector(N-1 downto 0);
    b  : in  std_logic_vector(N-1 downto 0);
    ci : in  std_logic;
    co : out std_logic;
    s  : out std_logic_vector(N-1 downto 0)
  );
end component;

component mux_n
  generic(N : integer := 32);
  port (
    i_A : in std_logic_vector(N-1 downto 0);
    i_B : in std_logic_vector(N-1 downto 0);
    s   : in std_logic;
    o_F : out std_logic_vector(N-1 downto 0)
  );
end component;

component not1
  generic(N : integer := 32);
  port(
    i_A : in std_logic_vector(N-1 downto 0);
    o_F : out std_logic_vector(N-1 downto 0)
  );
end component;

signal not_o, mux_o : std_logic_vector(N-1 downto 0);

begin


g_mux: mux_n
  port map (
    i_A => i_b,
    i_B => not_o, 
    s   => i_nAdd_Sub,
    o_F => mux_o
  );
  
g_inv: not1
  port map (
    i_A => i_b,
    o_F => not_o
  );
  
g_add: n_bit_adder
  port map (
    a  => mux_o,
    b  => i_a,
    ci => i_nAdd_Sub,
    co => o_co,
    s  => o_s
  );

end structure;
