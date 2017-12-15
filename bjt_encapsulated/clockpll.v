`timescale 1ns / 1ps
 
module clockpll(input globalclock,
	input rst,
	output reg dac_clk,
	output reg adc_clk,
	output reg adc_clk_delay,
	output reg uart_clk);

	reg [15:0] count;
	reg delay_count;

	always @(posedge globalclock)
	begin
		if(~rst)
		begin
			count <= 16'd0;
			dac_clk <= 1'b0;
			delay_count <= 1'b0;
			adc_clk <= 1'b0;
			adc_clk_delay <= 1'b0;
		end
		else begin
			if(delay_count == 0) begin adc_clk_delay <= 0; delay_count <= 1'b1; end
			else adc_clk_delay <= ~ adc_clk_delay;
			adc_clk <= ~adc_clk;
			if(count == 16'd1) //altered, original: 63
			begin
				count <= 16'd0;
				dac_clk <= ~dac_clk;
			end
			else count <= count+1'b1;
		end
	end

	reg [15:0] cnt;

	//分频进程,对50Mhz的时钟326分频
	always @(posedge globalclock or negedge rst) begin
	    if(~rst) begin
	        cnt <= 16'd0;
	        uart_clk <= 0;
	    end
	    else
	        if(cnt == 16'd13) begin
	            uart_clk <= 1'b1;
	            cnt <= cnt + 16'd1;
	        end
	        else if(cnt == 16'd26) begin
	            uart_clk <= 1'b0;
	            cnt <= 16'd0;
	        end
	        else begin
	            cnt <= cnt + 16'd1;
	        end
	end

	endmodule

