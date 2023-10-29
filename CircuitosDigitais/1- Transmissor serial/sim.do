if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vcom -work work tx_serial.vhd
vcom -work work tx_serial_tb.vhd

vsim -voptargs=+acc=lprn -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wave.do 

run 600 ns

