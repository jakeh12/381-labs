-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity twos_complementer_nbit is
  
  generic (
    n : natural := 32);

  port (
    i_A : in  std_logic_vector (n-1 downto 0);   -- input
    o_F : out std_logic_vector (n-1 downto 0));  -- two's complement output

end entity twos_complementer_nbit;
-------------------------------------------------------------------------------
architecture mixed of twos_complementer_nbit is

  component adder_nbit is
   generic (n : natural := n);
   port (i_A, i_B : in  std_logic_vector (n-1 downto 0);
    i_Cin    : in  std_logic;
    o_S      : out std_logic_vector (n-1 downto 0);
    o_Cout   : out std_logic);
  end component;

  signal s_inverted : std_logic_vector (n-1 downto 0);  -- inverted i_A
  signal s_zero_vector : std_logic_vector (n-1 downto 0) := (others => '0');  -- zero vector
  signal s_one : std_logic := '1';        -- constant one for carry in
  
begin  -- architecture mixed

  invert_i_A: for i in 0 to n-1 generate
    s_inverted(i) <= not i_A(i);
  end generate invert_i_A;

  adder_0: adder_nbit
    port map (
      i_A    => s_inverted,
      i_B    => s_zero_vector,
      i_Cin  => s_one,
      o_S    => o_F,
      o_Cout => open);
  
end architecture mixed;
-------------------------------------------------------------------------------
