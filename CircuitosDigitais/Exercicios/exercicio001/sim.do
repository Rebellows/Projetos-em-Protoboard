if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vcom -work work ex4.vhd
vcom -work work ex4_tb.vhd

vsim -voptargs=+acc=lprn -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

add wave -noupdate /tb/reset
add wave -noupdate /tb/ck
add wave -noupdate -divider {registradores}
add wave -noupdate /tb/dut/opA
add wave -noupdate /tb/dut/opB
add wave -noupdate -divider {saida}
add wave -noupdate /tb/saida

run 300 ns

