library IEEE;
use IEEE.std_logic_1164.all;

entity pipereg_tb is
  generic(gCLK_HPER   : time := 5 ns);
end pipereg_tb;

architecture behavior of pipereg_tb is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component pipereg
      generic( n : integer := 8);
  port(i_CLK        : in std_logic;     -- Clock input
       i_FLUSH        : in std_logic;     -- Reset input
       i_STALL      : in std_logic;
       i_D          : in std_logic_vector(n-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(n-1 downto 0));   -- Data value output
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic;
  signal s_D, s_Q : std_logic_vector(7 downto 0);
  signal s_STALL : std_logic_vector(3 downto 0);
  signal s_FLUSH  : std_logic_vector(3 downto 0);
  

  signal s_IF : std_logic_vector (7 downto 0);
   signal s_ID : std_logic_vector (7 downto 0);
   signal s_EX : std_logic_vector (7 downto 0);
   signal s_MEM : std_logic_vector (7 downto 0);
   signal s_WB : std_logic_vector (7 downto 0);
begin

  
    IFID: pipereg
  port map(i_CLK => s_CLK, 
           i_FLUSH => s_FLUSH(0),
           i_D   => s_IF,
           o_Q   => s_ID,
           i_STALL => s_STALL(0));

    IDEX: pipereg
  port map(i_CLK => s_CLK, 
           i_FLUSH => s_FLUSH(1),
           i_D   => s_ID,
           o_Q   => s_EX,
           i_STALL => s_STALL(1));


    EXMEM: pipereg
  port map(i_CLK => s_CLK, 
           i_FLUSH => s_FLUSH(2),
           i_D   => s_EX,
           o_Q   => s_MEM,
           i_STALL => s_STALL(2));


    MEMWB: pipereg
  port map(i_CLK => s_CLK, 
           i_FLUSH => s_FLUSH(3),
           i_D   => s_MEM,
           o_Q   => s_WB,
           i_STALL => s_STALL(3));

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

    s_IF <= "00000000";
    s_STALL <= "0000";
    s_FLUSH <= "1111";                  -- initial reset
    wait for cCLK_PER;
    s_FLUSH <= "0000";


    
    wait for cCLK_PER;
    s_IF <= "00000001";

    wait for cCLK_PER;
    s_IF <= "00000010";
    s_STALL <= "0011";
    
    wait for cCLK_PER;
    s_IF <= "00000011";
    
    
    wait for cCLK_PER;
    s_IF <= "00000100";
    s_STALL <= "0000";

    wait;
    
  end process;
  
end behavior;
