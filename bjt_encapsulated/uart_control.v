module uart_control(
	input wire globalclock,
	input wire [31:0] verti_counter,
	input wire UART_CLK,
	input wire rst,
	input wire [23:0] q_sig,
	output wire uart_tx_wire,
	output wire idle,
	output reg [1:0] uart_counter
	);

parameter gap = 170;						//wait gap of UART TX, 168 clock cycles to send 1 byte

reg [7:0] datatosend;
//always@(*) q_sig = q_sig_wire;		//shift FIFO read out to UART send buffer
always@(posedge UART_CLK) begin
	if(!rst) 
		datatosend <= 8'd0;
	else begin
		case(uart_counter) 					//separate 1 fifo data to four bytes
		0:	datatosend <= 8'b01010101;
		1:	datatosend <= q_sig[23:16];
		2:	datatosend <= q_sig[15:8];
		3:	datatosend <= q_sig[7:0];	
		endcase
	end
end

reg [10:0] uart_fifo_cnt;
reg uart_reset;
reg wrsig;
reg [15:0] uart_tx_counter;
always@(posedge globalclock) begin 			//generate uart reset 
	if(~rst) begin
		uart_reset <= 0;
	end
	else if(verti_counter == 1) begin
		uart_reset <= 1;
	end
end

//reg uart_send_finish;

always @(posedge UART_CLK or negedge uart_reset) begin
	if (~uart_reset) begin
		// reset
		uart_tx_counter <= 0;
		uart_counter <= 0;
		wrsig <= 0;
		uart_fifo_cnt <= 0;
		//uart_send_finish <= 0;
	end
	else begin
			case(uart_tx_counter)
				0*gap:begin
					uart_tx_counter <= uart_tx_counter + 16'd1;
				end
				0*gap+1:begin 						//generate UART write enable pulse
					wrsig <= 1;
					uart_tx_counter <= uart_tx_counter + 16'd1;
				end 
				0*gap+2:begin 						//generate UART write enable pulse
					wrsig <= 0;
					uart_tx_counter <= uart_tx_counter + 16'd1;
				end
				1*gap:begin
					uart_tx_counter <= 0;
					uart_counter <= uart_counter == 2'd3 ? 2'd0:uart_counter + 2'd1;		//four byte = 1 fifo data
					if(uart_counter == 2'd3) uart_fifo_cnt <= uart_fifo_cnt == 11'd1999 ? 2'd0 :uart_fifo_cnt + 11'd1;
				end
				default:uart_tx_counter <= uart_tx_counter + 16'd1;
			endcase
		//if(uart_fifo_cnt == 11'd1999) uart_send_finish <= 1;
		//if(loop == 1) uart_send_finish <= 0;
	end
end

uarttx uarttx_inst(
	.clk(UART_CLK),                 //16 x Baud Rate
	.tx(uart_tx_wire),			    //Serial port tx
	.datain(datatosend),            //UART tx data  
    .wrsig(wrsig),                	//UART tx enable
    .idle(idle), 					//low = free, high = busy
    .rst(rst)						//reset
);

endmodule