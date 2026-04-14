vlib work
vcom memory.vhd
vcom memory_tb.vhd

vsim -voptargs=+acc memory_tb

add wave -r /*

run -all