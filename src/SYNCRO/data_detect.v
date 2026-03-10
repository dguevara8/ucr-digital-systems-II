module  data_detect(
    input [9:0] PUDI,
    output reg data_value,
    output reg good_cgs,
    output reg bad_cgs
);

// modulo creado con el fin de detectar si el valor de PUDI representa un dato válido

always @(*) begin
    //Detecto si tengo un dato
    case(PUDI)
    // Tabla de los otros Code Groups (rd+)
    `D5p6_10bits,
    `D16p2_10bits,
    `D22p7_10bits_pos, 
    `D24p7_10bits_pos,
    `D25p7_10bits_pos,
    `D26p7_10bits_pos,
    `D31p7_10bits_pos,
    `D22p7_10bits_neg,
    `D24p7_10bits_neg,
    `D25p7_10bits_neg,
    `D26p7_10bits_neg,
    `D31p7_10bits_neg: begin 
        data_value = 1;
        good_cgs   = 1;
        bad_cgs    = 0;
    end
    default: begin 
        data_value = 0;
        case(PUDI)
            `K28p5_10bits,
            `K23p7_10bits,
            `K27p7_10bits,
            `K29p7_10bits,
            `K30p7_10bits,
            `K28p6_10bits,
            `K28p0_10bits,
            `K28p1_10bits,
            `K28p2_10bits,
            `K28p3_10bits,
            `K28p4_10bits,
            `K28p7_10bits: begin	
                good_cgs   = 1;
                bad_cgs    = 0;
            end
            //Dato invalido
            default: begin
                good_cgs   = 0;
                bad_cgs    = 1;
            end
        endcase
    end
    endcase




end


endmodule
