module DAC_control(
	input wire tx_spi_sclk_wire,
	input wire rst,
	output reg tx_spi_sync,
	output reg tx_spi_din,
	output reg adc_start,
	output reg [31:0] verti_counter,//vertical scanning sequence counter
	output reg [3:0] serial_counter,//AD5664 output update requires data write to four channels
	output reg loop
	);

parameter inidata_1 = 24'b001010010000000000000001, inidata_2 = 24'b001110010000000000000001,//initial data for DAC AD5664

		inidata_3 = 24'b001000000000000000001111, inidata_4 = 24'b001100000000000000000000;

reg [8:0] counter;								//counter within a TX spi conversion

reg init = 1'b1;								//status register, 0 when AD5664 initialization complete

reg [7:0] hori_counter; 						//horizontal scanning sequence counter						

reg [23:0] sawtooth = 24'b00000000_0000000000000000;  		//initial value of sawtooth wave

reg [23:0] stepwave = 24'b00000001_0000000000000000;  		//initial value of step wave

reg [23:0] pin3_C_yminu = 24'b00000010_0000110110111001;  	//initial value of y-

reg [23:0] pin4_D_yplus = 24'b00010011_1100111000111100;  	//initial value of y+

parameter sawstep = 24'b0000_0000_0000_0000_0001_0000_0110; //step between each sawtooth output points
parameter stepstep = 24'b0000_0000_0000_0010_0100_1001_0010;//step between each stepwave output points

	

//---------------------------------------------------------------------------//tx module - counter
	always @(negedge tx_spi_sclk_wire) begin
		if(~rst) begin
			counter <= 0;
		end
		else begin
			counter <= counter + 1'b1;
			if(counter == 9'd201) counter <= 9'd102;
		end
	end
//---------------------------------------------------------------------------//tx module - spi write
	always @(posedge tx_spi_sclk_wire) begin
		case(counter)
		0:tx_spi_sync <= 1'b0;												//initialize sync
		1: begin															//pull up sync, initialize din and loop
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 1'b0;
			loop <= 1'b1;
			end

		2:begin																//send inidata_1
			tx_spi_sync <= 1'b0;
			tx_spi_din <= inidata_1[9'd25-counter];
			end
		3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25:
			tx_spi_din <= inidata_1[9'd25-counter];
		26:begin
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 0;
			end

		27:begin															//send inidata_2
			tx_spi_sync <= 1'b0;
			tx_spi_din <= inidata_2[9'd50-counter];
			end
		28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50:
			tx_spi_din <= inidata_2[9'd50-counter];
		51:begin
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 0;
			end

		52:begin															//send inidata_3
			tx_spi_sync <= 1'b0;
			tx_spi_din <= inidata_3[9'd75-counter];
			end
		53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75:
			tx_spi_din <= inidata_3[9'd75-counter];
		76:begin
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 0;
			end

		77:begin															//send inidata_4
			tx_spi_sync <= 1'b0;
			tx_spi_din <= inidata_4[9'd100-counter];
			end
		78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100:
			tx_spi_din <= inidata_4[9'd100-counter];
		101:begin
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 0;
			init <= 1'b0;
			end
		
		102:begin															//send pin1(output A)
			tx_spi_sync <= 1'b0;
			tx_spi_din <= sawtooth[9'd125-counter];
			end
		103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125:
			tx_spi_din <= sawtooth[9'd125-counter];
		126:begin
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 0;
			end

		127:begin															//send pin2(output B)
			tx_spi_sync <= 1'b0;
			tx_spi_din <= stepwave[9'd150-counter];
			end
		128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150:
			tx_spi_din <= stepwave[9'd150-counter];
		151:begin
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 0;
			end

		152:begin															//send pin3(no use, just to update the 4 channel DAC)
			tx_spi_sync <= 1'b0;
			tx_spi_din <= pin3_C_yminu[9'd175-counter];
			end
		153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175:
			tx_spi_din <= pin3_C_yminu[9'd175-counter];
		176:begin
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 0;
			end

		177:begin															//send pin4(LDAC update, data no use, just to update the 4 channel DAC)
			tx_spi_sync <= 1'b0;
			tx_spi_din <= pin4_D_yplus[9'd200-counter];
			end
		178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200:
			tx_spi_din <= pin4_D_yplus[9'd200-counter];
		201:begin
			tx_spi_sync <= 1'b1;
			tx_spi_din <= 0;
			end

		default:;
		endcase
		if(verti_counter == 16'd1999 & serial_counter == 4) loop <= 1'd1;	//one scanning cycle finished
		if(verti_counter == 16'd0) loop <= 1'd0;	//loop register reset
	end

//DAC AD5664 working under LDAC mode
	always @(posedge tx_spi_sync) begin
		if (counter == 1) begin
			// reset
			hori_counter <= 8'b0;							//initializing horizontal sequence counter, reset after finishing every single row
		    verti_counter <= 12'd0;							//initializing vertical sequence counter, vertical counter is much larger than hori.
		    serial_counter <= 4'd0;							//initializing tx spi data sending counter(4 registers to write per position)
			adc_start <= 0;
			sawtooth <= 24'b00000000_0000000000000000;	//initial value of x, center
			stepwave <= 24'b00000001_0000000000000000;	//initial value of y, center
			pin3_C_yminu <= 24'b00000010_0000000000000000;	//initial value of y-, center
			pin4_D_yplus <= 24'b00010011_0000000000000000;	//initial value of y+, center
		end
		else if(init == 0)begin     						//send the serial voltage swing
			if(serial_counter == 4)
			adc_start <= 1;
			if(loop == 1'd1) begin							//mirror set at the corner, one new frame starts
				sawtooth <= 24'b00000000_0000000000000000;//!!!Important!!!, set this value if lines are odd. If even, keep pin_A_xplus, otherwise break the mirror
				stepwave <= 24'b00000001_0000000000000000;
				if(verti_counter == 12'd1999 & serial_counter == 4'd4)begin	//vertical counter reset
					verti_counter <= 12'd0;
					hori_counter <= 8'b0;
				end
				serial_counter <= 1'd1;
			end
			else begin
				serial_counter <= serial_counter + 1'b1;

				if(serial_counter == 4'd4) begin
					serial_counter <= 4'd1;								//below 2.0 configurations
					verti_counter <= verti_counter + 12'd1;
					
					hori_counter <= hori_counter + 1'b1;
					if(hori_counter == 8'd249) begin						//one row finished			
						hori_counter <= 8'b0;
						sawtooth <= 24'b00000000_0000000000000000;					//x axis reset
						stepwave <= stepwave + stepstep;			//y position move up one step
					end
					else begin
						if(hori_counter < 8'd125) sawtooth <= sawtooth + sawstep;
						if(hori_counter < 8'd249 && hori_counter >= 8'd125) sawtooth <= sawtooth - sawstep;
						//sawtooth <= sawtooth + sawstep;
					end
				end
			end
		end
	end

endmodule