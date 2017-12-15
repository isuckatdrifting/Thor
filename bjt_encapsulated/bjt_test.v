`timescale 1ns / 1ns
  
//top spi module
module bjt(input globalclock, 					//fpgaclock, 50MHz
	input rst, 									//overall reset
	output tx_spi_sclk, 					//output spi clock for AD5664
	output tx_spi_sync, 					//output spi synchronize signal for AD5664 spi registers
	output tx_spi_din,						//output spi data signal for AD5664 spi registers
	output ADC_CONVST,							//LTC2308 spi conversion signal
	output ADC_SCK,								//LTC2308 spi clock
	output ADC_SDI,								//LTC2308 spi datain signal
	input wire ADC_SDO,							//LTC2308 spi dataout signal
	output reg uart_tx 							//UART tx signal baud rate = 115200
	);

wire [31:0] verti_counter;
wire [3:0] serial_counter;

clockpll pll(.globalclock(globalclock), //pll module
	.rst(rst),
	.dac_clk(tx_spi_sclk_wire),//spi clock, ----- if you want to boost the scanning speed, just boost the clock in clockpll.v -----
	.adc_clk(adc_clk),									//LTC2308 clock, 12.5M
	.adc_clk_delay(adc_clk_delay),						//LTC2308 delayed clock, 12.5M, phase shift 180 degrees
	.uart_clk(UART_CLK)									//UART Clock, Baud rate 115200
	);

DAC_control DAC_control_inst(
	.tx_spi_sclk_wire(tx_spi_sclk_wire),
	.rst(rst),
	.tx_spi_sync(tx_spi_sync),
	.tx_spi_din(tx_spi_din),
	.adc_start(adc_start),
	.verti_counter(verti_counter),
	.serial_counter(serial_counter),
	.loop(loop)
	);
assign	tx_spi_sclk = tx_spi_sclk_wire;				//output tx_spi_sclk

//----------------------------------------------------------------------------------//ADC Module
wire [23:0] fifo_data;
wire [11:0] measure_count;

ADC_control ADC_control_inst(
	.adc_clk(adc_clk),
	.adc_clk_delay(adc_clk_delay),
	.adc_start(adc_start),
	.ADC_CONVST(ADC_CONVST),
	.ADC_SCK(ADC_SCK),
	.ADC_SDI(ADC_SDI),
	.ADC_SDO(ADC_SDO),
	.rst(rst),
	.loop(loop),
	.serial_counter(serial_counter),
	.verti_counter(verti_counter),
	.fifo_data(fifo_data),
	.measure_count(measure_count),
	.measure_done(measure_done));

//-----------------------------------------------------------------------------//FIFO Module
wire [1:0] uart_counter_wire; 
wire [23:0] q_sig_wire;

wire idle;
FIFO_control FIFO_control_inst(
	.tx_spi_sclk_wire(tx_spi_sclk_wire),
	.rst(rst),
	.idle(idle),
	.uart_counter(uart_counter_wire),
	.serial_counter(serial_counter),
	.measure_count(measure_count),
	.fifo_data(fifo_data),
	.measure_done(measure_done),
	.q_sig_wire(q_sig_wire));

//----------------------------------------------------------------------------//UART Module
uart_control uart_control_inst(
	.globalclock(globalclock),
	.verti_counter(verti_counter),
	.UART_CLK(UART_CLK),
	.rst(rst),
	.q_sig(q_sig_wire),
	.uart_tx_wire(uart_tx_wire),
	.idle(idle),
	.uart_counter(uart_counter_wire));
always@(*) uart_tx = uart_tx_wire;
endmodule
