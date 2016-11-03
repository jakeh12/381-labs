library ieee;
use ieee.std_logic_1164.all;

entity fan_tb is
end fan_tb;

architecture behavior of fan_tb is

component fan_tb is
  generic(
    n : integer := 32
    );
  port(
    i_A, i_B : in std_logic_vector(n-1 downto 0);
    i_Cin : in std_logic;
    o_S : out std_logic_vector(n-1 downto 0);
    o_Cout : out std_logic   
  );
end component;

signal s_A, s_B, s_S1, s_S2 : std_logic_vector(31 downto 0);
signal s_Cin, s_Cout1, s_Cout2 : std_logic;

begin

  DUT1: entity work.fan(structural)
    port map(i_A  => s_A, i_B  => s_B,
             i_Cin => s_Cin,
             o_Cout => s_Cout1,
  	         o_S  => s_S1);

  DUT2: entity work.fan(dataflow)
    port map(i_A  => s_A, i_B  => s_B,
             i_Cin => s_Cin,
             o_Cout => s_Cout2,
  	         o_S  => s_S2);
  	         
  process
  begin

    s_A <= X"00000000";
    s_B <= X"00000000";
    s_Cin <= '0';
    wait for 100 ns;

    s_A <= X"00000000";
    s_B <= X"00000001";
    s_Cin <= '0';
    wait for 100 ns;

    s_A <= X"00000000";
    s_B <= X"00000001";
    s_Cin <= '1';
    wait for 100 ns;
    
    s_A <= X"FFFFFFFF";
    s_B <= X"00000000";
    s_Cin <= '0';
    wait for 100 ns;
    
    s_A <= X"FFFFFFFF";
    s_B <= X"00000001";
    s_Cin <= '0';
    wait for 100 ns;
    
    s_A <= X"FFFFFFFF";
    s_B <= X"00000000";
    s_Cin <= '1';
    wait for 100 ns;
    
	assert false report "end of test" severity note;

	wait;
	
  end process;
  
end behavior;