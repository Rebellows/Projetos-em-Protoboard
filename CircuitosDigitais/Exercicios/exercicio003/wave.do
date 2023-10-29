onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/reset
add wave -noupdate /tb/dut/clock
add wave -noupdate -divider entradas
add wave -noupdate -radix hexadecimal /tb/dut/X
add wave -noupdate -radix hexadecimal /tb/dut/Y
add wave -noupdate -radix hexadecimal /tb/dut/Z
add wave -noupdate -divider {saida mux}
add wave -noupdate -radix hexadecimal /tb/dut/mu
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /tb/dut/OMUX
add wave -noupdate -divider registradores
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /tb/dut/L1
add wave -noupdate -radix hexadecimal /tb/dut/RA
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /tb/dut/L2
add wave -noupdate -radix hexadecimal /tb/dut/RB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {300 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {350 ns}
