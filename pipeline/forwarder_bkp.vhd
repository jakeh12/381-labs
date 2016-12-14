library IEEE;
use IEEE.std_logic_1164.all;

entity forwarder is
  port (
    i_ID_ALUInputBSource       : in  std_logic;  --used to find if we need to forward Rt
    i_ID_Rs                    : in  std_logic_vector (4 downto 0);
    i_ID_Rt                    : in  std_logic_vector (4 downto 0);
    i_IDEX_RegWriteEnable      : in  std_logic;
    i_IDEX_Rs                  : in  std_logic_vector (4 downto 0);
    i_IDEX_Rt                  : in  std_logic_vector (4 downto 0);
    i_IDEX_WB                  : in  std_logic_vector (4 downto 0);
    i_EXMEM_RegWriteEnable     : in  std_logic;
    i_EXMEM_RegWriteDataSource : in  std_logic_vector (1 downto 0);
    i_EXMEM_Rs                 : in  std_logic_vector (4 downto 0);
    i_EXMEM_Rt                 : in  std_logic_vector (4 downto 0);
    i_EXMEM_WB                 : in  std_logic_vector (4 downto 0);
    o_FWD_ID_RsSource          : out std_logic_vector (1 downto 0);
    o_FWD_ID_RtSource          : out std_logic_vector (1 downto 0);
    o_FWD_EX_InputASource      : out std_logic;
    o_FWD_EX_InputBSource      : out std_logic);
end forwarder;

architecture behavioural of forwarder is
begin
  aluInputs_forwarder : process (i_IDEX_Rs, i_IDEX_Rt, i_ID_Rt, i_IDEX_WB, i_IDEX_RegWriteEnable, i_EXMEM_RegWriteEnable, i_EXMEM_RegWriteDataSource)
  begin
    --forward to ALU
    --if mem is using a load
    if i_EXMEM_RegWriteDataSource = "01" then
      if i_IDEX_Rs = i_EXMEM_WB and i_EXMEM_RegWriteEnable = '1' then o_FWD_EX_InputASource <= '1';
      else o_FWD_EX_InputASource                                                            <= '0';
      end if;

      if i_IDEX_Rt = i_EXMEM_WB and i_EXMEM_RegWriteEnable = '1' then o_FWD_EX_InputBSource <= '1';
      else o_FWD_EX_InputBSource                                                            <= '0';
      end if;
      -- if it is not a load then all info should have already been forwarded in previous stage
    else
      o_FWD_EX_InputASource <= '0';
      o_FWD_EX_InputBSource <= '0';
    end if;
  end process;


  rs_forwarder : process (i_ID_Rs, i_IDEX_WB, i_IDEX_RegWriteEnable, i_EXMEM_RegWriteEnable, i_EXMEM_RegWriteDataSource)
  begin
    --if rs is the zero register
    if i_ID_Rs = "00000" then o_FWD_ID_RsSource                                                                              <= "00";
                              --if rs matches the write back of idex
    elsif i_ID_Rs = i_IDEX_WB and i_IDEX_RegWriteEnable = '1' then o_FWD_ID_RsSource                                         <= "01";
                                        --if rs matches the writeback of exmem and exmem is a load instruction
    elsif i_ID_Rs = i_EXMEM_WB and i_EXMEM_RegWriteEnable = '1' and i_EXMEM_RegWriteDataSource = "01" then o_FWD_ID_RsSource <= "10";
                                        --if rs matches the writeback of exmem and exmem is NOT a load
    elsif i_ID_Rs = i_EXMEM_WB and i_EXMEM_RegWriteEnable                                                                    <= '1' then o_FWD_ID_RsSource <= "11";
                                        --else dont forward
    else o_FWD_ID_RsSource                                                                                                   <= "00";
    end if;
  end process;


  rt_forwarder : process (i_ID_Rt, i_IDEX_WB, i_IDEX_RegWriteEnable, i_EXMEM_RegWriteEnable, i_EXMEM_RegWriteDataSource)
  begin
    --if rt is an I type
    if i_ID_ALUInputBSource = '1' then o_FWD_ID_RtSource                                                                     <= "00";
                                       --if rt is zero register
    elsif i_ID_Rt = "00000" then o_FWD_ID_RtSource                                                                           <= "00";
                                 --if rt is the WB of idex
    elsif i_ID_Rt = i_IDEX_WB and i_IDEX_RegWriteEnable = '1' then o_FWD_ID_RtSource                                         <= "01";
                                        --if rt matches WB of exmem and exmem is a load
    elsif i_ID_Rt = i_EXMEM_WB and i_EXMEM_RegWriteEnable = '1' and i_EXMEM_RegWriteDataSource = "01" then o_FWD_ID_RtSource <= "10";
                                        --if rt matches wb of exmem and is NOT a load
    elsif i_ID_Rt = i_EXMEM_WB and i_EXMEM_RegWriteEnable = '1' then o_FWD_ID_RtSource                                       <= "11";
                                        --else dont forward
    else o_FWD_ID_RtSource                                                                                                   <= "00";
    end if;
  end process;


end behavioural;
