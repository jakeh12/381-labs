library ieee;
use ieee.std_logic_1164.all;

entity mips_shifter is
  
  port (
    i_A      : in  std_logic_vector (31 downto 0);
    i_Shamt  : in  std_logic_vector (4 downto 0);
    i_Shdir  : in  std_logic;
    i_Shtype : in  std_logic;
    o_F      : out std_logic_vector(31 downto 0));

end entity mips_shifter;

architecture mixed of mips_shifter is

  component barrel_shifter is
    port (
      i_A     : in  std_logic_vector (31 downto 0);
      i_In    : in  std_logic;
      i_Shamt : in  std_logic_vector (4 downto 0);
      o_F     : out std_logic_vector (31 downto 0));
  end component;


  signal s_A_flipped      : std_logic_vector (31 downto 0);
  signal s_shifter_input  : std_logic_vector (31 downto 0);
  signal s_shifter_output : std_logic_vector (31 downto 0);
  signal s_F_flipped      : std_logic_vector (31 downto 0);
  signal s_F_reversed     : std_logic_vector (31 downto 0);
  signal s_shift_in       : std_logic;


  function reverse_vector (a : in std_logic_vector)
    return std_logic_vector is
    variable result : std_logic_vector(a'RANGE);
    alias aa        : std_logic_vector(a'REVERSE_RANGE) is a;
  begin
    for i in aa'RANGE loop
      result(i) := aa(i);
    end loop;
    return result;
  end;



  
begin  -- architecture mixed


  barrel_shifter_0 : barrel_shifter
    port map (
      i_A     => s_shifter_input,
      i_Shamt => i_Shamt,
      o_F     => s_shifter_output,
      i_In    => s_shift_in);


  s_A_flipped <= reverse_vector(i_A);

  s_shifter_input <= s_A_flipped when i_Shdir = '1' else i_A;

  s_shift_in <= i_Shtype and i_A(31);

  s_F_flipped <= reverse_vector(s_shifter_output);

  o_F <= s_F_flipped when i_Shdir = '1' else s_shifter_output;

end architecture mixed;
