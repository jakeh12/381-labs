library ieee;
use ieee.std_logic_1164.all;

entity n_shifter is
  
  generic (
    n : natural := 0);

  port (
    i_A  : in  std_logic_vector (31 downto 0);
    i_In : in  std_logic;
    i_Sel: in std_logic;
    o_F  : out std_logic_vector (31 downto 0));

end entity n_shifter;

architecture dataflow of n_shifter is

  begin  -- architecture dataflow

  generate_one_shifter: if n = 0 generate
    o_F <= (i_A(30 downto 0) & i_In) when i_Sel = '1' else i_A;
  end generate generate_one_shifter;

  generate_others_shifter: if n > 0 generate
    o_F <= (i_A(31-2**n downto 0) & (2**n-1 downto 0 => i_In)) when i_Sel = '1' else i_A;
  end generate generate_others_shifter;
  
end architecture dataflow;
