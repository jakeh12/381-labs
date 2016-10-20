library ieee;
use ieee.std_logic_1164.all;

entity mips_regfile_tb is
end mips_regfile_tb;

architecture behavior of mips_regfile_tb is
  
  component mips_regfile is
    port(i_raddr1  : in  std_logic_vector(4 downto 0);
         i_raddr2  : in  std_logic_vector(4 downto 0);
         i_waddr   : in  std_logic_vector(4 downto 0);
         i_wdata   : in  std_logic_vector(31 downto 0);
         i_wenable : in  std_logic;
         i_clk     : in  std_logic;
         i_rst     : in  std_logic;
         o_rdata1  : out std_logic_vector(31 downto 0);
         o_rdata2  : out std_logic_vector(31 downto 0));
  end component;

  signal s_raddr1  : std_logic_vector(4 downto 0)  := (others => '0');
  signal s_raddr2  : std_logic_vector(4 downto 0)  := (others => '0');
  signal s_waddr   : std_logic_vector(4 downto 0)  := (others => '0');
  signal s_wdata   : std_logic_vector(31 downto 0) := (others => '0');
  signal s_wenable : std_logic                     := '0';
  signal s_rst     : std_logic                     := '0';
  signal s_rdata1  : std_logic_vector(31 downto 0) := (others => '0');
  signal s_rdata2  : std_logic_vector(31 downto 0) := (others => '0');
  signal s_clk     : std_logic                     := '1';
  
begin

  DUT : mips_regfile
    port map(
      i_raddr1  => s_raddr1,
      i_raddr2  => s_raddr2,
      i_waddr   => s_waddr,
      i_wdata   => s_wdata,
      i_wenable => s_wenable,
      i_clk     => s_clk,
      i_rst     => s_rst,
      o_rdata1  => s_rdata1,
      o_rdata2  => s_rdata2
      );

  s_clk <= not s_clk after 50 ns;

  simulation : process
  begin

    -- reset all registers
    s_rst <= '1';
    wait for 100 ns;
    s_rst <= '0';

    -- write AAAAAAAA into reg $2
    s_waddr   <= "00010";
    s_wdata   <= X"AAAAAAAA";
    s_wenable <= '1';
    wait for 100 ns;
    s_wenable <= '0';

    -- read reg $2
    s_raddr1 <= "00010";
    wait for 100 ns;

    -- write BBBBBBBB into reg $4
    s_waddr   <= "00100";
    s_wdata   <= X"BBBBBBBB";
    s_wenable <= '1';
    wait for 100 ns;
    s_wenable <= '0';

    -- read reg $4
    s_raddr2 <= "00100";
    wait for 100 ns;

    -- attempt to write CCCCCCCC to $0
    s_waddr   <= "00000";
    s_wdata   <= X"CCCCCCCC";
    s_wenable <= '1';
    wait for 100 ns;
    s_wenable <= '0';

    -- read reg $4
    s_raddr1 <= "00000";
    wait for 100 ns;

    -- reset all registers
    s_rst <= '1';
    wait for 100 ns;
    s_rst <= '0';

    -- write AAAAAAAA into reg $2 WITHOUT wenable
    s_waddr   <= "00010";
    s_wdata   <= X"FFFFFFFF";
    s_wenable <= '0';
    wait for 100 ns;
    s_wenable <= '0';

    -- read reg $2
    s_raddr1 <= "00010";
    wait for 200 ns;

    assert false report "end of test" severity note;
    wait;
  end process;
  
end behavior;
