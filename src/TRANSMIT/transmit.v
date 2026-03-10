`include "src/TRANSMIT/CODEBLOCKS/transmit_codeblocks.v"
`include "src/TRANSMIT/ORDERED/transmit_ordered.v"

module transmit (
    input mr_main_reset,
    input GTX_CLK,
    output wire tx_disparity,          
    input [7:0] TXD,      // Esta entrada contiene los datos que tengo que codificar             
    output wire PUDR,   
    output wire [9:0] TX_CODE_GROUP,
    input TX_EN,
    input TX_ER,
    input [2:0] xmit, //Estado actual de la transmision
    input assert_ipidle,
    output wire transmiting,
    output wire receiving
);

    wire TX_EVEN;
    wire TX_OSET_INDICATE;
    wire [3:0] TX_O_SET;


    transmit_ordered TRANSMIT_ORDERED_SET (
        .GTX_CLK(GTX_CLK),
        .mr_main_reset(mr_main_reset),
        .TX_EN(TX_EN),
        .TX_ER(TX_ER),
        .TX_OSET_INDICATE(TX_OSET_INDICATE),
        .TX_EVEN(TX_EVEN),
        .TXD(TXD),
        .xmit(xmit),
        .assert_ipidle(assert_ipidle),
        .TX_O_SET(TX_O_SET),
        .transmiting(transmiting),
        .receiving(receiving)
    );

    transmit_codeblocks TRANSMIT_CODE_BLOCKS (
        .mr_main_reset(mr_main_reset),
        .GTX_CLK(GTX_CLK),
        .tx_disparity(tx_disparity),
        .TX_O_SET(TX_O_SET),           
        .TXD(TXD),               
        .TX_EVEN(TX_EVEN),            
        .TX_OSET_INDICATE(TX_OSET_INDICATE),   
        .PUDR(PUDR),
        .TX_CODE_GROUP(TX_CODE_GROUP)
    );




    
endmodule