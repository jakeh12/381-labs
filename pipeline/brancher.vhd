-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity brancher is
  
  port (
    i_A              : in  std_logic_vector (31 downto 0);
    i_B              : in  std_logic_vector (31 downto 0);
    o_BranchDecision : out std_logic;
    i_BranchType     : in  std_logic_vector (2 downto 0));

end brancher;
-------------------------------------------------------------------------------
architecture mixed of brancher is


  component fan is
    generic(
      n : integer := 32
      );
    port(
      i_A, i_B : in  std_logic_vector(n-1 downto 0);
      i_Cin    : in  std_logic;
      o_S      : out std_logic_vector(n-1 downto 0);
      o_Cout   : out std_logic
      );
  end component;

  signal s_beq  : std_logic;
  signal s_bne  : std_logic;
  signal s_bltz : std_logic;
  signal s_bgez : std_logic;
  signal s_blez : std_logic;
  signal s_bgtz : std_logic;

  signal s_S : std_logic_vector (31 downto 0);
  signal s_ZeroFlag : std_logic;
  signal s_NegFlag : std_logic;

  signal s_notB : std_logic_vector (31 downto 0);
  signal s_muxedInputB : std_logic_vector (31 downto 0);

begin  -- behavioral


  bitwise_not: for i in 0 to 31 generate
    s_notB(i) <= not i_B(i);
  end generate bitwise_not;
  
  subtractor: fan
    port map (
      i_A   => i_A,
      i_B   => s_muxedInputB,
      i_Cin => '1',
      o_S   => s_S,
      o_Cout => open);

  s_NegFlag <= s_S(31);
  s_ZeroFlag <= '1' when s_S = X"00000000" else '0';

  s_muxedInputB <= s_notB when i_BranchType = "00-" else X"00000000";
  
  s_beq  <= s_ZeroFlag;
  s_bne  <= not s_ZeroFlag;
  s_bltz <= s_NegFlag;
  s_bgez <= not s_NegFlag;
  s_blez <= s_ZeroFlag or s_NegFlag;
  s_bgtz <= s_ZeroFlag nor s_NegFlag;

  with i_BranchType select
    o_BranchDecision <=
    s_beq  when "000",
    s_bne  when "001",
    s_bltz when "010",
    s_bgez when "011",
    s_blez when "100",
    s_bgtz when "101",
    '0'    when others;
  
end mixed;
