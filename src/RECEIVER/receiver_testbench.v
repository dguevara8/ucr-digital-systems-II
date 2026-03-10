// Includes
`include "src/GLOBALS/globals.vh"
`include "src/RECEIVER/receiver.v"
`include "src/RECEIVER/receiver_tester.v"

// Probador que agrega las conexiones
module receptor_testbench();

wire GTX_CLK;
wire mr_main_reset;
wire [10:0] SUDI;         
wire [7:0] RXD;  
wire carrier_detect;
wire RX_EVEN;             
wire RX_DV;            
wire RX_ER;   
wire receiving;

// Instancia del receptor
receptor DUT (
	.GTX_CLK(GTX_CLK),
    .mr_main_reset(mr_main_reset),
	.SUDI(SUDI),          
	.RXD(RXD), 
	.carrier_detect(carrier_detect),   
	.RX_EVEN(RX_EVEN),             
	.RX_DV(RX_DV),            
	.RX_ER(RX_ER),   
	.receiving(receiving)
);

// Instancia del generador de señales (tester)
receptor_tester TEST (
	.GTX_CLK(GTX_CLK),
    .mr_main_reset(mr_main_reset),
	.SUDI(SUDI),       
	.RXD(RXD),
	.carrier_detect(carrier_detect),  
	.RX_EVEN(RX_EVEN),               
	.RX_DV(RX_DV),            
	.RX_ER(RX_ER),   
	.receiving(receiving)
);


initial begin
	$dumpfile("src/RECEIVER/receiver.vcd");
	$dumpvars();	
	
end

endmodule