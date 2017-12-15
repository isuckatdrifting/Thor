onerror {resume}
quietly WaveActivateNextPane {} 0

#TX AD5664 Module
add wave -noupdate /testbench/globalclock_tb
add wave -noupdate /testbench/rst_tb
add wave -noupdate /testbench/tx_spi_sclk_tb
add wave -noupdate /testbench/tx_spi_sync_tb
add wave -noupdate /testbench/tx_spi_din_tb
add wave -noupdate -radix unsigned /testbench/testbench/DAC_control_inst/serial_counter
add wave -noupdate -radix unsigned /testbench/testbench/DAC_control_inst/verti_counter
add wave -noupdate -radix unsigned /testbench/testbench/DAC_control_inst/hori_counter
add wave -noupdate /testbench/testbench/DAC_control_inst/stepwave
add wave -noupdate /testbench/testbench/DAC_control_inst/sawtooth

#ADC Module
add wave -noupdate /testbench/ADC_CONVST_tb
add wave -noupdate /testbench/ADC_SCK_tb
add wave -noupdate /testbench/ADC_SDI_tb
add wave -noupdate /testbench/ADC_SDO_tb
add wave -noupdate -radix unsigned /testbench/testbench/ADC_control_inst/measure_count
add wave -noupdate /testbench/testbench/ADC_control_inst/measure_done

add wave -noupdate /testbench/testbench/ADC_control_inst/temp
add wave -noupdate /testbench/testbench/ADC_control_inst/measure_dataread

#FIFO Module
add wave -noupdate /testbench/testbench/FIFO_control_inst/FIFO1_inst/wrreq
add wave -noupdate -radix unsigned /testbench/testbench/FIFO_control_inst/FIFO1_inst/usedw
add wave -noupdate /testbench/testbench/FIFO_control_inst/FIFO1_inst/clock


add wave -noupdate /testbench/testbench/FIFO_control_inst/fifo_data
add wave -noupdate /testbench/testbench/FIFO_control_inst/FIFO1_inst/data
add wave -noupdate /testbench/testbench/FIFO_control_inst/FIFO1_inst/rdreq
add wave -noupdate /testbench/testbench/FIFO_control_inst/q_sig
add wave -noupdate /testbench/testbench/FIFO_control_inst/q_sig_wire
add wave -noupdate /testbench/testbench/FIFO_control_inst/fifo_rdreq


#UART Module
add wave -noupdate /testbench/testbench/uart_control_inst/UART_CLK
add wave -noupdate /testbench/uart_tx_tb
add wave -noupdate /testbench/testbench/uart_control_inst/uarttx_inst/idle
add wave -noupdate /testbench/testbench/uart_control_inst/uart_counter
add wave -noupdate /testbench/testbench/uart_control_inst/datatosend
add wave -noupdate /testbench/testbench/uart_control_inst/uart_tx_counter
add wave -noupdate /testbench/testbench/uart_control_inst/q_sig
run 4ms

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



