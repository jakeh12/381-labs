library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mips_multiplier_tb is  
end entity mips_multiplier_tb;

architecture behavioral of mips_multiplier_tb is

  component  mips_multiplier is
    port (
      i_A : in  std_logic_vector (31 downto 0);   -- multiplicant                                                                                    
      i_B : in  std_logic_vector (31 downto 0);   -- multiplier                                                                                    
      o_P : out std_logic_vector (31 downto 0));  -- product
  end component;

  signal s_A, s_B, s_P : std_logic_vector (31 downto 0);
  
begin  -- architecture behavioral

  DUT: mips_multiplier
    port map (
      i_A => s_A,
      i_B => s_B,
      o_P => s_P);

  -- purpose: tests component mips multiplier
  -- type   : combinational
  testbench: process is
  begin  -- process testbench

    -- case 0 * 0
    s_A <= std_logic_vector(to_signed(0, 32));
    s_B <= std_logic_vector(to_signed(0, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;
    

    -- case 1 * 1
    s_A <= std_logic_vector(to_signed(1, 32));
    s_B <= std_logic_vector(to_signed(1, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;


    -- case -1 * 1
    s_A <= std_logic_vector(to_signed(-1, 32));
    s_B <= std_logic_vector(to_signed(1, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;


    -- case 1 * -1
    s_A <= std_logic_vector(to_signed(1, 32));
    s_B <= std_logic_vector(to_signed(-1, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;

    -- case -1 * -1
    s_A <= std_logic_vector(to_signed(-1, 32));
    s_B <= std_logic_vector(to_signed(-1, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;

    -- case 256 * 256
    s_A <= std_logic_vector(to_signed(256, 32));
    s_B <= std_logic_vector(to_signed(256, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;

    -- case -13 * 21
    s_A <= std_logic_vector(to_signed(-13, 32));
    s_B <= std_logic_vector(to_signed(21, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;

    -- case 24 * 12
    s_A <= std_logic_vector(to_signed(24, 32));
    s_B <= std_logic_vector(to_signed(12, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;

    -- case -1000 * -100000
    s_A <= std_logic_vector(to_signed(-1000, 32));
    s_B <= std_logic_vector(to_signed(-100000, 32));
    assert (to_integer(signed(s_P)) = (to_integer(signed(s_A)) * to_integer(signed(s_B)))) report "error: " & integer'image(to_integer(signed(s_A))) & " * " & integer'image(to_integer(signed(s_B))) & " = " & integer'image(to_integer(signed(s_P))) severity error;
    wait for 10 ns;

    
    wait;
    end process testbench;

end architecture behavioral;
