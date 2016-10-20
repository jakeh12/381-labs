library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.array2d.all;

entity mux32b32to1_tb is
end mux32b32to1_tb;

architecture behavior of mux32b32to1_tb is
  
  component mux32b32to1
    port(i_X : in array32(31 downto 0); -- input ports
       i_S : in std_logic_vector(4 downto 0); -- select line
       o_Y : out std_logic_vector(31 downto 0));   -- decoded value
  end component;
  
  signal s_X : array32(31 downto 0) := (
	  X"0000001F",
	  X"0000001E",
	  X"0000001D",
	  X"0000001C",
	  X"0000001B",
	  X"0000001A",
	  X"00000019",
	  X"00000018",
	  X"00000017",
	  X"00000016",
	  X"00000015",
	  X"00000014",
	  X"00000013",
	  X"00000012",
	  X"00000011",
	  X"00000010",
	  X"0000000F",
	  X"0000000E",
	  X"0000000D",
	  X"0000000C",
	  X"0000000B",
	  X"0000000A",
	  X"00000009",
	  X"00000008",
	  X"00000007",
	  X"00000006",
	  X"00000005",
	  X"00000004",
	  X"00000003",
	  X"00000002",
	  X"00000001",
	  X"00000000");
    
  signal s_S : std_logic_vector(4 downto 0) := (others => '0');
  signal s_Y : std_logic_vector(31 downto 0);


begin

  DUT: mux32b32to1
  port map(i_X => s_X,
           i_S => s_S,
           o_Y => s_Y);
           
  s_S(0) <= not s_S(0) after 10 ns;
  s_S(1) <= not s_S(1) after 20 ns;
  s_S(2) <= not s_S(2) after 40 ns;
  s_S(3) <= not s_S(3) after 80 ns;
  s_S(4) <= not s_S(4) after 160 ns;
  
  process
  begin
    wait for 320 ns;  
    wait;
  end process;
  
end behavior;
