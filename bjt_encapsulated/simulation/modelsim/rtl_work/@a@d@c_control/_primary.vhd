library verilog;
use verilog.vl_types.all;
entity ADC_control is
    port(
        adc_clk         : in     vl_logic;
        adc_clk_delay   : in     vl_logic;
        adc_start       : in     vl_logic;
        ADC_CONVST      : out    vl_logic;
        ADC_SCK         : out    vl_logic;
        ADC_SDI         : out    vl_logic;
        ADC_SDO         : in     vl_logic;
        rst             : in     vl_logic;
        \loop\          : in     vl_logic;
        serial_counter  : in     vl_logic_vector(3 downto 0);
        verti_counter   : in     vl_logic_vector(31 downto 0);
        fifo_data       : out    vl_logic_vector(23 downto 0);
        measure_count   : out    vl_logic_vector(11 downto 0);
        measure_done    : out    vl_logic
    );
end ADC_control;
