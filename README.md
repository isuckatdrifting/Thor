# BJT-Test-with-FPGA
A FPGA based BJT test program, including FPGA Program and MATLAB GUI.

## Process
FPGA comminicates with DAC(AD5664) via SPI Protocol.

DAC generates the stepwave and triangle wave required in the measurement process

ADC measures two channel voltage.

FPGA communicates with ADC(LTC2308) via SPI Protocol to receive the measured data.

FPGA stores the cached data in FIFO.

FPGA sends the data in FIFO to PC(Matlab GUI) via UART.

##Matlab GUI
Using UART to receive data from FPGA.

Parse the 12bit 2-axis data.

Plot the scatter point.

Crop a specific area and calculate the magnification.

##Other Info
Analog device required in this system.

Results are attached in master directory.