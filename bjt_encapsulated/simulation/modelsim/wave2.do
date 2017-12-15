onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/globalclock_tb
add wave -noupdate /testbench/rst_tb
add wave -noupdate /testbench/tx_spi_sclk_tb
add wave -noupdate /testbench/tx_spi_sync_tb
add wave -noupdate /testbench/tx_spi_din_tb
add wave -noupdate -radix unsigned /testbench/testbench/serial_counter
add wave -noupdate -radix unsigned /testbench/testbench/verti_counter
add wave -noupdate -radix unsigned /testbench/testbench/hori_counter
add wave -noupdate /testbench/testbench/stepwave
add wave -noupdate /testbench/testbench/sawtooth
add wave -noupdate /testbench/led_tb
add wave -noupdate /testbench/ADC_CONVST_tb
add wave -noupdate /testbench/ADC_SCK_tb
add wave -noupdate /testbench/ADC_SDI_tb
add wave -noupdate /testbench/ADC_SDO_tb
add wave -noupdate -radix unsigned /testbench/testbench/measure_count
add wave -noupdate /testbench/uart_tx_tb
add wave -noupdate /testbench/clock_ref_tb
add wave -noupdate /testbench/testbench/FIFO1_inst/wrreq
add wave -noupdate -radix unsigned /testbench/testbench/FIFO1_inst/usedw
add wave -noupdate /testbench/testbench/FIFO1_inst/clock
add wave -noupdate /testbench/testbench/measure_dataread
add wave -noupdate /testbench/testbench/temp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39999999200 ps} 0}
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
WaveRestoreZoom {0 ps} {65536 ns}
