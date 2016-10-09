library IEEE;
use IEEE.std_logic_1164.all;

entity alu_32bit is

    port(
        iA          : in std_logic_vector(31 downto 0);
        iB          : in std_logic_vector(31 downto 0);
        iOP         : in std_logic_vector(2 downto 0);
        oZero       : out std_logic;
        oResult     : out std_logic_vector(31 downto 0);
        oOverflow   : out std_logic
    );

end alu_32bit;

architecture structure of alu_32bit is

    --components
    component alu_1bit is
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
    end component;

    component alu_1bit_overflow is
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
    end component;

    --signals
    signal sig_invert : std_logic;
    signal op_to_sel :std_logic_vector(2 downto 0);
    signal oC_to_iC : std_logic_vector(31 downto 0);
    signal sig_less : std_logic;

    --logic
begin

    invert <= '1' when iOP = "110" else
        '1' when iOP = "111" else
        --'0' when others;

    op_to_sel <= "110" when iOP = "111" else
        "101" when iOP = "110" else
        "101" when iOP = "101" else
        iOP;

    alu_1bit_i: alu_1bit
        port map(
            iA => iA(0),
            iB => iB(0),
            iBinv => invert,
            iC => invert,
            sel => op_to_sel,
            less => sig_less,
            oC => oC_to_iC(0),
            oRe => oResult(0)
        );

    G1: for i in 1 to 30 generate
        alu_1bit_i_gen: alu_1bit
            port map(
                iA => iA(i),
                iB => iB(i),
                iBinv => invert,
                iC => oC_to_iC(i-1),
                sel => op_to_sel,
                less => '0',
                oC => oC_to_iC(i),
                oRe => oResult(i)
            );
    end generate;

        alu_1bit_overflow_i: alu_1bit_overflow
            port map(
                iA => iA(31),
                iB => iB(31),
                iBinv => invert,
                iC => invert,
                sel => op_to_sel,
                less => '0',
                oC => oC,
                oRe => oResult(31),
                oSet => sig_less
            );

end structure;
