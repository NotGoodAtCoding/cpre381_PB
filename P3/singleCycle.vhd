library IEEE;
use IEEE.std_logic_1164.all;


entity singleCycle is
  port (CLK : in std_logic; -- CLOCK
				i_regReset : in std_logic); -- RESET                
end singleCycle;


architecture structure of singleCycle is


-- --- -- EXTERNAL COMPONENT DECLARATIONS 


component dmem  -- DATA MEMORY
	port(
		i_memOp : in std_logic_vector(2 downto 0);
		i_byteAddress : in std_logic_vector(31 downto 0);
		i_wData : in std_logic_vector(31 downto 0);
		i_clk : in std_logic;
		o_rData : out std_logic_vector(31 downto 0));
end component; 

component mem -- INSTRUCTION MEMORY
	generic(depth_exp_of_2 	: integer := 10;
			mif_filename 	: string := "bubblesort.mif");
	port   (address			: IN STD_LOGIC_VECTOR (depth_exp_of_2-1 DOWNTO 0) := (OTHERS => '0');
			byteena			: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '1');
			clock			: IN STD_LOGIC := '1';
			data			: IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
			wren			: IN STD_LOGIC := '0';
			q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));         
end component;

component alu_32
  port(
    i_A, i_B : in std_logic_vector(31 downto 0);
    i_op : in std_logic_vector(3 downto 0);
    o_F : out std_logic_vector(31 downto 0);
    o_carry, o_overflow, o_zero : out std_logic
  );
end component;

component extender16to32u 
	port(
		i_A : in std_logic_vector(15 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end component;

component extender_16_32_signed is
  port (
    i_A : in std_logic_vector(15 downto 0);
    o_F : out std_logic_vector(31 downto 0)
  );
end component;

component mult32 
	port(
		i_A, i_B : in std_logic_vector(31 downto 0);
		o_F : out std_logic_vector(31 downto 0));
end component;

component barrel_shifter 
  generic (
    N : integer := 32;                  -- Input bits to the shifter.      
    M : integer := 5);                  -- 2^M bits to shift N by.  M = log_2(N)
  port (
    i_A   : in  std_logic_vector(N-1 downto 0);       -- Input to shift.
    i_shamt : in  std_logic_vector(M-1 downto 0);     -- Input for shift amount.
    i_arithmetic : std_logic;
    i_shift_right : std_logic;
    o_F   : out std_logic_vector(N-1 downto 0));      -- Output of shifter
end component;

component controlModule
	port(
		i_instruction : in std_logic_vector(31 downto 0);
 		o_RegDst, o_jump, o_memRead, o_memtoReg, o_memWrite,
 		 o_ALUSrc, o_regWrite, o_andLink, o_lui, o_jr, o_bitwise : out std_logic; 
		o_ALUBOX_op, o_alu_ctrl : out std_logic_vector(1 downto 0);
		o_memOP : out std_logic_vector(2 downto 0);
		o_ALUOp : out std_logic_vector(3 downto 0));
end component;

component nbit_dff -- PROGRAM COUNTER
  generic(N : integer := 32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);    -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0)   -- Data value output
  );
end component;


component branch_control 
  port(i_zero        : in std_logic;     -- o_zero from ALU
       i_OP          : in std_logic_vector(31 downto 0);     -- ONLY [31, 26] USED
       i_lessThan    : in std_logic;     -- result of slt from Full ALU
       o_branch      : out std_logic   -- Data value output
  );
end component;

component alu_control 
  port(i_alu_op      : in std_logic_vector(3 downto 0);     -- o_zero from ALU
       i_op          : in std_logic_vector(5 downto 0);     -- INSTRUCTION[31, 26]
       o_alu_op      : out std_logic_vector(6 downto 0)   -- Data value output
  );
end component;

component register_file 
  port (
    wdata           : in std_logic_vector(31 downto 0);
    rs, rt, rd      : in std_logic_vector(4 downto 0);
    wen, clk, reset : in std_logic;
    rdata1, rdata2  : out std_logic_vector(31 downto 0)
  );
end component;

component and2
	port (
		i_A : in std_logic;
		i_B : in std_logic;
		o_F	: out std_logic
	);
end component;

-- --- --- END EXTERNAL COMPONENT DECLARATIONS --- 




-- --- --- INTERNAL SIGNALS -- -- 



signal s_RegDst : std_logic;
signal s_jump : std_logic;
signal s_memRead : std_logic;
signal s_memtoReg : std_logic;
signal s_memWrite : std_logic;
signal s_ALUSrc : std_logic;
signal s_regWrite : std_logic;
signal s_andLink : std_logic;
signal s_bitwise : std_logic;
signal s_lui : std_logic;
signal s_jr : std_logic;
signal s_memOP : std_logic_vector(2 downto 0);
signal s_ALUBOX_op : std_logic_vector(1 downto 0);
signal s_alu_ctrl : std_logic_vector(1 downto 0);
signal s_ALUOp : std_logic_vector(3 downto 0);

-- SHIFTERS

