-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity demux1to8_tb is
end entity demux1to8_tb;
-------------------------------------------------------------------------------
architecture behavioral of demux1to8_tb is

  component demux1to8 is
  port (
    i_A   : in  std_logic;                       -- demux input
    o_Y   : out std_logic_vector (7 downto 0);   -- demux output
    i_Sel : in  std_logic_vector (2 downto 0));  -- demux select
  end component;

  signal s_A : std_logic;
  signal s_Sel : std_logic_vector (2 downto 0) := "000";
  signal s_Y: std_logic_vector (7 downto 0);
  
begin  -- architecture behavioral

  
  -- generate all possibilities of input signals
  s_Sel(0) <= not s_Sel(0) after 5 ns;
  s_Sel(1) <= not s_Sel(1) after 10 ns;
  s_Sel(2) <= not s_Sel(2) after 20 ns;


  DUT: demux1to8
    port map (
      i_A   => s_A,
      o_Y   => s_Y,
      i_Sel => s_Sel);

  
  -- purpose: test component demux1to8
  testbench: process is
  begin  -- process testbench
    s_A <= '1';
    wait for 40 ns;
    wait;
  end process testbench;

  
end architecture behavioral;
-------------------------------------------------------------------------------
