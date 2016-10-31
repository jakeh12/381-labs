-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity decoder3to8 is
  
  port (
    o_Y   : out std_logic_vector (7 downto 0);   -- decoder output
    i_Sel : in  std_logic_vector (2 downto 0));  -- decoder select

end entity decoder3to8;
-------------------------------------------------------------------------------
architecture dataflow of decoder3to8 is

begin  -- architecture dataflow

  with i_Sel select o_Y <=
    "00000001" when "000",
    "00000011" when "001",
    "00000111" when "010",
    "00001111" when "011",
    "00011111" when "100",
    "00111111" when "101",
    "01111111" when "110",
    "11111111" when "111",
    "00000000" when others;             -- will never happen
  
end architecture dataflow;
-------------------------------------------------------------------------------
