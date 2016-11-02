-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- PLEASE, GO THROUGH THIS FILE AND READ THE COMMENTS BELOW.
-- IF YOU DECIDE TO WRITE THE ASSEMBLY TESTING PROGRAMS:
---- 1) PROGRAM FOR TESTING ALL INSTRUCTIONS
---- 2) BUBBLE SORT DEMONSTRATION PROGRAM
---- 3) MERGE SORT DEMONSTRATION PROGRAM
-- I WILL TAKE CARE OF THE HARDWARE SIDE OF THINGS
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips is
  
  port (
    i_clk : in std_logic;
    i_rst : in std_logic
   -- feel free to add any more signals if you feel like we need them!
    );

end entity mips;
-------------------------------------------------------------------------------
architecture mixed of mips is

  -----------------------------------------------------------------------------
  -- This is the spot where we put all of our component prototypes
  -----------------------------------------------------------------------------
  
  -- instruction memory
  -- I MADE THIS ONE SO IT CAN TAKE THE MARS MACHINE FILE DIRECTLY (SPEED UP DEBUGGING)
  component ram is
    generic (
      n         : natural := 32;        -- width of word in bits
      l         : natural := 10;  -- width of address bus in bits                                 
      init_file : string  := "ram.mif");  -- memory intialization file
    port (
      i_addr  : in  std_logic_vector (n-1 downto 0);  -- address input
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_wen   : in  std_logic;
      i_clk   : in  std_logic);
  end component ram;

  -- program counter
  component reg is
    generic (
      n : natural := 32);                             -- width of word in bits
    port (
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      i_wen   : in  std_logic;                        -- write enable
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_rst   : in  std_logic;                        -- reset input
      i_clk   : in  std_logic);                       -- clock input
  end component reg;

  -- register file
  component mips_regfile is
    port(i_raddr1  : in  std_logic_vector(4 downto 0);
         i_raddr2  : in  std_logic_vector(4 downto 0);
         i_waddr   : in  std_logic_vector(4 downto 0);
         i_wdata   : in  std_logic_vector(31 downto 0);
         i_wenable : in  std_logic;
         i_clk     : in  std_logic;
         i_rst     : in  std_logic;
         o_rdata1  : out std_logic_vector(31 downto 0);
         o_rdata2  : out std_logic_vector(31 downto 0));
  end component;

  
  -- alu
  component mips_alu is
    port (
      i_A           : in  std_logic_vector (31 downto 0);
      i_B           : in  std_logic_vector (31 downto 0);
      o_R           : out std_logic_vector (31 downto 0);
      i_ShiftAmount : in  std_logic_vector (4 downto 0);
      i_Function    : in std_logic_vector (3 downto 0);
      o_ZeroFlag    : out std_logic);
  end component;

  -- data memory
  component mips_mem is
    port (
      i_addr : in std_logic_vector(31 downto 0);
      i_wdata : in std_logic_vector(31 downto 0);
      i_size : in std_logic_vector(1 downto 0);
      i_signed : in std_logic;
      i_wen : in std_logic;
      i_clk : in std_logic;
      o_rdata : out std_logic_vector(31 downto 0));
  end component;

  -- control
  component mips_control is 
    port (
      i_instruction       : in std_logic_vector (31 downto 0);  -- instruction from the memory
      o_RdIsDest          : out std_logic;      -- COMMENT ME
      o_Link              : out std_logic;      --
      o_RtIsForceZero     : out std_logic;      --
      o_RegWrite          : out std_logic;      --
      o_ImmToAluB         : out std_logic;      --
      o_AluOp             : out std_logic_vector (2 downto 0);   --
      o_MemWrite          : out std_logic;      --
      o_MemSigned         : out std_logic;      --
      o_MemDataSize       : out std_logic;      --
      o_ShamSrc           : out std_logic;      --
      o_RegWriteFromMem   : out std_logic;      --
      o_BranchOp          : out std_logic_vector (1 downto 0);   --
      o_JumpReg           : out std_logic;      --
      o_Jump              : out std_logic;      --
      o_BranchEnable      : out std_logic       --
      );
  
  end entity mips_control;

