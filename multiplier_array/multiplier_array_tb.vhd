library ieee;
use ieee.std_logic_1164.all;

entity multiplier_array_tb is
  
end entity multiplier_array_tb;

architecture behavioral of multiplier_array_tb is

  signal s_M, s_Q : std_logic_vector (31 downto 0) := (others => '0');  -- multiplicant and multiplier
  signal s_P : std_logic_vector (63 downto 0);  -- product

  component multiplier_array is
    generic (n : natural := 32);
    port (i_A, i_B : in  std_logic_vector (n-1 downto 0);
          o_P     : out std_logic_vector (2*n-1 downto 0));
  end component;

    
begin  -- architecture behavioral

  DUT: multiplier_array
    port map (
      i_A => s_M,
      i_B => s_Q,
      o_P => s_P);

  -- purpose: test bench for component multiplier_array
  test_bench: process is
  begin  -- process test_bench
    s_M <= (others => '1');
    s_Q <= (others => '1');
    wait for 10 ns;
    wait;
  end process test_bench;
  

end architecture behavioral;
