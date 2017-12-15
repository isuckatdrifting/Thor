library verilog;
use verilog.vl_types.all;
entity bjt is
    port(
        globalclock     : in     vl_logic;
        rst             : in     vl_logic;
        tx_spi_sclk     : out    vl_logic;
        tx_spi_sync     : out    vl_logic;
        tx_spi_din      : out    vl_logic;
        ADC_CONVST      : out    vl_logic;
        ADC_SCK         : out    vl_logic;
        ADC_SDI         : out    vl_logic;
        ADC_SDO         : in     vl_logic;
        uart_tx         : out    vl_logic
    );
end bjt;
