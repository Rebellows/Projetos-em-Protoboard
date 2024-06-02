# wave.do - Script for setting up the waveform window in ModelSim

# Handle errors gracefully
onerror {resume}

# Activate the waveform pane
quietly WaveActivateNextPane {} 0

# Add signals to the waveform window
add wave -noupdate /tb/clock
add wave -noupdate /tb/reset
add wave -noupdate /tb/start
add wave -noupdate /tb/configuration
add wave -noupdate -radix hexadecimal /tb/data_i
add wave -noupdate -radix hexadecimal /tb/key
add wave -noupdate /tb/ready
add wave -noupdate /tb/busy
add wave -noupdate -radix hexadecimal /tb/data_o

# Add dividers and internal signals
add wave -noupdate -divider FSM
add wave -noupdate /tb/top/EA
add wave -noupdate /tb/top/PE

add wave -noupdate -divider INPUT
add wave -noupdate -radix hexadecimal /tb/top/v
add wave -noupdate -radix hexadecimal /tb/top/k
add wave -noupdate -radix hexadecimal /tb/top/i
add wave -noupdate -radix hexadecimal /tb/top/aux

# Add signals from the encryption module
add wave -noupdate -divider ENCRYPTION
add wave -noupdate /tb/top/enc/EA
add wave -noupdate /tb/top/enc/PE
add wave -noupdate -radix hexadecimal /tb/top/enc/y0
add wave -noupdate -radix hexadecimal /tb/top/enc/z0
add wave -noupdate -radix hexadecimal /tb/top/enc/y1
add wave -noupdate -radix hexadecimal /tb/top/enc/z1
add wave -noupdate -radix hexadecimal /tb/top/enc/sum
add wave -noupdate -radix hexadecimal /tb/top/enc/ready
add wave -noupdate -radix hexadecimal /tb/top/enc/data_o

# Add signals from the decryption module
add wave -noupdate -divider DECRYPTION
add wave -noupdate /tb/top/dec/EA
add wave -noupdate /tb/top/dec/PE
add wave -noupdate -radix hexadecimal /tb/top/dec/y0
add wave -noupdate -radix hexadecimal /tb/top/dec/z0
add wave -noupdate -radix hexadecimal /tb/top/dec/y1
add wave -noupdate -radix hexadecimal /tb/top/dec/z1
add wave -noupdate -radix hexadecimal /tb/top/dec/sum
add wave -noupdate -radix hexadecimal /tb/top/dec/ready
add wave -noupdate -radix hexadecimal /tb/top/dec/data_o

# Update the waveform display
TreeUpdate [SetDefaultTree]

# Set waveform cursor and configuration
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

# Update the display
update

# Run the simulation
run 1000 us
