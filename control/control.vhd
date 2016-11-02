-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips_control is

  port (
    i_instruction 	: in std_logic_vector (31 downto 0);  -- instruction from the memory
    o_RdIsDest      	: out std_logic;      -- COMMENT ME
    o_Link        	: out std_logic;      --
    o_RtIsForceZero 	: out std_logic;      --
    o_RegWrite     	: out std_logic;      --
    o_ImmToAluB    	: out std_logic;      --
    o_AluOp       	: out std_logic_vector (2 downto 0);   --
    o_MemWrite    	: out std_logic;      --
    o_MemSigned      	: out std_logic;      --
    o_MemDataSize    	: out std_logic;      --
    o_ShamSrc		: out std_logic;      --
    o_RegWriteFromMem 	: out std_logic;      --
    o_BranchOp 		: out std_logic_vector (1 downto 0);   --
    o_JumpReg		: out std_logic;      --
    o_Jump 		: out std_logic;      --
    o_BranchEnable	: out std_logic	      --
    );

end entity mips_control;
-------------------------------------------------------------------------------
architecture rom of mips_control is

  type rom_t is std_logic_vector(20 downto 0); --the size of all output bits

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
  constant OP_MUL 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_ADD 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_ADDU 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SUB 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SUBU 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_ADDI 	: std_logic_vector (5 downto 0) := "001100";
  constant OP_ADDIU 	: std_logic_vector (5 downto 0) := "001001";
  constant OP_OR 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_ORI 	: std_logic_vector (5 downto 0) := "001101";
  constant OP_AND 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_ANDI 	: std_logic_vector (5 downto 0) := "001100";
  constant OP_XOR 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_XORI 	: std_logic_vector (5 downto 0) := "001110";
  constant OP_NOR 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SLT 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SLTU 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SLTI 	: std_logic_vector (5 downto 0) := "001010";
  constant OP_SLTIU 	: std_logic_vector (5 downto 0) := "001011";
  constant OP_BEQ 	: std_logic_vector (5 downto 0) := "000100";
  constant OP_BNE 	: std_logic_vector (5 downto 0) := "000101";
  constant OP_BLTZ 	: std_logic_vector (5 downto 0) := "000001";
  constant OP_BGEZ 	: std_logic_vector (5 downto 0) := "000001";
  constant OP_BLTZAL 	: std_logic_vector (5 downto 0) := "000001";
  constant OP_BGEZAL 	: std_logic_vector (5 downto 0) := "000001";
  constant OP_BLEZ 	: std_logic_vector (5 downto 0) := "000110";
  constant OP_BGTZ 	: std_logic_vector (5 downto 0) := "000111";
  constant OP_J 	: std_logic_vector (5 downto 0) := "000010";
  constant OP_JAL 	: std_logic_vector (5 downto 0) := "000011";
  constant OP_JR 	: std_logic_vector (5 downto 0) := "001000";
  constant OP_JALR 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_LB 	: std_logic_vector (5 downto 0) := "100000";
  constant OP_LBU 	: std_logic_vector (5 downto 0) := "100100";
  constant OP_LH 	: std_logic_vector (5 downto 0) := "100001";
  constant OP_LHU 	: std_logic_vector (5 downto 0) := "100101";
  constant OP_LW 	: std_logic_vector (5 downto 0) := "100011";
  constant OP_SB 	: std_logic_vector (5 downto 0) := "101000";
  constant OP_SH 	: std_logic_vector (5 downto 0) := "101001";
  constant OP_SW 	: std_logic_vector (5 downto 0) := "101011";
  constant OP_SLL 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SRL 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SRA 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SLLV 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SRLV 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_SRAV 	: std_logic_vector (5 downto 0) := "000000";
  constant OP_LUI 	: std_logic_vector (5 downto 0) := "001111";


  --FUNCTION CODES
  constant FUNC_MUL  	: std_logic_vector (5 downto 0) := "111111";
  constant FUNC_ADD 	: std_logic_vector (5 downto 0) := "100000";
  constant FUNC_ADDU 	: std_logic_vector (5 downto 0) := "100001";
  constant FUNC_SUB 	: std_logic_vector (5 downto 0) := "100010";
  constant FUNC_SUBU 	: std_logic_vector (5 downto 0) := "100011";
  constant FUNC_OR	: std_logic_vector (5 downto 0) := "100101";
  constant FUNC_AND 	: std_logic_vector (5 downto 0) := "001101";
  constant FUNC_XOR 	: std_logic_vector (5 downto 0) := "100110";
  constant FUNC_NOR 	: std_logic_vector (5 downto 0) := "100111";
  constant FUNC_SLT 	: std_logic_vector (5 downto 0) := "101010";
  constant FUNC_SLTU 	: std_logic_vector (5 downto 0) := "101001";
  constant FUNC_JALR 	: std_logic_vector (5 downto 0) := "001001";
  constant FUNC_SLL 	: std_logic_vector (5 downto 0) := "000000";
  constant FUNC_SRL 	: std_logic_vector (5 downto 0) := "000010";
  constant FUNC_SRA 	: std_logic_vector (5 downto 0) := "000011";
  constant FUNC_SLLV 	: std_logic_vector (5 downto 0) := "000100";
  constant FUNC_SRLV 	: std_logic_vector (5 downto 0) := "000110";
  constant FUNC_SRAV 	: std_logic_vector (5 downto 0) := "000111";

  --BRANCH CODES
  constant BRANCH_BLTZ 	: std_logic_vector (5 downto 0) := "00000";
  constant BRANCH_BGEZ 	: std_logic_vector (5 downto 0) := "00001";
  constant BRANCH_BLTZAL : std_logic_vector (5 downto 0) := "10000";
  constant BRANCH_BGEZAL : std_logic_vector (5 downto 0) := "10001";

