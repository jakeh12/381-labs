-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips is
  
  port (
    i_clk : in std_logic;
    i_rst : in std_logic
    );

end entity mips;
-------------------------------------------------------------------------------
architecture mixed of mips is

  -----------------------------------------------------------------------------
  -- This is the spot where we put all of our component prototypes
  -----------------------------------------------------------------------------


  -- n-position shifter
  component n_shifter is
    generic (
      n : natural := 2);

    port (
      i_A   : in  std_logic_vector (31 downto 0);
      i_In  : in  std_logic;
      i_Sel : in  std_logic;
      o_F   : out std_logic_vector (31 downto 0));
  end component n_shifter;

  -- extender
  component extender is
    generic (
      n_small : integer := 16;
      n_big   : integer := 32
      );
    port (
      i_isSigned : in  std_logic;
      i_small    : in  std_logic_vector(n_small-1 downto 0);
      o_big      : out std_logic_vector(n_big-1 downto 0)
      );
  end component;


  -- full adder n-bit
  component fan is
    generic(
      n : integer := 32
      );
    port(
      i_A, i_B : in  std_logic_vector(n-1 downto 0);
      i_Cin    : in  std_logic;
      o_S      : out std_logic_vector(n-1 downto 0);
      o_Cout   : out std_logic
      );
  end component;


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
      i_Function    : in  std_logic_vector (3 downto 0);
      o_ZeroFlag    : out std_logic);
  end component;

  -- data memory
  component mips_mem is
    port (
      i_addr   : in  std_logic_vector(31 downto 0);
      i_wdata  : in  std_logic_vector(31 downto 0);
      i_size   : in  std_logic_vector(1 downto 0);
      i_signed : in  std_logic;
      i_wen    : in  std_logic;
      i_clk    : in  std_logic;
      o_rdata  : out std_logic_vector(31 downto 0));
  end component;

  -- control
  component mips_control is
    port (
      i_instruction     : in  std_logic_vector (31 downto 0);  -- instruction from the memory
      o_RdIsDest        : out std_logic;                       -- COMMENT ME
      o_Link            : out std_logic;                       --
      o_RtIsForceZero   : out std_logic;                       --
      o_RegWrite        : out std_logic;                       --
      o_ImmToAluB       : out std_logic;                       --
      o_AluOp           : out std_logic_vector (2 downto 0);   --
      o_MemWrite        : out std_logic;                       --
      o_MemSigned       : out std_logic;                       --
      o_MemDataSize     : out std_logic;                       --
      o_ShamSrc         : out std_logic;                       --
      o_RegWriteFromMem : out std_logic;                       --
      o_BranchOp        : out std_logic_vector (1 downto 0);   --
      o_JumpReg         : out std_logic;                       --
      o_Jump            : out std_logic;                       --
      o_BranchEnable    : out std_logic                        --
      );

  end component mips_control;

-- Control signals
  signal s_RdIsDest        : std_logic;                      -- COMMENT ME
  signal s_Link            : std_logic;                      --
  signal s_RtIsForceZero   : std_logic;                      --
  signal s_RegWrite        : std_logic;                      --
  signal s_ImmToAluB       : std_logic;                      --
  signal s_AluOp           : std_logic_vector (2 downto 0);  --
  signal s_MemWrite        : std_logic;                      --
  signal s_MemSigned       : std_logic;                      --
  signal s_MemDataSize     : std_logic;                      --
  signal s_ShamSrc         : std_logic;                      --
  signal s_RegWriteFromMem : std_logic;                      --
  signal s_BranchOp        : std_logic_vector (1 downto 0);  --
  signal s_JumpReg         : std_logic;                      --
  signal s_Jump            : std_logic;                      --
  signal s_BranchEnable    : std_logic;                      --

-- Instruction Fetch signals
  signal s_CurrentPC, s_NextPC, s_PCplus4, s_PCOut : std_logic_vector (31 downto 0);
  signal s_Instruction, s_JumpAddrShifted          : std_logic_vector (31 downto 0);
  signal s_BranchOffsetShifted, s_BranchAddress    : std_logic_vector (31 downto 0);
  signal s_SignExtImmOrAddr                        : std_logic_vector (31 downto 0);

