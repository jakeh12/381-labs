library ieee;
use ieee.std_logic_1164.all;

entity mips_shifter_tb is
  
end entity mips_shifter_tb;

architecture behavioral of mips_shifter_tb is

   component mips_shifter is
      port (
       i_A      : in  std_logic_vector (31 downto 0);
       i_ShAmt  : in  std_logic_vector (4 downto 0);
       i_ShDir  : in  std_logic;
       i_ShType : in  std_logic;
       o_F      : out std_logic_vector(31 downto 0));
  end component;

   signal s_A, s_F : std_logic_vector (31 downto 0);
   signal s_ShAmt : std_logic_vector (4 downto 0);
   signal s_ShDir, s_ShType : std_logic;
   
begin  -- architecture behavioral


  DUT: mips_shifter
    port map (
      i_A      => s_A,
      i_Shamt  => s_Shamt,
      i_Shdir  => s_Shdir,
      i_Shtype => s_Shtype,
      o_F      => s_F);

  testbench: process is
  begin  -- process testbench

    s_A <= X"FFFFFFFF";
    s_Shamt <= "00000";
    s_Shdir <= '0';
    s_Shtype <= '0';
    wait for 10 ns;



    s_A <= X"FFFFFFFF";
    s_Shamt <= "00001";
    s_Shdir <= '0';
    s_Shtype <= '0';
    wait for 10 ns;



    s_A <= X"FFFFFFFF";
    s_Shamt <= "00010";
    s_Shdir <= '0';
    s_Shtype <= '0';
    wait for 10 ns;



    s_A <= X"FFFFFFFF";
    s_Shamt <= "00100";
    s_Shdir <= '0';
    s_Shtype <= '0';
    wait for 10 ns;

    
    wait;
  end process testbench;

end architecture behavioral;
