--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
entity mips_mem_tb is
end mips_mem_tb;
--------------------------------------------------------------------------------
architecture behavioral of mips_mem_tb is


  component mips_mem is
    port (
      i_addr : in std_logic_vector(31 downto 0);
      i_wdata : in std_logic_vector(31 downto 0);
      i_size : in std_logic_vector(1 downto 0);
      i_signed : in std_logic;
      i_wen : in std_logic;
      i_clk : in std_logic;
      o_rdata : out std_logic_vector(31 downto 0)
    );
  end component;

  signal s_addr : std_logic_vector (31 downto 0);
  signal s_wdata : std_logic_vector (31 downto 0);
  signal s_size : std_logic_vector (1 downto 0);
  signal s_signed : std_logic;
  signal s_wen : std_logic;
  signal s_clk : std_logic := '1';
  signal s_rdata : std_logic_vector (31 downto 0);

begin

  s_clk <= not s_clk after 50 ns;

  data_mem: mips_mem
    port map(
      i_addr => s_addr,
      i_wdata => s_wdata,
      i_size => s_size,
      i_signed => s_signed,
      i_wen => s_wen,
      i_clk => s_clk,
      o_rdata => s_rdata
    );


  process
  begin
  
    -- storing half word unsigned extension
    s_addr <= X"0000000" & "0100";
    s_wdata <= X"FFEEDDCC";
    s_size <= "01";
    s_signed <= '0';
    s_wen <= '1';
    wait for 100 ns;
    s_wen <= '0';

    -- reading one byte unsigned extension
    s_addr <= X"0000000" & "0100";
    s_wdata <= X"00000000";
    s_size <= "10";
    s_signed <= '0';
    s_wen <= '0';
    wait for 100 ns;

    s_addr <= X"0000000" & "0101";
    s_wdata <= X"00000000";
    s_size <= "10";
    s_signed <= '0';
    s_wen <= '0';
    wait for 100 ns;

    s_addr <= X"0000000" & "0110";
    s_wdata <= X"00000000";
    s_size <= "10";
    s_signed <= '0';
    s_wen <= '0';
    wait for 100 ns;

    s_addr <= X"0000000" & "0111";
    s_wdata <= X"00000000";
    s_size <= "10";
    s_signed <= '0';
    s_wen <= '0';
    wait for 100 ns;
    
    -- reading one byte, signed extension
    s_addr <= X"0000000" & "0100";
    s_wdata <= X"00000000";
    s_size <= "10";
    s_signed <= '1';
    s_wen <= '0';
    wait for 100 ns;

    s_addr <= X"0000000" & "0101";
    s_wdata <= X"00000000";
    s_size <= "10";
    s_signed <= '1';
    s_wen <= '0';
    wait for 100 ns;

    s_addr <= X"0000000" & "0110";
    s_wdata <= X"00000000";
    s_size <= "10";
    s_signed <= '1';
    s_wen <= '0';
    wait for 100 ns;

    s_addr <= X"0000000" & "0111";
    s_wdata <= X"00000000";
    s_size <= "10";
    s_signed <= '1';
    s_wen <= '0';
    wait for 100 ns;
    
    -- reading half word, unsigned extension
    s_addr <= X"0000000" & "0100";
    s_wdata <= X"00000000";
    s_size <= "01";
    s_signed <= '0';
    s_wen <= '0';
    wait for 100 ns;


    s_addr <= X"0000000" & "0110";
    s_wdata <= X"00000000";
    s_size <= "01";
    s_signed <= '0';
    s_wen <= '0';
    wait for 100 ns;

    -- reading half word, signed extension
    s_addr <= X"0000000" & "0100";
    s_wdata <= X"00000000";
    s_size <= "01";
    s_signed <= '1';
    s_wen <= '0';
    wait for 100 ns;


    s_addr <= X"0000000" & "0110";
    s_wdata <= X"00000000";
    s_size <= "01";
    s_signed <= '1';
    s_wen <= '0';
    wait for 100 ns;

    -- reading full word
    s_addr <= X"0000000" & "0100";
    s_wdata <= X"00000000";
    s_size <= "00";
    s_signed <= '0';
    s_wen <= '0';
    wait for 100 ns;
    
    -- storing full word unsigned extension
    s_addr <= "00000000000000000000010000000000";
    s_wdata <= X"FFFFFFFF";
    s_size <= "00";
    s_signed <= '0';
    s_wen <= '1';
    wait for 100 ns;
    s_wen <= '0';

    wait; 
  end process;

end behavioral;
--------------------------------------------------------------------------------
