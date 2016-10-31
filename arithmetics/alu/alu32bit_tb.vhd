-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity alu32bit_tb is
end entity alu32bit_tb;
-------------------------------------------------------------------------------
architecture behavioral of alu32bit_tb is

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

  signal s_A, s_B, s_Result : std_logic_vector (31 downto 0);
  signal s_Operation : std_logic_vector (1 downto 0);
  signal s_isUnsignedSet, s_CarryOut, s_SignedOverflow, s_UnsignedOverflow, s_CarryIn, s_PassCarryIn, s_InvertA, s_InvertB, s_ZeroFlag : std_logic;
 
begin  -- architecture behavioral

  DUT: alu32bit
    port map (
      i_A                => s_A,
      i_B                => s_B,
      o_Result           => s_Result,
      o_CarryOut         => s_CarryOut,
      o_SignedOverflow   => s_SignedOverflow,
      o_UnsignedOverflow => s_UnsignedOverflow,
      i_isUnsignedSet    => s_isUnsignedSet,
      i_CarryIn          => s_CarryIn,
      i_Operation        => s_Operation,
      i_PassCarryIn      => s_PassCarryIn,
      i_InvertA          => s_InvertA,
      i_InvertB          => s_InvertB,
      o_ZeroFlag         => s_ZeroFlag);
  

  -- purpose: tests component alu32bit
  testbench: process is
  begin  -- process testbench

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_CarryIn <= '0';
    s_Operation <= "10";
    s_PassCarryIn <= '1';
    s_InvertA <= '0';
    s_InvertB <= '0';
    s_isUnsignedSet <= '0';
    wait for 10 ns;

    s_A <= X"00000000";
    s_B <= X"00000001";
    s_CarryIn <= '0';
    s_Operation <= "10";
    s_PassCarryIn <= '1';
    s_InvertA <= '0';
    s_InvertB <= '0';
    s_isUnsignedSet <= '0';
    wait for 10 ns;

    s_A <= X"00000000";
    s_B <= X"00000001";
    s_CarryIn <= '1';
    s_Operation <= "10";
    s_PassCarryIn <= '1';
    s_InvertA <= '0';
    s_InvertB <= '0';
    s_isUnsignedSet <= '0';
    wait for 10 ns;
    
    s_A <= X"00000010";
    s_B <= X"80000100";
    s_CarryIn <= '1';
    s_Operation <= "11";
    s_PassCarryIn <= '1';
    s_InvertA <= '0';
    s_InvertB <= '1';
    s_isUnsignedSet <= '1';
    wait for 10 ns;

    wait;
  end process testbench;
end architecture behavioral;
-------------------------------------------------------------------------------
