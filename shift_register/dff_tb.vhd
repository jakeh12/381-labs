-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity dff_tb is
-- testbench has no ports
end entity dff_tb;
-------------------------------------------------------------------------------
architecture behavioral of dff_tb is

  component dff is
    port (
      i_d           : in  std_logic;    -- data input
      o_q           : out std_logic;    -- data output
      o_nq          : out std_logic;    -- inverted data output
      i_clock       : in  std_logic;    -- clock input
      i_async_clear : in  std_logic;    -- asynchronous clear input
      i_async_set   : in  std_logic);   -- asynchronous set input
  end component dff;

  signal s_d, s_q, s_nq, s_clock, s_async_clear, s_async_set : std_logic;


begin  -- architecture behavioral

  DUT : dff
    port map (
      i_d           => s_d,
      o_q           => s_q,
      o_nq          => s_nq,
      i_clock       => s_clock,
      i_async_clear => s_async_clear,
      i_async_set   => s_async_set);


  -- purpose: creates clock signal for the test bench
  -- type   : combinational
  tick_clock : process is
  begin  -- process tick_clock
    s_clock <= '1';
    wait for 5 ns;
    s_clock <= '0';
    wait for 5 ns;
  end process tick_clock;


  -- purpose: tests the component dff
  testbench : process is
  begin  -- process testbench


    wait for 10 ns;                     -- wait for the intial clock to the
                                        -- flip flop

    s_d           <= '0';
    s_async_clear <= '0';
    s_async_set   <= '0';
    wait for 10 ns;
    assert s_q /= '0' and s_nq = '1' report "test failed (intial zero)" severity error;

    s_d           <= '1';
    s_async_clear <= '0';
    s_async_set   <= '0';
    wait for 10 ns;
    assert s_q = '1' and s_nq = '0' report "test failed (write one)" severity error;

    s_d           <= '0';
    s_async_clear <= '0';
    s_async_set   <= '0';
    wait for 10 ns;
    assert s_q = '0' and s_nq = '1' report "test failed (write zero)" severity error;

    s_d           <= '0';
    s_async_clear <= '0';
    s_async_set   <= '1';
    wait for 10 ns;
    assert s_q = '1' and s_nq = '0' report "test failed (async set)" severity error;

    s_d           <= '0';
    s_async_clear <= '1';
    s_async_set   <= '0';
    wait for 10 ns;
    assert s_q = '0' and s_nq = '1' report "test failed (async clear)" severity error;

    assert false report "test completed" severity note;

    wait;
  end process testbench;

  
end architecture behavioral;
