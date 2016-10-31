-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
------------------------------------------------------------------------------
entity reg_tb is
end entity reg_tb;
-------------------------------------------------------------------------------
architecture behavioral of reg_tb is

  component reg is
  generic (
    n         : natural := 32);           -- width of word in bits
  port (
    i_wdata : in  std_logic_vector (n-1 downto 0);   -- data input
    i_wen   : in  std_logic;                         -- write enable
    o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
    i_rst   : in std_logic;             -- reset input
    i_clk   : in std_logic);            -- clock input
  end component reg;
  
  signal s_wdata, s_rdata : std_logic_vector(7 downto 0);
  signal s_wen, s_rst, s_clk : std_logic;
  
begin  -- architecture behavioral

  DUT: reg
    port map (
      i_wdata => s_wdata,
      i_wen   => s_wen,
      o_rdata => s_rdata,
      i_rst   => s_rst,
      i_clk   => s_clk);

  
  clock: process is
  begin
    s_clk <= '1';
    wait for 5 ns;
    s_clk <= '0';
    wait for 5 ns;
  end process clock;  


  process is
  begin
    s_rst <= '1';
    s_wen <= '0';
    s_wdata <= X"00";
    wait for 10 ns;

    s_rst <= '0';
    wait for 10 ns;

    s_wdata <= X"AA";
    s_wen <= '1';
    wait for 10 ns;
    s_wen <= '0';

    assert s_rdata = X"AA"
    report "register test failed, unexpected value" severity error;

    wait for 10 ns;
    s_rst <= '1';
    wait for 10 ns;
    s_rst <= '0';

    assert s_rdata = X"00"
    report "register test failed, unexpected value" severity error;

    wait;
  end process;
  
end architecture behavioral;
-------------------------------------------------------------------------------
