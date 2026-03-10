// Includes
`include "src/GLOBALS/globals.vh"

module sincronizador_tester (
    output reg GTX_CLK,
    output reg mr_main_reset,
    output reg [9:0] PUDI,   
    output reg mr_loopback,         
    output reg signal_detect,   
    input       RX_EVEN, CODE_SYNC_STATUS,
    input [10:0] SUDI
    );

 // Definición del reloj 
always begin
   #2 GTX_CLK = !GTX_CLK;
end

// Prueba para el módulo
initial begin
    mr_main_reset = 0;
    GTX_CLK = 0;
    PUDI    = `K28p7_10bits;
    mr_loopback = `FALSE;
    signal_detect = `FAIL;    
    #10
    mr_main_reset = 1;
    #10 //Aca ya reiniciamos todo
    PUDI    = `K28p5_10bits; //Comma
    signal_detect    = `OK; 
    #4
    PUDI    = `D5p6_10bits; //Dato X
    #4
    PUDI    = `K28p5_10bits; //Comma
    #4
    PUDI    = `D5p6_10bits; //Dato Y
    #4
    PUDI    = `K28p5_10bits; //Comma
    #4
    PUDI    = `D5p6_10bits; //Dato Z
    #4
    PUDI    = 10'd10; //Dato basura para ver cgs_bad
    #4
    PUDI    = `D5p6_10bits; //Dato Z
    #4
    PUDI    = `D5p6_10bits; //Dato Z
    #40

	#10 $finish;
end

endmodule
