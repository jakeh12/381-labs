-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity twos_complementer_nbit_tb is
end entity twos_complementer_nbit_tb;
-------------------------------------------------------------------------------
architecture mixed of twos_complementer_nbit_tb is

  component twos_complementer_nbit is
    generic (n : natural := 32);
    port (i_A : in  std_logic_vector (n-1 downto 0);
          o_F : out std_logic_vector (n-1 downto 0));
  end component;


  signal s_A, s_F : std_logic_vector (31 downto 0);  -- input

begin

  DUT: twos_complementer_nbit
    port map (
      i_A => s_A,
      o_F => s_F);

  -- purpose: testing component twos_complementer_nbit
  -- type   : combinational
  -- inputs : 
  -- outputs: 
  testbench: process is
  begin  -- process testbench
    s_A <= X"00000000";
    wait for 10 ns;
    s_A <= X"11111111";
    wait for 10 ns;
    s_A <= X"00000001";
    wait for 10 ns;
    s_A <= X"FFFFFFFF";
    wait for 10 ns;
    s_A <= X"FFFFFFFE";
  end process testbench;

end architecture mixed;
-------------------------------------------------------------------------------
