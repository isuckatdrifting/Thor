library verilog;
use verilog.vl_types.all;
entity uarttx is
    generic(
        paritymode      : vl_logic := Hi0
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic_vector(7 downto 0);
        wrsig           : in     vl_logic;
        idle            : out    vl_logic;
        tx              : out    vl_logic;
        rst             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of paritymode : constant is 1;
end uarttx;
