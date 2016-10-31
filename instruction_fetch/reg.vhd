-------------------------------------------------------------------------------
-- N-bit register with asynchronous reset.
--
-- Positive edge triggered.
-- Synthesizable.
--
-- 2016/10/28 Jakub Hladik, Iowa State University
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
------------------------------------------------------------------------------
entity reg is
  
  generic (
    n         : natural := 32);           -- width of word in bits
  port (
    i_wdata : in  std_logic_vector (n-1 downto 0);   -- data input
    i_wen   : in  std_logic;                         -- write enable
    o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
    i_rst   : in std_logic;             -- reset input
    i_clk   : in std_logic);            -- clock input

end entity reg;
-------------------------------------------------------------------------------
architecture behavioral of reg is

  signal s_data : std_logic_vector(n-1 downto 0);-- := (others => '0');
  
begin  -- architecture behavioral

  
  -----------------------------------------------------------------------------
  -- write_data:
  -- This process value into the register when i_wen = '1'.
  -----------------------------------------------------------------------------
  write_data : process (i_clk, i_wen, i_rst) is
  begin
    if i_rst = '1' then
      s_data <= (others => '0');
    elsif rising_edge(i_clk) then
      if i_wen = '1' then
        s_data <= i_wdata;
      end if;
    end if;
  end process;

  -- output data
  o_rdata <= s_data;
  
end architecture behavioral;
-------------------------------------------------------------------------------
