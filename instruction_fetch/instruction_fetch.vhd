-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity instruction_fetch is
  
  port (
    i_instruction : in std_logic_vector (31 downto 0);
    i_JumpReg     : in std_logic_vector (31 downto 0);

end entity instruction_fetch;
