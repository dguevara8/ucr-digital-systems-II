// Includes
`include "src/GLOBALS/globals.vh"

// módulo especificamente creado para convertir los datos de 10 bits a 8 bits

module codegroup_decoder (
    input [9:0] tenbit_code_group_tenbit, // recibe el codegroup con de 10 bits
    output reg [7:0] code_group_eigthbit  // salida ya decodificada
);
    always @(tenbit_code_group_tenbit) begin
        case(tenbit_code_group_tenbit)
			// Tabla de los Code Groups ESPECIALES
			`K28p5_10bits: code_group_eigthbit = `K28p5_8bits; 
			`K23p7_10bits: code_group_eigthbit = `K23p7_8bits;
			`K27p7_10bits: code_group_eigthbit = `K27p7_8bits;
			`K29p7_10bits: code_group_eigthbit = `K29p7_8bits;
			`K30p7_10bits: code_group_eigthbit = `K30p7_8bits;
			`K28p6_10bits: code_group_eigthbit = `K28p6_8bits;
			`K28p0_10bits: code_group_eigthbit = `K28p0_8bits;
			`K28p1_10bits: code_group_eigthbit = `K28p1_8bits;
			`K28p2_10bits: code_group_eigthbit = `K28p2_8bits;
			`K28p3_10bits: code_group_eigthbit = `K28p3_8bits;
			`K28p4_10bits: code_group_eigthbit = `K28p4_8bits;
			`K28p7_10bits: code_group_eigthbit = `K28p7_8bits;
			

			`D22p7_10bits_pos,
			`D22p7_10bits_neg: code_group_eigthbit = `D22p7_8bits;
			`D24p7_10bits_pos,
			`D24p7_10bits_neg: code_group_eigthbit = `D24p7_8bits;
			`D25p7_10bits_pos,
			`D25p7_10bits_neg: code_group_eigthbit = `D25p7_8bits;
			`D26p7_10bits_pos,
    		`D26p7_10bits_neg: code_group_eigthbit = `D26p7_8bits;
			`D31p7_10bits_pos,
			`D31p7_10bits_neg: code_group_eigthbit = `D31p7_8bits;

		endcase
	end

endmodule