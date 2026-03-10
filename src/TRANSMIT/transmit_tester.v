`include "src/GLOBALS/globals.vh"

module transmit_tester (
    output reg mr_main_reset,
    output reg GTX_CLK,
    output reg [7:0] TXD,      // Esta entrada contiene los datos que tengo que codificar             
    output reg TX_EN,
    output reg TX_ER,

    input transmiting,
    input receiving,
    input PUDR,   
    input [9:0] TX_CODE_GROUP

);

always begin
   #2 GTX_CLK = !GTX_CLK;
end

initial begin
    GTX_CLK = 0;
    mr_main_reset = 0;
    TX_EN = `FALSE;
    TX_ER = 0;
    TXD = 0;
    #4
    mr_main_reset = 1;
    #40
    TX_EN = `TRUE;
    TX_ER = `FALSE;
    TXD   = `D22p7_8bits;
    #20
	TX_EN = `FALSE;
    
    
    #40 $finish;
end
    
endmodule