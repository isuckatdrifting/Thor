library verilog;
use verilog.vl_types.all;
entity FIFO_control is
    port(
        tx_spi_sclk_wire: in     vl_logic;
        rst             : in     vl_logic;
        idle            : in     vl_logic;
        uart_counter    : in     vl_logic_vector(1 downto 0);
        serial_counter  : in     vl_logic_vector(3 downto 0);
        measure_count   : in     vl_logic_vector(11 downto 0);
        fifo_data       : in     vl_logic_vector(23 downto 0);
        measure_done    : in     vl_logic;
        q_sig_wire      : out    vl_logic_vector(23 downto 0)
    );
end FIFO_control;