signal s_shift_left_2_0 : std_logic_vector(31 downto 0);
signal s_shift_left_2_1 : std_logic_vector(31 downto 0);
signal s_extender_16_32_signed : std_logic_vector(31 downto 0);
signal s_extender_16_32_unsigned_0 : std_logic_vector(31 downto 0);
signal s_shift_left_16 : std_logic_vector(31 downto 0);  -- added for lui

-- ALU SIGNALS

signal s_alu_32_o_F : std_logic_vector(31 downto 0);
signal s_alu_32_o_zero : std_logic;
signal s_n_bit_adder_0 : std_logic_vector(31 downto 0); 
signal s_n_bit_adder_1 : std_logic_vector(31 downto 0);

-- REGISTER

signal s_RData1 : std_logic_vector(31 downto 0);
signal s_RData2 : std_logic_vector(31 downto 0);
  
-- IMEM

signal s_imem : std_logic_vector(31 downto 0);

-- PROGRAM COUNTER

signal s_PC : std_logic_vector(31 downto 0); -- Diagram comment suggests that this is a 28-bit signal.

-- AND GATE 

signal s_AND : std_logic;

-- BARREL SHIFTER
signal s_barrel_shifter : std_logic_vector(31 downto 0);

-- CLOCK
signal s_CLK : std_logic;


-- MUX SIGNALS 

-- 32 MULT
signal s_mult_32 : std_logic_vector(31 downto 0);

-- NUMBERED MUX
signal s_mux_1 : std_logic_vector(31 downto 0);
signal s_mux_2 : std_logic_vector(31 downto 0);
signal s_mux_3 : std_logic_vector(31 downto 0);
signal s_mux_4 : std_logic_vector(4 downto 0); 
signal s_mux_5 : std_logic_vector(4 downto 0); 
signal s_mux_6 : std_logic_vector(31 downto 0);
signal s_mux_7 : std_logic_vector(31 downto 0);
signal s_mux_8 : std_logic_vector(31 downto 0);
signal s_mux_9 : std_logic_vector(31 downto 0);
signal s_mux_10: std_logic_vector(31 downto 0);
signal s_mux_11: std_logic_vector(4 downto 0);
signal s_mux_12: std_logic_vector(31 downto 0);
signal s_shiftedPC : std_logic_vector(9 downto 0); 

-- BRANCH CONTROL
signal s_branch_control : std_logic;

-- ALU CONTROL
signal s_alu_control : std_logic_vector(6 downto 0);

-- DMEM CONTROL
signal s_dmem : std_logic_vector(31 downto 0);

begin
	s_clk <= clk;
	s_shiftedPC <= "00" & s_PC(9 downto 2);

-- MUX DECLARATIONS

-- mux_1 
  with s_jr select
    s_mux_1 <=
      s_mux_9 when '0',
      s_alu_32_o_F when '1',
      x"00000000" when others;
      
-- mux_2
  with s_lui select
    s_mux_2 <=
      s_mux_10 when '0',
      s_shift_left_16 when '1',
      x"00000000" when others;
      
-- mux_3
  with s_andLink select
    s_mux_3 <=
      s_mux_2 when '0',
      s_n_bit_adder_1 when '1',
      x"00000000" when others;
      
-- mux_4
  with s_RegDst select
    s_mux_4 <=
      s_imem(20 downto 16) when '0',
      s_imem(15 downto 11) when '1',
      "00000" when others;
      
-- mux_5
  with s_andLink select
    s_mux_5 <=
      s_mux_4 when '0',
      "11111" when '1',
      "00000" when others;
      
-- mux_6
  with s_ALUSrc select
    s_mux_6 <=
      s_RData2 when '0',
      s_mux_12 when '1',
      x"00000000" when others;
      
-- mux_7
  with s_ALUBOX_op select
    s_mux_7 <=
      s_alu_32_o_F when "00",
      s_barrel_shifter when "01",
      s_mult_32 when "10",
      x"00000000" when others;
      
-- mux_8
  with s_branch_control select
    s_mux_8 <=
      s_n_bit_adder_1 when '0',
      s_n_bit_adder_0 when '1',
      x"00000000" when others;
      
-- mux_9
  with s_jump select
    s_mux_9 <=
      s_mux_8 when '0',
      (s_shift_left_2_0) when '1',
      x"00000000" when others;    
                                       
-- mux_10
  with s_memtoReg select
    s_mux_10 <=
      s_mux_7 when '0',
      s_dmem when '1',
      x"00000000"  when others;
      
-- mux_11
  with s_alu_control(6) select
    s_mux_11 <=
      s_RData1(4 downto 0) when '0',
      s_imem(10 downto 6) when '1',
      "00000"  when others;
      
-- mux_12
  with s_bitwise select
    s_mux_12 <=
      s_extender_16_32_signed when '0',
      s_extender_16_32_unsigned_0 when '1',
      x"00000000"  when others;
      
-- END MUX DECLARATIONS



-- -- MEMORY MODULES


