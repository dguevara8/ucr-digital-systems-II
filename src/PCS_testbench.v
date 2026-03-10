`include "src/PCS.v"
`include "src/PCS_tester.v"



module PCS_testbench();

 
wire GTX_CLK;
wire RTX_CLK;
wire mr_main_reset;
wire TX_EN;
wire TX_ER;
wire [7:0] RXD;
wire [7:0] TXD;
wire RX_DV;
wire RX_ER;
wire [9:0] loopback_wire;

PCS DUT_PCS (
    .GTX_CLK(GTX_CLK),
    .RTX_CLK(GTX_CLK),
    .mr_main_reset(mr_main_reset),
    .TX_EN(TX_EN),
    .TX_ER(TX_ER),
    .RXD(RXD),
    .TXD(TXD),
    .RX_DV(RX_DV),
    .RX_ER(RX_ER),
    .TX_CODE_GROUP(loopback_wire),             
    .RX_CODE_GROUP(loopback_wire),
    .signal_detect(signal_detect),
    .mr_loopback(mr_loopback)
);



PCS_tester test_PCS (
    .GTX_CLK(GTX_CLK),
    .mr_main_reset(mr_main_reset),
    .TX_EN(TX_EN),
    .TX_ER(TX_ER),
    .RX_DV(RX_DV),
    .RX_ER(RX_ER),
    .TXD(TXD),
    .RXD(RXD),
    .signal_detect(signal_detect),
    .mr_loopback(mr_loopback)
);
initial begin
	$dumpfile("src/PCS.vcd");
	$dumpvars();	
	
end

endmodule