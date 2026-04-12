LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Goal of this stage is to fetch instruction from instruction memory at current PC register address, and compute NPC=PC+4

entity instruction_fetch is
	port (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;												-- reset PC = 0x0
		cond : in STD_LOGIC;													-- aka branch taken- 0 or 1
		branch_target : IN STD_LOGIC_VECTOR (31 DOWNTO 0);			-- target address to branch to in case branch taken
		stall : in STD_LOGIC;												-- 1 = stall instruction, dont increment PC, dont fetch next instruction
		
		IR : out STD_LOGIC_VECTOR (31 DOWNTO 0);						-- holds instruction fetched
		NPC : out STD_LOGIC_VECTOR (31 DOWNTO 0)						-- holds next instruction address (PC + 4)
	);
end instruction_fetch;

architecture rtl of instruction_fetch is
	-- component and signal declaration --
	component memory is 
		GENERIC(
        ram_size : INTEGER := 8192;
        mem_delay : time := 1 ns;
        clock_period : time := 1 ns
		);
		PORT(
        clock : IN STD_LOGIC;
        writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        address : IN INTEGER RANGE 0 TO ram_size-1;
        memwrite : IN STD_LOGIC;
        memread : IN STD_LOGIC;
        readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        waitrequest : OUT STD_LOGIC
		);
	end component;
	
	signal PC : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal IR_reg : std_logic_vector(31 downto 0);
	signal NPC_reg : std_logic_vector(31 downto 0);
	signal waitrequest_unused : STD_LOGIC;		-- ModelSim for some stupid reason has issues with open so I replaced it witha dummy signal
	signal pc_index : INTEGER RANGE 0 TO 8191;		-- word aligned, so ignore last 2 bits
	signal IR_mem : std_logic_vector(31 downto 0);
	
	begin

		pc_index <= to_integer(unsigned(PC(14 DOWNTO 2)));

		instr_memory : memory
		 PORT MAP(
			clock => clk,
			writedata => (others => '0'),
			address => pc_index,		-- word aligned, so ignore last 2 bits
			memwrite => '0',
			memread => '1',
			readdata => IR_mem,
			waitrequest => waitrequest_unused							-- do not care about this port, is unconnected
		 );
		 
		 -- combinatorial logic
		 IR <= IR_reg;
		 NPC <= NPC_reg;
		 
		 -- clocked process
		 process(clk, reset)
		 begin
			-- reset PC = 0x0
			if(reset = '1') then
				PC <= (others => '0');
				IR_reg <= (others => '0');
				NPC_reg <= (others => '0');
				
			-- clocked process for PC update
			elsif rising_edge(clk) then
				if (stall = '1') then
					-- freeze fetch stage outputs and PC during data hazard stall
					PC <= PC;
					IR_reg <= IR_reg;
					NPC_reg <= NPC_reg;
				else
					IR_reg <= IR_mem;
					NPC_reg <= std_logic_vector(unsigned(PC) + 4);
					if (cond = '0') then
						PC <= std_logic_vector(unsigned(PC) + 4);
					else
						PC <= branch_target;
					end if;
				end if;
			end if;
		 end process;
	
end rtl;
