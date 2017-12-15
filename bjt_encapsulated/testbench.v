`timescale 1ns / 1ns

module testbench(
    );
    reg globalclock_tb;
    reg rst_tb;
    wire tx_spi_sclk_tb;
    wire tx_spi_sync_tb;
    wire tx_spi_din_tb;
    wire ADC_CONVST_tb;
    wire ADC_SCK_tb;
    wire ADC_SDI_tb;
    reg ADC_SDO_tb;
    wire uart_tx_tb;
    

    bjt testbench(
        .globalclock(globalclock_tb),
        .rst(rst_tb),
        .tx_spi_sclk(tx_spi_sclk_tb),
        .tx_spi_sync(tx_spi_sync_tb),
        .tx_spi_din(tx_spi_din_tb),
        .ADC_CONVST(ADC_CONVST_tb),
        .ADC_SCK(ADC_SCK_tb),
        .ADC_SDI(ADC_SDI_tb),
        .ADC_SDO(ADC_SDO_tb),
        .uart_tx(uart_tx_tb)
    );

    initial
    begin
      globalclock_tb = 1'b0;
      rst_tb = 1'b0;
      #30 rst_tb = 1'b1;
     
    end

    always
    #10 globalclock_tb = ~globalclock_tb;
    always
    #40 ADC_SDO_tb = {$random}%65535;

endmodule
