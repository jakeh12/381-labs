-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity instruction_fetch is
  
  port (
    o_Instruction : out std_logic_vector (31 downto 0);
    i_JumpRegData     : in std_logic_vector (31 downto 0);
    i_BranchType : in std_logic_vector (1 downto 0));

end entity instruction_fetch;
-------------------------------------------------------------------------------
architecture mixed of instruction_fetch is

  component ram is
    generic (
      n         : natural := 32;         -- width of word in bits
      l         : natural := 10;  -- width of address bus in bits                                 
      init_file : string  := "ram.mif");  -- memory intialization file
    port (
      i_addr  : in  std_logic_vector (n-1 downto 0);  -- address input
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_wen   : in  std_logic;
      i_clk   : in  std_logic);
  end component ram;

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

  
  
begin  -- architecture mixed

    inst_mem : ram
    port map (
      i_addr  => s_addr,
      o_rdata => s_rdata,
      i_wdata => X"00000000",
      i_wen   => '0',
      i_clk   => s_clk);

    program_counter: reg
    port map (
      i_wdata => s_wdata,
      i_wen   => '1',
      o_rdata => s_rdata,
      i_rst   => s_rst,
      i_clk   => s_clk);

    
  

end architecture mixed;
-------------------------------------------------------------------------------
