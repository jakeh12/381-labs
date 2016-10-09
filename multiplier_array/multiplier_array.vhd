--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
entity multiplier_array is
  generic (n : natural := 32);
  port (i_A, i_B : in  std_logic_vector (n-1 downto 0);
        o_P      : out std_logic_vector (2*n-1 downto 0));
end multiplier_array;
--------------------------------------------------------------------------------
architecture structural of multiplier_array is

  component and2 is
    port (i_A, i_B : in  std_logic;
          o_F      : out std_logic);
  end component;

  component adder_nbit is
    generic (n : natural := n);
    port (i_A, i_B : in  std_logic_vector (n-1 downto 0);
          i_Cin    : in  std_logic;
          o_S      : out std_logic_vector (n-1 downto 0);
          o_Cout   : out std_logic);
  end component;


  type array2d is array (natural range <>) of std_logic_vector (n downto 0);
  signal s_partial_product : array2d (n-1 downto 0);
  signal s_partial_sum     : array2d (n-1 downto 0);


  signal row_temp : std_logic_vector (n-1 downto 0);
begin

  -----------------------------------------------------------------------------
  -- The following generates partial product matrix pp(i)(j) <= A(j) and B(i)
  -----------------------------------------------------------------------------
  generate_partial_product_matrix_row_i : for i in 0 to n-1 generate
  begin
    generate_partial_product_column_j : for j in 0 to n-1 generate
    begin
      partial_and_i_j : and2
        port map (i_A => i_A(j),
                  i_B => i_B(i),
                  o_F => s_partial_product(i)(j));
    end generate generate_partial_product_column_j;
  end generate generate_partial_product_matrix_row_i;

  -----------------------------------------------------------------------------
  -- Now sum the partial products using n-bit adders
  -----------------------------------------------------------------------------
  sum_partial_products : for i in 0 to n-1 generate

    -- first row special case
    first_row_adder : if i = 0 generate
      o_P(0) <= s_partial_product(0)(0);
    end generate first_row_adder;

    -- second row special case
    second_row_adder : if i = 1 generate

      row_temp <= '0' & s_partial_product(0)(n-2 downto 1);
      second_row_adder : adder_nbit
        port map (
          i_A    => s_partial_product(1),
          i_B    => row_temp,
          i_Cin  => '0',
          o_S    => s_partial_sum(1),
          o_Cout => s_partial_sum(1)(n));  -- carry to be used for next sum

      o_P(1) <= s_partial_sum(1)(0);
    end generate second_row_adder;

    -- intermediate rows
    intermediate_row_adder : if i > 1 and i < n-1 generate
      
      row_i_adder : adder_nbit
        port map (
          i_A    => s_partial_product(i),
          i_B    => s_partial_sum(i-1)(i+n downto i+1),  -- previous sum shifted left
          i_Cin  => '0',
          o_S    => s_partial_sum(i),
          o_Cout => s_partial_sum(i)(n));  -- carry to be used for next sum

      o_P(i) <= s_partial_sum(i)(0);
    end generate intermediate_row_adder;

    -- last row
    last_row_adder : if i = n-1 generate
      last_row_adder : adder_nbit
        port map (
          i_A    => s_partial_product(i),
          i_B    => s_partial_sum(i-1)(2*n-1 downto n),  -- previous sum shifted left
          i_Cin  => '0',
          o_S    => s_partial_sum(i),
          o_Cout => s_partial_sum(i)(n));  -- carry to be used for next sum

      o_P <= s_partial_sum(n-1)(2*n-1 downto n);
    end generate last_row_adder;
    
  end generate sum_partial_products;
  

end structural;
--------------------------------------------------------------------------------
