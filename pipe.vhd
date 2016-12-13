-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity pipe is
  generic(
    program_file : string := "testing/r_test.mif");
  port (i_clk : in std_logic;
        i_rst : in std_logic);
end entity pipe;
-------------------------------------------------------------------------------
architecture mixed of pipe is

  -- Pipeline n-bit register
  component pipereg
    generic(n : integer := 256);
    port(i_CLK   : in  std_logic;    -- Clock input
         i_FLUSH : in  std_logic;    -- Reset input
         i_STALL : in  std_logic;
         i_D     : in  std_logic_vector(n-1 downto 0);   -- Data value input
         o_Q     : out std_logic_vector(n-1 downto 0));  -- Data value output
  end component;

  -- Branch control
  component branch_control is
    port (
      i_BranchType                : in  std_logic_vector (2 downto 0);
      i_ALUFlagZero, i_ALUFlagNeg : in  std_logic;
      o_BranchDecision            : out std_logic);
  end component branch_control;

  -- N-position shifter
  component n_shifter is
    generic (
      n : natural := 1);

    port (
      i_A   : in  std_logic_vector (31 downto 0);
      i_In  : in  std_logic;
      i_Sel : in  std_logic;
      o_F   : out std_logic_vector (31 downto 0));
  end component n_shifter;

  -- Extender
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

  -- Full adder n-bit
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

  -- Instruction memory
  component ram is
    generic (
      n         : natural := 32;        -- width of word in bits
      l         : natural := 10;  -- width of address bus in bits                                 
      init_file : string  := program_file);  -- memory intialization file
    port (
      i_addr  : in  std_logic_vector (l-1 downto 0);  -- address input
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_wen   : in  std_logic;
      i_clk   : in  std_logic);
  end component ram;

  -- Program counter
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

  -- Register file
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


  -- ALU
  component mips_alu is
    port (
      i_A           : in  std_logic_vector (31 downto 0);
      i_B           : in  std_logic_vector (31 downto 0);
      o_R           : out std_logic_vector (31 downto 0);
      i_ShiftAmount : in  std_logic_vector (4 downto 0);
      i_Function    : in  std_logic_vector (5 downto 0);
      o_ZeroFlag    : out std_logic);
  end component;

  -- Data memory
  component mips_mem is
    generic (
      l : natural := 14);
    port (
      i_addr   : in  std_logic_vector(31 downto 0);
      i_wdata  : in  std_logic_vector(31 downto 0);
      i_size   : in  std_logic_vector(1 downto 0);
      i_signed : in  std_logic;
      i_wen    : in  std_logic;
      i_clk    : in  std_logic;
      o_rdata  : out std_logic_vector(31 downto 0));
  end component;

  -- Main control
  component mips_control is
    port (
      i_instruction        : in  std_logic_vector (31 downto 0);
      o_RegWriteEnable     : out std_logic;
      o_MemWriteEnable     : out std_logic;
      o_ALUFunction        : out std_logic_vector(5 downto 0);
      o_BranchType         : out std_logic_vector(2 downto 0);
      o_MemDataLength      : out std_logic_vector(1 downto 0);
      o_MemDataSigned      : out std_logic;
      o_NextPCSource       : out std_logic_vector(1 downto 0);
      o_RegWriteAddrSource : out std_logic_vector(1 downto 0);
      o_RegWriteDataSource : out std_logic_vector(1 downto 0);
      o_RtReadAddrSource   : out std_logic;
      o_ALUInputBSource    : out std_logic);
  end component mips_control;

  -- Control signals
  signal s_RegWriteEnable     : std_logic;
  signal s_MemWriteEnable     : std_logic;
  signal s_ALUFunction        : std_logic_vector(5 downto 0);
  signal s_BranchType         : std_logic_vector(2 downto 0);
  signal s_MemDataLength      : std_logic_vector(1 downto 0);
  signal s_MemDataSigned      : std_logic;
  signal s_NextPCSource       : std_logic_vector(1 downto 0);
  signal s_RegWriteAddrSource : std_logic_vector(1 downto 0);
  signal s_RegWriteDataSource : std_logic_vector(1 downto 0);
  signal s_RtReadAddrSource   : std_logic;
  signal s_ALUInputBSource    : std_logic;


  -- Instruction Fetch signals
  signal s_CurrentPC, s_NextPC, s_PCplus4       : std_logic_vector (31 downto 0);
  signal s_Instruction, s_JumpAddrShifted       : std_logic_vector (31 downto 0);
  signal s_JumpAddrExtended                     : std_logic_vector (31 downto 0);
  signal s_BranchOffsetShifted, s_BranchAddress : std_logic_vector (31 downto 0);
  signal s_SignExtImmOrAddr                     : std_logic_vector (31 downto 0);
  signal s_JumpAddress                          : std_logic_vector (31 downto 0);
  signal s_JumpRegAddress                       : std_logic_vector (31 downto 0);
  signal s_CurrentPCWordAddr                    : std_logic_vector (9 downto 0);


  -- Branch Control Signals
  signal s_BranchDecision        : std_logic;
  signal s_BranchDecisionAddress : std_logic_vector (31 downto 0);


  -- Instruction aliases
  alias a_Opcode     : std_logic_vector (5 downto 0) is s_Instruction(31 downto 26);
  alias a_Rs         : std_logic_vector (4 downto 0) is s_Instruction (25 downto 21);
  alias a_Rt         : std_logic_vector (4 downto 0) is s_Instruction (20 downto 16);
  alias a_BranchCode : std_logic_vector (4 downto 0) is s_Instruction (20 downto 16);
  alias a_Rd         : std_logic_vector (4 downto 0) is s_Instruction (15 downto 11);
  alias a_Shamt      : std_logic_vector (4 downto 0) is s_Instruction (10 downto 6);
  alias a_Funct      : std_logic_vector (5 downto 0) is s_Instruction (5 downto 0);
  alias a_ImmOrAddr  : std_logic_vector (15 downto 0) is s_Instruction (15 downto 0);
  alias a_JumpAddr   : std_logic_vector (25 downto 0) is s_Instruction (25 downto 0);


  -- Data Memory signals
  signal s_MemReadData : std_logic_vector (31 downto 0);


  -- ALU signals
  signal s_ALUInputB, s_ALUResult : std_logic_vector (31 downto 0);
  signal s_ALUFlagZero            : std_logic;


  -- Register File signals
  signal s_RtReadAddr               : std_logic_vector (4 downto 0);
  signal s_RsReadData, s_RtReadData : std_logic_vector (31 downto 0);
  signal s_RegWriteAddr             : std_logic_vector (4 downto 0);
  signal s_RegWriteData             : std_logic_vector (31 downto 0);
  --signal s_RegWriteAddrSource       : std_logic_vector (1 downto 0);  

  signal s_UpperImm : std_logic_vector (31 downto 0);


  -- Pipeline register signals
  signal s_IFID_Flush, s_IDEX_Flush, s_EXMEM_Flush, s_MEMWB_Flush : std_logic;
  signal s_IFID_Stall, s_IDEX_Stall, s_EXMEM_Stall, s_MEMWB_Stall : std_logic;
  signal s_in_IFID, s_out_IFID : std_logic_vector (255 downto 0);
  signal s_in_IDEX, s_out_IDEX : std_logic_vector (255 downto 0);
  signal s_in_EXMEM, s_out_EXMEM  : std_logic_vector (255 downto 0);
  signal s_in_MEMWB, s_out_MEMWB : std_logic_vector (255 downto 0);

  
  --IF/ID alias
  alias a_in_ifid_Instruction  : std_logic_vector (31 downto 0) is s_in_IFID (31 downto 0);
  alias a_out_ifid_Instruction : std_logic_vector (31 downto 0) is s_out_IFID (31 downto 0);
  alias a_in_ifid_PCplus4      : std_logic_vector (31 downto 0) is s_in_IFID (63 downto 32);
  alias a_out_ifid_PCplus4     : std_logic_vector (31 downto 0) is s_out_IFID (63 downto 32);
  --
  alias a_in_ifid_JumpAddress      : std_logic_vector (31 downto 0) is s_in_IFID (95 downto 64);
  alias a_out_ifid_JumpAddress    : std_logic_vector (31 downto 0) is s_out_IFID (95 downto 64);
  alias a_in_ifid_BranchAddress     : std_logic_vector (31 downto 0) is s_in_IFID (127 downto 96);
  alias a_out_ifid_BranchAddress     : std_logic_vector (31 downto 0) is s_out_IFID (127 downto 96);
  
  -----------------------------------------------------------------------------
  -- DO WE NEED THIS IN HERE?
  -----------------------------------------------------------------------------
  --may not need NEXTPCSOURCE v
  --alias a_in_exmem_NextPCSource        : std_logic_vector(1 downto 0) is;
  --alias a_out_exmem_NextPCSource       : std_logic_vector(1 downto 0) is;
  --may not need NEXTPCSOURCE ^
  -----------------------------------------------------------------------------
 

  
  --ID/EX alias
  alias a_in_idex_Instruction         : std_logic_vector (31 downto 0) is s_in_IDEX (31 downto 0);
  alias a_out_idex_Instruction        : std_logic_vector (31 downto 0) is s_out_IDEX (31 downto 0);
  alias a_in_idex_PCplus4             : std_logic_vector (31 downto 0) is s_in_IDEX (63 downto 32);
  alias a_out_idex_PCplus4            : std_logic_vector (31 downto 0) is s_out_IDEX (63 downto 32);
  alias a_in_idex_RegWriteEnable      : std_logic is  s_in_IDEX (64);
  alias a_out_idex_RegWriteEnable     : std_logic is  s_out_IDEX (64);
  alias a_in_idex_RegWriteAddrSource  : std_logic_vector(1 downto 0) is s_in_IDEX (66 downto 65);
  alias a_out_idex_RegWriteAddrSource : std_logic_vector(1 downto 0) is s_out_IDEX (66 downto 65);
  alias a_in_idex_RegWriteDataSource  : std_logic_vector(1 downto 0) is s_in_IDEX (68 downto 67);
  alias a_out_idex_RegWriteDataSource : std_logic_vector(1 downto 0) is s_out_IDEX (68 downto 67);
  alias a_in_idex_MemWriteEnable      : std_logic is s_in_IDEX (69);
  alias a_out_idex_MemWriteEnable     : std_logic is s_out_IDEX (69);
  alias a_in_idex_MemDataLength       : std_logic_vector(1 downto 0) is s_in_IDEX (71 downto 70);
  alias a_out_idex_MemDataLength      : std_logic_vector(1 downto 0) is s_out_IDEX (71 downto 70);
  alias a_in_idex_MemDataSigned       : std_logic is s_in_IDEX (72);
  alias a_out_idex_MemDataSigned      : std_logic is s_out_IDEX (72);
  alias a_in_idex_NextPCSource        : std_logic_vector(1 downto 0) is s_in_IDEX (75 downto 74);
  alias a_out_idex_NextPCSource       : std_logic_vector(1 downto 0) is s_out_IDEX (75 downto 74);
  alias a_in_idex_ALUFunction         : std_logic_vector(5 downto 0) is s_in_IDEX (81 downto 76);
  alias a_out_idex_ALUFunction        : std_logic_vector(5 downto 0) is s_out_IDEX (81 downto 76);
  alias a_in_idex_BranchType          : std_logic_vector (4 downto 0) is s_in_IDEX (86 downto 82);
  alias a_out_idex_BranchType         : std_logic_vector (4 downto 0) is s_out_IDEX (86 downto 82);
  alias a_in_idex_RtReadAddrSource    : std_logic is s_in_IDEX (87);
  alias a_out_idex_RtReadAddrSource   : std_logic is s_out_IDEX (87);
  alias a_in_idex_ALUInputBSource     : std_logic is s_in_IDEX (88);
  alias a_out_idex_ALUInputBSource    : std_logic is s_out_IDEX (88);
  alias a_out_idex_RtData             : std_logic_vector(31 downto 0) is s_in_IDEX (120 downto 89);
  alias a_in_idex_RtData              : std_logic_vector(31 downto 0) is s_out_IDEX (120 downto 89);

  --EX/MEM alias
  alias a_in_exmem_Instruction         : std_logic_vector (31 downto 0) is s_in_EXMEM (31 downto 0);
  alias a_out_exmem_Instruction        : std_logic_vector (31 downto 0) is s_out_EXMEM (31 downto 0);
  alias a_in_exmem_PCplus4             : std_logic_vector (31 downto 0) is s_in_EXMEM (63 downto 32);
  alias a_out_exmem_PCplus4            : std_logic_vector (31 downto 0) is s_out_EXMEM (63 downto 32);
  alias a_in_exmem_RegWriteEnable      : std_logic is s_in_EXMEM (64);
  alias a_out_exmem_RegWriteEnable     : std_logic is s_out_EXMEM (64);
  alias a_in_exmem_RegWriteAddrSource  : std_logic_vector(1 downto 0) is s_in_EXMEM (66 downto 65);
  alias a_out_exmem_RegWriteAddrSource : std_logic_vector(1 downto 0) is s_out_EXMEM (66 downto 65);
  alias a_in_exmem_RegWriteDataSource  : std_logic_vector(1 downto 0) is s_in_EXMEM (68 downto 67);
  alias a_out_exmem_RegWriteDataSource : std_logic_vector(1 downto 0) is s_out_EXMEM (68 downto 67);
  alias a_in_exmem_MemWriteEnable      : std_logic is s_in_EXMEM (69);
  alias a_out_exmem_MemWriteEnable     : std_logic is s_out_EXMEM (69);
  alias a_in_exmem_MemDataLength       : std_logic_vector(1 downto 0) is s_in_EXMEM (71 downto 70);
  alias a_out_exmem_MemDataLength      : std_logic_vector(1 downto 0) is s_out_EXMEM (71 downto 70);
  alias a_in_exmem_MemDataSigned       : std_logic is s_in_EXMEM (72);
  alias a_out_exmem_MemDataSigned      : std_logic is s_out_EXMEM (72);
  alias a_in_exmem_ALUResult           : std_logic_vector(31 downto 0) is s_in_EXMEM (104 downto 73);
  alias a_out_exmem_ALUResult          : std_logic_vector(31 downto 0) is s_out_EXMEM (104 downto 73);
  alias a_out_exmem_RtData             : std_logic_vector(31 downto 0) is s_in_EXMEM (136 downto 105);
  alias a_in_exmem_RtData              : std_logic_vector(31 downto 0) is s_out_EXMEM (136 downto 105);

  --MEM/WB alias
  alias a_in_memwb_Instruction         : std_logic_vector (31 downto 0) is s_in_MEMWB (31 downto 0);
  alias a_out_memwb_Instruction        : std_logic_vector (31 downto 0) is s_out_MEMWB (31 downto 0);
  alias a_in_memwb_PCplus4             : std_logic_vector (31 downto 0) is s_in_MEMWB (63 downto 32);
  alias a_out_memwb_PCplus4            : std_logic_vector (31 downto 0) is s_out_MEMWB (63 downto 32);
  alias a_in_memwb_RegWriteEnable      : std_logic is s_in_MEMWB (64);
  alias a_out_memwb_RegWriteEnable     : std_logic is s_out_MEMWB (64);
  alias a_in_memwb_RegWriteAddrSource  : std_logic_vector(1 downto 0) is s_in_MEMWB (66 downto 65);
  alias a_out_memwb_RegWriteAddrSource : std_logic_vector(1 downto 0) is s_out_MEMWB (66 downto 65);
  alias a_in_memwb_RegWriteDataSource  : std_logic_vector(1 downto 0) is s_in_MEMWB (68 downto 67);
  alias a_out_memwb_RegWriteDataSource : std_logic_vector(1 downto 0) is s_out_MEMWB (68 downto 67);
  alias a_out_memwb_MemData            : std_logic_vector(31 downto 0) is s_in_MEMWB (100 downto 69);
  alias a_in_memwb_MemData             : std_logic_vector(31 downto 0) is s_out_MEMWB (100 downto 69);
  alias a_in_memwb_ALUResult           : std_logic_vector(31 downto 0) is s_in_MEMWB (132 downto 101);
  alias a_out_memwb_ALUResult          : std_logic_vector(31 downto 0) is s_out_MEMWB (132 downto 101);

  --divider registers input and output
  --alias a_in_ifid   : std_logic_vector(downto 0) is;
  --alias a_out_ifid  : std_logic_vector(downto 0) is;
  --alias a_in_idex   : std_logic_vector(downto 0) is;
  --alias a_out_idex  : std_logic_vector(downto 0) is;
  --alias a_in_exmem  : std_logic_vector(downto 0) is;
  --alias a_out_exmem : std_logic_vector(downto 0) is;
  --alias a_in_memwb  : std_logic_vector(downto 0) is;
  --alias a_out_memwb : std_logic_vector(downto 0) is;


