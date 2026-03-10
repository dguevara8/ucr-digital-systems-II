// Includes
`include "src/GLOBALS/globals.vh"
`include "src/SYNCRO/sincronizador.v"
`include "src/SYNCRO/sincronizador_tester.v"

// Probador que agrega las conexiones
module sincronizador_testbench();

wire GTX_CLK;
wire mr_main_reset;
wire [9:0] PUDI;              
wire [10:0] SUDI;              
wire mr_loopback;            
wire signal_detect;   
wire RX_EVEN, CODE_SYNC_STATUS, GOOD_CGS;

// Instancia del sincronizador
sincronizador DUT (
    .GTX_CLK(GTX_CLK),
	.mr_main_reset(mr_main_reset),
	.PUDI(PUDI),
	.mr_loopback(mr_loopback),            
	.signal_detect(signal_detect),   
	.SUDI(SUDI),
    .RX_EVEN(RX_EVEN),            
	.CODE_SYNC_STATUS(CODE_SYNC_STATUS)
);

// Instancia del generador de señales (tester)
sincronizador_tester TEST (
    .GTX_CLK(GTX_CLK),
	.mr_main_reset(mr_main_reset),
	.PUDI(PUDI),
	.mr_loopback(mr_loopback),            
	.signal_detect(signal_detect),   
	.SUDI(SUDI),
    .RX_EVEN(RX_EVEN),            
	.CODE_SYNC_STATUS(CODE_SYNC_STATUS)
);



initial begin
	$dumpfile("src/SYNCRO/sincronizador.vcd");
	$dumpvars();	
	
end

endmodule
