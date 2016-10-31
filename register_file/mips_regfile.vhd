library ieee;
use ieee.std_logic_1164.all;
use work.array2d.all;

entity mips_regfile is
  port(i_raddr1  : in  std_logic_vector(4 downto 0);
       i_raddr2  : in  std_logic_vector(4 downto 0);
       i_waddr   : in  std_logic_vector(4 downto 0);
       i_wdata   : in  std_logic_vector(31 downto 0);
       i_wenable : in  std_logic;
       i_clk     : in  std_logic;
       i_rst     : in  std_logic;
       o_rdata1  : out std_logic_vector(31 downto 0);
       o_rdata2  : out std_logic_vector(31 downto 0));
end mips_regfile;

architecture structural of mips_regfile is
  
  component mux32b32to1 is
    port(i_X : in  array32(31 downto 0);
         i_S : in  std_logic_vector(4 downto 0);
         o_Y : out std_logic_vector(31 downto 0)); 
  end component;

  component regn is
    generic(n : integer := 32);
    port(i_CLK : in  std_logic;
         i_RST : in  std_logic;
         i_WE  : in  std_logic;
         i_D   : in  std_logic_vector(n-1 downto 0);
         o_Q   : out std_logic_vector(n-1 downto 0));
  end component;

  component decoder5to32 is
    port(i_X  : in  std_logic_vector(4 downto 0);
         i_En : in  std_logic;
         o_Y  : out std_logic_vector(31 downto 0));
  end component;

  signal s_wregsel : std_logic_vector(31 downto 0);
  signal s_rdata   : array32(31 downto 0);
  
begin

  -- generate registers
  generate_regs : for i in 0 to 31 generate

    null_reg : if i = 0 generate
      reg_0 : regn
        port map(
          i_CLK => i_clk,
          i_RST => i_rst,
          i_WE  => s_wregsel(i),
          i_D   => (others => '0'),
          o_Q   => s_rdata(i)
          );
    end generate null_reg;

    reg_1_31 : if i > 1 generate
      reg_i : regn
        port map(
          i_CLK => i_clk,
          i_RST => i_rst,
          i_WE  => s_wregsel(i),
          i_D   => i_wdata,
          o_Q   => s_rdata(i)
          );
    end generate reg_1_31;

  end generate generate_regs;



  wregsel_decoder : decoder5to32
    port map(
      i_X  => i_waddr,
      i_En => i_wenable,
      o_Y  => s_wregsel
      );

  rdata1_mux : mux32b32to1
    port map(
      i_X => s_rdata,
      i_S => i_raddr1,
      o_Y => o_rdata1
      );

  rdata2_mux : mux32b32to1
    port map(
      i_X => s_rdata,
      i_S => i_raddr2,
      o_Y => o_rdata2
      );


end structural;
