--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
entity multiplier_array is
  generic (n : natural := 32);
  port (i_M, i_Q : in  std_logic_vector (n-1 downto 0);
         o_P     : out std_logic_vector (2*(n-1) downto 0));
end multiplier_array;
--------------------------------------------------------------------------------
architecture structural of multiplier_array is

  component and2 is
    port (i_A, i_B : in  std_logic;
           o_F     : out std_logic);
  end component;

  component full_adder is
    port (i_A, i_B : in  std_logic;
           i_Cin   : in  std_logic;
           o_S     : out std_logic;
           o_Cout  : out std_logic);
  end component;


  type array2d is array (natural range<>) of std_logic_vector (n-1 downto 0);
  signal s_partial_product         : array2d (n-1 downto 0);
  signal s_partial_sum             : array2d (n-1 downto 0);
  signal s_partial_sum_carry_chain : array2d (n-1 downto 0);
  
  
begin

  generate_row : for i in 0 to n-1 generate
  begin
    
    
    generate_column : for j in 0 to n-1 generate
    begin
      
      partial_and_i_j : and2
        port map (i_A  => i_M(i),
                   i_B => i_Q(j),
                   o_F => s_partial_product(i)(j));

      sum_partial_i : full_adder
        port map (i_A     => s_partial_product(i)(j),
                   i_B    => s_partial_product(i+1)(j-1),
                   i_Cin  => s_partial_sum_carry_chain(i)(j),
                   o_S    => s_partial_sum(i)(j),
                   o_Cout => s_partial_sum_carry_chain(i)(j));

    end generate generate_column;
    
    

  end generate generate_row;
end structural;
--------------------------------------------------------------------------------
