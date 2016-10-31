-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips_multiplier is

  port (
    i_A : in  std_logic_vector (31 downto 0);   -- multiplicant
    i_B : in  std_logic_vector (31 downto 0);   -- multiplier
    o_P : out std_logic_vector (31 downto 0));  -- product

end entity mips_multiplier;
-------------------------------------------------------------------------------
architecture mixed of mips_multiplier is

  
  component twos_complementer_nbit is
    generic (n : natural := 32);
    port (i_A : in  std_logic_vector (n-1 downto 0);
          o_F : out std_logic_vector (n-1 downto 0));
  end component;

  component multiplier_array is
    generic (n : natural := 32);
    port (i_A, i_B : in  std_logic_vector (n-1 downto 0);
          o_P      : out std_logic_vector (2*n-1 downto 0));
  end component;  

  signal s_B_twos_complement : std_logic_vector (31 downto 0);
  signal s_A_twos_complement : std_logic_vector (31 downto 0);
  signal s_P_twos_complement : std_logic_vector (63 downto 0);

  signal s_B_muxed : std_logic_vector (31 downto 0);
  signal s_A_muxed : std_logic_vector (31 downto 0);
  signal s_P_muxed : std_logic_vector (63 downto 0);
  signal s_P_raw : std_logic_vector (63 downto 0);
  
begin  -- architecture mixed

  twos_complementer_A : twos_complementer_nbit
    generic map (
      n => 32)
    port map (
      i_A => i_A,
      o_F => s_A_twos_complement);

  twos_complementer_B : twos_complementer_nbit
    generic map (
      n => 32)
    port map (
      i_A => i_B,
      o_F => s_B_twos_complement);

  twos_complementer_R : twos_complementer_nbit
    generic map (
      n => 64)
    port map (
      i_A => s_P_raw,
      o_F => s_P_twos_complement);

  multiplier_0: multiplier_array
    port map (
      i_A => s_A_muxed,
      i_B => s_B_muxed,
      o_P => s_P_raw);



  -- keeps i_A always positive
  s_A_muxed <= s_A_twos_complement when (i_A(31) = '1') else i_A;
  -- keeps i_B always positive
  s_B_muxed <= s_B_twos_complement when (i_B(31) = '1') else i_B;
  -- fixes sign of the result of i_A or i_B were negative
  s_P_muxed <= s_P_twos_complement when ((i_A(31) xor i_B(31)) = '1') else s_P_raw;
  -- truncate the 64 bit result into 32 bits
  o_P <= s_P_muxed(31 downto 0);
  
end architecture mixed;
-------------------------------------------------------------------------------
