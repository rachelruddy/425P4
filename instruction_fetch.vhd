LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Goal of this stage is to fetch instruction from instruction memory at current PC register address, and compute NPC=PC+4

ENTITY instruction_fetch IS
	PORT (
		clk : IN STD_LOGIC;
		reset : IN STD_LOGIC; -- reset PC = 0x0
		cond : IN STD_LOGIC; -- aka branch taken- 0 or 1
		branch_target : IN STD_LOGIC_VECTOR (31 DOWNTO 0); -- target address to branch to in case branch taken
		stall : IN STD_LOGIC; -- 1 = stall instruction, dont increment PC, dont fetch next instruction

		IR : OUT STD_LOGIC_VECTOR (31 DOWNTO 0); -- holds instruction fetched
		NPC : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) -- holds next instruction address (PC + 4)
	);
END instruction_fetch;

ARCHITECTURE rtl OF instruction_fetch IS
	-- component and signal declaration --

	--Initialize the memory that will be used to hold instructions
	COMPONENT memory IS
		GENERIC (
			ram_size : INTEGER := 8192;
			mem_delay : TIME := 1 ns;
			clock_period : TIME := 1 ns
		);
		PORT (
			clock : IN STD_LOGIC;
			writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			address : IN INTEGER RANGE 0 TO ram_size - 1;
			memwrite : IN STD_LOGIC;
			memread : IN STD_LOGIC;
			readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			waitrequest : OUT STD_LOGIC
		);
	END COMPONENT;

	SIGNAL PC : STD_LOGIC_VECTOR (31 DOWNTO 0);
	SIGNAL IR_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL NPC_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL waitrequest_unused : STD_LOGIC; -- ModelSim for some stupid reason has issues with open so I replaced it witha dummy signal
	SIGNAL pc_index : INTEGER RANGE 0 TO 8191; -- word aligned, so ignore last 2 bits
	SIGNAL IR_mem : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

	pc_index <= to_integer(unsigned(PC(14 DOWNTO 2)));

	instr_memory : memory
	PORT MAP(
		clock => clk,
		writedata => (OTHERS => '0'),
		address => pc_index, -- word aligned, so ignore last 2 bits
		memwrite => '0',
		memread => '1',
		readdata => IR_mem,
		waitrequest => waitrequest_unused -- do not care about this port, is unconnected
	);

	-- combinatorial logic
	IR <= IR_reg;
	NPC <= NPC_reg;

	-- clocked process
	PROCESS (clk, reset)
	BEGIN
		-- reset PC = 0x0
		IF (reset = '1') THEN
			PC <= (OTHERS => '0');
			IR_reg <= (OTHERS => '0');
			NPC_reg <= (OTHERS => '0');

			-- clocked process for PC update
		ELSIF rising_edge(clk) THEN
			IF (stall = '1') THEN
				-- freeze fetch stage outputs and PC during data hazard stall
				PC <= PC;
				IR_reg <= IR_reg;
				NPC_reg <= NPC_reg;
			ELSE
				-- Signals if no stall is ordered
				IR_reg <= IR_mem;
				NPC_reg <= STD_LOGIC_VECTOR(unsigned(PC) + 4);
				IF (cond = '0') THEN
					PC <= STD_LOGIC_VECTOR(unsigned(PC) + 4); --if there is no branch porcced by incrementing PC
				ELSE
					PC <= branch_target; --if there is a branch set PC to the destination
				END IF;
			END IF;
		END IF;
	END PROCESS;

END rtl;