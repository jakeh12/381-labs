-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips_control is
  
  port (
    i_instruction : in  std_logic_vector (5 downto 0);  -- instruction from the memory
    o_RegDst      : out std_logic);     -- destination register address

end entity mips_control;
