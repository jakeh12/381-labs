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
begin
    oOverflow <= (  (iA AND iB AND (NOT iBinv) AND (NOT iResult)) OR
                    ((NOT iA) AND (NOT iB) AND (NOT iBinv) AND iResult) OR
                    ((NOT iA) AND iB AND iBinv AND iResult) OR
                    (iA AND (NOT iB) AND iBinv AND (NOT iResult))
                );
end dataflow;
