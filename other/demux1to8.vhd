-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity demux1to8 is
  
  port (
    i_A   : in  std_logic;                       -- demux input
    o_Y   : out std_logic_vector (7 downto 0);   -- demux output
    i_Sel : in  std_logic_vector (2 downto 0));  -- demux select

end entity demux1to8;
-------------------------------------------------------------------------------
architecture dataflow of demux1to8 is

begin  -- architecture dataflow

  o_Y(0) <= i_A when i_Sel = "000" else '0';
  o_Y(1) <= i_A when i_Sel = "001" else '0';
  o_Y(2) <= i_A when i_Sel = "010" else '0';
  o_Y(3) <= i_A when i_Sel = "011" else '0';
  o_Y(4) <= i_A when i_Sel = "100" else '0';
  o_Y(5) <= i_A when i_Sel = "101" else '0';
  o_Y(6) <= i_A when i_Sel = "110" else '0';
  o_Y(7) <= i_A when i_Sel = "111" else '0';

end architecture dataflow;
-------------------------------------------------------------------------------
