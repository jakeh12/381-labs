-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------
entity mips_control is

  port (
    i_instruction        : in  std_logic_vector (31 downto 0);  -- instruction from the memory
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
    o_ALUInputBSource    : out std_logic
    );

end entity mips_control;
-------------------------------------------------------------------------------
architecture rom of mips_control is

  -- checkout MIPS instruction formats (p. 120)
  alias a_op             : std_logic_vector (5 downto 0) is i_instruction(31 downto 26);
  alias a_rs             : std_logic_vector (4 downto 0) is i_instruction (25 downto 21);
  alias a_rt             : std_logic_vector (4 downto 0) is i_instruction (20 downto 16);
  alias a_branch         : std_logic_vector (4 downto 0) is i_instruction (20 downto 16);
  alias a_rd             : std_logic_vector (4 downto 0) is i_instruction (15 downto 11);
  alias a_shamt          : std_logic_vector (4 downto 0) is i_instruction (10 downto 6);
  alias a_funct          : std_logic_vector (5 downto 0) is i_instruction (5 downto 0);
  alias a_addr_or_imm    : std_logic_vector (15 downto 0) is i_instruction (15 downto 0);
  alias a_target_address : std_logic_vector (25 downto 0) is i_instruction (25 downto 0);

  --OP CODES
  constant OP_MUL    : natural := 2#000000#;
  constant OP_ADD    : natural := 2#000000#;
  constant OP_ADDU   : natural := 2#000000#;
  constant OP_SUB    : natural := 2#000000#;
  constant OP_SUBU   : natural := 2#000000#;
  constant OP_ADDI   : natural := 2#001000#;
  constant OP_ADDIU  : natural := 2#001001#;
  constant OP_OR     : natural := 2#000000#;
  constant OP_ORI    : natural := 2#001101#;
  constant OP_AND    : natural := 2#000000#;
  constant OP_ANDI   : natural := 2#001100#;
  constant OP_XOR    : natural := 2#000000#;
  constant OP_XORI   : natural := 2#001110#;
  constant OP_NOR    : natural := 2#000000#;
  constant OP_SLT    : natural := 2#000000#;
  constant OP_SLTU   : natural := 2#000000#;
  constant OP_SLTI   : natural := 2#001010#;
  constant OP_SLTIU  : natural := 2#001011#;
  constant OP_BEQ    : natural := 2#000100#;
  constant OP_BNE    : natural := 2#000101#;
  constant OP_BLTZ   : natural := 2#000001#;
  constant OP_BGEZ   : natural := 2#000001#;
  constant OP_BLTZAL : natural := 2#000001#;
  constant OP_BGEZAL : natural := 2#000001#;
  constant OP_BLEZ   : natural := 2#000110#;
  constant OP_BGTZ   : natural := 2#000111#;
  constant OP_J      : natural := 2#000010#;
  constant OP_JAL    : natural := 2#000011#;
  constant OP_JR     : natural := 2#000000#;
  constant OP_JALR   : natural := 2#000000#;
  constant OP_LB     : natural := 2#100000#;
  constant OP_LBU    : natural := 2#100100#;
  constant OP_LH     : natural := 2#100001#;
  constant OP_LHU    : natural := 2#100101#;
  constant OP_LW     : natural := 2#100011#;
  constant OP_SB     : natural := 2#101000#;
  constant OP_SH     : natural := 2#101001#;
  constant OP_SW     : natural := 2#101011#;
  constant OP_SLL    : natural := 2#000000#;
  constant OP_SRL    : natural := 2#000000#;
  constant OP_SRA    : natural := 2#000000#;
  constant OP_SLLV   : natural := 2#000000#;
  constant OP_SRLV   : natural := 2#000000#;
  constant OP_SRAV   : natural := 2#000000#;
  constant OP_LUI    : natural := 2#001111#;


  --FUNCTION CODES
  constant FUNC_MUL  : natural := 2#111111#;
  constant FUNC_ADD  : natural := 2#100000#;
  constant FUNC_ADDU : natural := 2#100001#;
  constant FUNC_SUB  : natural := 2#100010#;
  constant FUNC_SUBU : natural := 2#100011#;
  constant FUNC_OR   : natural := 2#100101#;
  constant FUNC_AND  : natural := 2#001101#;
  constant FUNC_XOR  : natural := 2#100110#;
  constant FUNC_NOR  : natural := 2#100111#;
  constant FUNC_SLT  : natural := 2#101010#;
  constant FUNC_SLTU : natural := 2#101001#;
  constant FUNC_JR   : natural := 2#001000#;
  constant FUNC_JALR : natural := 2#001001#;
  constant FUNC_SLL  : natural := 2#000000#;
  constant FUNC_SRL  : natural := 2#000010#;
  constant FUNC_SRA  : natural := 2#000011#;
  constant FUNC_SLLV : natural := 2#000100#;
  constant FUNC_SRLV : natural := 2#000110#;
  constant FUNC_SRAV : natural := 2#000111#;

  --BRANCH CODES
  constant BRANCH_BLTZ   : natural := 2#000000#;
  constant BRANCH_BGEZ   : natural := 2#000001#;
  constant BRANCH_BLTZAL : natural := 2#010000#;
  constant BRANCH_BGEZAL : natural := 2#010001#;


  type rom_array is array (63 downto 0) of std_logic_vector(21 downto 0);  

  --signal dummy : integer := 61;
  --R Type ROM
  signal rom_r : rom_array := (
    FUNC_JALR => "10100000------10001100",
    FUNC_JR   => "00------------10-----0",
    --others    => "10" & "011000" & "------00000000"
    others    => "10------------00000000"
    );

