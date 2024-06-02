if {[file isdirectory work]} { vdel -all -lib work }

vlib work
vmap work work

vlog -work work xtea_top.v
vlog -work work xtea_enc.v
vlog -work work xtea_dec.v
vlog -work work xtea_tb.v

vsim -voptargs="+acc=lprn" -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wave.do 

run 1000 us
