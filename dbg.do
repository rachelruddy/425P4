vsim -c work.integration_data_hazards_tb -do "
mem load -infile integration_data_hazards_bin.txt -format binary /integration_data_hazards_tb/uut/IF_stage/instr_memory/ram_block;
run 1.1ns;
mem load -infile regs_init.txt -format binary /integration_data_hazards_tb/uut/RF_stage/regs;
proc phex {sig} {return [format %08X [expr {0x[string trim [examine -radix hex $sig] ]}]]}
for {set t 0} {$t < 20} {incr t} {
  run 1ns;
  set ifid [examine -radix hex /integration_data_hazards_tb/uut/IFID_IR];
  set idex [examine -radix hex /integration_data_hazards_tb/uut/IDEX_IR];
  set exm  [examine -radix hex /integration_data_hazards_tb/uut/EXMEM_IR_out];
  set mwb  [examine -radix hex /integration_data_hazards_tb/uut/MEMWB_IR_out];
  set st   [examine /integration_data_hazards_tb/uut/stall];
  set hx   [examine /integration_data_hazards_tb/uut/hazard_ex];
  set hm   [examine /integration_data_hazards_tb/uut/hazard_mem];
  set hw   [examine /integration_data_hazards_tb/uut/hazard_wb];
  set rs1  [examine -radix unsigned /integration_data_hazards_tb/uut/ID_rs1_addr];
  set rs2  [examine -radix unsigned /integration_data_hazards_tb/uut/ID_rs2_addr];
  set rdx  [examine -radix unsigned /integration_data_hazards_tb/uut/IDEX_rd_addr];
  set rdm  [examine -radix unsigned /integration_data_hazards_tb/uut/EXMEM_rd_addr];
  set rdw  [examine -radix unsigned /integration_data_hazards_tb/uut/MEMWB_rd_out];
  echo "t=[format %.1f [expr {[time]/1000.0}]]ns IFID=$ifid IDEX=$idex EXMEM=$exm MEMWB=$mwb stall=$st hx=$hx hm=$hm hw=$hw rs1=$rs1 rs2=$rs2 rdx=$rdx rdm=$rdm rdw=$rdw";
}
mem display -startaddress 0 -endaddress 8 /integration_data_hazards_tb/uut/RF_stage/regs;
quit -f"
