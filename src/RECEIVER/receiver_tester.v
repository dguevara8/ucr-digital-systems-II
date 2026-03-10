// Includes
`include "src/GLOBALS/globals.vh"

module receptor_tester (
    output reg GTX_CLK,   
    output reg mr_main_reset,
    output reg [10:0] SUDI, 
    output reg carrier_detect,
    output reg RX_EVEN,
    input [7:0] RXD,
    input RX_DV, RX_ER, receiving // declaración de las salidas 
    );

 // Definición del reloj 
always begin
   #2 GTX_CLK = !GTX_CLK;
end

// Prueba para el módulo
initial begin
    mr_main_reset = 0;
    GTX_CLK = 1;
    SUDI = 0;
    RX_EVEN = 0;
    carrier_detect = `TRUE;
    #4
    mr_main_reset = 1; // activar reset
    #4
    SUDI    = {`D24p7_10bits_pos,1'b1};  // pasa al estado WAIT_FOR_K
    #4
    SUDI    = {`K28p5_10bits,1'b0}; 
    RX_EVEN = 1;              // pasa al estado RX_K
    #4
    SUDI = {`D22p7_10bits_neg,1'b1};     // pasa al estado IDLE_D
    #4
    SUDI = {`D21p5_10bits,1'b0};
    carrier_detect = `TRUE;   // pasa al estado CARRIER_DETECT
    #4
    SUDI = {`K27p7_10bits,1'b1};     // pasa al estado START_OF_PACKET
    #4
    SUDI = {`D25p7_10bits_pos,1'b0};     // pasa al estado RECEIVE
    #4
    SUDI = {`D26p7_10bits_neg,1'b1};     // dentro de receive pasa a la condicion de RX_DATA
    // Condicion dentro del receive que va a TRI_RRI
    #4 
    RX_EVEN = 1;
    SUDI = {`K29p7_10bits,1'b0};
    #4 
    SUDI = {`K23p7_10bits,1'b1};
    #4
    SUDI = {`K28p5_10bits,1'b0};
    carrier_detect = `FALSE;  // se devuelve a RX_K
    #8
    SUDI = {`D24p7_10bits_pos,1'b1};     // pasa de nuevo a IDLE_D
    #8
    SUDI = 0;
    #40


	#10 $finish;
end

endmodule