library IEEE;
use IEEE.std_logic_1164.all;

entity overflow is

    port(
    iA          : in std_logic;
    iB          : in std_logic;
    iBinv       : in std_logic;
    iResult     : in std_logic;
    oOverflow   : out std_logic
    );

end overflow;

architecture dataflow of overflow is
    signal ovr : std_logic_vector(3 downto 0);
begin
    -- ovr(3) <= iA;
    -- ovr(2) <= iB;
    -- ovr(1) <= iBinv;
    -- ovr(0) <= iResult;
    --
    -- with ovr select oOverflow <=
    --     '1' when "1100",
    --     '1' when "0001",
    --
    --     '0' when others;
    oOverflow <= (
                    (iA AND iB AND (NOT iBinv) AND (NOT iResult)) OR
                    ((NOT iA) AND (NOT iB) AND (NOT iBinv) AND iResult) OR
                    ((NOT iA) AND iB AND iBinv AND iResult) OR
                    (iA AND (iB) AND iBinv AND (NOT iResult))
                );
end dataflow;
