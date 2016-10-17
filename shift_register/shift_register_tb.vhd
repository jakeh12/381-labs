-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity shift_register_tb is
end entity shift_register_tb;
-------------------------------------------------------------------------------
architecture behavioral of shift_register_tb is

  component shift_register is
  generic (
    n : natural := 8);                  -- size of the register in bits                       
  port (
    i_serial      : in  std_logic;      -- serial input
    i_clock       : in  std_logic;      -- clock input
    i_async_clear : in  std_logic;      -- asynchronous clear
    i_async_set   : in  std_logic;      -- asynchronous set
    o_q           : out std_logic_vector (n-1 downto 0));  -- parallel output 
  end component;

  signal s_serial, s_clock, s_async_clear, s_async_set : std_logic;
  signal s_q : std_logic_vector (7 downto 0);
  
begin  -- architecture behavioral

  DUT: shift_register
    port map (
      i_serial      => s_serial,
      i_clock       => s_clock,
      i_async_clear => s_async_clear,
      i_async_set   => s_async_set,
      o_q           => s_q);

  
  -- purpose: creates clock signal
  tick_clock: process is
  begin  -- process tick_clock
    s_clock <= '1';
    wait for 5 ns;
    s_clock <= '0';
    wait for 5 ns;
  end process tick_clock;


  -- purpose: test the component shift register
  testbench: process is
  begin

    -- initialize all signals
    s_serial <= '0';
    s_async_clear <= '0';
    s_async_set <= '0';
    wait for 10 ns;

    -- set register for two clock cycles
    s_async_set <= '1';
    wait for 20 ns;
    s_async_set <= '0';

    -- clear register for two clock cycles
    s_async_clear <= '1';
    wait for 20 ns;
    s_async_clear <= '0';

    -- shift in "11101101"
    s_serial <= '1';
    wait for 10 ns;
    s_serial <= '0';
    wait for 10 ns;
    s_serial <= '1';
    wait for 10 ns;
    s_serial <= '1';
    wait for 10 ns;
    s_serial <= '0';
    wait for 10 ns;
    s_serial <= '1';
    wait for 10 ns;
    s_serial <= '1';
    wait for 10 ns;
    s_serial <= '1';
    wait for 10 ns;

    wait;
  
  end process testbench;

end architecture behavioral;