begin  -- ARCHITECTURE DEFINITION STARTS HERE --




  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  -- IF STAGE
  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  
  pc_plus_4_adder : fan
    port map (
      i_A    => s_CurrentPC,
      i_B    => X"00000004",
      i_Cin  => '0',
      o_S    => s_PCplus4,              -- s_PCplus4
      o_Cout => open);
  a_in_idex_PCplus4 <= s_PCplus4;

  
  branch_addr_adder : fan
    port map (
      i_A    => s_BranchOffsetShifted,
      i_B    => s_PCplus4,
      i_Cin  => '0',
      o_S    => a_in_ifid_BranchAddress,        -- s_BranchAddress
      o_Cout => open);

  instruction_memory : ram
    port map (
      i_addr  => s_CurrentPCWordAddr,
      o_rdata => a_in_ifid_Instruction, --s_Instruction,
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


  s_JumpAddrExtended <= "000000" & a_JumpAddr;

  shifter_JumpAddr : n_shifter
    port map (
      i_A   => s_JumpAddrExtended,
      i_In  => '0',
      i_Sel => '1',
      o_F   => s_JumpAddrShifted);

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

  s_CurrentPCWordAddr <= "00" & s_CurrentPC(9 downto 2);

  a_in_ifid_JumpAddress <= s_PCplus4(31 downto 28) & s_JumpAddrShifted(27 downto 0); --
  --s_JumpAddress


  -- TODO: needs some attention....
  s_JumpRegAddress <= s_RsReadData;

  -----------------------------------------------------------------------------
  -- s_NextPCSource mux
  -----------------------------------------------------------------------------
  -- Select next program counter source
  --
  -- 00 = PC+4
  -- 01 = JumpAddress
  -- 10 = JumpRegAddress
  -- 11 = BranchDecisionAddress
  -----------------------------------------------------------------------------
  with s_NextPCSource select
    s_NextPC <=
    s_PCplus4               when "00",
    s_JumpAddress           when "01",
    s_JumpRegAddress        when "10",
    s_BranchDecisionAddress when "11",
    X"00000000"             when others;  -- should never happen


  
  IFID_pipereg: pipereg
    generic map (
      n => 256)
    port map (
      i_CLK   => i_clk,
      i_FLUSH => s_IFID_Flush,
      i_STALL => s_IFID_Stall,
      i_D     => s_in_IFID,
      o_Q     => s_out_IFID);




  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  -- ID STAGE
  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  --Main Control
  main_control : mips_control
    port map(
      i_instruction        => s_Instruction,
      o_RegWriteEnable     => s_RegWriteEnable,
      o_MemWriteEnable     => s_MemWriteEnable,
      o_ALUFunction        => s_ALUFunction,
      o_BranchType         => s_BranchType,
      o_MemDataLength      => s_MemDataLength,
      o_MemDataSigned      => s_MemDataSigned,
      o_NextPCSource       => s_NextPCSource,
      o_RegWriteAddrSource => s_RegWriteAddrSource,
      o_RegWriteDataSource => s_RegWriteDataSource,
      o_RtReadAddrSource   => s_RtReadAddrSource,
      o_ALUInputBSource    => s_ALUInputBSource);

  -----------------------------------------------------------------------------
  -- s_RegWriteAddrSource mux
  -----------------------------------------------------------------------------
  -- chooses the write address for the register file
  -- 00 = Rd
  -- 01 = Rt
  -- 10 = $ra (for linking)
  -- 11 = $zero or $ra (for branch linking)
  -----------------------------------------------------------------------------
  with s_RegWriteAddrSource select
    s_RegWriteAddr <=
    a_Rd                         when "00",
    a_Rt                         when "01",
    "11111"                      when "10",  -- $ra for linking
    (others => s_BranchDecision) when "11",  -- $zero or $ra for branch linking
    "00000"                      when others;  -- should never happen


  
  shifter_upper_imm : n_shifter
    generic map (
      n => 4)
    port map (
      i_A   => s_SignExtImmOrAddr,
      i_In  => '0',
      i_Sel => '1',
      o_F   => s_UpperImm);

  -----------------------------------------------------------------------------
  -- s_RegWriteDataSource mux
  -----------------------------------------------------------------------------
  -- chooses the write data for the register file
  -- 00 = ALU Result
  -- 01 = Memory Data Read
  -- 10 = Upper Immediate (LUI)
  -- 11 = PC+4 (for linking)
  -----------------------------------------------------------------------------
  with s_RegWriteDataSource select
    s_RegWriteData <=
    s_ALUResult   when "00",
    s_MemReadData when "01",
    s_UpperImm    when "10",
    s_PCplus4     when "11",
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



  
  
  IDEX_pipereg: pipereg
    generic map (
      n => 256)
    port map (
      i_CLK   => i_clk,
      i_FLUSH => s_IDEX_Flush,
      i_STALL => s_IDEX_Stall,
      i_D     => s_in_IDEX,
      o_Q     => s_out_IDEX);




  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  -- EX STAGE
  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  -----------------------------------------------------------------------------
  -- s_ALUInputBSource mux
  -----------------------------------------------------------------------------
  -- chooses between register file output and immediate value
  -- 0 = $Rt
  -- 1 = SignExtImm
  -----------------------------------------------------------------------------
  s_ALUInputB <= s_RtReadData when s_ALUInputBSource = '0' else s_SignExtImmOrAddr;

  alu : mips_alu
    port map (
      i_A           => s_RsReadData,
      i_B           => s_ALUInputB,
      o_R           => s_ALUResult,
      i_ShiftAmount => a_Shamt,
      i_Function    => s_ALUFunction,
      o_ZeroFlag    => s_ALUFlagZero);

  branch_ctl : branch_control
    port map (
      i_BranchType     => s_BranchType,
      i_ALUFlagZero    => s_ALUFlagZero,
      i_ALUFlagNeg     => s_ALUResult(31),
      o_BranchDecision => s_BranchDecision);

  -----------------------------------------------------------------------------
  -- BranchDecisionAddress mux
  -----------------------------------------------------------------------------
  -- 0 = PC+4
  -- 1 = BranchAddress
  -----------------------------------------------------------------------------
  s_BranchDecisionAddress <= s_PCplus4 when s_BranchDecision = '0' else s_BranchAddress;




  
  EXMEM_pipereg: pipereg
    generic map (
      n => 256)
    port map (
      i_CLK   => i_clk,
      i_FLUSH => s_EXMEM_Flush,
      i_STALL => s_EXMEM_Stall,
      i_D     => s_in_EXMEM,
      o_Q     => s_out_EXMEM);



  
  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  -- MEM STAGE
  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  data_memory : mips_mem
    port map(
      i_addr   => s_ALUResult,
      i_wdata  => s_RtReadData,
      i_size   => s_MemDataLength,
      i_signed => s_MemDataSigned,
      i_wen    => s_MemWriteEnable,
      i_clk    => i_Clk,
      o_rdata  => s_MemReadData);


  
  MEMWB_pipereg: pipereg
    generic map (
      n => 256)
    port map (
      i_CLK   => i_clk,
      i_FLUSH => s_MEMWB_Flush,
      i_STALL => s_MEMWB_Stall,
      i_D     => s_in_MEMWB,
      o_Q     => s_out_MEMWB);


  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  -- WB STAGE
  --:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

end architecture mixed;
-------------------------------------------------------------------------------
