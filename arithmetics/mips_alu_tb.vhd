-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips_alu_tb is
end entity mips_alu_tb;
-------------------------------------------------------------------------------
architecture behavioral of mips_alu_tb is

  component mips_alu is
  port (
    i_A           : in  std_logic_vector (31 downto 0);
    i_B           : in  std_logic_vector (31 downto 0);
    o_R           : out std_logic_vector (31 downto 0);
    i_ShiftAmount : in  std_logic_vector (4 downto 0);
    i_Function    : in std_logic_vector (3 downto 0);
    o_ZeroFlag    : out std_logic);
  end component;
  
  signal s_A, s_B, s_R : std_logic_vector (31 downto 0);
  signal s_ShiftAmount : std_logic_vector (4 downto 0);
  signal s_Function : std_logic_vector (3 downto 0);
  signal s_ZeroFlag : std_logic;
  
begin  -- architecture behavioral

  DUT: mips_alu
    port map (
      i_A           => s_A,
      i_B           => s_B,
      o_R           => s_R,
      i_ShiftAmount => s_ShiftAmount,
      i_Function    => s_Function,
      o_ZeroFlag    => s_ZeroFlag);


  -- purpose: tests component mips_alu
  testbench: process is
  begin  -- process testbench

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_ShiftAmount <= "00000";
    s_Function <= "1000";
    wait for 10 ns;
    
    wait;
    
  end process testbench;
  

end architecture behavioral;
-------------------------------------------------------------------------------
