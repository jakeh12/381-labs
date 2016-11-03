library ieee;
use ieee.std_logic_1164.all;

entity fa is
  port(
    i_A, i_B, i_Cin: in std_logic;
    o_S, o_Cout : out std_logic
  );
end fa;

architecture structural of fa is
  
  component xor2 is
    port(
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic
    );
  end component;
  
  component and2 is
    port(
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic
    );
  end component;

  component or2 is
    port(
      i_A : in std_logic;
      i_B : in std_logic;
      o_F : out std_logic
    );
  end component;
  
  signal s_AxorB, s_AxorBandCin, s_AandB : std_logic;
    
begin
  
    xor_0: xor2
      port map(
        i_A => i_A,
        i_B => i_B,
        o_F => s_AxorB
      );
      
    xor_1: xor2
      port map(
        i_A => s_AxorB,
        i_B => i_Cin,
        o_F => o_S
      );
    
    and_0: and2
      port map(
        i_A => i_Cin,
        i_B => s_AxorB,
        o_F => s_AxorBandCin
      );
      
    and_1: and2
      port map(
        i_A => i_A,
        i_B => i_B,
        o_F => s_AandB
      );
      
	or_0: or2
      port map(
        i_A => s_AxorBandCin,
        i_B => s_AandB,
        o_F => o_Cout
      );
  
end structural;
