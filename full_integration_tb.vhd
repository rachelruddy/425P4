library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;        
use ieee.std_logic_textio.all;

entity full_integration_tb is
end;

architecture tb of full_integration_tb is
    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
	 signal dbg_IF_IR   : std_logic_vector(31 downto 0);
	 signal dbg_IFID_IR : std_logic_vector(31 downto 0);
	 signal dbg_ID_IR   : std_logic_vector(31 downto 0);
	 signal dbg_IF_NPC  :  STD_LOGIC_VECTOR(31 downto 0);
	 signal dbg_IFID_NPC  :  STD_LOGIC_VECTOR(31 downto 0);
	 signal dbg_ID_NPC  :  STD_LOGIC_VECTOR(31 downto 0);
	 signal dbg_A :  STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal dbg_B :  STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal dbg_imm :  STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal dbg_ALUSrc :  STD_LOGIC;
	signal dbg_ALUOp :  STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal dbg_ALUFunc :  STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal dbg_Branch :  STD_LOGIC;
	signal dbg_BranchType :   STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal dbg_Jump :  STD_LOGIC;
	signal dbg_JumpReg :  STD_LOGIC;
	signal dbg_MemRead :  STD_LOGIC;
	signal dbg_MemWrite :  STD_LOGIC;
	signal dbg_RegWrite :  STD_LOGIC;
	signal dbg_MemToReg :  STD_LOGIC;
	
	signal dbg_IDEX_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_IDEX_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_IDEX_imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_IDEX_IR   : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_IDEX_NPC   : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_IDEX_ALUSrc : STD_LOGIC;
		signal dbg_IDEX_ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
		signal dbg_IDEX_ALUFunc : STD_LOGIC_VECTOR(3 DOWNTO 0);
		signal dbg_IDEX_Branch : STD_LOGIC;
		signal dbg_IDEX_BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0);
		signal dbg_IDEX_Jump : STD_LOGIC;
		signal dbg_IDEX_JumpReg : STD_LOGIC;
		signal dbg_IDEX_MemRead : STD_LOGIC;
		signal dbg_IDEX_MemWrite : STD_LOGIC;
		signal dbg_IDEX_RegWrite : STD_LOGIC;
		signal dbg_IDEX_MemToReg : STD_LOGIC;
		
		-- EX outputs
		-- outputs of EX
		signal dbg_EX_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EX_B_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EX_IR_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EX_NPC_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EX_BranchTaken :  STD_LOGIC;
		signal dbg_EX_BranchTarget :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EX_Jump_out    :  STD_LOGIC;
      signal dbg_EX_JumpReg_out :  STD_LOGIC;
		signal dbg_EX_MemRead_out :  STD_LOGIC;
		signal dbg_EX_MemWrite_out :  STD_LOGIC;
		signal dbg_EX_RegWrite_out :  STD_LOGIC;
		signal dbg_EX_MemToReg_out :  STD_LOGIC;
		
		
		-- EX/MEM pipeline registers
		signal dbg_EXMEM_ALUResult_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EXMEM_B_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EXMEM_IR_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EXMEM_NPC_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EXMEM_BranchTaken :  STD_LOGIC;
		signal dbg_EXMEM_BranchTarget :  STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_EXMEM_Jump_out    : STD_LOGIC;
		signal dbg_EXMEM_JumpReg_out : STD_LOGIC;
		signal dbg_EXMEM_MemRead_out :  STD_LOGIC;
		signal dbg_EXMEM_MemWrite_out :  STD_LOGIC;
		signal dbg_EXMEM_RegWrite_out :  STD_LOGIC;
		signal dbg_EXMEM_MemToReg_out :  STD_LOGIC;
		
		
		-- MEM outputs
		signal dbg_MEM_LMD_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEM_ALUResult_out  : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEM_IR_out         : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEM_NPC_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEM_Jump_out       : STD_LOGIC;
		signal dbg_MEM_JumpReg_out    : STD_LOGIC;
		signal dbg_MEM_RegWrite_out   : STD_LOGIC;
		signal dbg_MEM_MemToReg_out   : STD_LOGIC;
		signal dbg_MEM_rd_out 			: STD_LOGIC_VECTOR(4 DOWNTO 0);

		-- MEM/WB pipeline registers
		signal dbg_MEMWB_LMD_out       : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEMWB_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEMWB_IR_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEMWB_NPC_out       : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEMWB_Jump_out      : STD_LOGIC;
		signal dbg_MEMWB_JumpReg_out   : STD_LOGIC;
		signal dbg_MEMWB_RegWrite_out  : STD_LOGIC;
		signal dbg_MEMWB_MemToReg_out  : STD_LOGIC;
		signal dbg_MEMWB_rd_out 			:  STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		-- WB outputs
		signal dbg_WB_regfile_write_en   : STD_LOGIC;
		signal dbg_WB_regfile_write_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
		signal dbg_WB_regfile_write_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

    component processor is
        port(
            clk   : in std_logic;
            reset : in std_logic;
				-- testing/debugging outputs (to be removed later)
			  dbg_IF_IR   : out STD_LOGIC_VECTOR(31 downto 0);
			  dbg_IFID_IR : out STD_LOGIC_VECTOR(31 downto 0);
			  dbg_ID_IR   : out STD_LOGIC_VECTOR(31 downto 0);
			  dbg_IF_NPC  : out STD_LOGIC_VECTOR(31 downto 0);
			  dbg_IFID_NPC  : out STD_LOGIC_VECTOR(31 downto 0);
			  dbg_ID_NPC  : out STD_LOGIC_VECTOR(31 downto 0);
			  dbg_A : out STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_B : out STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_imm : out STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_ALUSrc : out STD_LOGIC;
				dbg_ALUOp : out STD_LOGIC_VECTOR(1 DOWNTO 0);
				dbg_ALUFunc : out STD_LOGIC_VECTOR(3 DOWNTO 0);
				dbg_Branch : out STD_LOGIC;
				dbg_BranchType :  out STD_LOGIC_VECTOR(2 DOWNTO 0);
				dbg_Jump : out STD_LOGIC;
				dbg_JumpReg : out STD_LOGIC;
				dbg_MemRead : out STD_LOGIC;
				dbg_MemWrite : out STD_LOGIC;
				dbg_RegWrite : out STD_LOGIC;
				dbg_MemToReg : out STD_LOGIC;
				
				dbg_IDEX_A : out STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_IDEX_B : out STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_IDEX_imm : out STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_IDEX_IR   : out STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_IDEX_NPC   : out STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_IDEX_ALUSrc : out STD_LOGIC;
				dbg_IDEX_ALUOp : out STD_LOGIC_VECTOR(1 DOWNTO 0);
				dbg_IDEX_ALUFunc : out STD_LOGIC_VECTOR(3 DOWNTO 0);
				dbg_IDEX_Branch : out STD_LOGIC;
				dbg_IDEX_BranchType : out STD_LOGIC_VECTOR(2 DOWNTO 0);
				dbg_IDEX_Jump : out STD_LOGIC;
				dbg_IDEX_JumpReg : out STD_LOGIC;
				dbg_IDEX_MemRead : out STD_LOGIC;
				dbg_IDEX_MemWrite : out STD_LOGIC;
				dbg_IDEX_RegWrite : out STD_LOGIC;
				dbg_IDEX_MemToReg : out STD_LOGIC;
				
				dbg_EX_ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EX_B_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EX_IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EX_NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EX_BranchTaken : OUT STD_LOGIC;
				dbg_EX_BranchTarget : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EX_Jump_out    : OUT STD_LOGIC;
				dbg_EX_JumpReg_out : OUT STD_LOGIC;
				dbg_EX_MemRead_out : OUT STD_LOGIC;
				dbg_EX_MemWrite_out : OUT STD_LOGIC;
				dbg_EX_RegWrite_out : OUT STD_LOGIC;
				dbg_EX_MemToReg_out : OUT STD_LOGIC;
				
				
				
				dbg_EXMEM_ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EXMEM_B_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EXMEM_IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EXMEM_NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EXMEM_BranchTaken : OUT STD_LOGIC;
				dbg_EXMEM_BranchTarget : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_EXMEM_Jump_out    : OUT STD_LOGIC;
				dbg_EXMEM_JumpReg_out : OUT STD_LOGIC;
				dbg_EXMEM_MemRead_out : OUT STD_LOGIC;
				dbg_EXMEM_MemWrite_out : OUT STD_LOGIC;
				dbg_EXMEM_RegWrite_out : OUT STD_LOGIC;
				dbg_EXMEM_MemToReg_out : OUT STD_LOGIC;
				
				-- outputs of MEM
				dbg_MEM_LMD_out        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEM_ALUResult_out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEM_IR_out         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEM_NPC_out        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEM_Jump_out    : OUT STD_LOGIC;
				dbg_MEM_JumpReg_out : OUT STD_LOGIC;
				dbg_MEM_RegWrite_out   : OUT STD_LOGIC;
				dbg_MEM_MemToReg_out   : OUT STD_LOGIC;
				dbg_MEM_rd_out 			: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

				-- MEM/WB pipeline registers
				dbg_MEMWB_LMD_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEMWB_ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEMWB_IR_out        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEMWB_NPC_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEMWB_Jump_out    : OUT STD_LOGIC;
				dbg_MEMWB_JumpReg_out : OUT STD_LOGIC;
				dbg_MEMWB_RegWrite_out  : OUT STD_LOGIC;
				dbg_MEMWB_MemToReg_out  : OUT STD_LOGIC;
				dbg_MEMWB_rd_out 			: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
				
				-- WB outputs
				dbg_WB_regfile_write_en   : OUT STD_LOGIC;
				dbg_WB_regfile_write_addr : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
				dbg_WB_regfile_write_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		
        );
    end component;

