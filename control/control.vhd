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

  --roms
  --type rom_rtype is std_logic_vector(23 downto 0); --the size of all output bits
  --type rom_branch is std_logic_vector(23 downto 0); --the size of all output bits
  --type rom_other is std_logic_vector(23 downto 0); --the size of all output bits

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
  constant OP_MUL    : std_logic_vector (5 downto 0) := "000000";
  constant OP_ADD    : std_logic_vector (5 downto 0) := "000000";
  constant OP_ADDU   : std_logic_vector (5 downto 0) := "000000";
  constant OP_SUB    : std_logic_vector (5 downto 0) := "000000";
  constant OP_SUBU   : std_logic_vector (5 downto 0) := "000000";
  constant OP_ADDI   : std_logic_vector (5 downto 0) := "001100";
  constant OP_ADDIU  : std_logic_vector (5 downto 0) := "001001";
  constant OP_OR     : std_logic_vector (5 downto 0) := "000000";
  constant OP_ORI    : std_logic_vector (5 downto 0) := "001101";
  constant OP_AND    : std_logic_vector (5 downto 0) := "000000";
  constant OP_ANDI   : std_logic_vector (5 downto 0) := "001100";
  constant OP_XOR    : std_logic_vector (5 downto 0) := "000000";
  constant OP_XORI   : std_logic_vector (5 downto 0) := "001110";
  constant OP_NOR    : std_logic_vector (5 downto 0) := "000000";
  constant OP_SLT    : std_logic_vector (5 downto 0) := "000000";
  constant OP_SLTU   : std_logic_vector (5 downto 0) := "000000";
  constant OP_SLTI   : std_logic_vector (5 downto 0) := "001010";
  constant OP_SLTIU  : std_logic_vector (5 downto 0) := "001011";
  constant OP_BEQ    : std_logic_vector (5 downto 0) := "000100";
  constant OP_BNE    : std_logic_vector (5 downto 0) := "000101";
  constant OP_BLTZ   : std_logic_vector (5 downto 0) := "000001";
  constant OP_BGEZ   : std_logic_vector (5 downto 0) := "000001";
  constant OP_BLTZAL : std_logic_vector (5 downto 0) := "000001";
  constant OP_BGEZAL : std_logic_vector (5 downto 0) := "000001";
  constant OP_BLEZ   : std_logic_vector (5 downto 0) := "000110";
  constant OP_BGTZ   : std_logic_vector (5 downto 0) := "000111";
  constant OP_J      : std_logic_vector (5 downto 0) := "000010";
  constant OP_JAL    : std_logic_vector (5 downto 0) := "000011";
  constant OP_JR     : std_logic_vector (5 downto 0) := "001000";
  constant OP_JALR   : std_logic_vector (5 downto 0) := "000000";
  constant OP_LB     : std_logic_vector (5 downto 0) := "100000";
  constant OP_LBU    : std_logic_vector (5 downto 0) := "100100";
  constant OP_LH     : std_logic_vector (5 downto 0) := "100001";
  constant OP_LHU    : std_logic_vector (5 downto 0) := "100101";
  constant OP_LW     : std_logic_vector (5 downto 0) := "100011";
  constant OP_SB     : std_logic_vector (5 downto 0) := "101000";
  constant OP_SH     : std_logic_vector (5 downto 0) := "101001";
  constant OP_SW     : std_logic_vector (5 downto 0) := "101011";
  constant OP_SLL    : std_logic_vector (5 downto 0) := "000000";
  constant OP_SRL    : std_logic_vector (5 downto 0) := "000000";
  constant OP_SRA    : std_logic_vector (5 downto 0) := "000000";
  constant OP_SLLV   : std_logic_vector (5 downto 0) := "000000";
  constant OP_SRLV   : std_logic_vector (5 downto 0) := "000000";
  constant OP_SRAV   : std_logic_vector (5 downto 0) := "000000";
  constant OP_LUI    : std_logic_vector (5 downto 0) := "001111";


  --FUNCTION CODES
  constant FUNC_MUL  : std_logic_vector (5 downto 0) := "111111";
  constant FUNC_ADD  : std_logic_vector (5 downto 0) := "100000";
  constant FUNC_ADDU : std_logic_vector (5 downto 0) := "100001";
  constant FUNC_SUB  : std_logic_vector (5 downto 0) := "100010";
  constant FUNC_SUBU : std_logic_vector (5 downto 0) := "100011";
  constant FUNC_OR   : std_logic_vector (5 downto 0) := "100101";
  constant FUNC_AND  : std_logic_vector (5 downto 0) := "001101";
  constant FUNC_XOR  : std_logic_vector (5 downto 0) := "100110";
  constant FUNC_NOR  : std_logic_vector (5 downto 0) := "100111";
  constant FUNC_SLT  : std_logic_vector (5 downto 0) := "101010";
  constant FUNC_SLTU : std_logic_vector (5 downto 0) := "101001";
  constant FUNC_JALR : std_logic_vector (5 downto 0) := "001001";
  constant FUNC_SLL  : std_logic_vector (5 downto 0) := "000000";
  constant FUNC_SRL  : std_logic_vector (5 downto 0) := "000010";
  constant FUNC_SRA  : std_logic_vector (5 downto 0) := "000011";
  constant FUNC_SLLV : std_logic_vector (5 downto 0) := "000100";
  constant FUNC_SRLV : std_logic_vector (5 downto 0) := "000110";
  constant FUNC_SRAV : std_logic_vector (5 downto 0) := "000111";

  --BRANCH CODES
  constant BRANCH_BLTZ   : std_logic_vector (5 downto 0) := "000000";
  constant BRANCH_BGEZ   : std_logic_vector (5 downto 0) := "000001";
  constant BRANCH_BLTZAL : std_logic_vector (5 downto 0) := "010000";
  constant BRANCH_BGEZAL : std_logic_vector (5 downto 0) := "010001";


  type rom_array is array (63 downto 0) of std_logic_vector(21 downto 0);  

