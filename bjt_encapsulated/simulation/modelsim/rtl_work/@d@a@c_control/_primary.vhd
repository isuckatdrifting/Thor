library verilog;
use verilog.vl_types.all;
entity DAC_control is
    generic(
        inidata_1       : vl_logic_vector(0 to 23) := (Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        inidata_2       : vl_logic_vector(0 to 23) := (Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        inidata_3       : vl_logic_vector(0 to 23) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1);
        inidata_4       : vl_logic_vector(0 to 23) := (Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        sawstep         : vl_logic_vector(0 to 23) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0);
        stepstep        : vl_logic_vector(0 to 23) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0)
    );
    port(
        tx_spi_sclk_wire: in     vl_logic;
        rst             : in     vl_logic;
        tx_spi_sync     : out    vl_logic;
        tx_spi_din      : out    vl_logic;
        adc_start       : out    vl_logic;
        verti_counter   : out    vl_logic_vector(31 downto 0);
        serial_counter  : out    vl_logic_vector(3 downto 0);
        \loop\          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of inidata_1 : constant is 1;
    attribute mti_svvh_generic_type of inidata_2 : constant is 1;
    attribute mti_svvh_generic_type of inidata_3 : constant is 1;
    attribute mti_svvh_generic_type of inidata_4 : constant is 1;
    attribute mti_svvh_generic_type of sawstep : constant is 1;
    attribute mti_svvh_generic_type of stepstep : constant is 1;
end DAC_control;
