-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity hazard is
  generic (
    CONF_ENABLE_BRANCH_DELAY_SLOT : std_logic := '1');
  port (
    i_IDEX_RegWriteDataSource : in std_logic_vector (1 downto 0);
    i_IDEX_WBAddr             : in std_logic_vector (4 downto 0);
    i_IFID_RsAddr             : in std_logic_vector (4 downto 0);
    i_IFID_RtAddr             : in std_logic_vector (4 downto 0);
    i_ID_ALUInputBSource      : in std_logic;
    i_IDEX_NextPCSource       : in std_logic_vector (1 downto 0);
    i_IDEX_BranchDecision     : in std_logic;
    o_Stall                   : out std_logic;
    o_Flush                   : out std_logic);
end hazard;
-------------------------------------------------------------------------------
architecture behavioral of hazard is
  
begin  -- behavioral

  load_use_hazard: process (i_IDEX_RegWriteDataSource, i_IDEX_WBAddr, i_IFID_RsAddr, i_IFID_RtAddr, i_ID_ALUInputBSource)
  begin  -- process load_use_hazard
    if i_IDEX_RegWriteDataSource = "01" then
      -- it is a LOAD instruction
      if i_ID_ALUInputBSource = '1' then
        -- I format, check only for Rs dependency
        if i_IDEX_WBAddr = i_IFID_RsAddr then
          o_Stall = '1';
        else
          o_Stall = '0';
        end if;
      else
        -- R format, check both Rs and Rt dependencies
        if i_IDEX_WBAddr = i_IFID_RsAddr or i_IDEX_WBAddr = i_IFID_RtAddr then
          o_Stall = '1';
        else
          o_Stall = '0';  
        end if;
      end if;
    end if;
  end process load_use_hazard;


  control_hazard: process (i_IDEX_NextPCSource, i_IDEX_BranchDecision)
  begin  -- process
    if i_IDEX_NextPCSource = "01" or i_IDEX_NextPCSource = "10" or (in_IDEX_NextPCSource = "11" and i_IDEX_BranchDecision = '1' and not(CONF_ENABLE_BRANCH_DELAY_SLOT) = '1') then
        o_Flush = '1';
    else
      o_Flush = '0';
    end if;
  end process control_hazard;
  

end behavioral;
-------------------------------------------------------------------------------
