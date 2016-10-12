library IEEE;
use IEEE.std_logic_1164.all;

entity alu_1bit is
    port(
    iA      : in std_logic;
    iB      : in std_logic;
    iBinv   : in std_logic;
    iC      : in std_logic;
    sel     : in std_logic_vector(2 downto 0);
    less    : in std_logic;
    oC      : out std_logic;
    oRe     : out std_logic
    );
end alu_1bit;

architecture dataflow of alu_1bit is

    signal iB_mux_out: std_logic;

begin

    --invert b if needed
    iB_mux_out <= iB when iBinv = '0' else
        (NOT iB) when iBinv = '1';

    --output result
    oRe <= (iA AND iB_mux_out)          when sel = "000" else
        (iA OR iB_mux_out)              when sel = "001" else
        (iA XOR iB_mux_out)             when sel = "010" else
        (iA NAND iB_mux_out)            when sel = "011" else
        (iA NOR iB_mux_out)             when sel = "100" else
        ((iA XOR iB_mux_out) XOR iC)    when sel = "101" else
        less                            when sel = "110";

    --carry out
    oC <= ((iA AND iB_mux_out) OR (iA AND iC) OR (iB_mux_out AND iC));


end dataflow;
