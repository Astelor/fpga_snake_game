transcript off
#================================= 
# WAVE WIDGET CONFIG 
#=================================
configure wave -namecolwidth 250
configure wave -valuecolwidth 70
wave zoom range 0ps 2500ps
variable TB "sim:tb_circular_queue"
#================================= 
# ADD WAVE 
#=================================
add wave -divider "TESTBENCH"
add wave *
add wave -divider "MODULE"
add wave $TB/bruh/*
#================================= 
# RADIX 
#=================================
radix -h

restart
run -all