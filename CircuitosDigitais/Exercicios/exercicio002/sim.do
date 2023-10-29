if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vcom -work work ex5.vhd
vcom -work work ex5_tb.vhd

vsim -voptargs=+acc=lprn -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wave.do 

run 300 ns