--signals
	s_instruction       : in std_logic_vector (31 downto 0);  -- instruction from the memory
      s_RdIsDest          : out std_logic;      -- COMMENT ME
      s_Link              : out std_logic;      --
      s_RtIsForceZero     : out std_logic;      --
      s_RegWrite          : out std_logic;      --
      s_ImmToAluB         : out std_logic;      --
      s_AluOp             : out std_logic_vector (2 downto 0);   --
      s_MemWrite          : out std_logic;      --
      s_MemSigned         : out std_logic;      --
      s_MemDataSize       : out std_logic;      --
      s_ShamSrc           : out std_logic;      --
      s_RegWriteFromMem   : out std_logic;      --
      s_BranchOp          : out std_logic_vector (1 downto 0);   --
      s_JumpReg           : out std_logic;      --
      s_Jump              : out std_logic;      --
      s_BranchEnable      : out std_logic;       --
  
  
begin  -- architecture mixed

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- THE FOLLOWING IS THE ACTUAL STRUCTURAL ARCHITECTURE
  ----- PORT DEFINITIONS, WIRING STUFF TOGETHER, ...
  ----- USE DATAFLOW MUX (APPROVED BY ZAMBRENO, WILL SAVE SOME TIME)
  -------- E.G.: muxed_signal <= zero_signal when control_signal = '0' else one_signal;
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  


  -----------------------------------------------------------------------------
  -- Main Control
  -----------------------------------------------------------------------------
  
main_control : mips_conrtrol
	port map ( 
   	i_instruction    => s_instruction,
      o_RdIsDest         => s_RdIsDest,
      o_Link             => s_Link,
      o_RtIsForceZero    => s_RtIsForceZero,
      o_RegWrite         => s_RegWrite,
      o_ImmToAluB        =>s_ImmToAluB,
      o_AluOp            => s_AluOp,
      o_MemWrite         => s_MemWrite,
      o_MemSigned        => s_MemSigned,
      o_MemDataSize      => s_MemDataSize,
      o_ShamSrc          => s_ShamSrc,
      o_RegWriteFromMem   =>s_RegWriteFromMem,
      o_BranchOp          =>s_BranchOp,
      o_JumpReg           =>s_JumpReg,
      o_Jump              =>s_Jump,
      o_BranchEnable      =>s_BranchEnable,
);

  -----------------------------------------------------------------------------
  -- Instruction Fetch Logic
  -----------------------------------------------------------------------------

  instruction_memory : ram
    port map (
      i_addr  => s_addr,
      o_rdata => s_rdata,
      i_wdata => X"00000000",
      i_wen   => '0',
      i_clk   => s_clk);

  program_counter : reg
    port map (
      i_wdata => s_wdata,
      i_wen   => '1',
      o_rdata => s_rdata,
      i_rst   => s_rst,
      i_clk   => s_clk);

  

  -----------------------------------------------------------------------------
  -- Register File
  -----------------------------------------------------------------------------


  register_file : mips_regfile
    port map(
      i_raddr1  => s_raddr1,
      i_raddr2  => s_raddr2,
      i_waddr   => s_waddr,
      i_wdata   => s_wdata,
      i_wenable => s_wenable,
      i_clk     => s_clk,
      i_rst     => s_rst,
      o_rdata1  => s_rdata1,
      o_rdata2  => s_rdata2);

  
  -----------------------------------------------------------------------------
  -- ALU Control
  -----------------------------------------------------------------------------

  -- we need to discuss the implementation of this

  -----------------------------------------------------------------------------
  -- ALU
  -----------------------------------------------------------------------------

  alu: mips_alu
    port map (
      i_A           => s_A,
      i_B           => s_B,
      o_R           => s_R,
      i_ShiftAmount => s_ShiftAmount,
      i_Function    => s_Function,
      o_ZeroFlag    => s_ZeroFlag);

  
  -----------------------------------------------------------------------------
  -- Branch Control
  -----------------------------------------------------------------------------

  -- this should be very easy to implement, I can take care of it

  -----------------------------------------------------------------------------
  -- Data Memory
  -----------------------------------------------------------------------------

  data_memory: mips_mem
    port map(
      i_addr => s_addr,
      i_wdata => s_wdata,
      i_size => s_size,
      i_signed => s_signed,
      i_wen => s_wen,
      i_clk => s_clk,
      o_rdata => s_rdata);
  
end architecture mixed;
-------------------------------------------------------------------------------
