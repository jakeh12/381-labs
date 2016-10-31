-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity alu32bit is
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
end entity alu32bit;
-------------------------------------------------------------------------------
architecture structural of alu32bit is

  component alu1bit is
    port (
      i_A           : in  std_logic;
      i_B           : in  std_logic;
      i_CarryIn     : in  std_logic;
      i_InvertA     : in  std_logic;
      i_InvertB     : in  std_logic;
      i_Less        : in  std_logic;
      i_PassCarryIn : in  std_logic;
      i_Operation   : in  std_logic_vector (1 downto 0);
      o_Set         : out std_logic;
      o_CarryOut    : out std_logic;
      o_Result      : out std_logic);
  end component alu1bit;

  signal s_Result : std_logic_vector (31 downto 0);
  signal s_CarryChain : std_logic_vector (31 downto 0);
  signal s_Set, s_MuxedSet        : std_logic;
  signal s_ZeroFlagTemp : std_logic;

begin  -- architecture structural

  ali1bit_lsb : alu1bit
    port map (
      i_A           => i_A(0),
      i_B           => i_B(0),
      i_CarryIn     => i_CarryIn,
      i_InvertA     => i_InvertA,
      i_InvertB     => i_InvertB,
      i_Less        => s_MuxedSet,
      i_PassCarryIn => i_PassCarryIn,
      i_Operation   => i_Operation,
      o_Set         => open,
      o_CarryOut    => s_CarryChain(0),
      o_Result      => s_Result(0));


  alu1bit_intermediate : for i in 1 to 30 generate
    
    ali1bit_i : alu1bit
      port map (
        i_A           => i_A(i),
        i_B           => i_B(i),
        i_CarryIn     => s_CarryChain(i-1),
        i_InvertA     => i_InvertA,
        i_InvertB     => i_InvertB,
        i_Less        => '0',
        i_PassCarryIn => i_PassCarryIn,
        i_Operation   => i_Operation,
        o_Set         => open,
        o_CarryOut    => s_CarryChain(i),
        o_Result      => s_Result(i));

  end generate alu1bit_intermediate;



  ali1bit_msb : alu1bit
    port map (
      i_A           => i_A(31),
      i_B           => i_B(31),
      i_CarryIn     => s_CarryChain(30),
      i_InvertA     => i_InvertA,
      i_InvertB     => i_InvertB,
      i_Less        => '0',
      i_PassCarryIn => i_PassCarryIn,
      i_Operation   => i_Operation,
      o_Set         => s_Set,
      o_CarryOut    => s_CarryChain(31),
      o_Result      => s_Result(31));

  s_MuxedSet <= (not s_CarryChain(31)) when i_isUnsignedSet = '1' else s_Set;
  
  o_CarryOut <= s_CarryChain(31);
  
  o_Result <= s_Result;
  
  o_SignedOverflow   <= s_CarryChain(30) xor s_CarryChain(31);
  o_UnsignedOverflow <= s_CarryChain(31);
  
  o_ZeroFlag <= '1' when s_Result = X"00000000" else '0';
  
end architecture structural;
-------------------------------------------------------------------------------
