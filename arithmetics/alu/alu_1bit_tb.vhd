library IEEE;
use IEEE.std_logic_1164.all;

entity alu_1bit_tb is
end alu_1bit_tb;

architecture dataflow of alu_1bit_tb is



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

signal a, b, inv,s_ic,s_less,s_oc, ores : std_logic := '0';
signal s : std_logic_vector(2 downto 0);

begin

    --invert b if needed
        comp: alu_1bit
        port map(
        iA      => a,
        iB      => b,
        iBinv   => inv,
        iC      =>s_ic,
        sel     => s,
        less    =>s_less,
        oC      =>s_oc,
        oRe     => ores
        );

    process
    begin

        --AND
        a <= '1';
        b <= '0';
        inv <= '0';
       s_ic <= '0';
        s <= "000";
        s_less <= '1';
        wait for 20 ns;

        --OR
        s <= "001";
        wait for 20 ns;
        --XOR
        s <= "010";
        wait for 20 ns;
        --NAND
        s <= "011";
        wait for 20 ns;
        --NOR
        s <= "100";
        wait for 20 ns;
        --ADD
        s <= "101";
        wait for 20 ns;
        --SUB
        s_ic <='1';
        inv <= '1';
        wait for 20 ns;
        --LESS
        s <= "110";
        wait for 20 ns;

    end process;



end dataflow;
