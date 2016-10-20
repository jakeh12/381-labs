-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity alu1bit is
  
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

end entity alu1bit;
-------------------------------------------------------------------------------
architecture dataflow of alu1bit is

  signal s_InvertedA : std_logic;
  signal s_InvertedB : std_logic;

  signal s_MuxedA       : std_logic;
  signal s_MuxedB       : std_logic;
  signal s_MuxedCarryIn : std_logic;

  signal s_Anded : std_logic;
  signal s_Ored  : std_logic;
  signal s_Added : std_logic;
  
begin  -- architecture dataflow

  -- invert A and B
  s_InvertedA <= not i_A;
  s_InvertedB <= not i_B;

  -- mux non-inverted and inverted A and B
  s_MuxedA <= i_A when i_InvertA = '0' else s_InvertedA;
  s_MuxedB <= i_B when i_InvertB = '0' else s_InvertedB;

  -- mux carry in (pass or force zero)
  s_MuxedCarryIn <= '0' when i_PassCarryIn = '0' else i_CarryIn;

  -- assign operands to functions
  s_Anded <= s_MuxedA and s_MuxedB;
  s_Ored  <= s_MuxedA or s_MuxedB;
  s_Added <= s_MuxedA xor s_MuxedB xor s_MuxedCarryIn;

  -- calculate carry out
  o_CarryOut <= (s_MuxedA and s_MuxedB) or (s_MuxedCarryIn and (s_MuxedA xor s_MuxedB));

  -- set signal corresponds to addition result
  o_Set <= s_Added;

  -- final Mux
  with i_Operation select o_Result <=
    s_Anded when "00",
    s_Ored  when "01",
    s_Added when "10",
    i_Less  when "11",
    '0'     when others;                -- should never happen

end architecture dataflow;
-------------------------------------------------------------------------------
