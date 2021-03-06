library IEEE;
use IEEE.std_logic_1164.all;
use work.arrays.all;

entity register_file is
  port (
    wdata           : in std_logic_vector(31 downto 0);
    rs, rt, rd      : in std_logic_vector(4 downto 0);
    wen, clk, reset : in std_logic;
    rdata1, rdata2  : out std_logic_vector(31 downto 0)
  );
end register_file;

architecture structural of register_file is
  
  
  component reg_file_decoder is
    port(
      a : in std_logic_vector(4 downto 0);
      o : out std_logic_vector(31 downto 0)
    );
  end component;
  
  component and2 is
    port(i_A  : in std_logic;
      i_B     : in std_logic;
      o_F     : out std_logic);
  end component;
  
  component nbit_dff is
    generic(N : integer := 32);
    port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);    -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0)   -- Data value output
    );
  end component;

  component mux_32_1 is
    port(
      input : array32_bit(31 downto 0);      
      sel   : in std_logic_vector(4 downto 0);
      o     : out std_logic_vector(31 downto 0)
    );    
  end component;

  signal s_decoder, s_and : std_logic_vector(31 downto 0);
  signal s_reg : array32_bit(31 downto 0);
  
  begin
    
    decoder1 : reg_file_decoder
      port map (
        a => rd,
        o => s_decoder
      );
    
    G1: for i in 0 to 31 generate
      
      and_i : and2
      port map (
        i_A => wen,
        i_B => s_decoder(i),
        o_F => s_and(i)
      );
      
      ndff_i : nbit_dff
      generic map(N => 32)
      port map (
        i_CLK => clk,
        i_RST => reset,
        i_WE  => s_and(i),
        i_D   => wdata,
        o_Q   => s_reg(i)
      );
      
    end generate;  
    
    mux_i1 : mux_32_1
      port map (
        input => s_reg,
        sel      => rs,        
        o        => rdata1
      );

    mux_i2 : mux_32_1
      port map (
        input => s_reg,
        sel      => rt,
        o        => rdata2
      );
end structural;
    
    