-- Instruction aliases
  -- checkout MIPS instruction formats (p. 120)                    
  alias a_Opcode     : std_logic_vector (5 downto 0) is s_Instruction(31 downto 26);
  alias a_Rs         : std_logic_vector (4 downto 0) is s_Instruction (25 downto 21);
  alias a_Rt         : std_logic_vector (4 downto 0) is s_Instruction (20 downto 16);
  alias a_BranchCode : std_logic_vector (4 downto 0) is s_Instruction (20 downto 16);
  alias a_Rd         : std_logic_vector (4 downto 0) is s_Instruction (15 downto 11);
  alias a_Shamt      : std_logic_vector (4 downto 0) is s_Instruction (10 downto 6);
  alias a_Funct      : std_logic_vector (5 downto 0) is s_Instruction (5 downto 0);
  alias a_ImmOrAddr  : std_logic_vector (15 downto 0) is s_Instruction (15 downto 0);
  alias a_JumpAddr   : std_logic_vector (25 downto 0) is s_Instruction (25 downto 0);


  -- Register File signals
  signal s_RsReadData, s_RtReadData : std_logic_vector (31 downto 0);
  signal s_RegWriteAddr             : std_logic_vector (31 downto 0);
  signal s_RegWriteAddrSource       : std_logic_vector (1 downto 0);


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Architecture DEFINITION HERE
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
begin  -- architecture mixed

  -----------------------------------------------------------------------------
  -- Main Control
  -----------------------------------------------------------------------------
  
  main_control : mips_control
    port map (
      i_instruction     => s_Instruction,
      o_RdIsDest        => s_RdIsDest,
      o_Link            => s_Link,
      o_RtIsForceZero   => s_RtIsForceZero,
      o_RegWrite        => s_RegWrite,
      o_ImmToAluB       => s_ImmToAluB,
      o_AluOp           => s_AluOp,
      o_MemWrite        => s_MemWrite,
      o_MemSigned       => s_MemSigned,
      o_MemDataSize     => s_MemDataSize,
      o_ShamSrc         => s_ShamSrc,
      o_RegWriteFromMem => s_RegWriteFromMem,
      o_BranchOp        => s_BranchOp,
      o_JumpReg         => s_JumpReg,
      o_Jump            => s_Jump,
      o_BranchEnable    => s_BranchEnable);

  -----------------------------------------------------------------------------
  -- Instruction Fetch Logic
  -----------------------------------------------------------------------------

  pc_plus_4_adder : fan
    port map (
      i_A    => s_CurrentPC,
      i_B    => X"00000004",
      i_Cin  => '0',
      o_S    => s_PCplus4,
      o_Cout => open);

  
  branch_addr_adder : fan
    port map (
      i_A    => s_BranchOffsetShifted,
      i_B    => s_PCplus4,
      i_Cin  => '0',
      o_S    => s_BranchAddress,
      o_Cout => open);

  instruction_memory : ram
    port map (
      i_addr  => s_CurrentPC,
      o_rdata => s_Instruction,
      i_wdata => X"00000000",
      i_wen   => '0',
      i_clk   => i_clk);

  program_counter : reg
    port map (
      i_wdata => s_NextPC,
      i_wen   => '1',
      o_rdata => s_CurrentPC,
      i_rst   => i_rst,
      i_clk   => i_clk);


  shifter_JumpAddr : n_shifter
    port map (
      i_A   => a_JumpAddr,
      i_In  => '0',
      i_Sel => '1',
      o_F   => s_JumpAddrShifted);


  -- extender
  component extender is
    generic (
      n_small : integer := 16;
      n_big   : integer := 32
      );
    port (
      i_isSigned : in  std_logic;
      i_small    : in  std_logic_vector(n_small-1 downto 0);
      o_big      : out std_logic_vector(n_big-1 downto 0)
      );
  end component;

  imm_sign_ext : extender
    port map (
      i_isSigned => '1',
      i_small    => a_ImmOrAddr,
      o_big      => s_SignExtImmOrAddr);

  shifter_BranchOffset : n_shifter
    port map (
      i_A   => s_SignExtImmOrAddr,
      i_In  => '0',
      i_Sel => '1',
      o_F   => s_BranchOffsetShifted);


  s_JumpAddress    <= s_PCplus4(31 downto 28) & s_JumpAddrShifted;
  s_JumpRegAddress <= s_RsReadData;

  -----------------------------------------------------------------------------
  -- s_NextPCSource mux
  --
  -- Select next program counter source
  --
  -- 00 = PC+4
  -- 01 = BranchAddress
  -- 10 = JumpAddress
  -- 11 = JumpRegAddress
  -- others = reset state (impossible)
  -----------------------------------------------------------------------------
  with s_NextPCSource select
    s_NextPC <=
    s_PCplus4        when "00",
    s_BranchAddress  when "01",
    s_JumpAddress    when "10",
    s_JumpRegAddress when "11",
    X"00000000"      when others;       -- should never happen






  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Register File
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- s_RegWriteAddrSource mux
  -----------------------------------------------------------------------------
  -- chooses the write address for the register file
  -- 00 = Rd
  -- 01 = Rt
  -- 1X = $ra (for linking)
  -----------------------------------------------------------------------------
  with s_RegWriteAddrSource select
    s_RegWriteAddr <=
    a_Rd    when "00",
    a_Rt    when "01",
    "11111" when "1-",                  -- $ra for linking
    "00000" when others;                -- should never happen


  -----------------------------------------------------------------------------
  -- s_RegWriteDataSource mux
  -----------------------------------------------------------------------------
  -- chooses the write data for the register file
  -- 00 = ALU Result
  -- 01 = Memory Data Read
  -- 1X = PC+4 (for linking)
  -----------------------------------------------------------------------------
  with s_RegWriteDataSource select
    s_RegWriteData <=
    s_ALUResult   when "00",
    s_MemReadData when "01",
    s_PCplus4     when "1-",
    X"00000000"   when others;          -- should never happen


  -----------------------------------------------------------------------------
  -- s_RtReadAddrSource mux
  -----------------------------------------------------------------------------
  -- chooses between a_Rt and forced $0 (to support weird branch instructions)
  -- 0 = Rt
  -- 1 = $0
  -----------------------------------------------------------------------------
  s_RtReadAddr <= a_Rt when s_RtReadAddrSource = '0' else "00000";

  register_file : mips_regfile
    port map(
      i_raddr1  => a_Rs,
      i_raddr2  => s_RtReadAddr,
      i_waddr   => s_RegWriteAddr,
      i_wdata   => s_RegWriteData,
      i_wenable => s_RegWriteEnable,
      i_clk     => i_Clk,
      i_rst     => i_Rst,
      o_rdata1  => s_RsReadData,
      o_rdata2  => s_RtReadData);


  -----------------------------------------------------------------------------
  -- ALU Control
  -----------------------------------------------------------------------------

  -- we need to discuss the implementation of this






  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- ALU
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- s_ALUInputBSource mux
  -----------------------------------------------------------------------------
  -- chooses between register file output and immediate value
  -- 0 = $Rt
  -- 1 = SignExtImm
  -----------------------------------------------------------------------------
  s_ALUInputB <= s_RtReadData when s_ALUInputBSource = '0' else s_SignExtImmOrAddr;


  -----------------------------------------------------------------------------
  -- s_ALUShiftAmountSource mux
  -----------------------------------------------------------------------------
  -- chooses between different sources of shift amount
  -- 00 = Shift amount from the instruction
  -- 01 = Shift amount from register (variable shift)
  -- 1- = Shift amount by constant 16 (used for LUI)
  -----------------------------------------------------------------------------
  with s_ALUShiftAmountSource select
    s_ALUShiftAmount <=
    a_Shamt                  when "00",
    s_RsReadData(4 downto 0) when "01",
    "10000"                  when "1-",
    "00000"                  when others;  -- should never happen
  
  alu : mips_alu
    port map (
      i_A           => s_RsReadData,
      i_B           => s_ALUInputB,
      o_R           => s_ALUResult,
      i_ShiftAmount => s_ALUShiftAmountSource,
      i_Function    => s_ALUControlFunctOutput,  -- need to create this signal
                                                 -- in ALU Control
      o_ZeroFlag    => s_ALUZeroFlag);


  -----------------------------------------------------------------------------
  -- Branch Control
  -----------------------------------------------------------------------------

  -- this should be very easy to implement, I can take care of it

  -----------------------------------------------------------------------------
  -- Data Memory
  -----------------------------------------------------------------------------

  data_memory : mips_mem
    port map(
      i_addr   => s_ALUResult,
      i_wdata  => s_RtReadData,
      i_size   => s_MemDataLength,
      i_signed => s_MemDataSigned,
      i_wen    => s_MemWriteEnable,
      i_clk    => i_Clk,
      o_rdata  => s_MemReadData);

end architecture mixed;
-------------------------------------------------------------------------------
