library IEEE;
use IEEE.std_logic_1164.all;


entity tb_singleCycle is
	generic(gCLK_Hper : time := 50 ns);
end entity;

architecture behavioral of tb_singleCycle is
	constant cCLK_Per : time := gCLK_Hper * 2;

	component singleCycle is
		port(CLK : in std_logic;
		     i_regReset : in std_logic);
	end component;

signal s_clock : std_logic;
signal s_regReset : std_logic;

begin
DUT: singleCycle
	port map(CLK => s_clock,
		 i_regReset => s_regReset);

P_CLK: process
begin
	s_clock <= '0';
	wait for gCLK_HPER;
	s_clock <= '1';
	wait for gCLK_HPER;
end process;

TB: process
begin

s_regReset <= '1';
wait for cCLK_Per;

s_regReset <= '0';
wait for cClk_Per;
wait;

end process;
end behavioral;
