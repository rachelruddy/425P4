-- This will be the top level entity, the wrapper of all 5 stages
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- need a 'stall' signal which will be passed to IF and ID in case a data hazard is detected
-- this level will be responsible for doing the data hazard detection and setting stall = 1 in case theres a RAW

entity processor is
	port(
		clk : in STD_LOGIC;
      reset : in STD_LOGIC;
		
		-- testing/debugging outputs (to be removed later)
		-- outputs of IF
	  dbg_IF_IR   : out STD_LOGIC_VECTOR(31 downto 0);
	  dbg_IF_NPC   : out STD_LOGIC_VECTOR(31 downto 0);
	  
	  -- IF/ID pipeline registers
	  dbg_IFID_IR : out STD_LOGIC_VECTOR(31 downto 0);
	  dbg_IFID_NPC   : out STD_LOGIC_VECTOR(31 downto 0);
	  
	  -- outputs of ID
	  dbg_ID_IR   : out STD_LOGIC_VECTOR(31 downto 0);
	  dbg_ID_NPC   : out STD_LOGIC_VECTOR(31 downto 0);
	  dbg_A : out STD_LOGIC_VECTOR(31 DOWNTO 0);
		dbg_B : out STD_LOGIC_VECTOR(31 DOWNTO 0);
		dbg_imm : out STD_LOGIC_VECTOR(31 DOWNTO 0);
		dbg_ALUSrc : out STD_LOGIC;
		dbg_ALUOp : out STD_LOGIC_VECTOR(1 DOWNTO 0);
		dbg_ALUFunc : out STD_LOGIC_VECTOR(3 DOWNTO 0);
		dbg_Branch : out STD_LOGIC;
		dbg_BranchType : out STD_LOGIC_VECTOR(2 DOWNTO 0);
		dbg_Jump : out STD_LOGIC;
		dbg_JumpReg : out STD_LOGIC;
		dbg_MemRead : out STD_LOGIC;
		dbg_MemWrite : out STD_LOGIC;
		dbg_RegWrite : out STD_LOGIC;
		dbg_MemToReg : out STD_LOGIC;
		
		-- ID/EX pipeline registers
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
		
		-- outputs of EX
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
		
		
		-- EX/MEM pipeline registers
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
	   dbg_MEMWB_LMD_out      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	   dbg_MEMWB_ALUResult_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	   dbg_MEMWB_IR_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	   dbg_MEMWB_NPC_out      : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		dbg_MEMWB_Jump_out    : OUT STD_LOGIC;
      dbg_MEMWB_JumpReg_out : OUT STD_LOGIC;
	   dbg_MEMWB_RegWrite_out : OUT STD_LOGIC;
	   dbg_MEMWB_MemToReg_out : OUT STD_LOGIC;
		dbg_MEMWB_rd_out 			: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		--WB output
		dbg_WB_regfile_write_en   : OUT STD_LOGIC;
		dbg_WB_regfile_write_addr : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		dbg_WB_regfile_write_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		
		
	);

end processor;

