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
	  dbg_IF_IR   : out STD_LOGIC_VECTOR(31 downto 0);
	  dbg_IFID_IR : out STD_LOGIC_VECTOR(31 downto 0);
	  dbg_ID_IR   : out STD_LOGIC_VECTOR(31 downto 0);
	  dbg_IF_NPC   : out STD_LOGIC_VECTOR(31 downto 0);
	  dbg_IFID_NPC   : out STD_LOGIC_VECTOR(31 downto 0);
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
		dbg_MemToReg : out STD_LOGIC
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
	signal ID_rs1_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal ID_rs2_addr : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal RF_rs1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal RF_rs2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

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
	
	
	
	-----------------------------------
	-- STAGE 3: EXEC ------------------
	-----------------------------------
	-- cond- branch condition result (branch taken or not)
	signal cond : STD_LOGIC := '0';
	-- will need an output of this stage to be the branch target address, used in IF
	signal branch_target : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	
	-----------------------------------
	-- EXEC/MEM Pipeline registers ----
	-----------------------------------
	
	
	
	-----------------------------------
	-- STAGE 4: MEM --------------------
	-----------------------------------
	
	-----------------------------------
	-- MEM/WB Pipeline registers -----
	-----------------------------------
	
	
	
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
	
	begin
		-- rf read addresses come directly from the instruction currently in IF/ID
		-- combinatorial outside of clocked process so it can be an instant read 
		ID_rs1_addr <= IFID_IR(19 DOWNTO 15);
		ID_rs2_addr <= IFID_IR(24 DOWNTO 20);

		--testing signals
		dbg_IF_IR   <= IF_IR;
		dbg_IFID_IR <= IFID_IR;
		dbg_ID_IR   <= ID_IR;
		dbg_IF_NPC   <= IF_NPC;
	   dbg_IFID_NPC  <= IFID_NPC;
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
		
		
		process(clk, reset)
		begin
			if reset = '1' then
				-- reset the pipeline registers
				IFID_IR  <= (others => '0');
				IFID_NPC <= (others => '0');
				
			elsif rising_edge(clk) then
			   if stall = '1' then
					IFID_IR  <= IFID_IR;
					IFID_NPC <= IFID_NPC;
				-- if branch is taken, IR and NPC will be zerod out- let this indicate a NOP
				-- will also need to flush out other control signals like RegWrite, MemWrite, MemRead, Branch...
			   elsif cond = '1' then
					IFID_IR  <= (others => '0');
					IFID_NPC <= (others => '0');
			   else
					IFID_IR  <= IF_IR;
					IFID_NPC <= IF_NPC;
			  end if;
			end if;
		end process;

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
					-- hold ID/EX state on stall
					IDEX_A <= IDEX_A;
					IDEX_B <= IDEX_B;
					IDEX_Imm <= IDEX_Imm;
					IDEX_IR <= IDEX_IR;
					IDEX_NPC <= IDEX_NPC;

					IDEX_ALUSrc <= IDEX_ALUSrc;
					IDEX_ALUOp <= IDEX_ALUOp;
					IDEX_ALUFunc <= IDEX_ALUFunc;
					IDEX_Branch <= IDEX_Branch;
					IDEX_BranchType <= IDEX_BranchType;
					IDEX_Jump <= IDEX_Jump;
					IDEX_JumpReg <= IDEX_JumpReg;
					IDEX_MemRead <= IDEX_MemRead;
					IDEX_MemWrite <= IDEX_MemWrite;
					IDEX_RegWrite <= IDEX_RegWrite;
					IDEX_MemToReg <= IDEX_MemToReg;

				elsif cond = '1' then
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
end rtl;