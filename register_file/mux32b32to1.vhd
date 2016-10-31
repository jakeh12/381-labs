library ieee;
use ieee.std_logic_1164.all;
use work.array2d.all;

entity mux32b32to1 is
  port(i_X : in array32(31 downto 0); -- input ports
       i_S : in std_logic_vector(4 downto 0); -- select line
       o_Y : out std_logic_vector(31 downto 0));   -- decoded value
end mux32b32to1;

architecture dataflow of mux32b32to1 is

begin
	with i_S select
		o_Y <= i_X(0) when "00000", -- 00
		       i_X(1) when "00001", -- 01
		       i_X(2) when "00010", -- 02
		       i_X(3) when "00011", -- 03
		       i_X(4) when "00100", -- 04
		       i_X(5) when "00101", -- 05
		       i_X(6) when "00110", -- 06
		       i_X(7) when "00111", -- 07
		       i_X(8) when "01000", -- 08
		       i_X(9) when "01001", -- 09
		       i_X(10) when "01010", -- 0A
		       i_X(11) when "01011", -- 0B
		       i_X(12) when "01100", -- 0C
		       i_X(13) when "01101", -- 0D
		       i_X(14) when "01110", -- 0E
		       i_X(15) when "01111", -- 0F
		       i_X(16) when "10000", -- 10
		       i_X(17) when "10001", -- 11
		       i_X(18) when "10010", -- 12
		       i_X(19) when "10011", -- 13
		       i_X(20) when "10100", -- 14
		       i_X(21) when "10101", -- 15
		       i_X(22) when "10110", -- 16
		       i_X(23) when "10111", -- 17
		       i_X(24) when "11000", -- 18
		       i_X(25) when "11001", -- 19
		       i_X(26) when "11010", -- 1A
		       i_X(27) when "11011", -- 1B
		       i_X(28) when "11100", -- 1C
		       i_X(29) when "11101", -- 1D
		       i_X(30) when "11110", -- 1E
		       i_X(31) when "11111", -- 1F
		       "00000000000000000000000000000000" when others;  -- other
end dataflow;
