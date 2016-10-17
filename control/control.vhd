-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------------------
entity mips_control is
  
  port (
    i_instruction : in  std_logic_vector (31 downto 0);  -- instruction from the memory
    o_RegDst      : out std_logic;      -- COMMENT ME
    o_Jump        : out std_logic;      --
    o_Branch      : out std_logic;      --
    o_MemRead     : out std_logic;      --
    o_MemToReg    : out std_logic;      --
    o_ALUOp       : out std_logic_vector (1 downto 0);   --
    o_MemWrite    : out std_logic;      --
    o_ALUSrc      : out std_logic;      --
    o_RegWrite    : out std_logic       --
    );

end entity mips_control;
-------------------------------------------------------------------------------
architecture dataflow of mips_control is

  -- checkout MIPS instruction formats (p. 120)
  alias a_op             : std_logic_vector (5 downto 0) is i_instruction(31 downto 26);
  alias a_rs             : std_logic_vector (4 downto 0) is i_instruction (25 downto 21);
  alias a_rt             : std_logic_vector (4 downto 0) is i_instruction (20 downto 16);
  alias a_rd             : std_logic_vector (4 downto 0) is i_instruction (15 downto 11);
  alias a_shamt          : std_logic_vector (4 downto 0) is i_instruction (10 downto 6);
  alias a_funct          : std_logic_vector (5 downto 0) is i_instruction (5 downto 0);
  alias a_addr_or_imm    : std_logic_vector (15 downto 0) is i_instruction (15 downto 0);
  alias a_target_address : std_logic_vector (25 downto 0) is i_instruction (25 downto 0);


  -- define all op codes below
  constant OP_ALU : std_logic_vector (5 downto 0) := "000000";
  constant OP_LW  : std_logic_vector (5 downto 0) := "100011";
  constant OP_J   : std_logic_vector (5 downto 0) := "000010";
  -- continue here... (feel free to reorder them so they are as listed in book/guides


  -- define all functions below
  constant FUNC_ADD  : std_logic_vector (5 downto 0) := "100000";
  constant FUNC_ADDU : std_logic_vector (5 downto 0) := "100001";
  -- continue here...

  
begin  -- architecture dataflow

  -- purpose: generates control signals depending on the instruction
  -- type   : combinational
  -- inputs : i_instruction
  -- outputs: o_RegDst, o_Jump, o_Branch, o_MemRead, o_MemToReg, o_ALUOp,
  --          o_MemWrite, o_ALUSrc, o_RegWrite
  generate_control : process (i_instruction) is
  begin  -- process generate_control

    -- treat individual opcodes here
    case a_op is

      -------------------------------------------------------------------------
      -- ALU op code, look at func field
      -------------------------------------------------------------------------
      when OP_ALU =>

        case a_func is

          ---------------------------------------------------------------------
          -- ADD: add
          ---------------------------------------------------------------------
          when FUNC_ADD =>
            o_RegDst   <= '1';
            o_Jump     <= '1';
            o_Branch   <= '1';
            o_MemRead  <= '1';
            o_MemToReg <= '1';
            o_ALUOp    <= "11";
            o_MemWrite <= '1';
            o_ALUSrc   <= '1';
            o_RegWrite <= '1';

          -------------------------------------------------------------------
          -- ADDI: add immediate 
          -------------------------------------------------------------------
          when FUNC_ADDI =>
            o_RegDst   <= '1';
            o_Jump     <= '1';
            o_Branch   <= '1';
            o_MemRead  <= '1';
            o_MemToReg <= '1';
            o_ALUOp    <= "11";
            o_MemWrite <= '1';
            o_ALUSrc   <= '1';
            o_RegWrite <= '1';


          when others =>
            -- some default behavior for control
            -- if all cases defined, it should never happen
            -- probably safe to make it all '0'
            o_RegDst   <= '1';
            o_Jump     <= '1';
            o_Branch   <= '1';
            o_MemRead  <= '1';
            o_MemToReg <= '1';
            o_ALUOp    <= "11";
            o_MemWrite <= '1';
            o_ALUSrc   <= '1';
            o_RegWrite <= '1';
        end case;

      -------------------------------------------------------------------------
      -- LW: load word
      -------------------------------------------------------------------------               
      when OP_LW =>
        o_RegDst   <= '1';
        o_Jump     <= '1';
        o_Branch   <= '1';
        o_MemRead  <= '1';
        o_MemToReg <= '1';
        o_ALUOp    <= "11";
        o_MemWrite <= '1';
        o_ALUSrc   <= '1';
        o_RegWrite <= '1';
        
      when others =>
        -- some default behavior for control
        -- if all cases defined, it should never happen
        -- probably safe to make it all '0';
        o_RegDst   <= '1';
        o_Jump     <= '1';
        o_Branch   <= '1';
        o_MemRead  <= '1';
        o_MemToReg <= '1';
        o_ALUOp    <= "11";
        o_MemWrite <= '1';
        o_ALUSrc   <= '1';
        o_RegWrite <= '1';
        
    end case;
    
  end process generate_control;
  

end architecture dataflow;
-------------------------------------------------------------------------------
