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
	
	begin
		instr_memory : memory
		 PORT MAP(
			clock => clk,
			writedata => (others => '0'),
			address => to_integer(unsigned(PC)) / 4,
			memwrite => '0',
			memread => '1',
			readdata => IR,
			waitrequest => open								-- do not care about this port, is unconnected
		 );
		 
		 -- combinatorial logic
		 NPC <= std_logic_vector(unsigned(PC) + 4);
		 
		 -- clocked process
		 process(clk, reset)
		 begin
			-- reset PC = 0x0
			if(reset = '1') then
				PC <= (others => '0');
				
			-- clocked process for PC update
			elsif rising_edge(clk) then
				-- if not stalled, update PC
				if (stall = '0') then
					-- PC + 4
					if (cond = '0') then
						PC <= std_logic_vector(unsigned(PC) + 4);
					-- need to fetch memory from branch target
					else
						PC <= branch_target;
					end if;
				-- if stalled, retain previous PC
				end if;
			end if;
		 end process;
	
end rtl;