-- PC
  PC : nbit_dff
    port map(
      i_CLK => s_CLK,
      i_RST => i_regReset, -- PC is never reset when running
      i_WE  => '1', -- PC can always be written
      i_D   => s_mux_1,
      o_Q   => s_PC
    );


-- imem
  imem_0 : mem
    port map(
      address => s_shiftedPC,
      byteena => "1111",
      clock   => s_CLK,
      data    => x"00000000",
      wren    => '0',
      q       =>  s_imem
            );

-- dmem
  dmem_0 : dmem
    port map(
      i_memOp       => s_memOP,
      i_byteAddress => s_mux_7,
      i_wData       => s_RData2,
      i_clk         => s_CLK,
      o_rData       => s_dmem
            );

-- register_file
  register_file_0 : register_file
    port map(
      wdata  => s_mux_3,
      rs     => s_imem(25 downto 21),
      rt     => s_imem(20 downto 16),
      rd     => s_mux_5,
      wen    => s_regWrite, 
      clk    => s_CLK, 
      reset  => i_regReset,
      rdata1 => s_RData1, 
      rdata2 => s_RData2
            );
            
-- -- END MEMORY COMPONENTS



-- -- START ALU


-- n_bit_adder_0
  n_bit_adder_0 : alu_32
    port map(
      i_A        => s_n_bit_adder_1,
      i_B        => s_shift_left_2_1,
      i_op       => "0000", -- fixed to add
      o_F        => s_n_bit_adder_0
      -- ADDITIONAL SIGNALS NOT NEEDED
            );

-- n_bit_adder_1
  n_bit_adder_1 : alu_32
    port map(
      i_A        => s_PC,
      i_B        => x"00000004",
      i_op       => "0000", -- fixed to add
      o_F        => s_n_bit_adder_1
      -- ADDITIONAL SIGNALS NOT NEEDED
            );
            
-- alu_32 (FULL ADDER)
  alu_32_0 : alu_32
    port map(
      i_A        => s_RData1,
      i_B        => s_mux_6,
      i_op       => s_alu_control(5 downto 2),
      o_F        => s_alu_32_o_F,
--    o_carry    => , NOT NEEDED
--    o_overflow => , NOT NEEDED
      o_zero     => s_alu_32_o_zero
            );

-- barrel_shifter
  barrel_shifter_0  : barrel_shifter 
    port map(
      i_A           => s_RData2,
      i_shamt       => s_mux_11,
      i_arithmetic  => s_alu_control(1), 
      i_shift_right => s_alu_control(0), 
      o_F           => s_barrel_shifter
            );

-- mult32 
  mult32_0   : mult32  
    port map(
      i_A           => s_RData1,
      i_B           => s_mux_6,
      o_F           => s_mult_32
            );

-- -- END THE SUPER ALU



-- -- START SHIFTERS


-- shift_left_2_0
s_shift_left_2_0 <= s_n_bit_adder_1(31 downto 28) & s_imem(25 downto 0) & "00";

-- shift_left_2_1
s_shift_left_2_1 <= s_mux_12(29 downto 0) & "00";

-- shift_left_16
s_shift_left_16 <= s_extender_16_32_unsigned_0(15 downto 0) & x"0000";


-- -- END SHIFTERS


-- --  EXTENDERS

-- extender_16_32_signed
  extender_16_32_signed_0 : extender_16_32_signed
    port map(
      i_A        => s_imem(15 downto 0),
      o_F        => s_extender_16_32_signed
            );

-- extender_16_32_unsigned_0
  extender_16_32_unsigned_0 : extender16to32u
    port map(
      i_A    => s_imem(15 downto 0),
      o_F    => s_extender_16_32_unsigned_0
            );
            
            
-- -- END EXTENDERS




-- -- START CONTROL LOGIC


-- branch_control
  branch_control_0 : branch_control
    port map(
      i_zero        => s_alu_32_o_zero,
      i_OP          => s_imem,
      i_lessThan    => s_alu_32_o_F(0),
      o_branch      => s_branch_control
            );

-- alu_control
  alu_control_0  : alu_control 
    port map(
      i_alu_op        => s_ALUOp,
      i_op            => s_imem(5 downto 0),
      o_alu_op        => s_alu_control
            );

-- controlModule
  controlModule_0  : controlModule
    port map(
      i_instruction => s_imem,
      o_RegDst      => s_RegDst,
      o_bitwise     => s_bitwise,
      o_jump        => s_jump,
      o_memRead     => s_memRead,
      o_memtoReg    => s_memtoReg, 
      o_memWrite    => s_memWrite, 
      o_ALUSrc      => s_ALUSrc, 
      o_regWrite    => s_regWrite, 
      o_andLink     => s_andLink, 
      o_lui         => s_lui, 
      o_jr          => s_jr,
      o_ALUBOX_op   => s_ALUBOX_op, 
      o_alu_ctrl    => s_alu_ctrl,
      o_memOP       => s_memOP,
      o_ALUOp       => s_ALUOp
            );
-- -- END CONTROL LOGIC MODULE

end structure;
