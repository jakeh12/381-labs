library ieee;
use ieee.std_logic_1164.all;

entity barrel_shifter is
  
  port (
    i_A     : in  std_logic_vector (31 downto 0);
    i_In    : in  std_logic;
    i_ShAmt : in  std_logic_vector (4 downto 0);
    o_F     : out std_logic_vector (31 downto 0));

end entity barrel_shifter;

architecture structural of barrel_shifter is

  component n_shifter is
    generic (n : natural := 0);
    port (
      i_A   : in  std_logic_vector (31 downto 0);
      i_In  : in  std_logic;
      i_Sel : in  std_logic;
      o_F   : out std_logic_vector (31 downto 0));
  end component;
  

  type array2d is array (natural range <>) of std_logic_vector (31 downto 0);
  signal s_shifted : array2d (4 downto 0);

  
begin  -- architecture structural


  shifter_0 : n_shifter
    generic map (
      n => 0)
    port map (
      i_A   => i_A,
      i_In  => i_In,
      i_Sel => i_Shamt(0),
      o_F   => s_shifted(0));

  shifter_1 : n_shifter
    generic map (
      n => 1)
    port map (
      i_A   => s_shifted(0),
      i_In  => i_In,
      i_Sel => i_Shamt(1),
      o_F   => s_shifted(1));

  shifter_2 : n_shifter
    generic map (
      n => 2)
    port map (
      i_A   => s_shifted(1),
      i_In  => i_In,
      i_Sel => i_Shamt(2),
      o_F   => s_shifted(2));

  shifter_3 : n_shifter
    generic map (
      n => 3)
    port map (
      i_A   => s_shifted(2),
      i_In  => i_In,
      i_Sel => i_Shamt(3),
      o_F   => s_shifted(3));

  shifter_4 : n_shifter
    generic map (
      n => 4)
    port map (
      i_A   => s_shifted(3),
      i_In  => i_In,
      i_Sel => i_Shamt(4),
      o_F   => s_shifted(4));

  o_F <= s_shifted(4);
  
end architecture structural;
