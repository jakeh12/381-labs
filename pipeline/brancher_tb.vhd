-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity brancher_tb is
  
end brancher_tb;
-------------------------------------------------------------------------------
architecture behavioral of brancher_tb is


  component brancher
    port (
      i_A, i_B         : in  std_logic_vector (31 downto 0);
      i_BranchType     : in  std_logic_vector (2 downto 0);
      o_BranchDecision : out std_logic);
  end component;

  signal s_A, s_B : std_logic_vector (31 downto 0);
  signal s_BranchType : std_logic_vector (2 downto 0);
  signal s_BranchDecision : std_logic;
  
begin  -- behavioral


  process
  begin  -- process

    i_A <= X"00000000";
    i_B <= X"00000000";
    i_BranchType <= "000";
    wait for 10 ns;
    wait;
  end process;
  

end behavioral;
