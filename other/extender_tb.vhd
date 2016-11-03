library ieee;
use ieee.std_logic_1164.all;

entity extender_tb is
end extender_tb;

architecture behavioral of extender_tb is
  
  component extender is
    generic (
      n_small : integer := 16;
      n_big : integer := 32
    ); 
    port (
      i_isSigned : in std_logic;
      i_small : in std_logic_vector(n_small-1 downto 0);
      o_big : out std_logic_vector(n_big-1 downto 0)
    );
  end component;
  
  signal s_small : std_logic_vector(15 downto 0);
  signal s_big : std_logic_vector(31 downto 0);
  signal s_isSigned : std_logic;
  
begin
  
  DUT: extender
    port map (
      i_isSigned => s_isSigned,
      i_small => s_small,
      o_big => s_big
    );
  
  process
  begin
    s_small <= X"ABCD";
    s_isSigned <= '0';
    wait for 10 ns;
    s_isSigned <= '1';
    wait for 10 ns;
    
    
  end process;
  
end behavioral;