architecture rtl of processor is
	--------- component and signal declarations --------
	-----------------------------------
	-- STAGE 1: IF --------------------
	-----------------------------------
	signal stall : STD_LOGIC := '0';
	signal IF_IR : STD_LOGIC_VECTOR(31 DOWNTO 0); -- these are just wires from IF stage outputs
	signal IF_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-----------------------------------
	-- IF/ID Pipeline registers -------
	-----------------------------------
	signal IFID_IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal IFID_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	
	
	-----------------------------------
	-- STAGE 2: ID --------------------
	-----------------------------------
	signal IFID_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
	signal ID_rs1_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal ID_rs2_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal RF_rs1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal RF_rs2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal ID_uses_rs1 : STD_LOGIC := '0';
	signal ID_uses_rs2 : STD_LOGIC := '0';

	signal ID_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal ID_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal ID_Imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal ID_IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal ID_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);

	signal ID_ALUSrc : STD_LOGIC;
	signal ID_ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal ID_ALUFunc : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal ID_Branch : STD_LOGIC;
	signal ID_BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal ID_Jump : STD_LOGIC;
	signal ID_JumpReg : STD_LOGIC;
	signal ID_MemRead : STD_LOGIC;
	signal ID_MemWrite : STD_LOGIC;
	signal ID_RegWrite : STD_LOGIC;
	signal ID_MemToReg : STD_LOGIC;
	
	-----------------------------------
	-- ID/EXEC Pipeline registers -----
	-----------------------------------
	signal IDEX_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal IDEX_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal IDEX_Imm : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal IDEX_IR : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal IDEX_NPC : STD_LOGIC_VECTOR(31 DOWNTO 0);

	signal IDEX_ALUSrc : STD_LOGIC;
	signal IDEX_ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal IDEX_ALUFunc : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal IDEX_Branch : STD_LOGIC;
	signal IDEX_BranchType : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal IDEX_Jump : STD_LOGIC;
	signal IDEX_JumpReg : STD_LOGIC;
	signal IDEX_MemRead : STD_LOGIC;
	signal IDEX_MemWrite : STD_LOGIC;
	signal IDEX_RegWrite : STD_LOGIC;
	signal IDEX_MemToReg : STD_LOGIC;
	signal IDEX_rd_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	
	
	-----------------------------------
	-- STAGE 3: EXEC ------------------
	-----------------------------------
	-- cond- branch condition result (branch taken or not)
	signal cond : STD_LOGIC := '0';
	-- will need an output of this stage to be the branch target address, used in IF
	signal branch_target : STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- this signal will remember that a branch was taken last cycle- allows us to flush the instruction that was up next in pc when branch was being resolved in ex
	signal branch_taken_reg : STD_LOGIC := '0';
	
	signal EX_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal EX_B_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal EX_IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal EX_NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal EX_BranchTaken :  STD_LOGIC;
   signal EX_BranchTarget :  STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal EX_Jump_out    : STD_LOGIC;
	signal EX_JumpReg_out : STD_LOGIC;
   signal EX_MemRead_out :  STD_LOGIC;
   signal EX_MemWrite_out :  STD_LOGIC;
   signal EX_RegWrite_out :  STD_LOGIC;
   signal EX_MemToReg_out :  STD_LOGIC;
	
	-----------------------------------
	-- EXEC/MEM Pipeline registers ----
	-----------------------------------
	signal EXMEM_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal EXMEM_B_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal EXMEM_IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal EXMEM_NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
   signal EXMEM_BranchTaken :  STD_LOGIC;
   signal EXMEM_BranchTarget :  STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal EXMEM_Jump_out    : STD_LOGIC;
	signal EXMEM_JumpReg_out : STD_LOGIC;	
   signal EXMEM_MemRead_out :  STD_LOGIC;
   signal EXMEM_MemWrite_out :  STD_LOGIC;
   signal EXMEM_RegWrite_out :  STD_LOGIC;
   signal EXMEM_MemToReg_out :  STD_LOGIC;
	signal EXMEM_rd_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);

	-- data hazard detection (no forwarding)
	signal hazard_ex : STD_LOGIC := '0';
	signal hazard_mem : STD_LOGIC := '0';
	signal hazard_wb : STD_LOGIC := '0';
	
	
	-----------------------------------
	-- STAGE 4: MEM --------------------
	-----------------------------------
	signal MEM_LMD_out : STD_LOGIC_VECTOR(31 DOWNTO 0);      -- load memory data
	signal MEM_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0); -- pass-through ALU result
	signal MEM_IR_out : STD_LOGIC_VECTOR(31 DOWNTO 0);        -- pass-through IR
	signal MEM_NPC_out : STD_LOGIC_VECTOR(31 DOWNTO 0);       -- pass-through NPC
	signal MEM_Jump_out    :  STD_LOGIC;
   signal MEM_JumpReg_out :  STD_LOGIC;
	signal MEM_RegWrite_out : STD_LOGIC;
	signal MEM_MemToReg_out : STD_LOGIC;
	signal MEM_rd_out : STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	-----------------------------------
	-- MEM/WB Pipeline registers -----
	-----------------------------------
	signal MEMWB_LMD_out       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal MEMWB_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal MEMWB_IR_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal MEMWB_NPC_out       : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal MEMWB_Jump_out    :  STD_LOGIC;
   signal MEMWB_JumpReg_out :  STD_LOGIC;
	signal MEMWB_RegWrite_out  : STD_LOGIC;
	signal MEMWB_MemToReg_out  : STD_LOGIC;
	signal MEMWB_rd_out : STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	
	
	-----------------------------------
	-- STAGE 5: WB --------------------
	-----------------------------------
	signal WB_regfile_write_en : STD_LOGIC := '0';
	signal WB_regfile_write_addr : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
	signal WB_regfile_write_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');


	
	component instruction_fetch is
		port(
			clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			cond : in  STD_LOGIC;
			branch_target : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			stall: in  STD_LOGIC;
			IR : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			NPC : out STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	end component;

	component instruction_decode is
		port(
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			IR : in STD_LOGIC_VECTOR(31 DOWNTO 0);
			NPC : in STD_LOGIC_VECTOR(31 DOWNTO 0);
			A_in : in STD_LOGIC_VECTOR(31 DOWNTO 0);
			B_in : in STD_LOGIC_VECTOR(31 DOWNTO 0);

			A : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			B : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			Imm : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			IR_out : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			NPC_out : out STD_LOGIC_VECTOR(31 DOWNTO 0);

			ALUSrc : out STD_LOGIC;
			ALUOp : out STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUFunc : out STD_LOGIC_VECTOR(3 DOWNTO 0);
			Branch : out STD_LOGIC;
			BranchType : out STD_LOGIC_VECTOR(2 DOWNTO 0);
			Jump : out STD_LOGIC;
			JumpReg : out STD_LOGIC;
			MemRead : out STD_LOGIC;
			MemWrite : out STD_LOGIC;
			RegWrite : out STD_LOGIC;
			MemToReg : out STD_LOGIC
		);
	end component;

	component register_file is
		port(
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			rs1_addr : in STD_LOGIC_VECTOR(4 DOWNTO 0);
			rs2_addr : in STD_LOGIC_VECTOR(4 DOWNTO 0);
			rs1_data : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			rs2_data : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			write_enable : in STD_LOGIC;
			write_addr : in STD_LOGIC_VECTOR(4 DOWNTO 0);
			write_data : in STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
	end component;
	
	component execute is
		port(
			  clk : IN STD_LOGIC;
			  reset : IN STD_LOGIC;
			  A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			  B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			  Imm : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			  IR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			  NPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			  ALUSrc : IN STD_LOGIC;
			  ALUFunc : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			  Branch : IN STD_LOGIC;
			  BranchType : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			  Jump : IN STD_LOGIC;
			  JumpReg : IN STD_LOGIC;
			  MemRead : IN STD_LOGIC;
			  MemWrite : IN STD_LOGIC;
			  RegWrite : IN STD_LOGIC;
			  MemToReg : IN STD_LOGIC;  

			  ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			  B_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			  IR_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			  NPC_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			  BranchTaken : OUT STD_LOGIC;
			  BranchTarget : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			  Jump_out    : OUT STD_LOGIC;
			  JumpReg_out : OUT STD_LOGIC;
			  MemRead_out : OUT STD_LOGIC;
			  MemWrite_out : OUT STD_LOGIC;
			  RegWrite_out : OUT STD_LOGIC;
			  MemToReg_out : OUT STD_LOGIC
		);
	end component;
	
	component mem_pipeline is
		 port(
			  clk          : in  STD_LOGIC;
			  reset        : in  STD_LOGIC;
			  ALUResult    : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  B_in         : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  IR_in        : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  NPC_in       : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  Jump       	: IN STD_LOGIC;                      
			  JumpReg    	: IN STD_LOGIC; 
			  MemRead      : in  STD_LOGIC;
			  MemWrite     : in  STD_LOGIC;
			  MemFunc      : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  RegWrite     : in  STD_LOGIC;
			  MemToReg     : in  STD_LOGIC;
			  
			  LMD_out      : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			  ALUResult_out: out STD_LOGIC_VECTOR(31 DOWNTO 0);
			  IR_out       : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			  NPC_out      : out STD_LOGIC_VECTOR(31 DOWNTO 0);
			  Jump_out    	: OUT STD_LOGIC;
			  JumpReg_out 	: OUT STD_LOGIC;
			  RegWrite_out : out STD_LOGIC;
			  MemToReg_out : out STD_LOGIC;
			  rd_out 		: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
		 );
	end component;
	
	component writeback is
		 port(
			  clk               : in  STD_LOGIC;
			  reset             : in  STD_LOGIC;
			  MemToReg          : in  STD_LOGIC;
			  RegWrite          : in  STD_LOGIC;
			  Jump              : in  STD_LOGIC;
			  JumpReg           : in  STD_LOGIC;
			  rd                : in  STD_LOGIC_VECTOR(4 DOWNTO 0);
			  ALUOutput         : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  mem_data          : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  NPC               : in  STD_LOGIC_VECTOR(31 DOWNTO 0);
			  regfile_write_en  : out STD_LOGIC;
			  regfile_write_addr: out STD_LOGIC_VECTOR(4 DOWNTO 0);
			  regfile_write_data: out STD_LOGIC_VECTOR(31 DOWNTO 0)
		 );
	end component;
	
	begin
		-- rf read addresses come directly from the instruction currently in IF/ID
		-- combinatorial outside of clocked process so it can be an instant read 
		IFID_opcode <= IFID_IR(6 DOWNTO 0);
		ID_rs1_addr <= IFID_IR(19 DOWNTO 15);
		ID_rs2_addr <= IFID_IR(24 DOWNTO 20);
		IDEX_rd_addr <= IDEX_IR(11 DOWNTO 7);
		EXMEM_rd_addr <= EXMEM_IR_out(11 DOWNTO 7);

		-- RV32I source register usage for current decode instruction
		process(IFID_opcode)
		begin
			ID_uses_rs1 <= '0';
			ID_uses_rs2 <= '0';

			case IFID_opcode is
				when "0110011" => -- R-type ALU
					ID_uses_rs1 <= '1';
					ID_uses_rs2 <= '1';
				when "0010011" => -- I-type ALU immediate
					ID_uses_rs1 <= '1';
				when "0000011" => -- loads
					ID_uses_rs1 <= '1';
				when "0100011" => -- stores
					ID_uses_rs1 <= '1';
					ID_uses_rs2 <= '1';
				when "1100011" => -- branches
					ID_uses_rs1 <= '1';
					ID_uses_rs2 <= '1';
				when "1100111" => -- jalr
					ID_uses_rs1 <= '1';
				when others =>
					null;
			end case;
		end process;

		-- RAW hazard checks against instructions ahead in pipeline
		hazard_ex <= '1' when (IDEX_RegWrite = '1' and IDEX_rd_addr /= "00000" and
							 ((ID_uses_rs1 = '1' and IDEX_rd_addr = ID_rs1_addr) or
							  (ID_uses_rs2 = '1' and IDEX_rd_addr = ID_rs2_addr)))
				 else '0';

		hazard_mem <= '1' when (EXMEM_RegWrite_out = '1' and EXMEM_rd_addr /= "00000" and
							  ((ID_uses_rs1 = '1' and EXMEM_rd_addr = ID_rs1_addr) or
							   (ID_uses_rs2 = '1' and EXMEM_rd_addr = ID_rs2_addr)))
				  else '0';

		hazard_wb <= '1' when (MEMWB_RegWrite_out = '1' and MEMWB_rd_out /= "00000" and
							 ((ID_uses_rs1 = '1' and MEMWB_rd_out = ID_rs1_addr) or
							  (ID_uses_rs2 = '1' and MEMWB_rd_out = ID_rs2_addr)))
				 else '0';

		-- stall decode/fetch until producer reaches or passes WB (no forwarding)
		-- keep branch flush priority intact by not stalling during taken-branch flush windows
		stall <= '1' when (reset = '0' and cond = '0' and branch_taken_reg = '0' and
						(hazard_ex = '1' or hazard_mem = '1' or hazard_wb = '1'))
			 else '0';
		
		-- control hazards (from branch taken or jal/jalr) concurrent logic
		cond          <= EX_BranchTaken;
		branch_target <= EX_BranchTarget;

		--testing signals
		--outputs of IF
		dbg_IF_IR   <= IF_IR;
		dbg_IF_NPC   <= IF_NPC;
		
		-- IF/ID pipeline regs
		dbg_IFID_IR <= IFID_IR;
	   dbg_IFID_NPC  <= IFID_NPC;
		
		-- outputs of ID
		dbg_ID_IR   <= ID_IR;
		dbg_ID_NPC <= ID_NPC;
		dbg_A <= ID_A;
		dbg_B <= ID_B;
		dbg_imm <= ID_Imm;
		dbg_ALUSrc <= ID_ALUSrc;
		dbg_ALUOp <= ID_ALUOp;
		dbg_ALUFunc <= ID_ALUFunc;
		dbg_Branch <= ID_Branch;
		dbg_BranchType <= ID_BranchType;
		dbg_Jump <= ID_Jump;
		dbg_JumpReg <= ID_JumpReg;
		dbg_MemRead <= ID_MemRead;
		dbg_MemWrite <= ID_MemWrite;
		dbg_RegWrite <= ID_RegWrite;
		dbg_MemToReg <= ID_MemToReg;
		
		--ID/EX pipeline registers
		dbg_IDEX_A <= IDEX_A;
		dbg_IDEX_B <= IDEX_B;
		dbg_IDEX_imm <= IDEX_Imm;
		dbg_IDEX_IR   <= IDEX_IR;
		dbg_IDEX_NPC   <= IDEX_NPC;
		dbg_IDEX_ALUSrc <= IDEX_ALUSrc;
		dbg_IDEX_ALUOp <= IDEX_ALUOp;
		dbg_IDEX_ALUFunc <= IDEX_ALUFunc;
		dbg_IDEX_Branch <= IDEX_Branch;
		dbg_IDEX_BranchType <= IDEX_BranchType;
		dbg_IDEX_Jump <= IDEX_Jump;
		dbg_IDEX_JumpReg <= IDEX_JumpReg;
		dbg_IDEX_MemRead <= IDEX_MemRead;
		dbg_IDEX_MemWrite <= IDEX_MemWrite;
		dbg_IDEX_RegWrite <= IDEX_RegWrite;
		dbg_IDEX_MemToReg <= IDEX_MemToReg;
		
		-- outputs of EX
		dbg_EX_ALUResult_out <= EX_ALUResult_out;
		dbg_EX_B_out <= EX_B_out;
		dbg_EX_IR_out <= EX_IR_out;
		dbg_EX_NPC_out <= EX_NPC_out;
		dbg_EX_BranchTaken <= EX_BranchTaken;
		dbg_EX_BranchTarget <= EX_BranchTarget;
		dbg_EX_Jump_out    <= EX_Jump_out;
      dbg_EX_JumpReg_out <= EX_JumpReg_out;
		dbg_EX_MemRead_out <= EX_MemRead_out;
		dbg_EX_MemWrite_out <= EX_MemWrite_out;
		dbg_EX_RegWrite_out <= EX_RegWrite_out;
		dbg_EX_MemToReg_out <= EX_MemToReg_out;

		
		--EX/MEM pipeline registers
		dbg_EXMEM_ALUResult_out <= EXMEM_ALUResult_out;
		dbg_EXMEM_B_out <= EXMEM_B_out;
		dbg_EXMEM_IR_out <= EXMEM_IR_out;
		dbg_EXMEM_NPC_out <= EXMEM_NPC_out;
		dbg_EXMEM_BranchTaken <= EXMEM_BranchTaken;
		dbg_EXMEM_BranchTarget <= EXMEM_BranchTarget;
		dbg_EXMEM_Jump_out    <= EXMEM_Jump_out;
      dbg_EXMEM_JumpReg_out <= EXMEM_JumpReg_out;
		dbg_EXMEM_MemRead_out <= EXMEM_MemRead_out;
		dbg_EXMEM_MemWrite_out <= EXMEM_MemWrite_out;
		dbg_EXMEM_RegWrite_out <= EXMEM_RegWrite_out;
		dbg_EXMEM_MemToReg_out <= EXMEM_MemToReg_out;
		
		-- outputs of MEM
		dbg_MEM_LMD_out        <= MEM_LMD_out;
	   dbg_MEM_ALUResult_out  <= MEM_ALUResult_out;
	   dbg_MEM_IR_out         <= MEM_IR_out;
	   dbg_MEM_NPC_out        <= MEM_NPC_out;
		dbg_MEM_Jump_out       <= MEM_Jump_out;
      dbg_MEM_JumpReg_out    <= MEM_JumpReg_out;
	   dbg_MEM_RegWrite_out   <= MEM_RegWrite_out;
	   dbg_MEM_MemToReg_out   <= MEM_MemToReg_out;
		dbg_MEM_rd_out			  <= MEM_rd_out;
		
		-- MEM/WB
		dbg_MEMWB_LMD_out       <= MEMWB_LMD_out;
	   dbg_MEMWB_ALUResult_out <= MEMWB_ALUResult_out;
	   dbg_MEMWB_IR_out        <= MEMWB_IR_out;
	   dbg_MEMWB_NPC_out       <= MEMWB_NPC_out;
		dbg_MEMWB_Jump_out      <= MEMWB_Jump_out;
      dbg_MEMWB_JumpReg_out   <= MEMWB_JumpReg_out;
	   dbg_MEMWB_RegWrite_out  <= MEMWB_RegWrite_out;
	   dbg_MEMWB_MemToReg_out  <= MEMWB_MemToReg_out;
		dbg_MEMWB_rd_out			<= MEMWB_rd_out;
		
		--writeback
		dbg_WB_regfile_write_en   <= WB_regfile_write_en;
		dbg_WB_regfile_write_addr <= WB_regfile_write_addr;
		dbg_WB_regfile_write_data <= WB_regfile_write_data;
		

		-- pipeline stage instantiations
		IF_stage : instruction_fetch port map(
			clk => clk, 
			reset => reset, 
			cond => cond, 
			branch_target => branch_target, 
			stall => stall, 
			IR => IF_IR, 
			NPC => IF_NPC
		);

		RF_stage : register_file port map(
			clk => clk,
			reset => reset,
			rs1_addr => ID_rs1_addr,
			rs2_addr => ID_rs2_addr,
			rs1_data => RF_rs1_data,
			rs2_data => RF_rs2_data,
			write_enable => WB_regfile_write_en,
			write_addr => WB_regfile_write_addr,
			write_data => WB_regfile_write_data
		);

		ID_stage : instruction_decode port map(
			clk => clk,
			reset => reset,
			IR => IFID_IR,
			NPC => IFID_NPC,
			A_in => RF_rs1_data,
			B_in => RF_rs2_data,
			A => ID_A,
			B => ID_B,
			Imm => ID_Imm,
			IR_out => ID_IR,
			NPC_out => ID_NPC,
			ALUSrc => ID_ALUSrc,
			ALUOp => ID_ALUOp,
			ALUFunc => ID_ALUFunc,
			Branch => ID_Branch,
			BranchType => ID_BranchType,
			Jump => ID_Jump,
			JumpReg => ID_JumpReg,
			MemRead => ID_MemRead,
			MemWrite => ID_MemWrite,
			RegWrite => ID_RegWrite,
			MemToReg => ID_MemToReg
		);
		EX_stage : execute port map(
			 clk => clk,
			 reset => reset,
			 A => IDEX_A,
			 B => IDEX_B,
			 Imm => IDEX_Imm,
			 IR => IDEX_IR,
			 NPC => IDEX_NPC,

			 ALUSrc => IDEX_ALUSrc,
			 ALUFunc => IDEX_ALUFunc,

			 Branch => IDEX_Branch,
			 BranchType => IDEX_BranchType,
			 Jump => IDEX_Jump,
			 JumpReg => IDEX_JumpReg,

			 MemRead => IDEX_MemRead,
			 MemWrite => IDEX_MemWrite,
			 RegWrite => IDEX_RegWrite,
			 MemToReg => IDEX_MemToReg,

			 ALUResult_out => EX_ALUResult_out,
			 B_out => EX_B_out,
			 IR_out => EX_IR_out,
			 NPC_out => EX_NPC_out,
			 BranchTaken => EX_BranchTaken,
			 BranchTarget => EX_BranchTarget,
			 Jump_out    => EX_Jump_out,
		    JumpReg_out => EX_JumpReg_out,

			 MemRead_out => EX_MemRead_out,
			 MemWrite_out => EX_MemWrite_out,
			 RegWrite_out => EX_RegWrite_out,
			 MemToReg_out => EX_MemToReg_out
		);

		 MEM_stage : mem_pipeline
		 port map(
			  clk           => clk,
			  reset			 => reset,
			  ALUResult     => EXMEM_ALUResult_out,
			  B_in          => EXMEM_B_out,
			  IR_in         => EXMEM_IR_out,
			  NPC_in        => EXMEM_NPC_out,
			  Jump          => EXMEM_Jump_out,             
			  JumpReg       => EXMEM_JumpReg_out,
			  MemRead       => EXMEM_MemRead_out,
			  MemWrite      => EXMEM_MemWrite_out,
			  MemFunc       => "010",  -- always word access (LW/SW only)
			  RegWrite      => EXMEM_RegWrite_out,
			  MemToReg      => EXMEM_MemToReg_out,
			  LMD_out       => MEM_LMD_out,
			  ALUResult_out => MEM_ALUResult_out,
			  IR_out        => MEM_IR_out,
			  NPC_out       => MEM_NPC_out,
			  Jump_out      => MEM_Jump_out,
			  JumpReg_out   => MEM_JumpReg_out,
			  RegWrite_out  => MEM_RegWrite_out,
			  MemToReg_out  => MEM_MemToReg_out,
			  rd_out			 => MEM_rd_out
		 );
		 
		 WB_stage : writeback
		 port map(
			  clk                => clk,
			  reset              => reset,
			  MemToReg           => MEMWB_MemToReg_out,
			  RegWrite           => MEMWB_RegWrite_out,
			  Jump               => MEMWB_Jump_out,
			  JumpReg            => MEMWB_JumpReg_out,
			  rd                 => MEMWB_rd_out,
			  ALUOutput          => MEMWB_ALUResult_out,
			  mem_data           => MEMWB_LMD_out,
			  NPC                => MEMWB_NPC_out,
			  regfile_write_en   => WB_regfile_write_en,
			  regfile_write_addr => WB_regfile_write_addr,
			  regfile_write_data => WB_regfile_write_data
		 );
		 
		 branch_delay : process(clk)
			begin
				 if rising_edge(clk) then
					  if reset = '1' then
							branch_taken_reg <= '0';
					  else
							branch_taken_reg <= cond;
					  end if;
				 end if;
			end process;
		
		-- IF/ID pipeline registers
		process(clk, reset)
		begin
			if reset = '1' then
				-- reset the pipeline registers
				IFID_IR  <= (others => '0');
				IFID_NPC <= (others => '0');
				
			elsif rising_edge(clk) then
			   if stall = '1' then -- freeze IF
					IFID_IR  <= IFID_IR;
					IFID_NPC <= IFID_NPC;
				-- if branch is taken, IR and NPC will be zerod out- let this indicate a NOP
				-- will also need to flush out other control signals like RegWrite, MemWrite, MemRead, Branch...
			   elsif cond = '1' or branch_taken_reg = '1' then
					IFID_IR  <= (others => '0');
					IFID_NPC <= (others => '0');
			   else
					IFID_IR  <= IF_IR;
					IFID_NPC <= IF_NPC;
			  end if;
			end if;
		end process;

		-- ID/EX pipeline registers
		process(clk, reset)
		begin
			if reset = '1' then
				-- reset ID/EX pipeline registers
				IDEX_A <= (others => '0');
				IDEX_B <= (others => '0');
				IDEX_Imm <= (others => '0');
				IDEX_IR <= (others => '0');
				IDEX_NPC <= (others => '0');

				IDEX_ALUSrc <= '0';
				IDEX_ALUOp <= "00";
				IDEX_ALUFunc <= "0000";
				IDEX_Branch <= '0';
				IDEX_BranchType <= (others => '0');
				IDEX_Jump <= '0';
				IDEX_JumpReg <= '0';
				IDEX_MemRead <= '0';
				IDEX_MemWrite <= '0';
				IDEX_RegWrite <= '0';
				IDEX_MemToReg <= '0';

			elsif rising_edge(clk) then
				if stall = '1' then
					-- data stall with no forwarding: inject bubble into ID/EX
					IDEX_A <= (others => '0');
					IDEX_B <= (others => '0');
					IDEX_Imm <= (others => '0');
					IDEX_IR <= (others => '0');
					IDEX_NPC <= (others => '0');

					IDEX_ALUSrc <= '0';
					IDEX_ALUOp <= "00";
					IDEX_ALUFunc <= "0000";
					IDEX_Branch <= '0';
					IDEX_BranchType <= (others => '0');
					IDEX_Jump <= '0';
					IDEX_JumpReg <= '0';
					IDEX_MemRead <= '0';
					IDEX_MemWrite <= '0';
					IDEX_RegWrite <= '0';
					IDEX_MemToReg <= '0';

				elsif cond = '1' or branch_taken_reg = '1' then
					-- flush decode output on taken branch (inject bubble)
					IDEX_A <= (others => '0');
					IDEX_B <= (others => '0');
					IDEX_Imm <= (others => '0');
					IDEX_IR <= (others => '0');
					IDEX_NPC <= (others => '0');

					IDEX_ALUSrc <= '0';
					IDEX_ALUOp <= "00";
					IDEX_ALUFunc <= "0000";
					IDEX_Branch <= '0';
					IDEX_BranchType <= (others => '0');
					IDEX_Jump <= '0';
					IDEX_JumpReg <= '0';
					IDEX_MemRead <= '0';
					IDEX_MemWrite <= '0';
					IDEX_RegWrite <= '0';
					IDEX_MemToReg <= '0';

				else
					-- latch decode outputs into ID/EX pipeline registers
					IDEX_A <= ID_A;
					IDEX_B <= ID_B;
					IDEX_Imm <= ID_Imm;
					IDEX_IR <= ID_IR;
					IDEX_NPC <= ID_NPC;

					IDEX_ALUSrc <= ID_ALUSrc;
					IDEX_ALUOp <= ID_ALUOp;
					IDEX_ALUFunc <= ID_ALUFunc;
					IDEX_Branch <= ID_Branch;
					IDEX_BranchType <= ID_BranchType;
					IDEX_Jump <= ID_Jump;
					IDEX_JumpReg <= ID_JumpReg;
					IDEX_MemRead <= ID_MemRead;
					IDEX_MemWrite <= ID_MemWrite;
					IDEX_RegWrite <= ID_RegWrite;
					IDEX_MemToReg <= ID_MemToReg;
				end if;
			end if;
		end process;
		
		-- EX/MEM pipeline registers
		process(clk, reset)
		begin
			if reset = '1' then
				-- reset EX/MEM pipeline registers
				  EXMEM_ALUResult_out <= (others => '0');
				  EXMEM_B_out <= (others => '0');
				  EXMEM_IR_out <= (others => '0');
				  EXMEM_NPC_out <= (others => '0');
				  EXMEM_BranchTaken <= '0';
				  EXMEM_BranchTarget <= (others => '0');
				  EXMEM_Jump_out    <= '0';
				  EXMEM_JumpReg_out <= '0';
				  EXMEM_MemRead_out <= '0';
				  EXMEM_MemWrite_out <= '0';
				  EXMEM_RegWrite_out <= '0';
				  EXMEM_MemToReg_out <= '0';

			elsif rising_edge(clk) then
				-- do not stall EX/MEM on data hazards; older instructions must drain
				-- no cond  = '1' logic because dont want to flush branch instr itself
				EXMEM_ALUResult_out <= EX_ALUResult_out;
				EXMEM_B_out <= EX_B_out;
				EXMEM_IR_out <= EX_IR_out;
				EXMEM_NPC_out <= EX_NPC_out;
				EXMEM_BranchTaken <= EX_BranchTaken;
				EXMEM_BranchTarget <= EX_BranchTarget;
				EXMEM_Jump_out    <= EX_Jump_out;
				EXMEM_JumpReg_out <= EX_JumpReg_out;
				EXMEM_MemRead_out <= EX_MemRead_out;
				EXMEM_MemWrite_out <= EX_MemWrite_out;
				EXMEM_RegWrite_out <= EX_RegWrite_out;
				EXMEM_MemToReg_out <= EX_MemToReg_out;
			end if;
		end process;
		
		-- MEM/WB pipeline registers
		process(clk, reset)
		begin
			if reset = '1' then
				-- reset MEM/WB pipeline registers
				MEMWB_LMD_out       <= (others => '0');
				MEMWB_ALUResult_out <= (others => '0');
				MEMWB_IR_out        <= (others => '0');
				MEMWB_NPC_out       <= (others => '0');
				MEMWB_Jump_out    <= '0';
				MEMWB_JumpReg_out <= '0';
				MEMWB_RegWrite_out  <= '0';
				MEMWB_MemToReg_out  <= '0';
				MEMWB_rd_out			<= (others => '0');

			elsif rising_edge(clk) then
				-- when branch taken, flush IF/ID and ID/EX, so this this should be valid
				-- i think stall shouldnt affect this stage - rachel
				MEMWB_LMD_out       <= MEM_LMD_out;
			   MEMWB_ALUResult_out <= MEM_ALUResult_out;
			   MEMWB_IR_out        <= MEM_IR_out;
			   MEMWB_NPC_out       <= MEM_NPC_out;
				MEMWB_Jump_out      <= MEM_Jump_out;
				MEMWB_JumpReg_out   <= MEM_JumpReg_out;
			   MEMWB_RegWrite_out  <= MEM_RegWrite_out;
			   MEMWB_MemToReg_out  <= MEM_MemToReg_out;
				MEMWB_rd_out		  <= MEM_rd_out;
					
				
			end if;
		end process;
end rtl;