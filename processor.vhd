-- This will be the top level entity, the wrapper of all 5 stages
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- need a 'stall' signal which will be passed to IF and ID in case a data hazard is detected
-- this level will be responsible for doing the data hazard detection and setting stall = 1 in case theres a RAW

entity processor is
	port(
		clk : in STD_LOGIC;
      reset : in STD_LOGIC
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
	
	-----------------------------------
	-- ID/EXEC Pipeline registers -----
	-----------------------------------
	
	
	
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
	
	begin
		-- pipeline stage instantiations
		IF_stage : instruction_fetch port map(clk => clk, reset => reset, cond => cond, branch_target => branch_target, stall => stall, IR => IF_IR, NPC => IF_NPC);
		
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
end rtl;