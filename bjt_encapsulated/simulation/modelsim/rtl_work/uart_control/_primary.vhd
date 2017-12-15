library verilog;
use verilog.vl_types.all;
entity uart_control is
    generic(
        gap             : integer := 170
    );
    port(
        globalclock     : in     vl_logic;
        verti_counter   : in     vl_logic_vector(31 downto 0);
        UART_CLK        : in     vl_logic;
        rst             : in     vl_logic;
        q_sig           : in     vl_logic_vector(23 downto 0);
        uart_tx_wire    : out    vl_logic;
        idle            : out    vl_logic;
        uart_counter    : out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of gap : constant is 1;
end uart_control;
