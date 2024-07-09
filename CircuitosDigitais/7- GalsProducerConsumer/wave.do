onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {TOP}
add wave -noupdate /tb/top/reset
add wave -noupdate /tb/top/clock
add wave -noupdate /tb/top/EA
add wave -noupdate /tb/top/start_f
add wave -noupdate /tb/top/start_t
add wave -noupdate /tb/top/stop_f_t
add wave -noupdate /tb/top/parity
add wave -noupdate -divider {DCM}
add wave -noupdate /tb/top/dcm/update
add wave -noupdate -radix unsigned /tb/top/prog
add wave -noupdate -radix unsigned /tb/top/dcm/prog_out
add wave -noupdate /tb/top/dcm/clock_1
add wave -noupdate /tb/top/dcm/clock_2
add wave -noupdate -divider {FIB}
add wave -noupdate /tb/top/clock_1
add wave -noupdate /tb/top/fib/f_en
add wave -noupdate /tb/top/fib/f_valid
add wave -noupdate -radix unsigned /tb/top/fib/f_out
add wave -noupdate -divider {TIMER}
add wave -noupdate /tb/top/clock_1
add wave -noupdate /tb/top/t/t_en
add wave -noupdate /tb/top/t/t_valid
add wave -noupdate -radix unsigned /tb/top/t/t_out
add wave -noupdate -divider {WRAPPER}
add wave -noupdate /tb/top/wrp/clock_1
add wave -noupdate /tb/top/wrp/clock_2
add wave -noupdate /tb/top/wrp/buffer_empty
add wave -noupdate /tb/top/wrp/buffer_full
add wave -noupdate /tb/top/wrp/data_1_en
add wave -noupdate -radix unsigned /tb/top/wrp/data_1
add wave -noupdate /tb/top/wrp/data_2_valid
add wave -noupdate -radix unsigned /tb/top/wrp/data_2
add wave -noupdate -radix unsigned /tb/top/wrp/buffer_wr
add wave -noupdate -radix unsigned /tb/top/wrp/buffer_rd
add wave -noupdate -radix unsigned /tb/top/wrp/buffer_reg
add wave -noupdate -divider {DM}
add wave -noupdate -radix unsigned /tb/top/dm/prog
add wave -noupdate -radix unsigned /tb/top/dm/module_sig
add wave -noupdate -radix unsigned /tb/top/dm/data_2
add wave -noupdate -radix hexadecimal /tb/top/dm/an
add wave -noupdate -radix hexadecimal /tb/top/dm/dec_ddp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {300 ns}