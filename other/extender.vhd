library ieee;
use ieee.std_logic_1164.all;

entity extender is
  generic (
    n_small : integer := 16;
    n_big : integer := 32
  ); 
  port (
    i_isSigned : in std_logic;
    i_small : in std_logic_vector(n_small-1 downto 0);
    o_big : out std_logic_vector(n_big-1 downto 0)
  );
end extender;

architecture dataflow of extender is
begin
  o_big <= (n_big-1 downto 16 => i_small(n_small-1) and i_isSigned) & i_small;
end dataflow;