--signal dummy : integer := 61;
--R Type ROM
  signal rom_r : rom_array := (
    to_integer(unsigned(FUNC_JALR)) => "10100000------10001100",
    others                          => "10" & a_funct & "-------00000000"
    );

--Branch Type ROM
  signal rom_b : rom_array := (
    to_integer(unsigned(BRANCH_BLTZ))   => "00100010010---11----10",
    to_integer(unsigned(BRANCH_BGEZ))   => "00100010011---11----10",
    to_integer(unsigned(BRANCH_BLTZAL)) => "10100010010---11111110",
    to_integer(unsigned(BRANCH_BGEZAL)) => "10100010011---11111110"
    );

--All other instructions ROM
  signal rom_o : rom_array := (
    to_integer(unsigned(OP_ADDI))  => "10100000------00010001",
    to_integer(unsigned(OP_ADDIU)) => "10100001------00010001",
    to_integer(unsigned(OP_ORI))   => "10100101------00010001",
    to_integer(unsigned(OP_ANDI))  => "10001101------00010001",
    to_integer(unsigned(OP_XORI))  => "10100110------00010001",
    to_integer(unsigned(OP_SLTI))  => "10101010------00010001",
    to_integer(unsigned(OP_SLTIU)) => "10101001------00010001",
    to_integer(unsigned(OP_J))     => "00------------01------",
    to_integer(unsigned(OP_JAL))   => "10------------01101100",
    to_integer(unsigned(OP_JR))    => "00------------10-----0",
    to_integer(unsigned(OP_JALR))  => "10100000------10001100",
    to_integer(unsigned(OP_LB))    => "10100000---10100010101",
    to_integer(unsigned(OP_LBU))   => "10100000---10000010101",
    to_integer(unsigned(OP_LH))    => "10100000---01100010101",
    to_integer(unsigned(OP_LHU))   => "10100000---01000010101",
    to_integer(unsigned(OP_LW))    => "10100000---00100010101",
    to_integer(unsigned(OP_SB))    => "01100000---10-00----01",
    to_integer(unsigned(OP_SH))    => "01100000---01-00----01",
    to_integer(unsigned(OP_SW))    => "01100000---00-00----01",
    to_integer(unsigned(OP_LUI))   => "10------------000110-1"
    );

  signal controlVector : std_logic_vector(21 downto 0);

begin

  with a_op select controlVector <=
    rom_r(to_integer(unsigned(a_funct)))    when "000000",
    rom_b(to_integer(unsigned('0' & a_rt))) when "000001",
    rom_o(to_integer(unsigned(opcode)))     when others;

  (
    o_RegWriteEnable,
    o_MemWriteEnable,
    o_ALUFuntion(0),
    o_ALUFuntion(1),
    o_ALUFuntion(2),
    o_ALUFuntion(3),
    o_ALUFuntion(4),
    o_ALUFuntion(5),
    o_BranchType(0),
    o_BranchType(1),
    o_BranchType(2),
    o_MemDataLength(0),
    o_MemDataLength(1),
    o_MemDataSigned,
    o_NextPCSource(0),
    o_NextPCSource(1),
    o_RegWriteAddrSource(0),
    o_RegWriteAddrSource(1),
    o_RegWriteDataSource(0),
    o_RegWriteDataSource(1),
    o_ReadAddrSource,
    o_ALUInputBSource
    )
    <= controlVector;



end rom;
