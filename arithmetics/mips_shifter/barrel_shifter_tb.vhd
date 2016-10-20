-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity barrel_shifter_tb is
end entity barrel_shifter_tb;
-------------------------------------------------------------------------------
architecture behavioral of barrel_shifter_tb is

  component barrel_shifter is
    port (
     i_A     : in  std_logic_vector (31 downto 0);
     i_In    : in  std_logic;
     i_ShAmt : in  std_logic_vector (4 downto 0);
     o_F     : out std_logic_vector (31 downto 0)); 
  end component barrel_shifter;

  signal s_A, s_F : std_logic_vector (31 downto 0);
  signal s_ShAmt : std_logic_vector (4 downto 0);
  signal s_In : std_logic;

  
begin  -- architecture behavioral

  DUT: barrel_shifter
    port map (
      i_A     => s_A,
      i_In    => s_In,
      i_ShAmt => s_ShAmt,
      o_F     => s_F);

  process is
  begin  -- process

    s_A <= X"FFFFFFFF";
    s_In <= '0';
    s_ShAmt <= "00000";
    wait for 10 ns;
    

    s_A <= X"FFFFFFFF";
    s_In <= '0';
    s_ShAmt <= "00001";
    wait for 10 ns;


    s_A <= X"FFFFFFFF";
    s_In <= '0';
    s_ShAmt <= "00010";
    wait for 10 ns;


    s_A <= X"FFFFFFFF";
    s_In <= '0';
    s_ShAmt <= "00100";
    wait for 10 ns;


    s_A <= X"FFFFFFFF";
    s_In <= '0';
    s_ShAmt <= "01000";
    wait for 10 ns;

    s_A <= X"FFFFFFFF";
    s_In <= '0';
    s_ShAmt <= "10000";
    wait for 10 ns;
    
  end process;
  

end architecture behavioral;
-------------------------------------------------------------------------------
