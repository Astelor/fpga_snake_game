transcript off
#=================================
# WAVE WIDGET CONFIG 
#=================================
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
wave zoom range 0ps 2500ps
variable TB "sim:tb_snake_controller"
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

radix signal $TB/oMapAddr "d"
radix signal $TB/bruh/counter "d"
radix signal $TB/bruh/map_counter "d"

radix define States {
    0 "IDLE", 
    1 "INIT", 
    2 "WRITE", 
    3 "INPUT_WAIT", 
    4 "MOVE",           -color cyan
    6 "INIT_HEAD",      -color gold
    7 "INIT_TAIL",      -color gold
    5 "SSNAKE1",        -color magenta
    8 "SSNAKE2",        -color magenta
    9 "SSNAKE3",        -color gold
    10 "SSNAKE4",       -color blue
    11 "SSNAKE5",
    12 "SSNAKE6",
    8'hx "X",
    -default dec
}
radix signal $TB/bruh/rState "States"

restart
run -all