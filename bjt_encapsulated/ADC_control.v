module ADC_control(
	input wire adc_clk,
	input wire adc_clk_delay,
	input wire adc_start,
	output ADC_CONVST,
	output ADC_SCK,
	output ADC_SDI,
	input wire ADC_SDO,
	input wire rst,
	input wire loop,
	input wire [3:0] serial_counter,
	input wire [31:0] verti_counter,
	output reg [23:0] fifo_data,
	output reg [11:0] measure_count,
	output wire measure_done);

reg config_first;
reg wait_measure_done;
reg measure_start;
wire [11:0] measure_dataread;
reg [2:0] measure_ch;

adc_ltc2308 adc_ltc2308_inst(
	.clk(adc_clk & adc_start), // max 40mhz
	.clk_delay(adc_clk_delay), // max 40mhz
	
	// start measure
	.measure_start(measure_start), // posedge triggle
	.measure_done(measure_done),
	.measure_ch(measure_ch),
	.measure_dataread(measure_dataread),	
	
	// adc interface
	.ADC_CONVST(ADC_CONVST),
	.ADC_SCK(ADC_SCK),
	.ADC_SDI(ADC_SDI),
	.ADC_SDO(ADC_SDO)
);

reg [23:0] temp;
always @ (posedge adc_clk or negedge rst)	
begin
	if (~rst)
	begin
		measure_start <= 1'b0;
		config_first <= 1'b1;
		measure_count <= 12'b0;
		wait_measure_done <= 1'b0;
		measure_ch <= 3'b000;
		temp <= 23'b0;
		fifo_data <= 23'b0;
	end 
	else if (~measure_start & ~wait_measure_done)
	begin
		measure_start <= 1'b1;
		wait_measure_done <= 1'b1;
	end
	else if (wait_measure_done)
	begin
		measure_start <= 1'b0;
		if(serial_counter == 2) begin
				fifo_data <= temp;
			end
		if (measure_done)
		begin
			if(serial_counter == 1) begin
				measure_ch <= 3'b000;								//measure channel 0
				temp[11:0] <= measure_dataread;			//retrieve data from LTC2308 to temp
			end
			if(serial_counter == 3) begin
				measure_ch <= 3'b001;								//measure channel 1
				temp[23:12] <= measure_dataread;			//retrieve data from LTC2308 to temp
				measure_count <= measure_count + 12'd1;
			end
			if(loop == 1) measure_count <= 0;
			
			if (config_first)
				config_first <= 1'b0;
			else
			begin	// read data and save into fifo
				begin
					wait_measure_done <= 1'b0;
				end
			end
		end
	end
end
endmodule