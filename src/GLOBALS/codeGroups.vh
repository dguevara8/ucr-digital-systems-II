`ifndef CODE_GROUPS_TABLE
`define CODE_GROUPS_TABLE
    //010001011100010101111100000101
    // Tabla de los Code Groups ESPECIALES
    `define K28p5_10bits 10'b11_0000_0101 // Para cuando se envie una /COMMA/
    `define K23p7_10bits 10'b00_0101_0111 // Para cuando se envie /R/ Carrier Extend
    `define K27p7_10bits 10'b00_1001_0111 // Para cuando se envie /S/ Inicio de Paquete
    `define K29p7_10bits 10'b01_0001_0111 // Para cuando se envie /T/ Fin de Paquete
    `define K30p7_10bits 10'b10_0001_0111 // Para cuando se envie /V/ Control/Error especial
    `define K28p6_10bits 10'b11_0000_1001 // Para cuando se envie /I/ IDLE
    `define K28p0_10bits 10'b11_0000_1011
    `define K28p1_10bits 10'b11_0000_0110
    `define K28p2_10bits 10'b11_0000_1010
    `define K28p3_10bits 10'b11_0000_1100
    `define K28p4_10bits 10'b11_0000_1101
    `define K28p7_10bits 10'b11_0000_0111

    //Datos extras que se necesitan en las maquinas (rd+)
    `define D5p6_10bits 10'b10_1001_0110
    `define D16p2_10bits 10'b10_0100_0101
    `define D21p5_10bits 10'b10_1010_1010
    `define D2p2_10bits 10'b01_0010_0101

    //Datos extras que se necesitan en las maquinas (rd-)
    `define D16p2_10bits 10'b01_1011_0101
    `define D21p5_10bits 10'b10_1010_1010
    `define D2p2_10bits 10'b10_1101_0101

    // Tabla de los otros Code Groups (rd+)
    `define D22p7_10bits_pos 10'b01_1010_1110
    `define D24p7_10bits_pos 10'b11_0011_0001
    `define D25p7_10bits_pos 10'b10_0110_1110
    `define D26p7_10bits_pos 10'b01_0110_1110
    `define D31p7_10bits_pos 10'b01_0100_1110

    // Tabla de los otros Code Groups (rd-)
    `define D22p7_10bits_neg 10'b01_1010_1110
    `define D24p7_10bits_neg 10'b11_0011_0001
    `define D25p7_10bits_neg 10'b10_0110_1110
    `define D26p7_10bits_neg 10'b01_0110_1110
    `define D31p7_10bits_neg 10'b10_1011_0001

    // Datos de 8 bits
    `define K28p0_8bits 8'b000_11100
    `define K28p1_8bits 8'b001_11100
    `define K28p2_8bits 8'b010_11100
    `define K28p3_8bits 8'b011_11100
    `define K28p4_8bits 8'b100_11100
    `define K28p5_8bits 8'b101_11100 // Para cuando se envie una /COMMA/
    `define K28p6_8bits 8'b110_11100 // Para cuando se envie /I/ IDLE
    `define K28p7_8bits 8'b111_11100
    `define K23p7_8bits 8'b111_10111 // Para cuando se envie /R/ Carrier Extend
    `define K27p7_8bits 8'b111_11011 // Para cuando se envie /S/ Inicio de Paquete
    `define K29p7_8bits 8'b111_11101 // Para cuando se envie /T/ Fin de Paquete
    `define K30p7_8bits 8'b111_11110 // Para cuando se envie /V/ Control/Error especial

    // Tabla de los otros Code Groups
    `define D22p7_8bits 8'b111_10110
    `define D24p7_8bits 8'b111_11000
    `define D25p7_8bits 8'b111_11001
    `define D26p7_8bits 8'b111_11010
    `define D31p7_8bits 8'b111_11111
    //
    `define D5p6_8bits 8'b110_00101
    
`endif
