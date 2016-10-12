library IEEE;
use IEEE.std_logic_1164.all;

entity alu_32bit_tb is
end alu_32bit_tb;

architecture dataflow of alu_32bit_tb is

    --components
    component alu_32bit is

        port(
            iA          : in std_logic_vector(31 downto 0);
            iB          : in std_logic_vector(31 downto 0);
            iOP         : in std_logic_vector(3 downto 0);
            oZero       : out std_logic;
            oResult     : out std_logic_vector(31 downto 0);
            oOverflow   : out std_logic
        );

    end component;

    signal a, b, result: std_logic_vector(31 downto 0);
    signal op : std_logic_vector(3 downto 0);

    signal zero, overflow : std_logic;

    begin

        comp: alu_32bit
        port map(
        iA          => a,
        iB          => b,
        iOP         => op,
        oZero       => zero,
        oResult     => result,
        oOverflow   => overflow
        );

        process
        begin

            a <= x"80000000";
            b <= x"80000000";
            --test AND
            op <= "0000";
            wait for 20 ns;
            --test OR
            op <= "0001";
            wait for 20 ns;
            --test XOR
            op <= "0010";
            wait for 20 ns;
            --test NAND
            op <= "0011";
            wait for 20 ns;
            --test NOR
            op <= "0100";
            wait for 20 ns;
            --test ADDU
            op <= "0101";
            wait for 20 ns;
            --test SUBU
            op <= "0110";
            wait for 20 ns;
            --test SLT
            op <= "0111";
            wait for 20 ns;
            --test ADD
            op <= "1000";
            wait for 20 ns;
            --test SUB
            op <= "1001";
            wait for 20 ns;

            a <= x"EFFFFFFF";
            b <= x"00000001";
            --test AND
            op <= "0000";
            wait for 20 ns;
            --test OR
            op <= "0001";
            wait for 20 ns;
            --test XOR
            op <= "0010";
            wait for 20 ns;
            --test NAND
            op <= "0011";
            wait for 20 ns;
            --test NOR
            op <= "0100";
            wait for 20 ns;
            --test ADDU
            op <= "0101";
            wait for 20 ns;
            --test SUBU
            op <= "0110";
            wait for 20 ns;
            --test SLT
            op <= "0111";
            wait for 20 ns;
            --test ADD
            op <= "1000";
            wait for 20 ns;
            --test SUB
            op <= "1001";
            wait for 20 ns;

            a <= x"FFFFFFFE";
            b <= x"00000001";
            --test AND
            op <= "0000";
            wait for 20 ns;
            --test OR
            op <= "0001";
            wait for 20 ns;
            --test XOR
            op <= "0010";
            wait for 20 ns;
            --test NAND
            op <= "0011";
            wait for 20 ns;
            --test NOR
            op <= "0100";
            wait for 20 ns;
            --test ADDU
            op <= "0101";
            wait for 20 ns;
            --test SUBU
            op <= "0110";
            wait for 20 ns;
            --test SLT
            op <= "0111";
            wait for 20 ns;
            --test ADD
            op <= "1000";
            wait for 20 ns;
            --test SUB
            op <= "1001";
            wait for 20 ns;

        end process;


end dataflow;
