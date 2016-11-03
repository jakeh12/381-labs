-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_vector_1164.all;
-------------------------------------------------------------------------------
entity branch_control is
  
  port (
    i_BranchType                : in  std_logic_vector (2 downto 0);
    i_ALUFlagZero, i_ALUFlagNeg : in  std_logic;
    o_BranchDecision            : out std_logic_vector);

end entity branch_control;
-------------------------------------------------------------------------------
architecture dataflow of branch_control is

  signal s_beq : std_logic;
  signal s_bne : std_logic;
  signal s_bltz : std_logic;
  signal s_bgez : std_logic;
  signal s_blez : std_logic;
  signal s_bgtz : std_logic;
  
begin  -- architecture dataflow

  s_beq <= i_ALUFlagZero;
  s_bne <= not i_ALUFlagZero;
  s_bltz <= i_ALUFlagNeg;
  s_bgez <= not i_ALUFlagNeg;
  s_blez <= i_ALUFlagZero and i_ALUFlagNeg;
  s_bgtz <= i_ALUFlagZero nor i_ALUFlagNeg;

  with i_BranchType select
    o_BranchDecision <=
    s_beq  when "000",
    s_bne  when "001",
    s_bltz when "010",
    s_bgez when "011",
    s_blez when "100",
    s_bgtz when "101",
    '0'    when others;
 
end architecture dataflow;
