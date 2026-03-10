`include "src/GLOBALS/globals.vh"


module PCS_tester(
    output reg GTX_CLK,
    output reg mr_main_reset,
    output reg [7:0] TXD ,
    output reg TX_EN,
    output reg TX_ER,
    output reg signal_detect,
    output reg mr_loopback,
    
    input [7:0] RXD ,
    input RX_DV,
    input RX_ER
);

always begin
   #2 GTX_CLK = !GTX_CLK;
end

initial begin
    GTX_CLK = 0;
    mr_main_reset = 0;
    TX_EN = `FALSE;
    TX_ER = 0;
    signal_detect = `OK;
    mr_loopback = `OK;
    TXD = 0;
    #4
    mr_main_reset = 1;
    TXD    = `D31p7_8bits; //Dato Z

    #40
    TX_EN = `TRUE;
    TX_ER = `FALSE;
    #20
    
    
    #4
    TXD   = `D24p7_8bits;
    #4
    TXD   = `D31p7_8bits;
    #4
    TXD   = `D26p7_8bits;
    #4
    TXD   = `D22p7_8bits;
    #4
    TXD   = `D24p7_8bits;
    #4
    TXD   = `D31p7_8bits;
    #4
    TXD   = `D26p7_8bits;
    #4
    TXD   = `D22p7_8bits;
    #4
    
    #16
	TX_EN = `FALSE;
    #40 $finish;
end


endmodule