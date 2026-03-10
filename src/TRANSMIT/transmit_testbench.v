`include "src/TRANSMIT/transmit.v"
`include "src/TRANSMIT/transmit_tester.v"

module transmit_testbench ();
    wire mr_main_reset;
    wire GTX_CLK;
    wire [7:0] TXD;      // Esta entrada contiene los datos que tengo que codificar             
    wire PUDR;   
    wire [9:0] TX_CODE_GROUP;
    wire TX_EN;
    wire TX_ER;
    wire [2:0] xmit; //Estado actual de la transmision
    wire assert_ipidle;
    wire transmiting;;
    wire tx_disparity;
    wire receiving;
    wire TX_EVEN;
    wire TX_O_SET_INDICATE;
    wire [3:0] TX_O_SET;


    transmit DUT_TX (
        .mr_main_reset(mr_main_reset),
        .GTX_CLK(GTX_CLK),
        .tx_disparity(tx_disparity),          
        .TXD(TXD),      // Esta entrada contiene los datos que tengo que codificar             
        .PUDR(PUDR),   
        .TX_CODE_GROUP(TX_CODE_GROUP),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .xmit(xmit), //Estado actual de la transmision
        .assert_ipidle(assert_ipidle),
        .transmiting(transmiting),
        .receiving(receiving)
    );

    transmit_tester TX_TEST (
        .mr_main_reset(mr_main_reset),
        .GTX_CLK(GTX_CLK),
        .TXD(TXD),      // Esta entrada contiene los datos que tengo que codificar             
        .PUDR(PUDR),   
        .TX_CODE_GROUP(TX_CODE_GROUP),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .transmiting(transmiting),
        .receiving(receiving)
    );

initial begin
	$dumpfile("src/TRANSMIT/transmit.vcd");
	$dumpvars();	
	
end

endmodule