begin

    uut: processor
    port map (
        clk => clk,
        reset => reset,
        dbg_IF_IR => dbg_IF_IR,
        dbg_IFID_IR => dbg_IFID_IR,
        dbg_ID_IR => dbg_ID_IR,
		  dbg_IF_NPC => dbg_IF_NPC,
		  dbg_IFID_NPC => dbg_IFID_NPC,
		  dbg_ID_NPC => dbg_ID_NPC,
		  dbg_A => dbg_A,
		dbg_B => dbg_B,
		dbg_imm => dbg_imm,
		dbg_ALUSrc => dbg_ALUSrc,
		dbg_ALUOp => dbg_ALUOp,
		dbg_ALUFunc => dbg_ALUFunc,
		dbg_Branch => dbg_Branch,
		dbg_BranchType => dbg_BranchType,
		dbg_Jump => dbg_Jump,
		dbg_JumpReg => dbg_JumpReg,
		dbg_MemRead => dbg_MemRead,
		dbg_MemWrite => dbg_MemWrite,
		dbg_RegWrite => dbg_RegWrite,
		dbg_MemToReg => dbg_MemToReg,
		
		dbg_IDEX_A => dbg_IDEX_A,
		dbg_IDEX_B => dbg_IDEX_B,
		dbg_IDEX_imm => dbg_IDEX_imm,
		dbg_IDEX_IR   => dbg_IDEX_IR,
		dbg_IDEX_NPC   => dbg_IDEX_NPC,
		dbg_IDEX_ALUSrc => dbg_IDEX_ALUSrc,
		dbg_IDEX_ALUOp => dbg_IDEX_ALUOp,
		dbg_IDEX_ALUFunc => dbg_IDEX_ALUFunc,
		dbg_IDEX_Branch => dbg_IDEX_Branch,
		dbg_IDEX_BranchType => dbg_IDEX_BranchType,
		dbg_IDEX_Jump => dbg_IDEX_Jump,
		dbg_IDEX_JumpReg => dbg_IDEX_JumpReg,
		dbg_IDEX_MemRead => dbg_IDEX_MemRead,
		dbg_IDEX_MemWrite => dbg_IDEX_MemWrite,
		dbg_IDEX_RegWrite => dbg_IDEX_RegWrite,
		dbg_IDEX_MemToReg => dbg_IDEX_MemToReg,
		
		dbg_EX_ALUResult_out => dbg_EX_ALUResult_out,
		dbg_EX_B_out => dbg_EX_B_out,
		dbg_EX_IR_out => dbg_EX_IR_out,
		dbg_EX_NPC_out => dbg_EX_NPC_out,
		dbg_EX_BranchTaken => dbg_EX_BranchTaken,
		dbg_EX_BranchTarget => dbg_EX_BranchTarget,
		dbg_EX_Jump_out  => dbg_EX_Jump_out,
		dbg_EX_JumpReg_out => dbg_EX_JumpReg_out,
		dbg_EX_MemRead_out => dbg_EX_MemRead_out,
		dbg_EX_MemWrite_out => dbg_EX_MemWrite_out,
		dbg_EX_RegWrite_out => dbg_EX_RegWrite_out,
		dbg_EX_MemToReg_out => dbg_EX_MemToReg_out,
		
		
		
		dbg_EXMEM_ALUResult_out => dbg_EXMEM_ALUResult_out,
		dbg_EXMEM_B_out => dbg_EXMEM_B_out,
		dbg_EXMEM_IR_out => dbg_EXMEM_IR_out,
		dbg_EXMEM_NPC_out => dbg_EXMEM_NPC_out,
		dbg_EXMEM_BranchTaken => dbg_EXMEM_BranchTaken,
		dbg_EXMEM_BranchTarget => dbg_EXMEM_BranchTarget,
		dbg_EXMEM_Jump_out   => dbg_EXMEM_Jump_out,
		dbg_EXMEM_JumpReg_out => dbg_EXMEM_JumpReg_out,
		dbg_EXMEM_MemRead_out => dbg_EXMEM_MemRead_out,
		dbg_EXMEM_MemWrite_out => dbg_EXMEM_MemWrite_out,
		dbg_EXMEM_RegWrite_out => dbg_EXMEM_RegWrite_out,
		dbg_EXMEM_MemToReg_out => dbg_EXMEM_MemToReg_out,
		
		dbg_MEM_LMD_out        => dbg_MEM_LMD_out,
		dbg_MEM_ALUResult_out  => dbg_MEM_ALUResult_out,
		dbg_MEM_IR_out         => dbg_MEM_IR_out,
		dbg_MEM_NPC_out        => dbg_MEM_NPC_out,
		dbg_MEM_Jump_out       => dbg_MEM_Jump_out,
		dbg_MEM_JumpReg_out    => dbg_MEM_JumpReg_out,
		dbg_MEM_RegWrite_out   => dbg_MEM_RegWrite_out,
		dbg_MEM_MemToReg_out   => dbg_MEM_MemToReg_out,
		dbg_MEM_rd_out			 => dbg_MEM_rd_out,

		dbg_MEMWB_LMD_out       => dbg_MEMWB_LMD_out,
		dbg_MEMWB_ALUResult_out => dbg_MEMWB_ALUResult_out,
		dbg_MEMWB_IR_out        => dbg_MEMWB_IR_out,
		dbg_MEMWB_NPC_out       => dbg_MEMWB_NPC_out,
		dbg_MEMWB_Jump_out      => dbg_MEMWB_Jump_out,
		dbg_MEMWB_JumpReg_out   => dbg_MEMWB_JumpReg_out,
		dbg_MEMWB_RegWrite_out  => dbg_MEMWB_RegWrite_out,
		dbg_MEMWB_MemToReg_out  => dbg_MEMWB_MemToReg_out,
		dbg_MEMWB_rd_out		   => dbg_MEMWB_rd_out,
		
		dbg_WB_regfile_write_en   => dbg_WB_regfile_write_en,
		dbg_WB_regfile_write_addr => dbg_WB_regfile_write_addr,
		dbg_WB_regfile_write_data => dbg_WB_regfile_write_data
		
    );

    -- clock
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 0.5 ns;
            clk <= '1'; wait for 0.5 ns;
        end loop;
    end process;

    -- stimulus
    stim : process
	 begin
		 -- reset
		 reset <= '1';
		 wait for 1 ns;
		 reset <= '0';
		 
		 -- =====================================================================
		 -- this tests loads this set of instructions:
		 -- addi x1, x0, 10      -- x1 = 10
		 -- addi x2, x0, 3       -- x2 = 3
		 -- add  x3, x1, x2      -- x3 = 10 + 3 = 13
		 -- sub  x4, x1, x2      -- x4 = 10 - 3 = 7
		 -- mul  x5, x1, x2      -- x5 = 10 * 3 = 30
		 -- and  x6, x1, x2      -- x6 = 10 & 3 = 2
		 
		 -- we expect this to be the result of the RF:
		-- x0  = 0   (hardwired)
		-- x1  = 10
		-- x2  = 3
		-- x3  = 13
		-- x4  = 7
		-- x5  = 30
		-- x6  = 2
		-- x7-x31 = 0
		
		-- there are nops between the instructions to avoid data hazards in the binary file
		 -- =====================================================================

		
		 -------------------------------------------------------------------------------------------------------------------------------
		 -- 
		 -------------------------------------------------------------------------------------------------------------------------------
		 

		wait;
    end process;

end;