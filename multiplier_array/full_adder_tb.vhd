library ieee;
use ieee.std_logic_1164.all;

entity full_adder_tb is
  
end entity full_adder_tb;

architecture behavioral of full_adder_tb is

  signal s_A, s_B, s_Cin : std_logic := '0';  -- inputs
  signal s_S, s_Cout : std_logic;       -- outputs

  component full_adder is
    port (i_A, i_B, i_Cin : in  std_logic;
          o_S, o_Cout    : out std_logic);
  end component;
  
begin  -- architecture behavioral

  DUT: full_adder
    port map (
      i_A   => s_A,
      i_B   => s_B,
      i_Cin => s_Cin,
      o_Cout => s_Cout,
      o_S   => s_S);
  
  
-- purpose: test bench for full_adder component
testbench: process is
begin  -- process testbench
  s_A <= '0';
  s_B <= '1';
  s_Cin <= '0';
  wait for 10 ns;
  s_A <= '1';
  s_B <= '0';
  s_Cin <= '1';
  wait for 10 ns;
  s_A <= '1';
  s_B <= '1';
  s_Cin <= '1';
  wait for 10 ns;
  wait;
end process testbench;


end architecture behavioral;
