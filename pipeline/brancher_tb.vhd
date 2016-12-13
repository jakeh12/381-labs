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

  DUT: brancher
    port map (
      i_A              => s_A,
      i_B              => s_b,
      i_BranchType     => s_BranchType,
      o_BranchDecision => s_BranchDecision);

  process
  begin  -- process


    ---------------------------------------------------------------------------
    -- BEQ
    ---------------------------------------------------------------------------
    s_A <= X"A0000000";
    s_B <= X"A0000000";
    s_BranchType <= "000";
    wait for 10 ns;

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_BranchType <= "000";
    wait for 10 ns;

    s_A <= X"00000001";
    s_B <= X"00000002";
    s_BranchType <= "000";
    wait for 10 ns;


    
    ---------------------------------------------------------------------------
    -- BNE
    ---------------------------------------------------------------------------
    s_A <= X"A0000000";
    s_B <= X"A0000000";
    s_BranchType <= "001";
    wait for 10 ns;

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_BranchType <= "001";
    wait for 10 ns;

    s_A <= X"00000001";
    s_B <= X"00000002";
    s_BranchType <= "001";
    wait for 10 ns;
    

    
    ---------------------------------------------------------------------------
    -- BLTZ
    ---------------------------------------------------------------------------
    s_A <= X"A0000000";
    s_B <= X"A0000000";
    s_BranchType <= "010";
    wait for 10 ns;

    s_A <= X"10000000";
    s_B <= X"00000000";
    s_BranchType <= "010";
    wait for 10 ns;

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_BranchType <= "010";
    wait for 10 ns;


    ---------------------------------------------------------------------------
    -- BGEZ
    ---------------------------------------------------------------------------
    s_A <= X"A0000000";
    s_B <= X"A0000000";
    s_BranchType <= "011";
    wait for 10 ns;

    s_A <= X"10000000";
    s_B <= X"00000000";
    s_BranchType <= "011";
    wait for 10 ns;

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_BranchType <= "011";
    wait for 10 ns;


    ---------------------------------------------------------------------------
    -- BLEZ
    ---------------------------------------------------------------------------
    s_A <= X"A0000000";
    s_B <= X"A0000000";
    s_BranchType <= "100";
    wait for 10 ns;

    s_A <= X"10000000";
    s_B <= X"00000000";
    s_BranchType <= "100";
    wait for 10 ns;

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_BranchType <= "100";
    wait for 10 ns;


    ---------------------------------------------------------------------------
    -- BGTZ
    ---------------------------------------------------------------------------
    s_A <= X"A0000000";
    s_B <= X"A0000000";
    s_BranchType <= "101";
    wait for 10 ns;

    s_A <= X"10000000";
    s_B <= X"00000000";
    s_BranchType <= "101";
    wait for 10 ns;

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_BranchType <= "101";
    wait for 10 ns;


    wait;
  end process;
  

end behavioral;
