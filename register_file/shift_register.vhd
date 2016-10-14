-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_vector.all;
-------------------------------------------------------------------------------
entity shift_register is
  
  generic (
    n : natural := 8);                  -- size of the register in bits

  port (
    i_serial      : in  std_logic;      -- serial input
    i_clock       : in  std_logic;      -- clock input
    i_async_clear : in  std_logic;      -- asynchronous clear
    i_async_set   : in  std_logic;      -- asynchronous set
    o_q           : out std_logic_vector (n-1 downto 0));  -- parallel output

end entity shift_register;
-------------------------------------------------------------------------------
architecture structural of shift_register is

  component dff is
    port (
      i_d           : in  std_logic;  -- data input                                                                                           
      o_q           : out std_logic;  -- data output                                                                                           
      o_nq          : out std_logic;  -- inverted data output                                                                                 
      i_clock       : in  std_logic;  -- clock input                                                                                        
      i_async_clear : in  std_logic;  -- asynchronous clear input                                                                             
      i_async_set   : in  std_logic);  -- asynchronous set input                                                                               
  end component dff;

  signal s_interconnect : std_logic_vector (n-2 downto 0);  -- interconnects
                                                            -- for flip flops
  
begin  -- architecture structural

  flip_flops_generator: for i in n-1 downto 0 generate

    msb_dff: if i = n-1 generate
      dff_msb: dff
      port map (
        i_d           => i_serial,
        o_q           => s_interconnect(i),
        o_nq          => open,
        i_async_clear => i_async_clear,
        i_async_set   => i_async_set);
    end generate msb_dff;

    intermediate_dff: if i < n-1 and i > 0 generate
      dff_i: dff
      port map (
        i_d           => s_interconnect(i-1),
        o_q           => s_interconnect(i),
        o_nq          => open,
        i_async_clear => i_async_clear,
        i_async_set   => i_async_set)
    end generate intermediate_dff;

    lsb_dff: if i = 0 generate
      dff_lsb: dff
      port map (
        i_d           => s_interconnect(i-1),
        o_q           => s_interconnect(i),
        o_nq          => open,
        i_async_clear => i_async_clear,
        i_async_set   => i_async_set)
    end generate lsb_dff;
    
  end generate flip_flops_generator;

  o_q <= s_interconnect;

end architecture structural;
-------------------------------------------------------------------------------
