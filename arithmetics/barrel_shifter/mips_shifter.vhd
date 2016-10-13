-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips_shifter is
  
  port (
    i_A      : in  std_logic_vector (31 downto 0);
    i_ShAmt  : in  std_logic_vector (4 downto 0);
    i_ShDir  : in  std_logic;
    i_ShType : in  std_logic;
    o_F      : out std_logic_vector(31 downto 0));

end entity mips_shifter;
-------------------------------------------------------------------------------
architecture mixed of mips_shifter is

  component barrel_shifter is
    port (
      i_A     : in  std_logic_vector (31 downto 0);
      i_In    : in  std_logic;
      i_ShAmt : in  std_logic_vector (4 downto 0);
      o_F     : out std_logic_vector (31 downto 0));
  end component;


  signal s_A_reversed      : std_logic_vector (31 downto 0);
  signal s_shifter_input  : std_logic_vector (31 downto 0);
  signal s_shifter_output : std_logic_vector (31 downto 0);
  signal s_F_reversed      : std_logic_vector (31 downto 0);
  signal s_shift_in       : std_logic;
  
begin  -- architecture mixed


  barrel_shifter_0 : barrel_shifter
    port map (
      i_A     => s_shifter_input,
      i_Shamt => i_Shamt,
      o_F     => s_shifter_output,
      i_In    => s_shift_in);



  reverse_a: for i in 0 to 31 generate
    s_A_reversed(31-i) <= i_A(i);
  end generate reverse_a;

  reverse_f: for i in 0 to 31 generate
    s_F_reversed(31-i) <= s_shifter_output(i);
  end generate reverse_f;

  
  s_shifter_input <= s_A_reversed when i_ShDir = '1' else i_A;
  s_shift_in <= s_A_reversed(0) when i_ShType = '1' else '0';
  o_F <= s_F_reversed when i_ShDir = '1' else s_shifter_output;
  
end architecture mixed;
-------------------------------------------------------------------------------
