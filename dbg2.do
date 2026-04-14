mem load -infile integration_data_hazards_bin.txt -format binary /integration_data_hazards_tb/uut/IF_stage/instr_memory/ram_block
run 1.1ns
mem load -infile regs_init.txt -format binary /integration_data_hazards_tb/uut/RF_stage/regs
for {set t 0} {$t < 30} {incr t} {
  run 1ns
  set ifid [examine -radix hex /integration_data_hazards_tb/uut/IFID_IR]
  set idex [examine -radix hex /integration_data_hazards_tb/uut/IDEX_IR]
  set exm [examine -radix hex /integration_data_hazards_tb/uut/EXMEM_IR_out]
  set mwb [examine -radix hex /integration_data_hazards_tb/uut/MEMWB_IR_out]
  set st [examine /integration_data_hazards_tb/uut/stall]
  set hx [examine /integration_data_hazards_tb/uut/hazard_ex]
  set hm [examine /integration_data_hazards_tb/uut/hazard_mem]
  set hw [examine /integration_data_hazards_tb/uut/hazard_wb]
  set wen [examine /integration_data_hazards_tb/uut/WB_regfile_write_en]
  set wa [examine -radix unsigned /integration_data_hazards_tb/uut/WB_regfile_write_addr]
  set wd [examine -radix signed /integration_data_hazards_tb/uut/WB_regfile_write_data]
  echo "step=$t IFID=$ifid IDEX=$idex EXMEM=$exm MEMWB=$mwb stall=$st hx=$hx hm=$hm hw=$hw WB=($wen,$wa,$wd)"
}
mem display -startaddress 0 -endaddress 8 /integration_data_hazards_tb/uut/RF_stage/regs
quit -f
