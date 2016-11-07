--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------------------
entity mips_mem is
  port (
    i_addr   : in  std_logic_vector(31 downto 0);
    i_wdata  : in  std_logic_vector(31 downto 0);
    i_size   : in  std_logic_vector(1 downto 0);
    i_signed : in  std_logic;
    i_wen    : in  std_logic;
    i_clk    : in  std_logic;
    o_rdata  : out std_logic_vector(31 downto 0)
    );
end mips_mem;
--------------------------------------------------------------------------------
architecture behavioral of mips_mem is

component ram_wbe is
  
    generic (
    init_file : string  := "dmem.mif";  -- memory intialization file
     l         : natural := 10);           -- width of address bus in bits
  
  port (
    i_byteena : in std_logic_vector (3 downto 0);  -- byte enable for write
    i_addr  : in  std_logic_vector (l-1 downto 0);   -- address input
    i_wdata : in  std_logic_vector (31 downto 0);   -- data input
    i_wen   : in  std_logic;                         -- write enable
    o_rdata : out std_logic_vector (31 downto 0);  -- data output
    i_clk   : in std_logic);            -- clock input

end component;
  

  signal s_address : std_logic_vector (9 downto 0);
  signal s_byteena : std_logic_vector (3 downto 0);
  signal s_data    : std_logic_vector (31 downto 0);
  signal s_q       : std_logic_vector (31 downto 0);

  alias a_full_word : std_logic_vector (31 downto 0) is s_q (31 downto 0);

  alias a_upper_half : std_logic_vector (15 downto 0) is s_q (31 downto 16);
  alias a_lower_half : std_logic_vector (15 downto 0) is s_q (15 downto 0);

  alias a_highest_byte : std_logic_vector (7 downto 0) is s_q (31 downto 24);
  alias a_higher_byte  : std_logic_vector (7 downto 0) is s_q (23 downto 16);
  alias a_lower_byte   : std_logic_vector (7 downto 0) is s_q (15 downto 8);
  alias a_lowest_byte  : std_logic_vector (7 downto 0) is s_q (7 downto 0);

  constant FULL_WORD : std_logic_vector (1 downto 0) := "00";
  constant HALF_WORD : std_logic_vector (1 downto 0) := "01";
  constant BYTE_WORD : std_logic_vector (1 downto 0) := "10";

begin

  dmem : ram_wbe
    port map(
      i_addr => s_address,
      i_byteena => s_byteena,
      i_clk => i_clk,
      i_wdata => s_data,
      i_wen => i_wen,
      o_rdata  => s_q
      );


  mimps_mem : process (i_clk, i_wen, i_size, i_addr, i_signed)
  begin

    s_address <= i_addr(11 downto 2);

    case i_size is

      -- loading or storing FULL WORD
      when FULL_WORD =>
        s_data    <= i_wdata;
        o_rdata   <= a_full_word;
        s_byteena <= "1111";

        -- loading or storing HALF WORD
      when HALF_WORD =>
        s_data <= i_wdata(15 downto 0) & i_wdata(15 downto 0);
        if (i_addr(1) = '0') then
          s_byteena <= "0011";
          o_rdata   <= (31 downto 16 => a_lower_half(15) and i_signed) & a_lower_half;
        else
          s_byteena <= "1100";
          o_rdata   <= (31 downto 16 => a_upper_half(15) and i_signed) & a_upper_half;
        end if;

        -- loading or storing BYTE
      when BYTE_WORD =>
        s_data <= i_wdata(7 downto 0) & i_wdata(7 downto 0) & i_wdata(7 downto 0) & i_wdata(7 downto 0);
        if (i_addr(1 downto 0) = "00") then
          s_byteena <= "0001";
          o_rdata   <= (31 downto 8 => a_lowest_byte(7) and i_signed) & a_lowest_byte;
        elsif (i_addr(1 downto 0) = "01") then
          s_byteena <= "0010";
          o_rdata   <= (31 downto 8 => a_lower_byte(7) and i_signed) & a_lower_byte;
        elsif (i_addr(1 downto 0) = "10") then
          s_byteena <= "0100";
          o_rdata   <= (31 downto 8 => a_higher_byte(7) and i_signed) & a_higher_byte;
        else
          s_byteena <= "1000";
          o_rdata   <= (31 downto 8 => a_highest_byte(7) and i_signed) & a_highest_byte;
        end if;

      when others =>
        o_rdata   <= (others => '0');
        s_data    <= (others => '0');
        s_byteena <= "0000";

    end case;
  end process;

end behavioral;
--------------------------------------------------------------------------------
