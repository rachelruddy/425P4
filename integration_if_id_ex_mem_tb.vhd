library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;        
use ieee.std_logic_textio.all;

entity integration_if_id_ex_mem_tb is
end;

architecture tb of integration_if_id_ex_mem_tb is
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
		
		
		-- MEM outputs
		signal dbg_MEM_LMD_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEM_ALUResult_out  : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEM_IR_out         : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEM_NPC_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEM_RegWrite_out   : STD_LOGIC;
		signal dbg_MEM_MemToReg_out   : STD_LOGIC;

		-- MEM/WB pipeline registers
		signal dbg_MEMWB_LMD_out       : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEMWB_ALUResult_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEMWB_IR_out        : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEMWB_NPC_out       : STD_LOGIC_VECTOR(31 DOWNTO 0);
		signal dbg_MEMWB_RegWrite_out  : STD_LOGIC;
		signal dbg_MEMWB_MemToReg_out  : STD_LOGIC;

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
				dbg_EXMEM_MemToReg_out : OUT STD_LOGIC;
				
				-- outputs of MEM
				dbg_MEM_LMD_out        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEM_ALUResult_out  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEM_IR_out         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEM_NPC_out        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEM_RegWrite_out   : OUT STD_LOGIC;
				dbg_MEM_MemToReg_out   : OUT STD_LOGIC;

				-- MEM/WB pipeline registers
				dbg_MEMWB_LMD_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEMWB_ALUResult_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEMWB_IR_out        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEMWB_NPC_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				dbg_MEMWB_RegWrite_out  : OUT STD_LOGIC;
				dbg_MEMWB_MemToReg_out  : OUT STD_LOGIC
		
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
		dbg_EXMEM_MemToReg_out => dbg_EXMEM_MemToReg_out,
		
		dbg_MEM_LMD_out        => dbg_MEM_LMD_out,
		dbg_MEM_ALUResult_out  => dbg_MEM_ALUResult_out,
		dbg_MEM_IR_out         => dbg_MEM_IR_out,
		dbg_MEM_NPC_out        => dbg_MEM_NPC_out,
		dbg_MEM_RegWrite_out   => dbg_MEM_RegWrite_out,
		dbg_MEM_MemToReg_out   => dbg_MEM_MemToReg_out,

		dbg_MEMWB_LMD_out       => dbg_MEMWB_LMD_out,
		dbg_MEMWB_ALUResult_out => dbg_MEMWB_ALUResult_out,
		dbg_MEMWB_IR_out        => dbg_MEMWB_IR_out,
		dbg_MEMWB_NPC_out       => dbg_MEMWB_NPC_out,
		dbg_MEMWB_RegWrite_out  => dbg_MEMWB_RegWrite_out,
		dbg_MEMWB_MemToReg_out  => dbg_MEMWB_MemToReg_out
		
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
		 -- readme
		 -- =====================================================================

		 -- wait for first rising edge
		 wait until rising_edge(clk);
		 wait for 0.1 ns;

		 -------------------------------------------------------------------------------------------------------------------------------
		 -- instr1:  SW x2, 0(x0), 
		 -- instr2:  LW x3, 0(x0)
		 -------------------------------------------------------------------------------------------------------------------------------
		 -- reset
		reset <= '1';
		wait for 1 ns;
		reset <= '0';

		wait until rising_edge(clk);
		wait for 0.1 ns;
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 1: SW in IF
		-------------------------------------------------------------------------------------------------------------------------------
		if (dbg_IF_IR /= "00000000001000000010000000100011") then
			 report "FAIL: IF_IR incorrect at cycle 1 (SW)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		wait until rising_edge(clk);
		wait for 0.1 ns;
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 2: SW in ID, LW in IF
		-------------------------------------------------------------------------------------------------------------------------------
		if (dbg_IF_IR /= "00000000000000000010000110000011") then
			 report "FAIL: IF_IR incorrect at cycle 2 (LW)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if dbg_MemWrite /= '1' then
			 report "FAIL: MemWrite incorrect at cycle 2 (SW in ID)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if dbg_RegWrite /= '0' then
			 report "FAIL: RegWrite incorrect at cycle 2 (SW in ID, should be 0)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;
		
		
		if (dbg_B /= x"00000003") then
			 report "FAIL: B incorrect at cycle 2 (SW in ID, x2 should be 3, got " & 
					  integer'image(to_integer(unsigned(dbg_B))) & 
					  " (0x" & to_hstring(dbg_B) & "))" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;
		
		report "DEBUG: ID_IR at cycle 2 = " & to_hstring(dbg_ID_IR) severity note;
		report "DEBUG: B at cycle 2 = " & to_hstring(dbg_B) severity note;
		report "DEBUG: rs2 extracted = " & integer'image(to_integer(unsigned(dbg_ID_IR(24 downto 20)))) severity note;
		report "DEBUG: rs1 extracted = " & integer'image(to_integer(unsigned(dbg_ID_IR(19 downto 15)))) severity note;

		wait until rising_edge(clk);
		wait for 0.1 ns;
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 3: SW in EX, LW in ID
		-- SW: ALU computes x0 + 0 = 0 (memory address)
		-- LW: decoded, MemRead=1
		-- ADDI x4, x1, 10 in IF
		-------------------------------------------------------------------------------------------------------------------------------
		if (dbg_EX_ALUResult_out /= x"00000000") then
			 report "FAIL: EX_ALUResult incorrect at cycle 3 (SW address should be 0)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if dbg_EX_MemWrite_out /= '1' then
			 report "FAIL: EX_MemWrite_out incorrect at cycle 3 (SW)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;
		
		

		-- LW now in ID
		if dbg_MemRead /= '1' then
			 report "FAIL: MemRead incorrect at cycle 3 (LW in ID)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;
		
		if (dbg_IF_IR /= "00000000101000001000001000010011") then
			 report "FAIL: IF_IR incorrect at cycle 3 (ADDI)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if (dbg_IF_NPC /= x"0000000C") then
			 report "FAIL: IF_NPC incorrect at cycle 3 (ADDI)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;
		
		--ADDI
		 if (dbg_IF_IR /= "00000000101000001000001000010011") then
             report "FAIL: IF_IR incorrect at cycle 3 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"0000000C") then
             report "FAIL: IF_NPC incorrect at cycle 3 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;


		wait until rising_edge(clk);
		wait for 0.1 ns;
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 4: SW in MEM (write happens here), LW in EX
		-- SW: memory write occurs, B_out should contain x2=3
		-- LW: ALU computes x0+0=0 (memory address)
		-- ADDI in ID
		-- BEQ x0, x9, 8 in IF
		-------------------------------------------------------------------------------------------------------------------------------
		if (dbg_EXMEM_ALUResult_out /= x"00000000") then
			 report "FAIL: EXMEM_ALUResult incorrect at cycle 4 (SW address)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if (dbg_EXMEM_B_out /= x"00000003") then
			 report "FAIL: EXMEM_B_out incorrect at cycle 4 (SW store value should be 3, got " & 
					  integer'image(to_integer(unsigned(dbg_EXMEM_B_out))) & 
					  " (0x" & to_hstring(dbg_EXMEM_B_out) & "))" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if dbg_EXMEM_MemWrite_out /= '1' then
			 report "FAIL: EXMEM_MemWrite_out incorrect at cycle 4 (SW)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		-- LW in EX
		if (dbg_EX_ALUResult_out /= x"00000000") then
			 report "FAIL: EX_ALUResult incorrect at cycle 4 (LW address should be 0)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;
		
		--ADDI in ID
		if (dbg_A /= x"00000005") then
             report "FAIL: A incorrect at cycle 4 (ADDI, expected x1=5, got " &
                      to_hstring(dbg_A) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"0000000A") then
             report "FAIL: imm incorrect at cycle 4 (ADDI, expected 10, got " &
                      to_hstring(dbg_imm) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_ALUSrc /= '1' then
             report "FAIL: ALUSrc incorrect at cycle 4 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '1' then
             report "FAIL: RegWrite incorrect at cycle 4 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemRead /= '0' then
             report "FAIL: MemRead incorrect at cycle 4 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemWrite /= '0' then
             report "FAIL: MemWrite incorrect at cycle 4 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- BEQ
			 if (dbg_IF_IR /= "00000000100100000000010001100011") then
             report "FAIL: IF_IR incorrect at cycle 4 (BEQ taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"00000010") then
             report "FAIL: IF_NPC incorrect at cycle 4 (BEQ taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

		wait until rising_edge(clk);
		wait for 0.1 ns;
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 5: SW in MEMWB (passthrough), LW in MEM (read happens here)
		-- SW: RegWrite=0, nothing written to register file
		-- LW: memory read occurs, LMD should get value 3
		-- ADDI in EXEC
		-- beq in id
		-- BEQ x1, x2, 8 in IF
		-------------------------------------------------------------------------------------------------------------------------------
		if dbg_MEMWB_RegWrite_out /= '0' then
			 report "FAIL: MEMWB_RegWrite_out incorrect at cycle 5 (SW should not write register)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		-- LW in MEM - check MEM outputs
		if (dbg_MEM_LMD_out /= x"00000003") then
			 report "FAIL: MEM_LMD_out incorrect at cycle 5 (LW should read 3)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if dbg_MEM_MemToReg_out /= '1' then
			 report "FAIL: MEM_MemToReg_out incorrect at cycle 5 (LW)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;
		
		if (dbg_EX_ALUResult_out /= x"0000000F") then
             report "FAIL: EX_ALUResult_out incorrect at cycle 5 (ADDI, expected 5+10=15, got " &
                      to_hstring(dbg_EX_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_BranchTaken /= '0' then
             report "FAIL: EX_BranchTaken incorrect at cycle 5 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '1' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 5 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- beq
			if (dbg_A /= x"00000000") then
             report "FAIL: A incorrect at cycle 5 (BEQ taken, expected x0=0, got " &
                      to_hstring(dbg_A) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_B /= x"00000000") then
             report "FAIL: B incorrect at cycle 5 (BEQ taken, expected x9=0, got " &
                      to_hstring(dbg_B) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"00000008") then
             report "FAIL: imm incorrect at cycle 5 (BEQ taken, expected 8, got " &
                      to_hstring(dbg_imm) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Branch /= '1' then
             report "FAIL: Branch incorrect at cycle 5 (BEQ taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_BranchType /= "000") then
             report "FAIL: BranchType incorrect at cycle 5 (BEQ taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '0' then
             report "FAIL: RegWrite incorrect at cycle 5 (BEQ taken, should be 0)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--beq2
			if (dbg_IF_IR /= "00000000001000001000010001100011") then
             report "FAIL: IF_IR incorrect at cycle 5 (BEQ not taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"00000014") then
             report "FAIL: IF_NPC incorrect at cycle 5 (BEQ not taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

		wait until rising_edge(clk);
		wait for 0.1 ns;
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- cycle 6: LW in MEMWB
		-- LMD should be 3, MemToReg=1, RegWrite=1
		-- ADDI in MEM
		-- BEQ in ex
		-- beq2 in id
		-- JAL x1, 12 in IF
		-------------------------------------------------------------------------------------------------------------------------------
		if (dbg_MEMWB_LMD_out /= x"00000003") then
			 report "FAIL: MEMWB_LMD_out incorrect at cycle 6 (LW should have loaded 3)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if dbg_MEMWB_RegWrite_out /= '1' then
			 report "FAIL: MEMWB_RegWrite_out incorrect at cycle 6 (LW should write register)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;

		if dbg_MEMWB_MemToReg_out /= '1' then
			 report "FAIL: MEMWB_MemToReg_out incorrect at cycle 6 (LW)" severity error;
			 fail_count := fail_count + 1;
		else
			 pass_count := pass_count + 1;
		end if;
		
		-- ADDI mem
		if (dbg_MEM_ALUResult_out /= x"0000000F") then
             report "FAIL: MEM_ALUResult_out incorrect at cycle 6 (ADDI, expected 15, got " &
                      to_hstring(dbg_MEM_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_RegWrite_out /= '1' then
             report "FAIL: MEM_RegWrite_out incorrect at cycle 6 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_MemToReg_out /= '0' then
             report "FAIL: MEM_MemToReg_out incorrect at cycle 6 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--beq
			if dbg_EX_BranchTaken /= '1' then
             report "FAIL: EX_BranchTaken incorrect at cycle 6 (BEQ taken, expected 1)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_BranchTarget /= x"00000014") then
             report "FAIL: EX_BranchTarget incorrect at cycle 6 (BEQ taken, expected 0x14, got " &
                      to_hstring(dbg_EX_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_ALUResult_out /= x"00000000") then
             report "FAIL: EX_ALUResult_out incorrect at cycle 6 (BEQ taken, expected 0, got " &
                      to_hstring(dbg_EX_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '0' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 6 (BEQ taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- beq2
			if (dbg_A /= x"00000005") then
             report "FAIL: A incorrect at cycle 6 (BEQ not taken, expected x1=5, got " &
                      to_hstring(dbg_A) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_B /= x"00000003") then
             report "FAIL: B incorrect at cycle 6 (BEQ not taken, expected x2=3, got " &
                      to_hstring(dbg_B) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"00000008") then
             report "FAIL: imm incorrect at cycle 6 (BEQ not taken, expected 8, got " &
                      to_hstring(dbg_imm) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_Branch /= '1' then
             report "FAIL: Branch incorrect at cycle 6 (BEQ not taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_BranchType /= "000") then
             report "FAIL: BranchType incorrect at cycle 6 (BEQ not taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '0' then
             report "FAIL: RegWrite incorrect at cycle 6 (BEQ not taken, should be 0)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			-- jal
			if (dbg_IF_IR /= "00000000110000000000000011101111") then
             report "FAIL: IF_IR incorrect at cycle 6 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"00000018") then
             report "FAIL: IF_NPC incorrect at cycle 6 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

			
			wait until rising_edge(clk);
         wait for 0.1 ns;
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 7: ADDI in MEMWB
         -- critical: ALUResult=15, RegWrite=1, MemToReg=0
			-- BEQ in MEM
			-- beq2 in exec
			-- jal in id
			-- JALR x1, x2, 0 in IF
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_MEMWB_ALUResult_out /= x"0000000F") then
             report "FAIL: MEMWB_ALUResult_out incorrect at cycle 7 (ADDI, expected 15, got " &
                      to_hstring(dbg_MEMWB_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_RegWrite_out /= '1' then
             report "FAIL: MEMWB_RegWrite_out incorrect at cycle 7 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_MemToReg_out /= '0' then
             report "FAIL: MEMWB_MemToReg_out incorrect at cycle 7 (ADDI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--BEQ
			if (dbg_EXMEM_BranchTaken /= '1') then
             report "FAIL: EXMEM_BranchTaken incorrect at cycle 7 (BEQ taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_BranchTarget /= x"00000014") then
             report "FAIL: EXMEM_BranchTarget incorrect at cycle 7 (BEQ taken, expected 0x14, got " &
                      to_hstring(dbg_EXMEM_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_RegWrite_out /= '0' then
             report "FAIL: MEM_RegWrite_out incorrect at cycle 7 (BEQ taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--beq2
			if dbg_EX_BranchTaken /= '0' then
             report "FAIL: EX_BranchTaken incorrect at cycle 7 (BEQ not taken, expected 0)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			if (dbg_EX_BranchTarget /= x"00000000") then
             report "FAIL: EX_BranchTarget incorrect at cycle 7 (BEQ not taken, expected 0, got " &
                      to_hstring(dbg_EX_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;


         if dbg_EX_RegWrite_out /= '0' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 7 (BEQ not taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--jal
			if dbg_Jump /= '1' then
             report "FAIL: Jump incorrect at cycle 7 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '1' then
             report "FAIL: RegWrite incorrect at cycle 7 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemRead /= '0' then
             report "FAIL: MemRead incorrect at cycle 7 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemWrite /= '0' then
             report "FAIL: MemWrite incorrect at cycle 7 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"0000000C") then
             report "FAIL: imm incorrect at cycle 7 (JAL, expected 12, got " &
                      to_hstring(dbg_imm) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--jalr
			if (dbg_IF_IR /= "00000000000000010000000011100111") then
             report "FAIL: IF_IR incorrect at cycle 7 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"0000001C") then
             report "FAIL: IF_NPC incorrect at cycle 7 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			

			
			wait until rising_edge(clk);
         wait for 0.1 ns;
			
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 8: BEQ in MEMWB
         -- critical: RegWrite=0, MemToReg=0
			-- beq2 in mem
			-- jal in ex
			-- jalr in id
			-- LUI x5, 5 in IF
         -------------------------------------------------------------------------------------------------------------------------------

         if dbg_MEMWB_RegWrite_out /= '0' then
             report "FAIL: MEMWB_RegWrite_out incorrect at cycle 8 (BEQ taken, should not write register)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_MemToReg_out /= '0' then
             report "FAIL: MEMWB_MemToReg_out incorrect at cycle 8 (BEQ taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--beq2
			if (dbg_EXMEM_BranchTaken /= '0') then
             report "FAIL: EXMEM_BranchTaken incorrect at cycle 8 (BEQ not taken, expected 0)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_RegWrite_out /= '0' then
             report "FAIL: MEM_RegWrite_out incorrect at cycle 8 (BEQ not taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--jal
			if (dbg_EX_ALUResult_out /= x"00000018") then
             report "FAIL: EX_ALUResult_out incorrect at cycle 8 (JAL, expected NPC=0x18, got " &
                      to_hstring(dbg_EX_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_BranchTaken /= '1' then
             report "FAIL: EX_BranchTaken incorrect at cycle 8 (JAL, expected 1)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_BranchTarget /= x"00000020") then
             report "FAIL: EX_BranchTarget incorrect at cycle 8 (JAL, expected 0x20, got " &
                      to_hstring(dbg_EX_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '1' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 8 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--jalr
			if dbg_JumpReg /= '1' then
             report "FAIL: JumpReg incorrect at cycle 8 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '1' then
             report "FAIL: RegWrite incorrect at cycle 8 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_A /= x"00000003") then
             report "FAIL: A incorrect at cycle 8 (JALR, expected x2=3, got " &
                      to_hstring(dbg_A) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_imm /= x"00000000") then
             report "FAIL: imm incorrect at cycle 8 (JALR, expected 0, got " &
                      to_hstring(dbg_imm) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemRead /= '0' then
             report "FAIL: MemRead incorrect at cycle 8 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MemWrite /= '0' then
             report "FAIL: MemWrite incorrect at cycle 8 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--LUI
			if (dbg_IF_IR /= "00000000000000000101001010110111") then
             report "FAIL: IF_IR incorrect at cycle 8 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"00000020") then
             report "FAIL: IF_NPC incorrect at cycle 8 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			
			wait until rising_edge(clk);
         wait for 0.1 ns;
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 9: BEQ not taken in MEMWB
         -- critical: RegWrite=0, MemToReg=0
			-- jal in mem
			-- jalr in ex
			-- lui in id
			-- SRA x6, x1, x2 in IF
         -------------------------------------------------------------------------------------------------------------------------------

         if dbg_MEMWB_RegWrite_out /= '0' then
             report "FAIL: MEMWB_RegWrite_out incorrect at cycle 9 (BEQ not taken, should not write register)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_MemToReg_out /= '0' then
             report "FAIL: MEMWB_MemToReg_out incorrect at cycle 9 (BEQ not taken)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--jal
			if (dbg_EXMEM_ALUResult_out /= x"00000018") then
             report "FAIL: EXMEM_ALUResult_out incorrect at cycle 9 (JAL, expected 0x18, got " &
                      to_hstring(dbg_EXMEM_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_BranchTaken /= '1' then
             report "FAIL: EXMEM_BranchTaken incorrect at cycle 9 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_BranchTarget /= x"00000020") then
             report "FAIL: EXMEM_BranchTarget incorrect at cycle 9 (JAL, expected 0x20, got " &
                      to_hstring(dbg_EXMEM_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_RegWrite_out /= '1' then
             report "FAIL: MEM_RegWrite_out incorrect at cycle 9 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_MEM_ALUResult_out /= x"00000018") then
             report "FAIL: MEM_ALUResult_out incorrect at cycle 9 (JAL, expected 0x18, got " &
                      to_hstring(dbg_MEM_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--jalr
			if (dbg_EX_ALUResult_out /= x"0000001C") then
             report "FAIL: EX_ALUResult_out incorrect at cycle 9 (JALR, expected NPC=0x1C, got " &
                      to_hstring(dbg_EX_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_BranchTaken /= '1' then
             report "FAIL: EX_BranchTaken incorrect at cycle 9 (JALR, expected 1)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EX_BranchTarget /= x"00000002") then
             report "FAIL: EX_BranchTarget incorrect at cycle 9 (JALR, expected x2+0 bit0 cleared=2, got " &
                      to_hstring(dbg_EX_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '1' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 9 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--lui
			if (dbg_imm /= x"00005000") then
             report "FAIL: imm incorrect at cycle 9 (LUI, expected 0x00005000, got " &
                      to_hstring(dbg_imm) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_ALUSrc /= '1' then
             report "FAIL: ALUSrc incorrect at cycle 9 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUOp /= "11") then
             report "FAIL: ALUOp incorrect at cycle 9 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUFunc /= "1010") then
             report "FAIL: ALUFunc incorrect at cycle 9 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '1' then
             report "FAIL: RegWrite incorrect at cycle 9 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--sra
			if (dbg_IF_IR /= "01000000001000001101001100110011") then
             report "FAIL: IF_IR incorrect at cycle 9 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_IF_NPC /= x"00000024") then
             report "FAIL: IF_NPC incorrect at cycle 9 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

			
			
			wait until rising_edge(clk);
         wait for 0.1 ns;
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 10: JAL in MEMWB
         -- critical: ALUResult=0x18 (return address to write to x1), RegWrite=1, MemToReg=0
			-- jalr in mem
			-- lui in ex
			-- sra in id
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_MEMWB_ALUResult_out /= x"00000018") then
             report "FAIL: MEMWB_ALUResult_out incorrect at cycle 10 (JAL, expected 0x18, got " &
                      to_hstring(dbg_MEMWB_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_RegWrite_out /= '1' then
             report "FAIL: MEMWB_RegWrite_out incorrect at cycle 10 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_MemToReg_out /= '0' then
             report "FAIL: MEMWB_MemToReg_out incorrect at cycle 10 (JAL)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--jalr
			if (dbg_EXMEM_ALUResult_out /= x"0000001C") then
             report "FAIL: EXMEM_ALUResult_out incorrect at cycle 10 (JALR, expected 0x1C, got " &
                      to_hstring(dbg_EXMEM_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EXMEM_BranchTaken /= '1' then
             report "FAIL: EXMEM_BranchTaken incorrect at cycle 10 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_EXMEM_BranchTarget /= x"00000002") then
             report "FAIL: EXMEM_BranchTarget incorrect at cycle 10 (JALR, expected 0x2, got " &
                      to_hstring(dbg_EXMEM_BranchTarget) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_RegWrite_out /= '1' then
             report "FAIL: MEM_RegWrite_out incorrect at cycle 10 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_MEM_ALUResult_out /= x"0000001C") then
             report "FAIL: MEM_ALUResult_out incorrect at cycle 10 (JALR, expected 0x1C, got " &
                      to_hstring(dbg_MEM_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--lui ex
			if (dbg_EX_ALUResult_out /= x"00005000") then
             report "FAIL: EX_ALUResult_out incorrect at cycle 10 (LUI, expected 0x00005000, got " &
                      to_hstring(dbg_EX_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_BranchTaken /= '0' then
             report "FAIL: EX_BranchTaken incorrect at cycle 10 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '1' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 10 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--sra
			if (dbg_A /= x"00000005") then
             report "FAIL: A incorrect at cycle 10 (SRA, expected x1=5, got " &
                      to_hstring(dbg_A) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_B /= x"00000003") then
             report "FAIL: B incorrect at cycle 10 (SRA, expected x2=3, got " &
                      to_hstring(dbg_B) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_ALUSrc /= '0' then
             report "FAIL: ALUSrc incorrect at cycle 10 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUOp /= "10") then
             report "FAIL: ALUOp incorrect at cycle 10 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if (dbg_ALUFunc /= "0111") then
             report "FAIL: ALUFunc incorrect at cycle 10 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_RegWrite /= '1' then
             report "FAIL: RegWrite incorrect at cycle 10 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			wait until rising_edge(clk);
         wait for 0.1 ns;
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 11: JALR in MEMWB
         -- critical: ALUResult=0x1C (return address to write to x1), RegWrite=1, MemToReg=0
			-- lui mem
			-- sra in ex
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_MEMWB_ALUResult_out /= x"0000001C") then
             report "FAIL: MEMWB_ALUResult_out incorrect at cycle 11 (JALR, expected 0x1C, got " &
                      to_hstring(dbg_MEMWB_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_RegWrite_out /= '1' then
             report "FAIL: MEMWB_RegWrite_out incorrect at cycle 11 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_MemToReg_out /= '0' then
             report "FAIL: MEMWB_MemToReg_out incorrect at cycle 11 (JALR)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--lui
			if (dbg_MEM_ALUResult_out /= x"00005000") then
             report "FAIL: MEM_ALUResult_out incorrect at cycle 11 (LUI, expected 0x00005000, got " &
                      to_hstring(dbg_MEM_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_RegWrite_out /= '1' then
             report "FAIL: MEM_RegWrite_out incorrect at cycle 11 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_MemToReg_out /= '0' then
             report "FAIL: MEM_MemToReg_out incorrect at cycle 11 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--sra
			if (dbg_EX_ALUResult_out /= x"00000000") then
             report "FAIL: EX_ALUResult_out incorrect at cycle 11 (SRA, expected 5>>3=0, got " &
                      to_hstring(dbg_EX_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_BranchTaken /= '0' then
             report "FAIL: EX_BranchTaken incorrect at cycle 11 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_EX_RegWrite_out /= '1' then
             report "FAIL: EX_RegWrite_out incorrect at cycle 11 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			wait until rising_edge(clk);
         wait for 0.1 ns;
			
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 12: LUI in MEMWB
         -- critical: ALUResult=0x00005000, RegWrite=1, MemToReg=0
			--sra in mem
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_MEMWB_ALUResult_out /= x"00005000") then
             report "FAIL: MEMWB_ALUResult_out incorrect at cycle 12 (LUI, expected 0x00005000, got " &
                      to_hstring(dbg_MEMWB_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_RegWrite_out /= '1' then
             report "FAIL: MEMWB_RegWrite_out incorrect at cycle 12 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_MemToReg_out /= '0' then
             report "FAIL: MEMWB_MemToReg_out incorrect at cycle 12 (LUI)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			--sra
			 if (dbg_MEM_ALUResult_out /= x"00000000") then
             report "FAIL: MEM_ALUResult_out incorrect at cycle 12 (SRA, expected 0, got " &
                      to_hstring(dbg_MEM_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_RegWrite_out /= '1' then
             report "FAIL: MEM_RegWrite_out incorrect at cycle 12 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEM_MemToReg_out /= '0' then
             report "FAIL: MEM_MemToReg_out incorrect at cycle 12 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;
			
			wait until rising_edge(clk);
         wait for 0.1 ns;
			
         -------------------------------------------------------------------------------------------------------------------------------
         -- cycle 13: SRA in MEMWB
         -- critical: ALUResult=0, RegWrite=1, MemToReg=0
         -------------------------------------------------------------------------------------------------------------------------------

         if (dbg_MEMWB_ALUResult_out /= x"00000000") then
             report "FAIL: MEMWB_ALUResult_out incorrect at cycle 13 (SRA, expected 0, got " &
                      to_hstring(dbg_MEMWB_ALUResult_out) & ")" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_RegWrite_out /= '1' then
             report "FAIL: MEMWB_RegWrite_out incorrect at cycle 13 (SRA)" severity error;
             fail_count := fail_count + 1;
         else
             pass_count := pass_count + 1;
         end if;

         if dbg_MEMWB_MemToReg_out /= '0' then
             report "FAIL: MEMWB_MemToReg_out incorrect at cycle 13 (SRA)" severity error;
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