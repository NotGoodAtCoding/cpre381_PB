
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_file_decoder is
  port(
    a : in std_logic_vector(4 downto 0);
    o : out std_logic_vector(31 downto 0)
    );
end reg_file_decoder;

architecture dataflow of reg_file_decoder is
  signal s_sel : integer := 0;

begin
  
  s_sel <= to_integer(unsigned(a));
  
decoder: process(s_sel)
  begin
    o <= (s_sel => '1', others => '0');
  end process decoder;

end dataflow;
