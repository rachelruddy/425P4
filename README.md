# RISC-V 5-Stage Pipelined Processor in VHDL

> **Important:** Please use the version of the assembler that does not already right-shift the immediate values for B and J instructions, as our decoding concatenates a `0` bit to the LSB of the encoded immediate value, in accordance with the RISC-V specification.

---

## File Dependency Structure

1. `processor.vhd` — top-level wrapper of the entire processor logic
   - `register_file.vhd` — register file instantiation, used by the instruction decode and writeback stages
   - `instruction_fetch.vhd`
     - `memory.vhd` — instruction memory instantiation
   - `instruction_decode.vhd`
   - `execute.vhd`
     - `ALU.vhd` — ALU component instantiation
   - `mem_pipeline.vhd`
     - `memory.vhd` — data memory instantiation
   - `writeback.vhd`

---

## Testing

Thorough testing was performed for the processor, conducted in several stages.

### Stage 1: Component Testing

We tested each of the individual components of the processor, such as `register_file`, `instruction_fetch`, `instruction_decode`, `execute`, etc.

This testing mainly focused on functionality and correctness. For example, in instruction decode, we made sure to test as many of the possible instructions that were expected to be implemented to see if they were decoded correctly.

### Stage 2: Integration Testing — No Hazards

Integration testing was done sequentially in order of the stages in the pipeline. For integration testing, the actual `processor.vhd` component was used, and we integrated many debugging signals that tracked the internal state of pipeline registers, as well as the combinatorial output of the different stage components. The logic in our 5 components is combinatorial, so the output from each stage happens concurrently, and the pipeline registers within `processor.vhd` (`IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB` signals) latch the outputs on the rising edge.

For our first part of integration testing, we tested the pipeline without introducing data or control hazards.

- **Integration 1 (IF + ID):** First, integration was done with IF and ID. This testing ensured that instructions entered the IF stage in their first cycle and were in ID in their second cycle in the pipeline. ModelSim was used for this task, as it allowed easy visual tracking of the instructions as they flowed through the pipeline via the clock signal, as well as running written tests on the testbench VHDL file.

- **Integration 2 (IF + ID + EX):** We ensured the results were as expected based on sample instructions. Ensured that instructions were in the EX stage in their third cycle in the pipeline by tracking specific debug signals in the ModelSim waveform view, as well as running written tests on the testbench VHDL file.

- **Integration 3 (IF + ID + EX + MEM):** We ensured the results were as expected based on sample instructions. Ensured that instructions were in the MEM stage in their 4th cycle in the pipeline by tracking specific debug signals in the ModelSim waveform view, as well as running written tests on the testbench VHDL file. Tested specifically with store and load instructions, and ensured that data memory was updated properly according to store instructions.

- **Integration 4 (IF + ID + EX + MEM + WB):** Tried various sample instructions and ensured that output signals in an instruction's 5th cycle in the pipeline were correct.

### Stage 3: Control Hazard Logic Implementation

We integrated logic for handling control hazards. Our pipeline assumes branches are not taken. Branch resolution takes place in the execute stage, so there is essentially 3 cycles of latency between an instruction that caused the hazard and when the next correct instruction flows out of the pipeline. This logic was implemented using two signals that receive `Branch_Taken` and `Branch_Target` from the execute stage. Then, in `processor.vhd`, the `IF/ID` and `ID/EX` pipeline registers are flushed (zeroed out). Testing ensured that when a taken branch, `JAL`, or `JALR` instruction was in the pipeline, the next 3 instructions were flushed. The ModelSim waveform view was helpful in allowing us to see the flow without writing many test cases.

### Stage 4: Data Hazard Logic Implementation

Data hazard stalling was implemented with a stall. Logic for the stall was added on top of our existing wrapper, `processor.vhd`.

---

## Results

Our pipeline produced the correct output for the factorial code example. Future improvements include further testing with a wider variety of programs.