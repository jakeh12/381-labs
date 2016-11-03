library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fan is
  generic(
    n : integer := 32
    );
  port(
    i_A, i_B : in std_logic_vector(n-1 downto 0);
    i_Cin : in std_logic;
    o_S : out std_logic_vector(n-1 downto 0);
    o_Cout : out std_logic
  );
end fan;

architecture structural of fan is

  component fa is
    port(
      i_A, i_B, i_Cin: in std_logic;
      o_S, o_Cout : out std_logic
    );
  end component;
  
  signal s_C : std_logic_vector(n-1 downto 0);
  
begin

  G1: for i in 0 to n-1 generate
  
    first_stage: if (i = 0) generate
      fa0: fa
      port map(
        i_A => i_A(i), i_B => i_B(i),
        i_Cin => i_Cin,
        o_S => o_S(i),
        o_Cout => s_C(i)
      );
      end generate first_stage;
      
    other_stages: if (i > 0) generate
      fa_i: fa
      port map(
        i_A => i_A(i), i_B => i_B(i),
        i_Cin => s_C(i-1),
        o_S => o_S(i),
        o_Cout => s_C(i)
      );
      
      end generate other_stages;
  
  end generate;
  
  o_Cout <= s_C(n-1);
  
end structural;


architecture dataflow of fan is

  signal u_Cin : unsigned(1 downto 0);
  signal s_S : std_logic_vector(n-1 downto 0);
  
begin
  
  u_Cin <= "0" & i_Cin;
  s_S <= std_logic_vector(unsigned(i_A) + unsigned(i_B) + u_Cin);
  o_S <= s_S;
  o_Cout <= (i_A(n-1) and i_B(n-1)) or (not s_S(n-1) and (i_A(n-1) or i_B(n-1)));
    
end dataflow;
