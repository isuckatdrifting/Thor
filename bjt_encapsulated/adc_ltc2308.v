module adc_ltc2308( 
	clk, // max 40mhz
	clk_delay,
	
	// start measure
	measure_start, // posedge triggle
	measure_ch,
	measure_done,
	measure_dataread,
	
	// adc interface
	ADC_CONVST,
	ADC_SCK,
	ADC_SDI,
	ADC_SDO 
);

input								clk;
input								clk_delay;

// start measure
input								measure_start;
input		[2:0]					measure_ch;
output	reg					measure_done;
output	[11:0]				measure_dataread;



output	reg	          		ADC_CONVST;
output	reg	          		ADC_SCK;
output	reg          		ADC_SDI;
input 	wire	          		ADC_SDO;


/////////////////////////////////
// Timing definition 

// using 40MHz clock
// to acheive fsample = 500KHz
// ntcyc = 2us / 25ns  = 80



`define DATA_BITS_NUM		4'd12
`define CMD_BITS_NUM		3'd6
`define CH_NUM					8

`define tWHCONV            3   // CONVST High Time, min 20 ns
`define tCONV     			36  // tCONV: type 1.3 us, MAX 1.6 us, 1600/40(assumed clk is 25mhz)=40
//                         +12 //data

`define tHCONVST           49   // If the source impedance of the driving circuit is low, the ADC inputs can be driven directly.
                                //Otherwise, more acquisition time should be allowed for a source with higher impedance.
`define tCONVST_HIGH_START	0 	
`define tCONVST_HIGH_END  	(`tCONVST_HIGH_START+`tWHCONV) 

`define tCONFIG_START		(`tCONVST_HIGH_END) 	
`define tCONFIG_END  		(`tCLK_START+`CMD_BITS_NUM - 1) 	

`define tCLK_START 			(`tCONVST_HIGH_START+`tCONV)
`define tCLK_END 	   		(`tCLK_START+`DATA_BITS_NUM)

`define tDONE 	   			(`tCLK_END+`tHCONVST)

// create triggle message: reset_n
reg pre_measure_start;
always @ (posedge clk)	
begin
	pre_measure_start <= measure_start;
end

wire reset_n;
assign reset_n = (~pre_measure_start & measure_start)?1'b0:1'b1;

// tick
reg [7:0] tick;	
always @ (posedge clk or negedge reset_n)	
begin
	if (~reset_n)
		tick <= 0;
	else if (tick < `tDONE)
		tick <= tick + 8'd1;
end
// tick
reg [7:0] tick_delay;	
always @ (posedge clk_delay or negedge reset_n)	
begin
	if (~reset_n)
		tick_delay <= 0;
	else if (tick_delay < `tDONE)
		tick_delay <= tick_delay + 8'd1;
end


/////////////////////////////////
// ADC_CONVST 
always@(*)
	ADC_CONVST = (tick >= `tCONVST_HIGH_START && tick < `tCONVST_HIGH_END)?1'b1:1'b0;

/////////////////////////////////
// ADC_SCK 

reg clk_enable_o; // must sync to clk in clk low
always @ (negedge clk or negedge reset_n)	 
begin
	if (~reset_n)
		clk_enable_o <= 1'b0;
	else if ((tick >= `tCLK_START && tick < `tCLK_END))
		clk_enable_o <= 1'b1;
	else
		clk_enable_o <= 1'b0;
end

always@(*) ADC_SCK = clk_enable_o?clk:1'b0;

// reg clk_enable; // must sync to clk in clk low
// always @ (negedge clk_delay or negedge reset_n)	 
// begin
// 	if (~reset_n)
// 		clk_enable <= 1'b0;
// 	else if ((tick_delay >= `tCLK_START +1  && tick_delay < `tCLK_END +1 ))
// 		clk_enable <= 1'b1;
// 	else
// 		clk_enable <= 1'b0;
// end


///////////////////////////////
// read data
reg [(`DATA_BITS_NUM-1):0] read_data;
reg [3:0] write_pos;



assign measure_dataread = read_data;

//always @ (posedge clk or negedge reset_n)	
always @ (negedge clk_delay or negedge reset_n)	
begin
	if (~reset_n)
	begin
		read_data <= 0;
		write_pos <= `DATA_BITS_NUM - 4'd1;
	end
	else if (clk_enable_o)
	begin
		read_data[write_pos] <= ADC_SDO;
		write_pos <= write_pos - 4'd1;
	end
end

///////////////////////////////
// measure done
wire read_ch_done;

assign read_ch_done = (tick_delay == `tDONE)?1'b1:1'b0;

always @ (posedge clk or negedge reset_n)	
begin
	if (~reset_n)
		measure_done <= 1'b0;
	else if (read_ch_done)
		measure_done <= 1'b1;
end

///////////////////////////////
// adc channel config

// pre-build config command
reg [(`CMD_BITS_NUM-1):0] config_cmd;


`define UNI_MODE		1'b1   //1: Unipolar, 0:Bipolar
`define SLP_MODE		1'b0   //1: enable sleep

always @(negedge reset_n)
begin
	if (~reset_n)
	begin
		case (measure_ch)
			0 : config_cmd <= {4'h8, `UNI_MODE, `SLP_MODE}; 
			1 : config_cmd <= {4'hC, `UNI_MODE, `SLP_MODE}; 
			2 : config_cmd <= {4'h9, `UNI_MODE, `SLP_MODE}; 
			3 : config_cmd <= {4'hD, `UNI_MODE, `SLP_MODE}; 
			4 : config_cmd <= {4'hA, `UNI_MODE, `SLP_MODE}; 
			5 : config_cmd <= {4'hE, `UNI_MODE, `SLP_MODE}; 
			6 : config_cmd <= {4'hB, `UNI_MODE, `SLP_MODE}; 
			7 : config_cmd <= {4'hF, `UNI_MODE, `SLP_MODE}; 
			default : config_cmd <= {4'hF, 2'b00}; 
		endcase
	end
end

// serial config command to adc chip
wire config_init;
wire config_enable;
wire config_done;
reg [2:0] sdi_index;

assign config_init = (tick == `tCONFIG_START)?1'b1:1'b0;	
assign config_enable = (tick > `tCLK_START && tick <= `tCONFIG_END)?1'b1:1'b0;	// > because this is negative edge triggle
assign config_done = (tick > `tCONFIG_END)?1'b1:1'b0;	
always @(negedge clk)	
begin
	if (config_init)
	begin
		ADC_SDI <= config_cmd[`CMD_BITS_NUM-1];
		sdi_index <= `CMD_BITS_NUM-3'd2;
	end
	else if (config_enable)
	begin
		ADC_SDI <= config_cmd[sdi_index];
		sdi_index <= sdi_index - 3'd1;
	end
	else if (config_done)
		ADC_SDI <= 1'b0; // z
end




endmodule

