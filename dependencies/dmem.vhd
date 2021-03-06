
library IEEE;
use IEEE.std_logic_1164.all;

--opcode format: 000 = sb   
--		 001 = sh   
--		 010 = sw
--		 011 = lw
--		 100 = lb
--		 101 = lhu
--		 110 = lbu
--		 111 = lh   



entity dmem is
	port(
		i_memOp : in std_logic_vector(2 downto 0);
		i_byteAddress : in std_logic_vector(31 downto 0);
		i_wData : in std_logic_vector(31 downto 0);
		i_clk : in std_logic;
		o_rData : out std_logic_vector(31 downto 0));
end dmem;

architecture structural of dmem is

component extenderModule is
	port(
		i_op : in std_logic_vector(2 downto 0);
		i_memData : in std_logic_vector(31 downto 0);
		o_data : out std_logic_vector(31 downto 0));
end component;

component memInputController is
	port(
		i_op : in std_logic_vector(2 downto 0);
		i_byteAddress : in std_logic_vector(31 downto 0);
		i_wData : in std_logic_vector(31 downto 0);
		o_wordAddress : out std_logic_vector(13 downto 0);
		o_byteEna : out std_logic_vector(3 downto 0);
		o_wData : out std_logic_vector(31 downto 0);
		o_wen : out std_logic);
end component;

component memOutputController is
  port(
        i_byteEna : in std_logic_vector(3 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0));
end component;

component mem is
	generic(depth_exp_of_2 	: integer := 14;
		mif_filename 	: string := "out.mif");
	port   (address			: IN STD_LOGIC_VECTOR (depth_exp_of_2-1 DOWNTO 0) := (OTHERS => '0');
		byteena			: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '1');
		clock			: IN STD_LOGIC := '1';
		data			: IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
		wren			: IN STD_LOGIC := '0';
		q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));         
end component;

signal s_memOCData : std_logic_vector(31 downto 0);
signal s_memICWdAddr : std_logic_vector(13 downto 0);
signal s_memICByteEna : std_logic_vector(3 downto 0);
signal s_memICWen : std_logic;
signal s_memData : std_logic_vector(31 downto 0);
signal s_memICData : std_logic_vector(31 downto 0);

begin

memIC: memInputController
	port map(i_op => i_memOp,
		 i_byteAddress => i_byteAddress,
		 i_wData => i_wData,
		 o_wordAddress => s_memICWdAddr,
		 o_byteEna => s_memICByteEna,
		 o_wData => s_memICData,
		 o_wen => s_memICWEn);

memOC: memOutputController
	port map(i_byteEna => s_memICByteEna,
		 i_data => s_memData,
		 o_data => s_memOCData);

memory: mem
	port map(address => s_memICWdAddr,
		 byteena => s_memICByteEna,
		 clock => i_clk,
		 data => s_memICData,
		 wren => s_memICWEn,
		 q => s_memData);

ext: extenderModule
	port map(i_op => i_memOp,
		 i_memData => s_memOCData,
		 o_data => o_rData);

end structural;
