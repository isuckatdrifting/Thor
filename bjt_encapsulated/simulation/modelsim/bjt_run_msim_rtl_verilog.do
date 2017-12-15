transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/FIFO1.v}
vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/uart_control.v}
vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/FIFO_control.v}
vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/DAC_control.v}
vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/ADC_control.v}
vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/uarttx.v}
vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/clockpll.v}
vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/bjt_test.v}
vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/adc_ltc2308.v}

vlog -vlog01compat -work work +incdir+D:/Files/S3E1/exp/bjt_encapsulated {D:/Files/S3E1/exp/bjt_encapsulated/testbench.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  testbench

do D:/Files/S3E1/exp/bjt_encapsulated/simulation/modelsim/wave.do
