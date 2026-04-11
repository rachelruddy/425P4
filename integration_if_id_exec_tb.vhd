library ieee;
use ieee.std_logic_1164.all;

entity integration_if_id_exec_tb is
end;

architecture tb of integration_if_id_exec_tb is
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
		signal dbg_EXMEM_MemRead_out :  STD_LOGIC;
		signal dbg_EXMEM_MemWrite_out :  STD_LOGIC;
		signal dbg_EXMEM_RegWrite_out :  STD_LOGIC;
		signal dbg_EXMEM_MemToReg_out :  STD_LOGIC;
		
		
		--EX/MEM pipeline regs

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
				dbg_EXMEM_MemRead_out : OUT STD_LOGIC;
				dbg_EXMEM_MemWrite_out : OUT STD_LOGIC;
				dbg_EXMEM_RegWrite_out : OUT STD_LOGIC;
				dbg_EXMEM_MemToReg_out : OUT STD_LOGIC
		
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
		dbg_EXMEM_MemRead_out => dbg_EXMEM_MemRead_out,
		dbg_EXMEM_MemWrite_out => dbg_EXMEM_MemWrite_out,
		dbg_EXMEM_RegWrite_out => dbg_EXMEM_RegWrite_out,
		dbg_EXMEM_MemToReg_out => dbg_EXMEM_MemToReg_out
		
		
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
		variable pass_count : integer := 0;
		variable fail_count : integer := 0;
	 begin
		 -- reset
		 reset <= '1';
		 wait for 1 ns;
		 reset <= '0';
		 
		 -- =====================================================================
		 -- instructions are already loaded into instruction memory via the tcl 
		 -- file for this integration test- binary instructions are located in 
		 -- integration_if_id_test_bin.txt
		 
		 -- i added intermediary signals all prefixed "dbg"
		 -- this allows us to view the values of the signals inside of 
		 -- processor.vhd while the component is running
		 -- once testing is done, we can remove these debugging signals
		 
		 -- for future integration tests, they can build off of the flow of this one
		 -- integration_if_id_test_bin contains almost every instruction except
		 -- srl, slti, and auipc
		 -- when integrating execute into the pipeline, can keep this source code
		 -- and add debug signals inside of processor that allow us to access 
		 -- the input signals of EX, the EX/MEM pipeline register signals, 
		 -- and the output signals of EX
		 
		 -- idea is you would keep all if the code below, add those dbg signals
		 -- into processor.vhd, then for each cycle you can see whether you are 
		 -- getting the expected results for execute
		 -- =====================================================================

		 -- wait for first rising edge
		 wait until rising_edge(clk);
		 wait for 0.1 ns;

		 -------------------------------------------------------------------------------------------------------------------------------
		 -- cycle 1: IF should have first instruction- ADD x3, x1, x2
		 -------------------------------------------------------------------------------------------------------------------------------
		 if (dbg_IF_IR /= "00000000001000001000000110110011") then
				 report "FAIL: IF_IR incorrect at cycle 1" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 if (dbg_IF_NPC /= "00000000000000000000000000000100") then
				 report "FAIL: IF_NPC incorrect at cycle 1" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 

		 wait until rising_edge(clk);
		 wait for 0.1 ns;
		 
		 -------------------------------------------------------------------------------------------------------------------------------
		 -- cycle 2: IF/ID pipeline registers should have instr 1's IR and NPC (dbg_IFID_IR, dbg_IFID_NPC ), and outputs of ID (dbg_ID_IR, dbg_ID_NPC, dbg_A, dbg_B, 
		 -- dbg_imm, dbg_ALUSrc dbg_ALUOp, dbg_ALUFunc, dbg_Branch, dbg_BranchType, dbg_Jump, dbg_JumpReg, dbg_MemRead, dbg_MemWrite, 
		 -- dbg_RegWrite, dbg_MemToReg) are all their values are correct for ADD x3, x1, x2
		 -------------------------------------------------------------------------------------------------------------------------------
		
		 if (dbg_IFID_IR /= "00000000001000001000000110110011") then
				 report "FAIL: IFID_IR incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000000100") then
				 report "FAIL: IFID_NPC incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_IR /= "00000000001000001000000110110011") then
				 report "FAIL: ID_IR incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000000100") then
				 report "FAIL: ID_NPC incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000000") then
				 report "FAIL: imm incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0000") then
				 report "FAIL: ALUFunc incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 2 (ADD)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- assertions for SUB instruction:
			if (dbg_IF_IR /= "01000000001000001000000110110011") then
				 report "FAIL: IF_IR incorrect at cycle 2 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000001000") then
				 report "FAIL: IF_NPC incorrect at cycle 2 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

		 wait until rising_edge(clk);
		 wait for 0.1 ns;
		 -------------------------------------------------------------------------------------------------------------------------------
		 -- cycle 3: ID/EX pipeline registers should have outputs instr1 from ID(dbg_IDEX_A,dbg_IDEX_B,dbg_IDEX_imm,dbg_IDEX_IR,
		 -- dbg_IDEX_NPC,dbg_IDEX_ALUSrc,dbg_IDEX_ALUOp,dbg_IDEX_ALUFunc,dbg_IDEX_Branch,dbg_IDEX_BranchType,dbg_IDEX_Jump,
		 -- dbg_IDEX_JumpReg,dbg_IDEX_MemWrite,dbg_IDEX_RegWrite, dbg_IDEX_MemToReg), and outputs of EX (dbg_EX_ALUResult_out, dbg_EX_B_out,
		 -- dbg_EX_IR_out, dbg_EX_NPC_out, dbg_EX_BranchTaken, dbg_EX_BranchTarget, dbg_EX_MemRead_out, dbg_EX_MemWrite_out, 
		 -- dbg_EX_RegWrite_out, dbg_EX_MemToReg_out) are all their values are correct for ADD x3, x1, x2
		 -------------------------------------------------------------------------------------------------------------------------------
		
			if (dbg_IDEX_IR /= "00000000001000001000000110110011") then
				 report "FAIL: IDEX_IR incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IDEX_NPC /= "00000000000000000000000000000100") then
				 report "FAIL: IDEX_NPC incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IDEX_A /= x"00000005") then
				 report "FAIL: IDEX_A incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IDEX_B /= x"00000003") then
				 report "FAIL: IDEX_B incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IDEX_ALUFunc /= "0000") then
				 report "FAIL: IDEX_ALUFunc incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_IDEX_ALUSrc /= '0' then
				 report "FAIL: IDEX_ALUSrc incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_IDEX_RegWrite /= '1' then
				 report "FAIL: IDEX_RegWrite incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_IDEX_MemRead /= '0' then
				 report "FAIL: IDEX_MemRead incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_IDEX_MemWrite /= '0' then
				 report "FAIL: IDEX_MemWrite incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- EX outputs (combinational, should be valid same cycle as IDEX)
			if (dbg_EX_ALUResult_out /= x"00000008") then
				 report "FAIL: EX_ALUResult incorrect at cycle 3 (expected 5+3=8)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EX_IR_out /= "00000000001000001000000110110011") then
				 report "FAIL: EX_IR_out incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EX_NPC_out /= "00000000000000000000000000000100") then
				 report "FAIL: EX_NPC_out incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EX_BranchTaken /= '0' then
				 report "FAIL: EX_BranchTaken incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EX_RegWrite_out /= '1' then
				 report "FAIL: EX_RegWrite_out incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EX_MemRead_out /= '0' then
				 report "FAIL: EX_MemRead_out incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EX_MemWrite_out /= '0' then
				 report "FAIL: EX_MemWrite_out incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			
			-- SUB in ID, IF/ID has SUB, ID outputs decoded values for SUB
			if (dbg_IFID_IR /= "01000000001000001000000110110011") then
				 report "FAIL: IFID_IR incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000001000") then
				 report "FAIL: IFID_NPC incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_IR /= "01000000001000001000000110110011") then
				 report "FAIL: ID_IR incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000001000") then
				 report "FAIL: ID_NPC incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000000") then
				 report "FAIL: imm incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0001") then
				 report "FAIL: ALUFunc incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 3 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- MUL now entering IF
         if (dbg_IF_IR /= "00000010001000001000000110110011") then
             report "FAIL: IF_IR incorrect at cycle 3 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"0000000C") then
             report "FAIL: IF_NPC incorrect at cycle 3 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

		 wait until rising_edge(clk);
		 wait for 0.1 ns;
		 -------------------------------------------------------------------------------------------------------------------------------
		 -- cycle 4: EX/MEM pipeline registers should have outputs instr1 from EX (dbg_EXMEM_ALUResult_out,dbg_EXMEM_B_out,dbg_EXMEM_IR_out,
		 -- dbg_EXMEM_NPC_out, dbg_EXMEM_BranchTaken,dbg_EXMEM_BranchTarget,dbg_EXMEM_MemRead_out,dbg_EXMEM_MemWrite_out,
		 -- dbg_EXMEM_RegWrite_out,dbg_EXMEM_MemToReg_out)
		 -------------------------------------------------------------------------------------------------------------------------------
			
			if (dbg_EXMEM_ALUResult_out /= x"00000008") then
				 report "FAIL: EXMEM_ALUResult incorrect at cycle 4 (expected 8)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EXMEM_IR_out /= "00000000001000001000000110110011") then
				 report "FAIL: EXMEM_IR_out incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EXMEM_NPC_out /= "00000000000000000000000000000100") then
				 report "FAIL: EXMEM_NPC_out incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EXMEM_BranchTaken /= '0' then
				 report "FAIL: EXMEM_BranchTaken incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EXMEM_RegWrite_out /= '1' then
				 report "FAIL: EXMEM_RegWrite_out incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EXMEM_MemRead_out /= '0' then
				 report "FAIL: EXMEM_MemRead_out incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EXMEM_MemWrite_out /= '0' then
				 report "FAIL: EXMEM_MemWrite_out incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- SUB in EX, ID/EX has SUB, EX outputs computed
			if (dbg_IDEX_IR /= "01000000001000001000000110110011") then
				 report "FAIL: IDEX_IR incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IDEX_NPC /= "00000000000000000000000000001000") then
				 report "FAIL: IDEX_NPC incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IDEX_A /= x"00000005") then
				 report "FAIL: IDEX_A incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IDEX_B /= x"00000003") then
				 report "FAIL: IDEX_B incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IDEX_ALUFunc /= "0001") then
				 report "FAIL: IDEX_ALUFunc incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_IDEX_ALUSrc /= '0' then
				 report "FAIL: IDEX_ALUSrc incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_IDEX_RegWrite /= '1' then
				 report "FAIL: IDEX_RegWrite incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_IDEX_MemRead /= '0' then
				 report "FAIL: IDEX_MemRead incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_IDEX_MemWrite /= '0' then
				 report "FAIL: IDEX_MemWrite incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EX_ALUResult_out /= x"00000002") then
				 report "FAIL: EX_ALUResult incorrect at cycle 4 (SUB, expected 5-3=2)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EX_IR_out /= "01000000001000001000000110110011") then
				 report "FAIL: EX_IR_out incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EX_NPC_out /= "00000000000000000000000000001000") then
				 report "FAIL: EX_NPC_out incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EX_BranchTaken /= '0' then
				 report "FAIL: EX_BranchTaken incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EX_RegWrite_out /= '1' then
				 report "FAIL: EX_RegWrite_out incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EX_MemRead_out /= '0' then
				 report "FAIL: EX_MemRead_out incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EX_MemWrite_out /= '0' then
				 report "FAIL: EX_MemWrite_out incorrect at cycle 4 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- MUL in IF/ID pipeline register
         if (dbg_IFID_IR /= "00000010001000001000000110110011") then
             report "FAIL: IFID_IR incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IFID_NPC /= x"0000000C") then
             report "FAIL: IFID_NPC incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- MUL ID combinational outputs
         if (dbg_ID_IR /= "00000010001000001000000110110011") then
             report "FAIL: ID_IR incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ID_NPC /= x"0000000C") then
             report "FAIL: ID_NPC incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_A /= x"00000005") then
             report "FAIL: A incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_B /= x"00000003") then
             report "FAIL: B incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"00000000") then
             report "FAIL: imm incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_ALUSrc /= '0' then
             report "FAIL: ALUSrc incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUOp /= "10") then
             report "FAIL: ALUOp incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUFunc /= "0010") then
             report "FAIL: ALUFunc incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Branch /= '0' then
             report "FAIL: Branch incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Jump /= '0' then
             report "FAIL: Jump incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '1' then
             report "FAIL: RegWrite incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemRead /= '0' then
             report "FAIL: MemRead incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemWrite /= '0' then
             report "FAIL: MemWrite incorrect at cycle 4 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- OR is in IF
			if (dbg_IF_IR /= "00000000001000001110000110110011") then
             report "FAIL: IF_IR incorrect at cycle 4 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"00000010") then
             report "FAIL: IF_NPC incorrect at cycle 4 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			
		 wait until rising_edge(clk);
		 wait for 0.1 ns;
		 
		   -------------------------------------------------------------------------------------------------------------------------------
			-- cycle 5: EX/MEM pipeline registers latch SUB results
			-------------------------------------------------------------------------------------------------------------------------------
			if (dbg_EXMEM_ALUResult_out /= x"00000002") then
				 report "FAIL: EXMEM_ALUResult incorrect at cycle 5 (SUB, expected 2)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EXMEM_IR_out /= "01000000001000001000000110110011") then
				 report "FAIL: EXMEM_IR_out incorrect at cycle 5 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_EXMEM_NPC_out /= "00000000000000000000000000001000") then
				 report "FAIL: EXMEM_NPC_out incorrect at cycle 5 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EXMEM_BranchTaken /= '0' then
				 report "FAIL: EXMEM_BranchTaken incorrect at cycle 5 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EXMEM_RegWrite_out /= '1' then
				 report "FAIL: EXMEM_RegWrite_out incorrect at cycle 5 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EXMEM_MemRead_out /= '0' then
				 report "FAIL: EXMEM_MemRead_out incorrect at cycle 5 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_EXMEM_MemWrite_out /= '0' then
				 report "FAIL: EXMEM_MemWrite_out incorrect at cycle 5 (SUB)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			-- MUL in ID/EX pipeline register
         if (dbg_IDEX_IR /= "00000010001000001000000110110011") then
             report "FAIL: IDEX_IR incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_NPC /= x"0000000C") then
             report "FAIL: IDEX_NPC incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_A /= x"00000005") then
             report "FAIL: IDEX_A incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_B /= x"00000003") then
             report "FAIL: IDEX_B incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_ALUFunc /= "0010") then
             report "FAIL: IDEX_ALUFunc incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_ALUSrc /= '0' then
             report "FAIL: IDEX_ALUSrc incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_RegWrite /= '1' then
             report "FAIL: IDEX_RegWrite incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_MemRead /= '0' then
             report "FAIL: IDEX_MemRead incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_MemWrite /= '0' then
             report "FAIL: IDEX_MemWrite incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- MUL EX combinational outputs
         if (dbg_EX_ALUResult_out /= x"0000000F") then
             report "FAIL: EX_ALUResult incorrect at cycle 5 (MUL, expected 5*3=15)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_IR_out /= "00000010001000001000000110110011") then
             report "FAIL: EX_IR_out incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_NPC_out /= x"0000000C") then
             report "FAIL: EX_NPC_out incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_BranchTaken /= '0' then
             report "FAIL: EX_BranchTaken incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '1' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_MemRead_out /= '0' then
             report "FAIL: EX_MemRead_out incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_MemWrite_out /= '0' then
             report "FAIL: EX_MemWrite_out incorrect at cycle 5 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- OR in IF/ID pipeline register
         if (dbg_IFID_IR /= "00000000001000001110000110110011") then
             report "FAIL: IFID_IR incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IFID_NPC /= x"00000010") then
             report "FAIL: IFID_NPC incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- OR ID combinational outputs
         if (dbg_ID_IR /= "00000000001000001110000110110011") then
             report "FAIL: ID_IR incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ID_NPC /= x"00000010") then
             report "FAIL: ID_NPC incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_A /= x"00000005") then
             report "FAIL: A incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_B /= x"00000003") then
             report "FAIL: B incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"00000000") then
             report "FAIL: imm incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_ALUSrc /= '0' then
             report "FAIL: ALUSrc incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUOp /= "10") then
             report "FAIL: ALUOp incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUFunc /= "0100") then
             report "FAIL: ALUFunc incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Branch /= '0' then
             report "FAIL: Branch incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Jump /= '0' then
             report "FAIL: Jump incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '1' then
             report "FAIL: RegWrite incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemRead /= '0' then
             report "FAIL: MemRead incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemWrite /= '0' then
             report "FAIL: MemWrite incorrect at cycle 5 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- SW now in IF
			if (dbg_IF_IR /= "00000000001000001010001110100011") then
             report "FAIL: IF_IR incorrect at cycle 5 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"00000014") then
             report "FAIL: IF_NPC incorrect at cycle 5 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			
			wait until rising_edge(clk);
         wait for 0.1 ns;
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 6: EX/MEM pipeline registers latch MUL results
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_EXMEM_ALUResult_out /= x"0000000F") then
             report "FAIL: EXMEM_ALUResult incorrect at cycle 6 (MUL, expected 15)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_IR_out /= "00000010001000001000000110110011") then
             report "FAIL: EXMEM_IR_out incorrect at cycle 6 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_NPC_out /= x"0000000C") then
             report "FAIL: EXMEM_NPC_out incorrect at cycle 6 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_BranchTaken /= '0' then
             report "FAIL: EXMEM_BranchTaken incorrect at cycle 6 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_RegWrite_out /= '1' then
             report "FAIL: EXMEM_RegWrite_out incorrect at cycle 6 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_MemRead_out /= '0' then
             report "FAIL: EXMEM_MemRead_out incorrect at cycle 6 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_MemWrite_out /= '0' then
             report "FAIL: EXMEM_MemWrite_out incorrect at cycle 6 (MUL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- OR in ID/EX pipeline register
         if (dbg_IDEX_IR /= "00000000001000001110000110110011") then
             report "FAIL: IDEX_IR incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_NPC /= x"00000010") then
             report "FAIL: IDEX_NPC incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_A /= x"00000005") then
             report "FAIL: IDEX_A incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_B /= x"00000003") then
             report "FAIL: IDEX_B incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_ALUFunc /= "0100") then
             report "FAIL: IDEX_ALUFunc incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_ALUSrc /= '0' then
             report "FAIL: IDEX_ALUSrc incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_RegWrite /= '1' then
             report "FAIL: IDEX_RegWrite incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_MemRead /= '0' then
             report "FAIL: IDEX_MemRead incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_MemWrite /= '0' then
             report "FAIL: IDEX_MemWrite incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- OR EX combinational outputs
         if (dbg_EX_ALUResult_out /= x"00000007") then
             report "FAIL: EX_ALUResult incorrect at cycle 6 (OR, expected 5|3=7)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_IR_out /= "00000000001000001110000110110011") then
             report "FAIL: EX_IR_out incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_NPC_out /= x"00000010") then
             report "FAIL: EX_NPC_out incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_BranchTaken /= '0' then
             report "FAIL: EX_BranchTaken incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '1' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_MemRead_out /= '0' then
             report "FAIL: EX_MemRead_out incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_MemWrite_out /= '0' then
             report "FAIL: EX_MemWrite_out incorrect at cycle 6 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- SW in IF/ID pipeline register
         if (dbg_IFID_IR /= "00000000001000001010001110100011") then
             report "FAIL: IFID_IR incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IFID_NPC /= x"00000014") then
             report "FAIL: IFID_NPC incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ID_IR /= "00000000001000001010001110100011") then
             report "FAIL: ID_IR incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ID_NPC /= x"00000014") then
             report "FAIL: ID_NPC incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_A /= x"00000005") then
             report "FAIL: A incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_B /= x"00000003") then
             report "FAIL: B incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"00000007") then
             report "FAIL: imm incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_ALUSrc /= '1' then
             report "FAIL: ALUSrc incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUOp /= "00") then
             report "FAIL: ALUOp incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUFunc /= "0000") then
             report "FAIL: ALUFunc incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Branch /= '0' then
             report "FAIL: Branch incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Jump /= '0' then
             report "FAIL: Jump incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '0' then
             report "FAIL: RegWrite incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemRead /= '0' then
             report "FAIL: MemRead incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemWrite /= '1' then
             report "FAIL: MemWrite incorrect at cycle 6 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- BEQ in IF
			if (dbg_IF_IR /= "00000010100101000000010001100011") then
             report "FAIL: IF_IR incorrect at cycle 6 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"00000018") then
             report "FAIL: IF_NPC incorrect at cycle 6 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

			
			wait until rising_edge(clk);
         wait for 0.1 ns;
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 7: EX/MEM pipeline registers latch OR results
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_EXMEM_ALUResult_out /= x"00000007") then
             report "FAIL: EXMEM_ALUResult incorrect at cycle 7 (OR, expected 5|3=7)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_IR_out /= "00000000001000001110000110110011") then
             report "FAIL: EXMEM_IR_out incorrect at cycle 7 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_NPC_out /= x"00000010") then
             report "FAIL: EXMEM_NPC_out incorrect at cycle 7 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_BranchTaken /= '0' then
             report "FAIL: EXMEM_BranchTaken incorrect at cycle 7 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_RegWrite_out /= '1' then
             report "FAIL: EXMEM_RegWrite_out incorrect at cycle 7 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_MemRead_out /= '0' then
             report "FAIL: EXMEM_MemRead_out incorrect at cycle 7 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_MemWrite_out /= '0' then
             report "FAIL: EXMEM_MemWrite_out incorrect at cycle 7 (OR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- SW in ID/EX pipeline register
         if (dbg_IDEX_IR /= "00000000001000001010001110100011") then
             report "FAIL: IDEX_IR incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_NPC /= x"00000014") then
             report "FAIL: IDEX_NPC incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_A /= x"00000005") then
             report "FAIL: IDEX_A incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_B /= x"00000003") then
             report "FAIL: IDEX_B incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_imm /= x"00000007") then
             report "FAIL: IDEX_imm incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_ALUSrc /= '1' then
             report "FAIL: IDEX_ALUSrc incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_ALUOp /= "00") then
             report "FAIL: IDEX_ALUOp incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_ALUFunc /= "0000") then
             report "FAIL: IDEX_ALUFunc incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_RegWrite /= '0' then
             report "FAIL: IDEX_RegWrite incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_MemRead /= '0' then
             report "FAIL: IDEX_MemRead incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_MemWrite /= '1' then
             report "FAIL: IDEX_MemWrite incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- SW EX combinational outputs
         if (dbg_EX_ALUResult_out /= x"0000000C") then
             report "FAIL: EX_ALUResult incorrect at cycle 7 (SW, expected 5+7=12)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_B_out /= x"00000003") then
             report "FAIL: EX_B_out incorrect at cycle 7 (SW, expected x2=3)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_IR_out /= "00000000001000001010001110100011") then
             report "FAIL: EX_IR_out incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_NPC_out /= x"00000014") then
             report "FAIL: EX_NPC_out incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_BranchTaken /= '0' then
             report "FAIL: EX_BranchTaken incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '0' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_MemRead_out /= '0' then
             report "FAIL: EX_MemRead_out incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_MemWrite_out /= '1' then
             report "FAIL: EX_MemWrite_out incorrect at cycle 7 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- BEQ in IF/ID pipeline register
         if (dbg_IFID_IR /= "00000010100101000000010001100011") then
             report "FAIL: IFID_IR incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IFID_NPC /= x"00000018") then
             report "FAIL: IFID_NPC incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- BEQ ID combinational outputs
         if (dbg_ID_IR /= "00000010100101000000010001100011") then
             report "FAIL: ID_IR incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ID_NPC /= x"00000018") then
             report "FAIL: ID_NPC incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_A /= x"00000000") then
             report "FAIL: A incorrect at cycle 7 (BEQ, expected x8=0)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_B /= x"00000000") then
             report "FAIL: B incorrect at cycle 7 (BEQ, expected x9=0)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"00000028") then
				 report "FAIL: imm incorrect at cycle 7 (BEQ, expected x00000028, got " & 
						  to_hstring(dbg_imm) & ")" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

         if dbg_ALUSrc /= '0' then
             report "FAIL: ALUSrc incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUOp /= "01") then
             report "FAIL: ALUOp incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Branch /= '1' then
             report "FAIL: Branch incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_BranchType /= "000") then
             report "FAIL: BranchType incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Jump /= '0' then
             report "FAIL: Jump incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '0' then
             report "FAIL: RegWrite incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemRead /= '0' then
             report "FAIL: MemRead incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemWrite /= '0' then
             report "FAIL: MemWrite incorrect at cycle 7 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			wait until rising_edge(clk);
         wait for 0.1 ns;
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 8: EX/MEM pipeline registers latch SW results
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_EXMEM_ALUResult_out /= x"0000000C") then
             report "FAIL: EXMEM_ALUResult incorrect at cycle 8 (SW, expected 5+7=12)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_B_out /= x"00000003") then
             report "FAIL: EXMEM_B_out incorrect at cycle 8 (SW, expected x2=3)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_IR_out /= "00000000001000001010001110100011") then
             report "FAIL: EXMEM_IR_out incorrect at cycle 8 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_NPC_out /= x"00000014") then
             report "FAIL: EXMEM_NPC_out incorrect at cycle 8 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_BranchTaken /= '0' then
             report "FAIL: EXMEM_BranchTaken incorrect at cycle 8 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_RegWrite_out /= '0' then
             report "FAIL: EXMEM_RegWrite_out incorrect at cycle 8 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_MemRead_out /= '0' then
             report "FAIL: EXMEM_MemRead_out incorrect at cycle 8 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_MemWrite_out /= '1' then
             report "FAIL: EXMEM_MemWrite_out incorrect at cycle 8 (SW)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- BEQ in ID/EX pipeline register
         if (dbg_IDEX_IR /= "00000010100101000000010001100011") then
             report "FAIL: IDEX_IR incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_NPC /= x"00000018") then
             report "FAIL: IDEX_NPC incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_A /= x"00000000") then
             report "FAIL: IDEX_A incorrect at cycle 8 (BEQ, expected x8=0)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_B /= x"00000000") then
             report "FAIL: IDEX_B incorrect at cycle 8 (BEQ, expected x9=0)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_imm /= x"00000028") then
             report "FAIL: IDEX_imm incorrect at cycle 8 (BEQ, got " &
                      to_hstring(dbg_IDEX_imm) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_ALUSrc /= '0' then
             report "FAIL: IDEX_ALUSrc incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_ALUOp /= "01") then
             report "FAIL: IDEX_ALUOp incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_Branch /= '1' then
             report "FAIL: IDEX_Branch incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IDEX_BranchType /= "000") then
             report "FAIL: IDEX_BranchType incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_RegWrite /= '0' then
             report "FAIL: IDEX_RegWrite incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_MemRead /= '0' then
             report "FAIL: IDEX_MemRead incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_IDEX_MemWrite /= '0' then
             report "FAIL: IDEX_MemWrite incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- BEQ EX combinational outputs
         if (dbg_EX_ALUResult_out /= x"00000000") then
             report "FAIL: EX_ALUResult incorrect at cycle 8 (BEQ, expected 0, got " &
                      to_hstring(dbg_EX_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_IR_out /= "00000010100101000000010001100011") then
             report "FAIL: EX_IR_out incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_NPC_out /= x"00000018") then
             report "FAIL: EX_NPC_out incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- branch taken since x8 == x9 (both 0)
         if dbg_EX_BranchTaken /= '1' then
             report "FAIL: EX_BranchTaken incorrect at cycle 8 (BEQ, expected taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         -- BranchTarget = NPC - 4 + 40 = 0x18 - 4 + 40 = 0x3C
         if (dbg_EX_BranchTarget /= x"0000003C") then
             report "FAIL: EX_BranchTarget incorrect at cycle 8 (BEQ, expected 0x3C, got " &
                      to_hstring(dbg_EX_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '0' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_MemRead_out /= '0' then
             report "FAIL: EX_MemRead_out incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_MemWrite_out /= '0' then
             report "FAIL: EX_MemWrite_out incorrect at cycle 8 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			wait until rising_edge(clk);
         wait for 0.1 ns;
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 9: EX/MEM pipeline registers latch BEQ results
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_EXMEM_ALUResult_out /= x"00000000") then
             report "FAIL: EXMEM_ALUResult incorrect at cycle 9 (BEQ, expected 0, got " &
                      to_hstring(dbg_EXMEM_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_IR_out /= "00000010100101000000010001100011") then
             report "FAIL: EXMEM_IR_out incorrect at cycle 9 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_NPC_out /= x"00000018") then
             report "FAIL: EXMEM_NPC_out incorrect at cycle 9 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_BranchTaken /= '1' then
             report "FAIL: EXMEM_BranchTaken incorrect at cycle 9 (BEQ, expected taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_BranchTarget /= x"0000003C") then
             report "FAIL: EXMEM_BranchTarget incorrect at cycle 9 (BEQ, expected 0x3C, got " &
                      to_hstring(dbg_EXMEM_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_RegWrite_out /= '0' then
             report "FAIL: EXMEM_RegWrite_out incorrect at cycle 9 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_MemRead_out /= '0' then
             report "FAIL: EXMEM_MemRead_out incorrect at cycle 9 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_MemWrite_out /= '0' then
             report "FAIL: EXMEM_MemWrite_out incorrect at cycle 9 (BEQ)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			
			
		 wait for 5 ns;
		 
		 
		 
		 report "===================================" severity note;
        report "Results: " & integer'image(pass_count) &
               " passed, " & integer'image(fail_count) & " failed." severity note;
        if fail_count = 0 then
            report "All tests PASSED." severity note;
        else
            report "Some tests FAILED - check output above." severity error;
        end if;
		  

		 assert false report "Simulation done" severity failure;
    end process;

end;