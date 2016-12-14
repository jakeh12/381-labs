-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity pipe_tb is
end entity pipe_tb;
-------------------------------------------------------------------------------
architecture behavioral of pipe_tb is

  signal s_clk : std_logic := '1';
  signal s_rst : std_logic := '0';


  component pipe is
    generic(
     PROGRAM_FILE      : string    := "testing/r_test.mif";
     BRANCH_DELAY_SLOT : std_logic := '1');
    port (
      i_clk : in std_logic;
      i_rst : in std_logic);
  end component pipe;
  
begin  -- architecture behavioral


  DUT: pipe
    generic map (
      PROGRAM_FILE => "testing/baby.mif",  -- INPUT TEST PROGRAM HERE
      BRANCH_DELAY_SLOT => '0')
    port map (
      i_clk => s_clk,
      i_rst => s_rst);

  clock: process is
  begin  -- process clock
    s_clk <= '1';
    wait for 5 ns;
    s_clk <= '0';
    wait for 5 ns;
  end process clock;

  testbench: process is
  begin  -- process testbench
    s_rst <= '1';
    wait for 11 ns;
    s_rst <= '0';
    wait for 1000 ns;
    wait;
  end process testbench;

end architecture behavioral;
-------------------------------------------------------------------------------
