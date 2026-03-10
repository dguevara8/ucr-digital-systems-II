`include "src/TRANSMIT/transmit.v"
`include "src/RECEIVER/receiver.v"
`include "src/SYNCRO/sincronizador.v"

module PCS(
    input GTX_CLK,
    input RTX_CLK,
    input mr_main_reset,
    input [7:0] TXD,
    input TX_EN,
    input TX_ER,
    input signal_detect,
    input mr_loopback,
    output wire [7:0] RXD ,
    output wire RX_DV,
    output wire RX_ER,
    output wire [9:0] TX_CODE_GROUP,             
    input   [9:0] RX_CODE_GROUP 
);

    wire receiving;
    wire [10:0] SUDI;              
    //wire mr_loopback;            
    wire RX_EVEN, CODE_SYNC_STATUS;
    
    sincronizador SINCRO (
        .GTX_CLK(GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .PUDI(RX_CODE_GROUP),
        .mr_loopback(mr_loopback),            
        .signal_detect(signal_detect),   
        .SUDI(SUDI),
        .RX_EVEN(RX_EVEN),            
        .CODE_SYNC_STATUS(CODE_SYNC_STATUS)
    );
    receptor RX (
        .GTX_CLK(RTX_CLK),
        .mr_main_reset(mr_main_reset),
        .SUDI(SUDI),          
        .RXD(RXD), 
        .carrier_detect(signal_detect),   
        .RX_EVEN(RX_EVEN),             
        .RX_DV(RX_DV),            
        .RX_ER(RX_ER),   
        .receiving(receiving)
    );
    
    transmit TX (
        .mr_main_reset(mr_main_reset),
        .GTX_CLK(GTX_CLK),
        .tx_disparity(),          
        .TXD(TXD),      // Esta entrada contiene los datos que tengo que codificar             
        .PUDR(),   
        .TX_CODE_GROUP(TX_CODE_GROUP),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .xmit(), //Estado actual de la transmision
        .assert_ipidle(),
        .transmiting(),
        .receiving(receiving)
    ); 





endmodule

