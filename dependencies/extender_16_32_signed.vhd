library IEEE;
use IEEE.std_logic_1164.all;

entity extender_16_32_signed is
  port (
    i_A : in std_logic_vector(15 downto 0);
    o_F : out std_logic_vector(31 downto 0)
  );
end extender_16_32_signed;


architecture dataflow of extender_16_32_signed is

-- mostly taken from online examples
  begin
    process(i_A)
    begin
      if i_A(15) = '1' then
        o_F <= x"FFFF" & i_A;
      else 
        o_F <= x"0000" & i_A;
      end if;
    end process;
end dataflow;