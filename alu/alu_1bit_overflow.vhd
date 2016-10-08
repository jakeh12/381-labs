library IEEE;
use IEEE.std_logic_1164.all;


entity alu_1bit_overflow is
    port(
    iA      : in std_logic;
    iB      : in std_logic;
    iBinv   :in std_logic;
    iC      : in std_logic;
    sel     : in std_logic_vector(2 downto 0);
    less    : in std_logic;
    oC      : out std_logic;
    oRe     : out std_logic;
    oSet    : out std_logic
    );
end alu_1bit_overflow;

architecture structural of alu_1bit_overflow is

    --components

    component alu_1bit is
        port(
        iA      : in std_logic;
        iB      : in std_logic;
        iBinv   :in std_logic;
        iC      : in std_logic;
        sel     : in std_logic_vector(2 downto 0);
        less    : in std_logic;
        oC      : out std_logic;
        oRe     : out std_logic
        );
    end component;

    component overflow is
        port(
        iA          : in std_logic;
        iB          : in std_logic;
        iBinv       : in std_logic;
        iResult     : in std_logic;
        oOverflow   : out std_logic
        );

    end component;

    --Signals
    signal iB_mux_out : std_logic;
    signal fAdder_out : std_logic;

begin

    iB_mux_out <= iB when iBinv = '0' else
        (NOT iB) when iBinv = '1';

    fAdder_out <= ((iA XOR iB_mux_out) XOR iC);

    fAdder_out => oSet;

    alu_1bit_i: alu_1bit
        port map(
            iA => iA,
            iB => iB,
            iBinv => iBinv,
            iC => iC,
            sel => sel,
            less => less,
            oC => oC,
            oRe => oRe
        );

    overflow_i: overflow
        port map(
        iA => iA,
        iB_mux_out => iB,
        iBinv => iBinv,
        fadder_out => iResult,
        oOverflow => oRe
        );

end structural;
