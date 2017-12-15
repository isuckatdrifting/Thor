library verilog;
use verilog.vl_types.all;
entity FIFO1 is
    port(
        clock           : in     vl_logic;
        data            : in     vl_logic_vector(23 downto 0);
        rdreq           : in     vl_logic;
        wrreq           : in     vl_logic;
        q               : out    vl_logic_vector(23 downto 0);
        usedw           : out    vl_logic_vector(12 downto 0)
    );
end FIFO1;
