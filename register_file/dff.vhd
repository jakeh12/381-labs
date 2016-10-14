-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity dff is
  
  port (
    i_d           : in  std_logic;      -- data input
    o_q           : out std_logic;      -- data output
    o_nq          : out std_logic;      -- inverted data output
    i_clock       : in  std_logic;      -- clock input
    i_async_clear : in  std_logic;      -- asynchronous clear input
    i_async_set   : in  std_logic);     -- asynchronous set input

end entity dff;
-------------------------------------------------------------------------------
architecture behavioral of dff is
  
  signal s_data : std_logic;            -- internal data

begin  -- architecture behavioral

  -- purpose: describes behavior of a d flip-flop
  -- type   : sequential
  -- inputs : i_clock, i_async_clear, i_async_set, i_d
  -- outputs: o_q, o_nq
  d_flip_flop : process (i_clock, i_async_clear) is
  begin  -- process d_flip_flop
    if i_async_clear = '1' then         -- asynchronous clear
      s_data <= '0';
    elsif i_async_set = '1' then        -- asynchronous set
      s_data <= '1';
    elsif rising_edge(i_clock) then     -- rising clock edge
      s_data <= i_d;                    -- sample data from the input
    end if;
  end process d_flip_flop;

  o_q  <= s_data;                       -- assign internal data to the output
  o_nq <= not s_data;                   -- assign inverted internal data to the
                                        -- inverted output

end architecture behavioral;
-------------------------------------------------------------------------------
