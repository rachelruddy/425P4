-- P4: need 2 instantiations of memory (instruction memory and data memory)
-- memwrite is always 0 for instruction memory
-- edits: changed to return 32 bits instead of a byte, changed mem_delay to same time as clock period
-- edits 04/10: removed signal read_adress_reg as this was causing a 2 cycle latency with instruction flow, now instruction is fetched combinatorially from input address


--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY memory IS
	GENERIC(
		ram_size : INTEGER := 8192;  -- 8192 words × 4 bytes = 32768 bytes
		mem_delay : time := 0.1 ns; -- mem access delay: PART 4- ALTERED THIS FROM 10 NS TO 1 NS SO DATA ARRIVES IN 1 CLOCK CYCLE (RACHEL)
		clock_period : time := 1 ns
	);
	-- memory acts as "follower" device in master, follower design
	-- master sends memwrite (m_write), writedata (m_writedata), address (m_address), readdata (m_read)
	-- follower outputs readdata (m_readdata, returns 1 byte at that mem location) and 
	-- waitrequest (m_waitrequest)- tells the master whether the memory is ready or still working	
		-- =1 when memory is idle or processing request
		-- =0 when transaction is complete- either read data is valid or write is done
	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO ram_size-1;
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
END memory;

ARCHITECTURE rtl OF memory IS
	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	--actual memory array
	SIGNAL ram_block : MEM := (OTHERS => (OTHERS => '0'));
	-- latched address for reads
	--SIGNAL read_address_reg: INTEGER RANGE 0 to ram_size-1;

	-- tracks write operations
	SIGNAL write_waitreq_reg: STD_LOGIC := '1';
	--tracks read operationss
	SIGNAL read_waitreq_reg: STD_LOGIC := '1';
BEGIN
	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)
	BEGIN
		--This is a cheap trick to initialize the SRAM in simulation
		--IF(now < 1 ps)THEN
		--	For i in 0 to ram_size-1 LOOP
		-- 		ram_block(i) <= (others => '0');
		--	END LOOP;
		--end if;

		--This is the actual synthesizable SRAM block
		IF (clock'event AND clock = '1') THEN
			--if write operation, put writedata into ram_block(address)
			IF (memwrite = '1') THEN
				ram_block(address) <= writedata;
			END IF;
		--always latch onto the value of the address
		--read_address_reg <= address;
		END IF;
	END PROCESS;

	--asynchronously put the contents of the latched address into readdata
	--readdata <= ram_block(read_address_reg);
	readdata <= ram_block(address);

	-- Is waitrequest necessary?
	--The waitrequest signal is used to vary response time in simulation
	--Read and write should never happen at the same time.
	waitreq_w_proc: PROCESS (memwrite)
	BEGIN
		IF(memwrite'event AND memwrite = '1')THEN
			write_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;

		END IF;
	END PROCESS;

	waitreq_r_proc: PROCESS (memread)
	BEGIN
		IF(memread'event AND memread = '1')THEN
			read_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;

	--set waitrequest to '0' after mem delay, and then after mem_delay + clk period, set back to 1 to signal that memory is idle or working
	waitrequest <= write_waitreq_reg and read_waitreq_reg;


END rtl;
