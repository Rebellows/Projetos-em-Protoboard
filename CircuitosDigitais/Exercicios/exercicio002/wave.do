onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/reset
add wave -noupdate /tb/dut/clock
add wave -noupdate /tb/dut/SA
add wave -noupdate /tb/dut/enableA
add wave -noupdate /tb/dut/SB
add wave -noupdate /tb/dut/enableB
add wave -noupdate -radix hexadecimal /tb/dut/X
add wave -noupdate -radix hexadecimal /tb/dut/Y
add wave -noupdate -radix hexadecimal /tb/dut/RB
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /tb/dut/xmux
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /tb/dut/ymux
add wave -noupdate -divider registradores
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /tb/dut/regB
add wave -noupdate -color {Dark Orchid} -radix hexadecimal /tb/dut/regA
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
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
WaveRestoreZoom {0 ns} {330 ns}
