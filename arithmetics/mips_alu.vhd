-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips_alu is
  port (
    i_A           : in  std_logic_vector (31 downto 0);
    i_B           : in  std_logic_vector (31 downto 0);
    o_R           : out std_logic_vector (31 downto 0);
    i_ShiftAmount : in  std_logic_vector (4 downto 0);
    i_Function    : in std_logic_vector (3 downto 0);
    o_ZeroFlag    : out std_logic);
end entity mips_alu;
-------------------------------------------------------------------------------
architecture structural of mips_alu is

  
  component alu32bit is
    port (
      i_A                : in  std_logic_vector (31 downto 0);
      i_B                : in  std_logic_vector (31 downto 0);
      o_Result           : out std_logic_vector (31 downto 0);
      o_CarryOut         : out std_logic;
      o_SignedOverflow   : out std_logic;
      o_UnsignedOverflow : out std_logic;
      i_isUnsignedSet    : in  std_logic;
      i_CarryIn          : in  std_logic;
      i_Operation        : in  std_logic_vector (1 downto 0);
      i_PassCarryIn      : in  std_logic;
      i_InvertA          : in  std_logic;
      i_InvertB          : in  std_logic;
      o_ZeroFlag         : out std_logic);
  end component;

  signal s_isUnsignedSet, s_CarryIn, s_PassCarryIn, s_InvertA, s_InvertB : std_logic;
  signal s_Operation : std_logic_vector (1 downto 0);
  

  component mips_shifter is
      port (
       i_A      : in  std_logic_vector (31 downto 0);
       i_ShAmt  : in  std_logic_vector (4 downto 0);
       i_ShDir  : in  std_logic;
       i_ShType : in  std_logic;
       o_F      : out std_logic_vector(31 downto 0));
  end component;

  signal s_ShiftDirection : std_logic;
  signal s_ShiftType : std_logic;
  
  component mips_multiplier is
    port (
      i_A : in  std_logic_vector (31 downto 0);  -- multiplicant                                                                                            
      i_B : in  std_logic_vector (31 downto 0);  -- multiplier                                                                                              
      o_P : out std_logic_vector (31 downto 0));  -- product                                                                                                 
  end component;



  --FUNCTION CODES
  constant FUNC_ADD  : std_logic_vector (3 downto 0) := "0000";
  constant FUNC_ADDU : std_logic_vector (3 downto 0) := "0001";
  constant FUNC_SUB  : std_logic_vector (3 downto 0) := "0010";
  constant FUNC_SUBU : std_logic_vector (3 downto 0) := "0011";
  constant FUNC_OR   : std_logic_vector (3 downto 0) := "0100";
  constant FUNC_AND  : std_logic_vector (3 downto 0) := "0101";
  constant FUNC_XOR  : std_logic_vector (3 downto 0) := "0110";
  constant FUNC_NOR  : std_logic_vector (3 downto 0) := "0111";
  constant FUNC_SLT  : std_logic_vector (3 downto 0) := "1000";
  constant FUNC_SLTU : std_logic_vector (3 downto 0) := "1001";
  constant FUNC_MUL  : std_logic_vector (3 downto 0) := "1010";
  constant FUNC_SLL  : std_logic_vector (3 downto 0) := "1011";
  constant FUNC_SRL  : std_logic_vector (3 downto 0) := "1100";
  constant FUNC_SRA  : std_logic_vector (3 downto 0) := "1101";


  signal s_ResultALU : std_logic_vector (31 downto 0);
  signal s_ResultMultiplier: std_logic_vector (31 downto 0);
  signal s_ResultShifter : std_logic_vector (31 downto 0);
  
  
begin  -- architecture structural

  alu: alu32bit
    port map (
      i_A                => i_A,
      i_B                => i_B,
      o_Result           => s_ResultALU,
      o_CarryOut         => open,
      o_SignedOverflow   => open,
      o_UnsignedOverflow => open,
      i_isUnsignedSet    => s_isUnsignedSet,
      i_CarryIn          => s_CarryIn,
      i_Operation        => s_Operation,
      i_PassCarryIn      => s_PassCarryIn,
      i_InvertA          => s_InvertA,
      i_InvertB          => s_InvertB,
      o_ZeroFlag         => o_ZeroFlag);


  shifter: mips_shifter
    port map (
      i_A      => i_B,
      i_Shamt  => i_ShiftAmount,
      i_Shdir  => s_ShiftDirection,
      i_Shtype => s_ShiftType,
      o_F      => s_ResultShifter);

  
  multiplier: mips_multiplier
    port map (
      i_A => i_A,
      i_B => i_B,
      o_P => s_ResultMultiplier);

  

  with i_Function select
    o_R <=
    s_ResultALU when FUNC_ADD | FUNC_ADDU | FUNC_SUB | FUNC_SUBU | FUNC_OR | FUNC_AND | FUNC_XOR | FUNC_NOR | FUNC_SLT | FUNC_SLTU,
    s_ResultMultiplier when FUNC_MUL,
    s_ResultShifter when FUNC_SLL | FUNC_SRL | FUNC_SRA,
    X"00000000" when others;

  
  with i_Function select
    s_isUnsignedSet <=
    '1' when FUNC_SLTU,
    '0' when others;

  with i_Function select
    s_CarryIn <=
    '1' when FUNC_SUB | FUNC_SUBU | FUNC_SLT | FUNC_SLTU,
    '0' when others;

  with i_Function select
    s_Operation <=
    "00" when FUNC_AND | FUNC_NOR,
    "01" when FUNC_OR,
    "10" when FUNC_ADD | FUNC_ADDU | FUNC_SUB | FUNC_SUBU | FUNC_XOR,
    "11" when FUNC_SLT | FUNC_SLTU,
    "00" when others;

  with i_Function select
    s_PassCarryIn <=
    '0' when FUNC_XOR,
    '1' when others;

  with i_Function select
    s_InvertA <=
    '1' when FUNC_NOR,
    '0' when others;

  with i_Function select
    s_InvertB <=
    '1' when FUNC_SUB | FUNC_SUBU | FUNC_NOR | FUNC_SLT | FUNC_SLTU,
    '0' when others;

  
  with i_Function select
    s_ShiftDirection <=
    '1' when FUNC_SRL | FUNC_SRA,
    '0' when others;


  with i_Function select
    s_ShiftType <=
    '1' when FUNC_SRA,
    '0' when others;
  
  
end architecture structural;
-------------------------------------------------------------------------------