signal rom : rom_t := (

	OP_MUL		=> "10010----0---000---000",
	OP_ADD		=> "10010----0---000---000",
	OP_ADDU		=> "10010----0---000---000",
	OP_SUB		=> "10010----0---000---000",
	OP_SUBU		=> "10010----0---000---000",
	OP_ADDI		=> "0001100010---000---000",
	OP_ADDIU	=> "0001100100---000---000",
	OP_OR		=> "10010----0---000---000",
	OP_ORI		=> "0001100110---000---000",
	OP_AND 		=> "10010----0---000---000",
	OP_ANDI		=> "0001101000---000---000",
	OP_XOR		=> "10010----0---000---000",
	OP_XORI		=> "0001101010---000---000",
	OP_NOR		=> "10010----0---000---000",
	OP_SLT		=> "10010----0---000---000",
	OP_SLTU		=> "10010----0---000---000",
	OP_SLTI		=> "0001101100---000---000",
	OP_SLTIU	=> "0001101110---000---000",
	OP_BEQ		=> "00000----0---000001001",
	OP_BNE		=> "00000----0---000010001",
	OP_BLTZ		=> "00000----0---000000001",
	OP_BGEZ		=> "00100----0---000000001",
	OP_BLTZAL	=> "00100----0---000000001",
	OP_BGEZAL	=> "00100----0---000000001",
	OP_BLEZ		=> "00100----0---000011001",
	OP_BGTZ 	=> "00100----0---000100001",
	OP_J		=> "00000----0---000---000",
	OP_JAL		=> "11010----0---000---010",
	OP_JR		=> "00000----0---000---100",
	OP_JALR		=> "01010----0---000---100",
	OP_LB		=> "00010----0110001---000",
	OP_LBU		=> "00010----0010001---000",
	OP_LH		=> "00010----0101001---000",
	OP_LHU		=> "00010----0001001---000",
	OP_LW		=> "00010----0100001---000",
	OP_SB		=> "00010----1---000---000",
	OP_SH		=> "00010----1---000---000",
	OP_SW		=> "00010----1---000---000",
	OP_SLL		=> "10010----0---000---000",
	OP_SRL		=> "10010----0---000---000",
	OP_SRA		=> "10010----0---000---000",
	OP_SLLV		=> "10010----0---000---000",
	OP_SRLV		=> "10010----0---000---000",
	OP_SRAV		=> "10010----0---000---000",
	OP_LUI		=> "0001110000---110---000",
)

begin

   (o_RdIsDest,      
    o_Link,    
    o_RtIsForceZero,
    o_RegWrite,
    o_ImmToAluB,
    o_AluOp,
    o_MemWrite,
    o_MemSigned,
    o_MemDataSize,
    o_ShamSrc,
    o_RegWriteForce,
    o_BranchOp,
    o_JumpReg,
    o_Jump,
    o_BranchEnable)
    <= rom(i_opcode);

end rom;
