----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
----------------------------------------------------------------------------------
entity full_adder is
    port ( i_A, i_B, i_Cin : in std_logic;
           o_S, o_Cout : out std_logic );
end full_adder;
----------------------------------------------------------------------------------
architecture dataflow of full_adder is
begin
    o_S <= i_A xor i_B xor i_Cin;
    o_Cout <= (i_A and i_B) or (i_Cin and (i_A xor i_B));
end dataflow;
----------------------------------------------------------------------------------
