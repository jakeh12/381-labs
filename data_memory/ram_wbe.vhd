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
entity ram_wbe is
  
  generic (
    init_file : string  := "dmem.mif";  -- memory intialization file
     l         : natural := 14);           -- width of address bus in bits
  port (
    i_byteena : in std_logic_vector (3 downto 0);  -- byte enable for write
    i_addr  : in  std_logic_vector (l-1 downto 0);   -- address input
    i_wdata : in  std_logic_vector (31 downto 0);   -- data input
    i_wen   : in  std_logic;                         -- write enable
    o_rdata : out std_logic_vector (31 downto 0);  -- data output
    i_clk   : in std_logic);            -- clock input

end entity ram_wbe;

-------------------------------------------------------------------------------
architecture behavioral of ram_wbe is

  type mem_array is array ((2**l-1) downto 0) of std_logic_vector(31 downto 0);

  -----------------------------------------------------------------------------
  -- mem_init_from_file:
  -- This function reads a ASCII defined, line separated hex values and
  -- loads them into the mem_array type. The uninitialized values are set to
  -- zero.
  -----------------------------------------------------------------------------
  impure function mem_init_from_file(filename : string) return mem_array is
    file file_object      : text open read_mode is filename;
    variable current_line : line;
    variable current_word : std_logic_vector(31 downto 0);
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
  
  signal bank0, bank1, bank2, bank3 : std_logic_vector(31 downto 0);
  
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
  write_data : process (i_clk) is
  begin
    if falling_edge(i_clk) then
      if i_wen = '1' then
        if i_byteena(0) = '1' then
          ram_block(to_integer(unsigned(i_addr)))(7 downto 0) <= i_wdata(7 downto 0);
        end if;
        if i_byteena(1) = '1' then
          ram_block(to_integer(unsigned(i_addr)))(15 downto 8) <= i_wdata(15 downto 8);
        end if;
        if i_byteena(2) = '1' then
          ram_block(to_integer(unsigned(i_addr)))(23 downto 16) <= i_wdata(23 downto 16);
        end if;
        if i_byteena(3) = '1' then
          ram_block(to_integer(unsigned(i_addr)))(31 downto 24) <= i_wdata(31 downto 24);
        end if;
      end if;
    end if;
  end process;
  
  bank0 <= ram_block(0);
  bank1 <= ram_block(1);
  bank2 <= ram_block(2);
  bank3 <= ram_block(3);

end architecture behavioral;
-------------------------------------------------------------------------------
