library ieee;
use ieee.std_logic_1164.all;

entity decoder5to32_tb is
end decoder5to32_tb;

architecture behavior of decoder5to32_tb is
  
  component decoder5to32
  port(i_X : in std_logic_vector(4 downto 0);     -- raw value
       i_En : in std_logic;
       o_Y : out std_logic_vector(31 downto 0));   -- decoded value
  end component;

  signal s_X : std_logic_vector(4 downto 0) := (others => '0');
  signal s_Y : std_logic_vector(31 downto 0);
  signal s_En : std_logic := '0';

begin

  DUT: decoder5to32
  port map(i_X => s_X, 
           i_En => s_En,
           o_Y => s_Y
           );
  
  s_X(0) <= not s_X(0) after 10 ns;
  s_X(1) <= not s_X(1) after 20 ns;
  s_X(2) <= not s_X(2) after 40 ns;
  s_X(3) <= not s_X(3) after 80 ns;
  s_X(4) <= not s_X(4) after 160 ns;
  
  simulation: process
    begin
      s_En <= '1';
      wait for 320 ns;
      s_En <= '0';
      assert false report "end of test" severity note; 
      wait;

  end process;
  
end behavior;
