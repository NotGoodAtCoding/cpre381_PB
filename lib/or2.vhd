
library IEEE;
use IEEE.std_logic_1164.all;

entity or2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end or2;

architecture dataflow of or2 is
begin

  o_F <= i_A or i_B;
  
end dataflow;
