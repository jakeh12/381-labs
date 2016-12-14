library IEEE;
use IEEE.std_logic_1164.all;

entity forwarder_tb is
	end forwarder_tb;

architecture behavioural of forwarder_tb is
	component forwarder is
	port (
	i_ID_ALUInputBSource : in std_logic;  --used to find if we need to forward Rt
	i_ID_Rs : in std_logic_vector ( 4 downto 0 );
	i_ID_Rt : in std_logic_vector ( 4 downto 0 );
	i_IDEX_RegWriteEnable : in std_logic;
	i_IDEX_Rs : in std_logic_vector ( 4 downto 0 );
	i_IDEX_Rt : in std_logic_vector ( 4 downto 0 );
	i_IDEX_WB : in std_logic_vector ( 4 downto 0 );
	i_EXMEM_RegWriteEnable : in std_logic;
	i_EXMEM_RegWriteDataSource : in std_logic_vector ( 1 downto 0 );
	i_EXMEM_Rs : in std_logic_vector ( 4 downto 0 );
	i_EXMEM_Rt : in std_logic_vector ( 4 downto 0 );
	i_EXMEM_WB : in std_logic_vector ( 4 downto 0 );
	o_FWD_ID_RsSource : out std_logic_vector ( 1 downto 0 );
	o_FWD_ID_RtSource : out std_logic_vector ( 1 downto 0 );
	o_FWD_EX_InputASource : out std_logic;
	o_FWD_EX_InputBSource : out std_logic
	     );

	end component;

	signal idrs, idrt, idexrs, idexrt,idexwb,iexmemrs,iexmemrt,iexmemwb :std_logic_vector ( 4 downto 0 );
	signal idaluinputbsource, idexregwriteenable, iexmemregwriteenable, fwdexinputa, fwddexinputb : std_logic;
	signal iexmemregwritedatasource, fwdrs, fwdrt : std_logic_vector ( 1 downto 0 );

begin

	DUT : forwarder
	port map (
	i_ID_ALUInputBSource => idaluinputbsource,
	i_ID_Rs => idrs, 
	i_ID_Rt => idrt, 
	i_IDEX_RegWriteEnable => idexregwriteenable,
	i_IDEX_Rs =>idexrs, 
	i_IDEX_Rt =>idexrt,
	i_IDEX_WB =>idexwb,
	i_EXMEM_RegWriteEnable => iexmemregwriteenable,
	i_EXMEM_RegWriteDataSource =>iexmemregwritedatasource, 
	i_EXMEM_Rs =>iexmemrs, 
	i_EXMEM_Rt=>iexmemrt, 
	i_EXMEM_WB=>iexmemwb,
	o_FWD_ID_RsSource=>fwdrs, 
	o_FWD_ID_RtSource=>fwdrt, 
	o_FWD_EX_InputASource=>fwdexinputa, 
	o_FWD_EX_InputBSource=>fwddexinputb);

	process
	begin
	
		--set to zero
		idaluinputbsource <= '0';
		idrs <= "00000";
		idrt <= "00000";
		idexregwriteenable <= '0';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "00000";
		iexmemregwriteenable <= '0';
		iexmemregwritedatasource <="00";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00000";
		wait for 10 ns;


		--test write enable
		idaluinputbsource <= '0';
		idrs <= "00001";
		idrt <= "00000";
		idexregwriteenable <= '0';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "00001";
		iexmemregwriteenable <= '0';
		iexmemregwritedatasource <="00";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00000";
		wait for 10 ns;
		
		--test ex rs
		idaluinputbsource <= '0';
		idrs <= "00011";
		idrt <= "00000";
		idexregwriteenable <= '1';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "00011";
		iexmemregwriteenable <= '0';
		iexmemregwritedatasource <="00";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00000";
		wait for 10 ns;

		--test ex rt
		idaluinputbsource <= '0';
		idrs <= "00000";
		idrt <= "00001";
		idexregwriteenable <= '1';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "00001";
		iexmemregwriteenable <= '0';
		iexmemregwritedatasource <="00";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00000";
		wait for 10 ns;

		--test mem load rs
		idaluinputbsource <= '0';
		idrs <= "00111";
		idrt <= "00000";
		idexregwriteenable <= '1';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "00000";
		iexmemregwriteenable <= '1';
		iexmemregwritedatasource <="01";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00111";
		wait for 10 ns;

		--test mem rs
		idaluinputbsource <= '0';
		idrs <= "01111";
		idrt <= "00000";
		idexregwriteenable <= '1';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "00000";
		iexmemregwriteenable <= '1';
		iexmemregwritedatasource <="00";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "01111";
		wait for 10 ns;

		--test fall through for rs
		idaluinputbsource <= '0';
		idrs <= "11111";
		idrt <= "00000";
		idexregwriteenable <= '1';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "11111";
		iexmemregwriteenable <= '1';
		iexmemregwritedatasource <="01";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "11111";
		wait for 10 ns;

		--nop
		idaluinputbsource <= '0';
		idrs <= "00000";
		idrt <= "00000";
		idexregwriteenable <= '0';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "00000";
		iexmemregwriteenable <= '0';
		iexmemregwritedatasource <="00";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00000";
		wait for 10 ns;

		--nop
		idaluinputbsource <= '0';
		idrs <= "00000";
		idrt <= "00000";
		idexregwriteenable <= '0';
		idexrs <= "00000";
		idexrt <= "00000";
		idexwb <= "00000";
		iexmemregwriteenable <= '0';
		iexmemregwritedatasource <="00";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00000";
		wait for 10 ns;
	
		--idex rs
		idaluinputbsource <= '0';
		idrs <= "00000";
		idrt <= "00000";
		idexregwriteenable <= '0';
		idexrs <= "00001";
		idexrt <= "00000";
		idexwb <= "00000";
		iexmemregwriteenable <= '1';
		iexmemregwritedatasource <="01";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00001";
		wait for 10 ns;
		
		--idex rt
		idaluinputbsource <= '0';
		idrs <= "00000";
		idrt <= "00000";
		idexregwriteenable <= '0';
		idexrs <= "00000";
		idexrt <= "00001";
		idexwb <= "00000";
		iexmemregwriteenable <= '1';
		iexmemregwritedatasource <="01";
		iexmemrs <= "00000";
		iexmemrt <= "00000";
		iexmemwb <= "00001";
		wait for 10 ns;
	end process;
end behavioural;
