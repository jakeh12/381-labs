--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
entity adder_nbit is
  generic (
    n : natural := 32);                 -- operand width
  port (i_A, i_B : in  std_logic_vector (n-1 downto 0);
        i_Cin    : in  std_logic;
        o_S      : out std_logic_vector (n-1 downto 0);
        o_Cout   : out std_logic);
end adder_nbit;
--------------------------------------------------------------------------------
architecture structural of adder_nbit is

  component full_adder is
    port (i_A, i_B : in  std_logic;
          i_Cin    : in  std_logic;
          o_S      : out std_logic;
          o_Cout   : out std_logic);
  end component;

  signal s_carry_chain : std_logic_vector (n-2 downto 0);
  
begin

  generate_adder_nbit : for i in 0 to n-1 generate

    generate_first_adder : if i = 0 generate
      first_adder : full_adder
        port map (
          i_A    => i_A(i),
          i_B    => i_B(i),
          i_Cin  => i_Cin,
          o_S    => o_S(i),
          o_Cout => s_carry_chain(i));
    end generate generate_first_adder;

    generate_intermediate_adders : if i > 0 and i < n-1 generate
      intermediate_adder_i : full_adder
        port map (
          i_A    => i_A(i),
          i_B    => i_B(i),
          i_Cin  => s_carry_chain(i-1),
          o_S    => o_S(i),
          o_Cout => s_carry_chain(i));
    end generate generate_intermediate_adders;


    generate_last_adder : if i = n-1 generate
      last_adder : full_adder
        port map (
          i_A    => i_A(i),
          i_B    => i_B(i),
          i_Cin  => s_carry_chain(i-1),
          o_S    => o_S(i),
          o_Cout => o_Cout);      
    end generate generate_last_adder;


  end generate generate_adder_nbit;
  
end structural;
--------------------------------------------------------------------------------
