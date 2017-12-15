library verilog;
use verilog.vl_types.all;
entity adc_ltc2308 is
    port(
        clk             : in     vl_logic;
        clk_delay       : in     vl_logic;
        measure_start   : in     vl_logic;
        measure_ch      : in     vl_logic_vector(2 downto 0);
        measure_done    : out    vl_logic;
        measure_dataread: out    vl_logic_vector(11 downto 0);
        ADC_CONVST      : out    vl_logic;
        ADC_SCK         : out    vl_logic;
        ADC_SDI         : out    vl_logic;
        ADC_SDO         : in     vl_logic
    );
end adc_ltc2308;
