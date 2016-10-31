-------------------------------------------------------------------------------
-- Synchronous single-port RAM implementation.
--
-- Reads input address on rising edge, writes on rising edge.
-- Synthesizable, with file initialization.
--
-- 2016/10/28 Jakub Hladik, Iowa State University
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
-------------------------------------------------------------------------------
entity ram is
  
  generic (
    n         : natural := 32;           -- width of word in bits
    l         : natural := 10;           -- width of address bus in bits
    init_file : string  := "ram.mif");  -- memory intialization file

  port (
    i_addr  : in  std_logic_vector (n-1 downto 0);   -- address input
    i_wdata : in  std_logic_vector (n-1 downto 0);   -- data input
    i_wen   : in  std_logic;                         -- write enable
    o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
    i_clk   : in std_logic);            -- clock input

end entity ram;
-------------------------------------------------------------------------------
architecture behavioral of ram is

  type mem_array is array ((2**l-1) downto 0) of std_logic_vector(n-1 downto 0);

  -----------------------------------------------------------------------------
  -- mem_init_from_file:
  -- This function reads a ASCII defined, line separated hex values and
  -- loads them into the mem_array type. The uninitialized values are set to
  -- zero.
  -----------------------------------------------------------------------------
  impure function mem_init_from_file(filename : string) return mem_array is
    file file_object      : text open read_mode is filename;
    variable current_line : line;
    variable current_word : std_logic_vector(n-1 downto 0);
    variable result       : mem_array := (others => (others => '0'));
  begin
    for i in 0 to (2**l-1) loop
      exit when endfile(file_object);
      readline(file_object, current_line);
      hread(current_line, current_word);
      result(i) := current_word;
    end loop;
    return result;
  end function;

  signal ram_block : mem_array := mem_init_from_file(init_file);
  
begin  -- architecture behavioral

  -----------------------------------------------------------------------------
  -- output_data:
  -- This process reacts to changes in i_addr input and outputs the appropriate
  -- data on the o_rdata output.
  -----------------------------------------------------------------------------
  output_rdata : process (i_addr) is --  output_rdata : process (i_clk, i_addr) is
  begin
    --if rising_edge(i_clk) then
      o_rdata <= ram_block(to_integer(unsigned(i_addr)));
    --end if;
  end process;

  -----------------------------------------------------------------------------
  -- write_data:
  -- This process writes into RAM on rising edge of the clock if wen = '1'.
  -----------------------------------------------------------------------------
  write_data : process (i_clk, i_addr, i_wen) is
  begin
    if rising_edge(i_clk) then
      if i_wen = '1' then
        ram_block(to_integer(unsigned(i_addr))) <= i_wdata;
      end if;
    end if;
  end process;
  

end architecture behavioral;
-------------------------------------------------------------------------------
