# BJT-Test-with-FPGA
A FPGA based BJT test program, including FPGA Program and MATLAB GUI.

## Process
FPGA comminicates with DAC via SPI Protocol.

DAC generates the stepwave and triangle wave required in the measurement process

ADC measures two channel voltage.

FPGA communicates with ADC via SPI Protocol to receive the measured data.

FPGA stores the cached data in FIFO.

FPGA sends the data in FIFO to PC(Matlab GUI) via UART.