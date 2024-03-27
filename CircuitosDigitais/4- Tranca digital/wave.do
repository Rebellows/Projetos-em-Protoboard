onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/DUT/clock
add wave -noupdate /tb/DUT/reset
add wave -noupdate -divider FSM
add wave -noupdate /tb/DUT/EA
add wave -noupdate /tb/DUT/PE
add wave -noupdate -divider INPUT
add wave -noupdate /tb/DUT/configurar
add wave -noupdate /tb/DUT/valido
add wave -noupdate /tb/DUT/entrada
add wave -noupdate -divider OUTPUT
add wave -noupdate /tb/DUT/configurado
add wave -noupdate /tb/DUT/alarme
add wave -noupdate /tb/DUT/tranca
add wave -noupdate -divider INTERNAL
add wave -noupdate /tb/DUT/A1
add wave -noupdate /tb/DUT/A2
add wave -noupdate /tb/DUT/A3
add wave -noupdate /tb/DUT/AUX
add wave -noupdate /tb/DUT/controlF
add wave -noupdate /tb/DUT/controlS
add wave -noupdate /tb/DUT/P1
add wave -noupdate /tb/DUT/P2
add wave -noupdate /tb/DUT/P3
add wave -noupdate /tb/DUT/QE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9267330 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
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
WaveRestoreZoom {9050 ns} {9807576 ps}
