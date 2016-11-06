library ieee;
use ieee.std_logic_1164.all;

entity n_shifter_tb is
  
end entity n_shifter_tb;

architecture behavioral of n_shifter_tb is

    component n_shifter is
      generic (
       n : natural := 0);
     port (
       i_A  : in  std_logic_vector (31 downto 0);
       i_In : in  std_logic;
       i_Sel: in std_logic;
       o_F  : out std_logic_vector (31 downto 0));
  end component;

    signal s_A, s_F : std_logic_vector(31 downto 0);
    signal s_In, s_Sel : std_logic;

    
begin  -- architecture behavioral

  DUT: n_shifter
    port map (
      i_A   => s_A,
      i_In  => s_In,
      i_Sel => s_Sel,
      o_F   => s_F);

  testbench: process is
  begin  -- process testbench

    s_A <= X"BFFFFFFF";
    s_In <= '0';
    s_Sel <= '0';
    wait for 10 ns;

    s_A <= X"BFFFFFFF";
    s_In <= '0';
    s_Sel <= '1';
    wait for 10 ns;

    s_A <= X"BFFFFFFF";
    s_In <= '1';
    s_Sel <= '1';
    wait for 10 ns;
    wait;
  end process testbench;
  

end architecture behavioral;
