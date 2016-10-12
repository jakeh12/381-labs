library ieee;
use ieee.std_logic_1164.all;

entity barrel_shifter is
  
  port (
    i_A   : in  std_logic_vector (31 downto 0);
    i_In  : in  std_logic;
    i_Shamt: in std_logic_vector (4 downto 0);
    o_F   : out std_logic_vector (31 downto 0));

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

  generate_shifters: for i in 0 to 4 generate

    generate_first_shifter: if i = 0 generate
      first_shifter: n_shifter
        generic map (
          n => 0)
        port map (
          i_A   => i_A,
          i_In  => i_In,
          i_Sel => i_Shamt(0),
          o_F   => s_shifted(0));
    end generate generate_first_shifter;

    intermediate_shifters: if i > 0 and i < 4 generate
      intermediate_shifter_i: n_shifter
        generic map (
          n => i)
        port map (
          i_A   => s_shifted(i-1),
          i_In  => i_In,
          i_Sel => i_Shamt(i),
          o_F   => s_shifted(i));
    end generate intermediate_shifters;

    generate_last_shifter: if i = 4 generate
      last_shifter: n_shifter
        generic map (
          n => 4)
        port map (
          i_A   => s_shifted(i-1),
          i_In  => i_In,
          i_Sel => i_Shamt(4),
          o_F   => o_F);
    end generate generate_last_shifter;
  end generate generate_shifters;

end architecture structural;