--Branch Type ROM
  signal rom_b : rom_array := (
    BRANCH_BLTZ   => "00100010010---11----10",
    BRANCH_BGEZ   => "00100010011---11----10",
    BRANCH_BLTZAL => "10100010010---11111110",
    BRANCH_BGEZAL => "10100010011---11111110",
    others => "0000000000000000000000"
    );

--All other instructions ROM
  signal rom_o : rom_array := (
    OP_ADDI  => "10100000------00010001",
    OP_ADDIU => "10100001------00010001",
    OP_ORI   => "10100101------00010001",
    OP_ANDI  => "10001101------00010001",
    OP_XORI  => "10100110------00010001",
    OP_SLTI  => "10101010------00010001",
    OP_SLTIU => "10101001------00010001",
    OP_J     => "00------------01------",
    OP_JAL   => "10------------01101100",
    OP_JALR  => "10100000------10001100",
    OP_LB    => "10100000---10100010101",
    OP_LBU   => "10100000---10000010101",
    OP_LH    => "10100000---01100010101",
    OP_LHU   => "10100000---01000010101",
    OP_LW    => "10100000---00100010101",
    OP_SB    => "01100000---10-00----01",
    OP_SH    => "01100000---01-00----01",
    OP_SW    => "01100000---00-00----01",
    OP_LUI   => "10------------000110-1",
    others   => "0000000000000000000000"
    );

  signal controlVector : std_logic_vector(21 downto 0);

begin

  with a_op select controlVector <=
    rom_r(to_integer(unsigned(a_funct)))    when "000000",
    rom_b(to_integer(unsigned('0' & a_rt))) when "000001",
    rom_o(to_integer(unsigned(a_op)))     when others;

  (
    o_RegWriteEnable,
    o_MemWriteEnable,
    o_ALUFunction(5),
    o_ALUFunction(4),
    o_ALUFunction(3),
    o_ALUFunction(2),
    o_ALUFunction(1),
    o_ALUFunction(0),
    o_BranchType(2),
    o_BranchType(1),
    o_BranchType(0),
    o_MemDataLength(1),
    o_MemDataLength(0),
    o_MemDataSigned,
    o_NextPCSource(1),
    o_NextPCSource(0),
    o_RegWriteAddrSource(1),
    o_RegWriteAddrSource(0),
    o_RegWriteDataSource(1),
    o_RegWriteDataSource(0),
    o_RtReadAddrSource,
    o_ALUInputBSource
    )
    <= ieee.std_logic_1164."&"(ieee.std_logic_1164."&"(controlVector(21 downto 20), a_funct),controlVector(13 downto 0)) when a_op="000000" else controlVector;



end rom;
