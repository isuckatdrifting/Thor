module FIFO_control(
	input wire tx_spi_sclk_wire,
	input wire rst,
	input wire idle,
	input wire [1:0] uart_counter,
	input wire [3:0] serial_counter,
	input wire [11:0] measure_count,
	input wire [23:0] fifo_data,
	input wire measure_done,
	output wire [23:0] q_sig_wire);//FIFO output data

wire [23:0] fifo_data_wire;
assign fifo_data_wire = fifo_data;

reg fifo_rdreq;
reg pulsed;

always @(negedge tx_spi_sclk_wire) begin //generate read signal for FIFO
 	if (~rst) begin
 		// reset
 		fifo_rdreq <= 0;
 	end
 	else begin
 		if(idle == 0 & pulsed == 0)
 			fifo_rdreq <= 1;
 		if(fifo_rdreq == 1) begin
 			fifo_rdreq <= 0;
 			pulsed <= 1;
 		end
 		if(idle == 1) pulsed <= 0;
 	end
end

wire [12:0] usedw_sig;				//temporarily no use

FIFO1	FIFO1_inst (
	.clock ( tx_spi_sclk_wire ),
	.data ( fifo_data_wire ),
	.rdreq ( fifo_rdreq && uart_counter == 2'd000),
	.wrreq ( measure_done && serial_counter == 1 && measure_count > 1 ),
	.q ( q_sig_wire ),
	.usedw ( usedw_sig  )
	);

endmodule