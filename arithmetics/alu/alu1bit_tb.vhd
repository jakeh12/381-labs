-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity alu1bit_tb is
end entity alu1bit_tb;
-------------------------------------------------------------------------------
architecture behavioral of alu1bit_tb is

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

  signal s_A, s_B, s_CarryIn, s_InvertA, s_InvertB, s_Less, s_PassCarryIn, s_Set, s_CarryOut, s_Result : std_logic;
  signal s_Operation : std_logic_vector (1 downto 0);

begin  -- architecture behavioral

  DUT: alu1bit
    port map (
      i_A           => s_A,
      i_B           => s_B,
      i_CarryIn     => s_CarryIn,
      i_InvertA     => s_InvertA,
      i_InvertB     => s_InvertB,
      i_Less        => s_Less,
      i_PassCarryIn => s_PassCarryIn,
      i_Operation   => s_Operation,
      o_Set         => s_Set,
      o_CarryOut    => s_CarryOut,
      o_Result      => s_Result);

  -- purpose: tests component alu1bit
  testbench: process is
  begin  -- process testbench

    -- all signals zero -> AND
    s_A <= '0';
    s_B <= '0';
    s_CarryIn <= '0';
    s_InvertA <= '0';
    s_InvertB <= '0';
    s_Less <= '0';
    s_PassCarryIn <= '0';
    s_Operation <= "00";
    wait for 10 ns;
    assert s_Set= '0' and s_Result = '0' report "test failed" severity error;

    -- 1 and 1
    s_A <= '0';
    s_B <= '0';
    s_CarryIn <= '1';
    s_InvertA <= '1';
    s_InvertB <= '1';
    s_Less <= '0';
    s_PassCarryIn <= '0';
    s_Operation <= "00";
    wait for 10 ns;
    assert s_Set= '0' and s_Result = '1' report "test failed" severity error;

    -- 1 and 0
    s_A <= '1';
    s_B <= '0';
    s_CarryIn <= '1';
    s_InvertA <= '0';
    s_InvertB <= '0';
    s_Less <= '0';
    s_PassCarryIn <= '0';
    s_Operation <= "00";
    wait for 10 ns;
    assert s_Set= '1' and s_Result = '0' report "test failed" severity error;

    -- 1 or 0
    s_A <= '1';
    s_B <= '0';
    s_CarryIn <= '1';
    s_InvertA <= '0';
    s_InvertB <= '0';
    s_Less <= '0';
    s_PassCarryIn <= '0';
    s_Operation <= "01";
    wait for 10 ns;
    assert s_Set = '1' and s_Result = '1' report "test failed: 0 and 0" severity error;


    
    -- 1 plus 1
    s_A <= '1';
    s_B <= '1';
    s_CarryIn <= '0';
    s_InvertA <= '0';
    s_InvertB <= '0';
    s_Less <= '0';
    s_PassCarryIn <= '1';
    s_Operation <= "10";
    wait for 10 ns;
    assert s_Set = '0' and s_Result = '0' report "test failed: 0 and 0" severity error;


    -- 1 plus 1 + 1 carry
    s_A <= '1';
    s_B <= '1';
    s_CarryIn <= '1';
    s_InvertA <= '0';
    s_InvertB <= '0';
    s_Less <= '0';
    s_PassCarryIn <= '1';
    s_Operation <= "10";
    wait for 10 ns;
    assert s_Set = '1' and s_Result = '1' report "test failed: 0 and 0" severity error;

    

    
    wait;
    
  end process testbench;

end architecture behavioral;
-------------------------------------------------------------------------------
