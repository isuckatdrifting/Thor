library verilog;
use verilog.vl_types.all;
entity clockpll is
    port(
        globalclock     : in     vl_logic;
        rst             : in     vl_logic;
        dac_clk         : out    vl_logic;
        adc_clk         : out    vl_logic;
        adc_clk_delay   : out    vl_logic;
        uart_clk        : out    vl_logic
    );
end clockpll;
