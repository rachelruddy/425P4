library ieee;
use ieee.std_logic_1164.all;

entity integration_if_id_tb is
end;

architecture tb of integration_if_id_tb is
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
				dbg_MemToReg : out STD_LOGIC
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
		dbg_MemToReg => dbg_MemToReg
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
		 -- cycle 1: IF should have first instruction
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
		 -- cycle 2: ID should now have ADD x3, x1, x2 instruction 1, IF should have SUB x3, x1, x2 (5-3) instruction 2
		 -------------------------------------------------------------------------------------------------------------------------------
		 --check IF's output signals
		 if (dbg_IF_IR /= "01000000001000001000000110110011") then
				 report "FAIL: IF_IR incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 if (dbg_IF_NPC /= "00000000000000000000000000001000") then
				 report "FAIL: IF_NPC incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 
		 --check pipeline registers
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
		 
		 
		 -- check ID's output signals
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
				 report "FAIL: dbgA incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 if (dbg_B /= x"00000003") then
				 report "FAIL: dbgB incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 if (dbg_imm /= x"00000000") then
				 report "FAIL: imm incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 if dbg_ALUSrc /= '0' then
				 report "FAIL: alusrc incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 if (dbg_ALUOp /= "10") then
				 report "FAIL: aluop incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 if (dbg_ALUFunc /= "0000") then
				 report "FAIL: alufunc incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 if dbg_Branch /= '0' then
				 report "FAIL: alubranch incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 if dbg_Jump /= '0' then
				 report "FAIL: alujump incorrect at cycle 2" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
		 end if;
		 
		 wait until rising_edge(clk);
		 wait for 0.1 ns;
		 
		 -------------------------------------------------------------------------------------------------------------------------------
		 -- cycle 3: ID should have SUB x3, x1, x2 (5-3) instruction 2, and IF should have MUL x3, x1, x2 instruction 3
		 -------------------------------------------------------------------------------------------------------------------------------
		 -- check IF's output signals
			if (dbg_IF_IR /= "00000010001000001000000110110011") then
				 report "FAIL: IF_IR incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000001100") then
				 report "FAIL: IF_NPC incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "01000000001000001000000110110011") then
				 report "FAIL: IFID_IR incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000001000") then
				 report "FAIL: IFID_NPC incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "01000000001000001000000110110011") then
				 report "FAIL: ID_IR incorrect at cycle 3" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000001000") then
				 report "FAIL: ID_NPC incorrect at cycle 3" severity error;
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
			
			wait until rising_edge(clk);
			wait for 0.1 ns;
			
			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 4: ID should have MUL x3, x1, x2 (instruction 3), IF should have OR x3, x1, x2 (instruction 4)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000001000001110000110110011") then
				 report "FAIL: IF_IR incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000010000") then
				 report "FAIL: IF_NPC incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000010001000001000000110110011") then
				 report "FAIL: IFID_IR incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000001100") then
				 report "FAIL: IFID_NPC incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000010001000001000000110110011") then
				 report "FAIL: ID_IR incorrect at cycle 4" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000001100") then
				 report "FAIL: ID_NPC incorrect at cycle 4" severity error;
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
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 5: ID should have OR x3, x1, x2 (instruction 4), IF should have AND x3, x1, x2 (instruction 5)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000001000001111000110110011") then
				 report "FAIL: IF_IR incorrect at cycle 5" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000010100") then
				 report "FAIL: IF_NPC incorrect at cycle 5" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000001000001110000110110011") then
				 report "FAIL: IFID_IR incorrect at cycle 5" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000010000") then
				 report "FAIL: IFID_NPC incorrect at cycle 5" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000001000001110000110110011") then
				 report "FAIL: ID_IR incorrect at cycle 5" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000010000") then
				 report "FAIL: ID_NPC incorrect at cycle 5" severity error;
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
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 6: ID should have AND x3, x1, x2 (instruction 5), IF should have ADDI x3, x1, 7 (instruction 6)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000011100001000000110010011") then
				 report "FAIL: IF_IR incorrect at cycle 6" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000011000") then
				 report "FAIL: IF_NPC incorrect at cycle 6" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000001000001111000110110011") then
				 report "FAIL: IFID_IR incorrect at cycle 6" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000010100") then
				 report "FAIL: IFID_NPC incorrect at cycle 6" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000001000001111000110110011") then
				 report "FAIL: ID_IR incorrect at cycle 6" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000010100") then
				 report "FAIL: ID_NPC incorrect at cycle 6" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000000") then
				 report "FAIL: imm incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0011") then
				 report "FAIL: ALUFunc incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 6 (AND)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 7: ID should have ADDI x3, x1, 7 (instruction 6), IF should have XORI x3, x1, 7 (instruction 7)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000011100001100000110010011") then
				 report "FAIL: IF_IR incorrect at cycle 7" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000011100") then
				 report "FAIL: IF_NPC incorrect at cycle 7" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000011100001000000110010011") then
				 report "FAIL: IFID_IR incorrect at cycle 7" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000011000") then
				 report "FAIL: IFID_NPC incorrect at cycle 7" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000011100001000000110010011") then
				 report "FAIL: ID_IR incorrect at cycle 7" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000011000") then
				 report "FAIL: ID_NPC incorrect at cycle 7" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000007") then
				 report "FAIL: imm incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '1' then
				 report "FAIL: ALUSrc incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0000") then
				 report "FAIL: ALUFunc incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 7 (ADDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 8: ID should have XORI x3, x1, 7 (instruction 7), IF should have ORI x3, x1, 7 (instruction 8)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000011100001110000110010011") then
				 report "FAIL: IF_IR incorrect at cycle 8" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000100000") then
				 report "FAIL: IF_NPC incorrect at cycle 8" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000011100001100000110010011") then
				 report "FAIL: IFID_IR incorrect at cycle 8" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000011100") then
				 report "FAIL: IFID_NPC incorrect at cycle 8" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000011100001100000110010011") then
				 report "FAIL: ID_IR incorrect at cycle 8" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000011100") then
				 report "FAIL: ID_NPC incorrect at cycle 8" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000007") then
				 report "FAIL: imm incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '1' then
				 report "FAIL: ALUSrc incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "1000") then
				 report "FAIL: ALUFunc incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 8 (XORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 9: ID should have ORI x3, x1, 7 (instruction 8), IF should have ANDI x3, x1, 7 (instruction 9)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000011100001111000110010011") then
				 report "FAIL: IF_IR incorrect at cycle 9" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000100100") then
				 report "FAIL: IF_NPC incorrect at cycle 9" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000011100001110000110010011") then
				 report "FAIL: IFID_IR incorrect at cycle 9" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000100000") then
				 report "FAIL: IFID_NPC incorrect at cycle 9" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000011100001110000110010011") then
				 report "FAIL: ID_IR incorrect at cycle 9" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000100000") then
				 report "FAIL: ID_NPC incorrect at cycle 9" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000007") then
				 report "FAIL: imm incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '1' then
				 report "FAIL: ALUSrc incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0100") then
				 report "FAIL: ALUFunc incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 9 (ORI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 10: ID should have ANDI x3, x1, 7 (instruction 9), IF should have SW x2, 7(x1) (instruction 10)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000001000001010001110100011") then
				 report "FAIL: IF_IR incorrect at cycle 10" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000101000") then
				 report "FAIL: IF_NPC incorrect at cycle 10" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000011100001111000110010011") then
				 report "FAIL: IFID_IR incorrect at cycle 10" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000100100") then
				 report "FAIL: IFID_NPC incorrect at cycle 10" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000011100001111000110010011") then
				 report "FAIL: ID_IR incorrect at cycle 10" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000100100") then
				 report "FAIL: ID_NPC incorrect at cycle 10" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000007") then
				 report "FAIL: imm incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '1' then
				 report "FAIL: ALUSrc incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0011") then
				 report "FAIL: ALUFunc incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 10 (ANDI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 11: ID should have SW x2, 7(x1) (instruction 10), IF should have BEQ x1, x2, 24 (instruction 11)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000010001000001000010001100011") then
				 report "FAIL: IF_IR incorrect at cycle 11" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000101100") then
				 report "FAIL: IF_NPC incorrect at cycle 11" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000001000001010001110100011") then
				 report "FAIL: IFID_IR incorrect at cycle 11" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000101000") then
				 report "FAIL: IFID_NPC incorrect at cycle 11" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000001000001010001110100011") then
				 report "FAIL: ID_IR incorrect at cycle 11" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000101000") then
				 report "FAIL: ID_NPC incorrect at cycle 11" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000007") then
				 report "FAIL: imm incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '1' then
				 report "FAIL: ALUSrc incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "00") then
				 report "FAIL: ALUOp incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0000") then
				 report "FAIL: ALUFunc incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '0' then
				 report "FAIL: RegWrite incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '1' then
				 report "FAIL: MemWrite incorrect at cycle 11 (SW)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 12: ID should have BEQ x1, x2, 40 (instruction 11), IF should have BNE x1, x2, 24 (instruction 12)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000001000001001110001100011") then
				 report "FAIL: IF_IR incorrect at cycle 12" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000110000") then
				 report "FAIL: IF_NPC incorrect at cycle 12" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000010001000001000010001100011") then
				 report "FAIL: IFID_IR incorrect at cycle 12" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000101100") then
				 report "FAIL: IFID_NPC incorrect at cycle 12" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000010001000001000010001100011") then
				 report "FAIL: ID_IR incorrect at cycle 12" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000101100") then
				 report "FAIL: ID_NPC incorrect at cycle 12" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000028") then
				 report "FAIL: imm incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "01") then
				 report "FAIL: ALUOp incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '1' then
				 report "FAIL: Branch incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_BranchType /= "000") then
				 report "FAIL: BranchType incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '0' then
				 report "FAIL: RegWrite incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 12 (BEQ)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 13: ID should have BNE x1, x2, 24 (instruction 12), IF should have BLT x1, x2, 24 (instruction 13)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000001000001100110001100011") then
				 report "FAIL: IF_IR incorrect at cycle 13" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000110100") then
				 report "FAIL: IF_NPC incorrect at cycle 13" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000001000001001110001100011") then
				 report "FAIL: IFID_IR incorrect at cycle 13" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000110000") then
				 report "FAIL: IFID_NPC incorrect at cycle 13" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000001000001001110001100011") then
				 report "FAIL: ID_IR incorrect at cycle 13" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000110000") then
				 report "FAIL: ID_NPC incorrect at cycle 13" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000018") then
				 report "FAIL: imm incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "01") then
				 report "FAIL: ALUOp incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '1' then
				 report "FAIL: Branch incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_BranchType /= "001") then
				 report "FAIL: BranchType incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '0' then
				 report "FAIL: RegWrite incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 13 (BNE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 14: ID should have BLT x1, x2, 24 (instruction 13), IF should have BGE x1, x2, 24 (instruction 14)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000001000001101110001100011") then
				 report "FAIL: IF_IR incorrect at cycle 14" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000111000") then
				 report "FAIL: IF_NPC incorrect at cycle 14" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000001000001100110001100011") then
				 report "FAIL: IFID_IR incorrect at cycle 14" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000110100") then
				 report "FAIL: IFID_NPC incorrect at cycle 14" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000001000001100110001100011") then
				 report "FAIL: ID_IR incorrect at cycle 14" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000110100") then
				 report "FAIL: ID_NPC incorrect at cycle 14" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000018") then
				 report "FAIL: imm incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "01") then
				 report "FAIL: ALUOp incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '1' then
				 report "FAIL: Branch incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_BranchType /= "100") then
				 report "FAIL: BranchType incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '0' then
				 report "FAIL: RegWrite incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 14 (BLT)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 15: ID should have BGE x1, x2, 24 (instruction 14), IF should have JAL x1, 24 (instruction 15)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000001100000000000000011101111") then
				 report "FAIL: IF_IR incorrect at cycle 15" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000000111100") then
				 report "FAIL: IF_NPC incorrect at cycle 15" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000001000001101110001100011") then
				 report "FAIL: IFID_IR incorrect at cycle 15" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000111000") then
				 report "FAIL: IFID_NPC incorrect at cycle 15" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000001000001101110001100011") then
				 report "FAIL: ID_IR incorrect at cycle 15" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000111000") then
				 report "FAIL: ID_NPC incorrect at cycle 15" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000018") then
				 report "FAIL: imm incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "01") then
				 report "FAIL: ALUOp incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '1' then
				 report "FAIL: Branch incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_BranchType /= "101") then
				 report "FAIL: BranchType incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '0' then
				 report "FAIL: RegWrite incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 15 (BGE)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 16: ID should have JAL x1, 24 (instruction 15), IF should have JALR x1, x2, 12 (instruction 16)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000110000010000000011100111") then
				 report "FAIL: IF_IR incorrect at cycle 16" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000001000000") then
				 report "FAIL: IF_NPC incorrect at cycle 16" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000001100000000000000011101111") then
				 report "FAIL: IFID_IR incorrect at cycle 16" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000000111100") then
				 report "FAIL: IFID_NPC incorrect at cycle 16" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000001100000000000000011101111") then
				 report "FAIL: ID_IR incorrect at cycle 16" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000000111100") then
				 report "FAIL: ID_NPC incorrect at cycle 16" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00000018") then
				 report "FAIL: imm incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '1' then
				 report "FAIL: ALUSrc incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "00") then
				 report "FAIL: ALUOp incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0000") then
				 report "FAIL: ALUFunc incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '1' then
				 report "FAIL: Jump incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 16 (JAL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 17: ID should have JALR x1, x2, 12 (instruction 16), IF should have LUI x1, 5 (instruction 17)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000000000000101000010110111") then
				 report "FAIL: IF_IR incorrect at cycle 17" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000001000100") then
				 report "FAIL: IF_NPC incorrect at cycle 17" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000110000010000000011100111") then
				 report "FAIL: IFID_IR incorrect at cycle 17" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000001000000") then
				 report "FAIL: IFID_NPC incorrect at cycle 17" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000110000010000000011100111") then
				 report "FAIL: ID_IR incorrect at cycle 17" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000001000000") then
				 report "FAIL: ID_NPC incorrect at cycle 17" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"0000000C") then
				 report "FAIL: imm incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '1' then
				 report "FAIL: ALUSrc incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "00") then
				 report "FAIL: ALUOp incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0000") then
				 report "FAIL: ALUFunc incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_JumpReg /= '1' then
				 report "FAIL: JumpReg incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 17 (JALR)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 18: ID should have LUI x1, 5 (instruction 17), IF should have SLL x3, x1, x2 (instruction 18)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000001000001001000110110011") then
				 report "FAIL: IF_IR incorrect at cycle 18" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000001001000") then
				 report "FAIL: IF_NPC incorrect at cycle 18" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000000000000101000010110111") then
				 report "FAIL: IFID_IR incorrect at cycle 18" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000001000100") then
				 report "FAIL: IFID_NPC incorrect at cycle 18" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000000000000101000010110111") then
				 report "FAIL: ID_IR incorrect at cycle 18" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000001000100") then
				 report "FAIL: ID_NPC incorrect at cycle 18" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_imm /= x"00005000") then
				 report "FAIL: imm incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '1' then
				 report "FAIL: ALUSrc incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "11") then
				 report "FAIL: ALUOp incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "1010") then
				 report "FAIL: ALUFunc incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 18 (LUI)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 19: ID should have SLL x3, x1, x2 (instruction 18), IF should have SRA x3, x1, x2 (instruction 19)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "01000000001000001101000110110011") then
				 report "FAIL: IF_IR incorrect at cycle 19" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000001001100") then
				 report "FAIL: IF_NPC incorrect at cycle 19" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "00000000001000001001000110110011") then
				 report "FAIL: IFID_IR incorrect at cycle 19" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000001001000") then
				 report "FAIL: IFID_NPC incorrect at cycle 19" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "00000000001000001001000110110011") then
				 report "FAIL: ID_IR incorrect at cycle 19" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000001001000") then
				 report "FAIL: ID_NPC incorrect at cycle 19" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0101") then
				 report "FAIL: ALUFunc incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 19 (SLL)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;
			
			wait until rising_edge(clk);
			wait for 0.1 ns;

			-------------------------------------------------------------------------------------------------------------------------------
			-- cycle 20: ID should have SRA x3, x1, x2 (instruction 19), IF should have SLTI x3, x1, 7 (instruction 20)
			-------------------------------------------------------------------------------------------------------------------------------
			-- check IF's output signals
			if (dbg_IF_IR /= "00000000011100001010000110010011") then
				 report "FAIL: IF_IR incorrect at cycle 20" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IF_NPC /= "00000000000000000000000001010000") then
				 report "FAIL: IF_NPC incorrect at cycle 20" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check pipeline registers
			if (dbg_IFID_IR /= "01000000001000001101000110110011") then
				 report "FAIL: IFID_IR incorrect at cycle 20" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_IFID_NPC /= "00000000000000000000000001001100") then
				 report "FAIL: IFID_NPC incorrect at cycle 20" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			-- check ID's output signals
			if (dbg_ID_IR /= "01000000001000001101000110110011") then
				 report "FAIL: ID_IR incorrect at cycle 20" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ID_NPC /= "00000000000000000000000001001100") then
				 report "FAIL: ID_NPC incorrect at cycle 20" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_A /= x"00000005") then
				 report "FAIL: A incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_B /= x"00000003") then
				 report "FAIL: B incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_ALUSrc /= '0' then
				 report "FAIL: ALUSrc incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUOp /= "10") then
				 report "FAIL: ALUOp incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if (dbg_ALUFunc /= "0111") then
				 report "FAIL: ALUFunc incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Branch /= '0' then
				 report "FAIL: Branch incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_Jump /= '0' then
				 report "FAIL: Jump incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_RegWrite /= '1' then
				 report "FAIL: RegWrite incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemRead /= '0' then
				 report "FAIL: MemRead incorrect at cycle 20 (SRA)" severity error;
				 fail_count := fail_count + 1;
			else
				 pass_count := pass_count + 1;
			end if;

			if dbg_MemWrite /= '0' then
				 report "FAIL: MemWrite incorrect at cycle 20 (SRA)" severity error;
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