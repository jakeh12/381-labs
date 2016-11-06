-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips_tb is
end entity mips_tb;
-------------------------------------------------------------------------------
architecture behavioral of mips_tb is

  signal s_clk : std_logic := '1';
  signal s_rst : std_logic := '0';


  component mips is
    generic(
      program_file : string := "prog.mif");
    port (
      i_clk : in std_logic;
      i_rst : in std_logic);
  end component mips;
  
begin  -- architecture behavioral


  DUT: mips
    generic map (
      program_file => "testing/r_test.mif")
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
    wait for 20 ns;
    s_rst <= '0';
    wait for 1000 ns;
    wait;
  end process testbench;

end architecture behavioral;
-------------------------------------------------------------------------------
