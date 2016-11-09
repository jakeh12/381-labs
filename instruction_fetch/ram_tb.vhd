-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------
entity ram_tb is
end entity ram_tb;
-------------------------------------------------------------------------------
architecture behavioral of ram_tb is

  component ram is
    generic (
      n         : natural := 32;         -- width of word in bits
      l         : natural := 8;  -- width of address bus in bits                                 
      init_file : string  := "ram.mif");  -- memory intialization file
    port (
      i_addr  : in  std_logic_vector (l-1 downto 0);  -- address input
      i_wdata : in  std_logic_vector (n-1 downto 0);  -- data input
      o_rdata : out std_logic_vector (n-1 downto 0);  -- data output
      i_wen   : in  std_logic;
      i_clk   : in  std_logic);
  end component ram;

  signal s_addr  : std_logic_vector (7 downto 0);
  signal s_rdata : std_logic_vector (31 downto 0);
  signal s_wdata : std_logic_vector (31 downto 0);
  signal s_wen   : std_logic;
  signal s_clk   : std_logic;
  
begin  -- architecture behavioral

  clock : process is
  begin
    s_clk <= '1';
    wait for 5 ns;
    s_clk <= '0';
    wait for 5 ns;
  end process clock;

  DUT : ram
    port map (
      i_addr  => s_addr,
      o_rdata => s_rdata,
      i_wdata => s_wdata,
      i_wen   => s_wen,
      i_clk   => s_clk);

  process is
  begin  -- process
    
    s_addr <= "00000000";
    s_wdata <= X"00000000";
    s_wen <= '0';
    wait for 10 ns;

    -- test reading initial values
    for i in 0 to 255 loop
      s_addr <= std_logic_vector(to_unsigned(i, 8));
      wait for 10 ns;
      assert s_rdata = std_logic_vector(to_unsigned(255-i, 32))
        report "rom test failed, unexpected value at address "
        & integer'image(i)
        severity error;
    end loop;

    -- test writing ordered values
    for i in 0 to 255 loop
      s_addr <= std_logic_vector(to_unsigned(i, 8));
      s_wdata <= std_logic_vector(to_unsigned(i, 32));
      s_wen <= '1';
      wait for 10 ns;
      s_wen <= '0';
      assert s_rdata = std_logic_vector(to_unsigned(255-i, 32))
        report "rom test failed, unexpected value at address "
        & integer'image(i)
        severity error;
    end loop;

    -- test reading written values
    for i in 0 to 255 loop
      s_addr <= std_logic_vector(to_unsigned(i, 8));
      wait for 10 ns;
      assert s_rdata = std_logic_vector(to_unsigned(i, 32))
        report "rom test failed, unexpected value at address "
        & integer'image(i)
        severity error;
    end loop;


    -- test reading written values
    s_addr <= "00000000";
    s_wdata <= x"10101010";
    s_wen <= '0';
    wait for 10 ns;
    assert s_rdata = x"00000000"
    report "rom test failed, wen does not prevent write"
    severity error;
   
    wait;
  end process;
  
end architecture behavioral;
-------------------------------------------------------------------------------
