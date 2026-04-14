vlib work
vcom execute.vhd
vcom execute_tb.vhd

vsim -voptargs=+acc execute_tb

add wave -r /*

run -all