module  SUDI_detect(
    input [9:0] TX_PACKET,
    output reg data_value
);

// modulo creado con el fin de detectar si el valor de SUDI representa un dato válido

always @(*) begin
    // Inicializo la salida por defecto
    data_value = 0;
    
    //Detecto si tengo un dato
    case(TX_PACKET) 
    //`D5p6_10bits,
    //`D16p2_10bits,
    `D22p7_10bits_pos, 
    `D24p7_10bits_pos,
    `D25p7_10bits_pos,
    `D26p7_10bits_pos,
    `D31p7_10bits_pos,
    `D22p7_10bits_neg,
    `D24p7_10bits_neg,
    `D25p7_10bits_neg,
    `D26p7_10bits_neg,
    `D31p7_10bits_neg,
    //`K27p7_10bits,
    `K28p5_10bits: begin 
        data_value = 1;

        end
    default: begin 
        data_value = 0;

        end
            
    endcase

end

endmodule