-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity hazard_tb is

end hazard_tb;
-------------------------------------------------------------------------------
architecture behavioral of hazard_tb is

  component hazard is
    generic (
      CONF_ENABLE_BRANCH_DELAY_SLOT : std_logic := '1');
    port (
      i_IDEX_RegWriteDataSource : in  std_logic_vector (1 downto 0);
      i_IDEX_WBAddr             : in  std_logic_vector (4 downto 0);
      i_IFID_RsAddr             : in  std_logic_vector (4 downto 0);
      i_IFID_RtAddr             : in  std_logic_vector (4 downto 0);
      i_ID_ALUInputBSource      : in  std_logic;
      i_IDEX_NextPCSource       : in  std_logic_vector (1 downto 0);
      i_IDEX_BranchDecision     : in  std_logic;
      o_Stall                   : out std_logic;
      o_Flush                   : out std_logic);
  end component;

  signal s_IDEX_RegWriteDataSource, s_IDEX_NextPCSource               : std_logic_vector (1 downto 0);
  signal s_IDEX_WBAddr, s_IFID_RsAddr, s_IFID_RtAddr                  : std_logic_vector (4 downto 0);
  signal s_ID_ALUInputBSource, s_IDEX_BranchDecision, s_Stall, s_Flush : std_logic;
  
  
begin  -- behavioral


  DUT : hazard
    generic map (
      CONF_ENABLE_BRANCH_DELAY_SLOT => '1')
    port map (
      i_IDEX_RegWriteDataSource => s_IDEX_RegWriteDataSource,
      i_IDEX_WBAddr             => s_IDEX_WBAddr,
      i_IFID_RsAddr             => s_IFID_RsAddr,
      i_IFID_RtAddr             => s_IFID_RtAddr,
      i_ID_ALUInputBSource      => s_ID_ALUInputBSource,
      i_IDEX_NextPCSource       => s_IDEX_NextPCSource,
      i_IDEX_BranchDecision     => s_IDEX_BranchDecision,
      o_Stall                   => s_Stall,
      o_Flush                   => s_Flush);

  process
  begin  -- process

    -- initialize all signals to 0
    s_IDEX_RegWriteDataSource <= "00";
    s_IDEX_WBAddr             <= "00000";
    s_IFID_RsAddr             <= "00000";
    s_IFID_RtAddr             <= "00000";
    s_ID_ALUInputBSource      <= '0';
    s_IDEX_NextPCSource       <= "00";
    s_IDEX_BranchDecision     <= '0';
    wait for 10 ns;


    -- j label
    s_IDEX_RegWriteDataSource <= "00";
    s_IDEX_WBAddr             <= "00000";
    s_IFID_RsAddr             <= "00000";
    s_IFID_RtAddr             <= "00000";
    s_ID_ALUInputBSource      <= '0';
    s_IDEX_NextPCSource       <= "01";
    s_IDEX_BranchDecision     <= '0';
    wait for 10 ns;


    -- jr $reg
    s_IDEX_RegWriteDataSource <= "00";
    s_IDEX_WBAddr             <= "00000";
    s_IFID_RsAddr             <= "00000";
    s_IFID_RtAddr             <= "00000";
    s_ID_ALUInputBSource      <= '0';
    s_IDEX_NextPCSource       <= "10";
    s_IDEX_BranchDecision     <= '0';
    wait for 10 ns;


    -- false branch (no flush)
    s_IDEX_RegWriteDataSource <= "00";
    s_IDEX_WBAddr             <= "00000";
    s_IFID_RsAddr             <= "00000";
    s_IFID_RtAddr             <= "00000";
    s_ID_ALUInputBSource      <= '0';
    s_IDEX_NextPCSource       <= "11";
    s_IDEX_BranchDecision     <= '0';
    wait for 10 ns;


    -- true branch (flush)
    s_IDEX_RegWriteDataSource <= "00";
    s_IDEX_WBAddr             <= "00000";
    s_IFID_RsAddr             <= "00000";
    s_IFID_RtAddr             <= "00000";
    s_ID_ALUInputBSource      <= '0';
    s_IDEX_NextPCSource       <= "11";
    s_IDEX_BranchDecision     <= '1';
    wait for 10 ns;


    -- load-use hazard
    -- lw $reg
    -- add $some, $reg, $reg
    s_IDEX_RegWriteDataSource <= "01";
    s_IDEX_WBAddr             <= "10000";
    s_IFID_RsAddr             <= "10000";
    s_IFID_RtAddr             <= "00000";
    s_ID_ALUInputBSource      <= '0';
    s_IDEX_NextPCSource       <= "00";
    s_IDEX_BranchDecision     <= '0';
    wait for 10 ns;


    -- load-use hazard
    -- lw $reg
    -- addi $some, $some, 1000
    s_IDEX_RegWriteDataSource <= "01";
    s_IDEX_WBAddr             <= "10000";
    s_IFID_RsAddr             <= "00000";
    s_IFID_RtAddr             <= "10000";
    s_ID_ALUInputBSource      <= '1';
    s_IDEX_NextPCSource       <= "00";
    s_IDEX_BranchDecision     <= '0';
    wait for 10 ns;


    -- load-use hazard
    -- lw $reg
    -- addi $some, $reg, 1000
    s_IDEX_RegWriteDataSource <= "01";
    s_IDEX_WBAddr             <= "10000";
    s_IFID_RsAddr             <= "10000";
    s_IFID_RtAddr             <= "00000";
    s_ID_ALUInputBSource      <= '1';
    s_IDEX_NextPCSource       <= "00";
    s_IDEX_BranchDecision     <= '0';
    wait for 10 ns;

    wait;
  end process;

end behavioral;
