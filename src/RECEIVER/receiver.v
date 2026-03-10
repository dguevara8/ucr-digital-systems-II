// Includes
`include "src/GLOBALS/globals.vh"
`include "src/RECEIVER/SUDI_detect.v"
`include "src/RECEIVER/codegroup_decoder.v"

module receptor( 
    input GTX_CLK,        // declaración de las entradas
    input mr_main_reset,
    input [10:0] SUDI, 
    input carrier_detect,
    input RX_EVEN,
    output reg [7:0] RXD, // declaración de las salidas
    output reg RX_DV, RX_ER, receiving 
    );

// Asignación de estados:
parameter LINK_FAILED       = 3'b000;
parameter WAIT_FOR_K        = 3'b001;
parameter RX_K              = 3'b010;
parameter IDLE_D            = 3'b011;
parameter CARRIER_DETECT    = 3'b100;
parameter START_OF_PACKET   = 3'b101;
parameter RECEIVE           = 3'b110; 

//Registros
reg [2:0] state, nxt_state;
reg [29:0] check_end, check_end_nxt;  // registro que acumula los últimos 30 bits recibidos para detectar condiciones de finales
reg running_disparity, running_disparity_nxt;

//Wires 
wire data_detected_wire;   // indica si SUDI corresponde a un dato válido
wire comma_detected_wire;  // detecta si el valor de SUDI es el carácter especial K28.5
wire [9:0]TX_PACKET;
assign TX_PACKET = SUDI[10:1];

assign comma_detected_wire = (TX_PACKET == `K28p5_10bits);
wire [7:0] salida_decodificada; // almacena el dato ya decodificado
integer unos;
integer ceros;
integer dispari;
// modulo que analiza SUDI y genera data_detected_wire, indicando si contiene un dato válido
SUDI_detect DETECTOR (
    .TX_PACKET(TX_PACKET),
    .data_value(data_detected_wire)
);


// modulo que decodifica SUDI (10 bits) en salida_decodificada (8 bits)
codegroup_decoder DECODER(
    .tenbit_code_group_tenbit(TX_PACKET),
    .code_group_eigthbit(salida_decodificada)
);

//Logica secuencial
always @(posedge GTX_CLK) begin
    if (!mr_main_reset) begin
        state <= LINK_FAILED;
        check_end <= 0;
        running_disparity <= 0;
    end else begin
        state <= nxt_state;
        check_end <= check_end_nxt;
        running_disparity <= running_disparity_nxt;
    end
end


// Comportamiento de la maquina de estados
// Define las transiciones de proximo estado segun el diagrama ASM
//Logica de los calculos para cada estado
always @(*) 
begin
// Inicializar las señales para evitar latches
    nxt_state = state;
    check_end_nxt = check_end;
    RX_DV = 0; 
    RX_ER = 0; 
    receiving = 0;
    //Funcion de disparidad
    //Cuento los unos
    unos =  ( TX_PACKET[9] + TX_PACKET[8] +  TX_PACKET[7] + TX_PACKET[6] + TX_PACKET[5] + TX_PACKET[4] + TX_PACKET[3] + TX_PACKET[2] +   TX_PACKET[1] + TX_PACKET[0]);
    //Calculo los ceros
    ceros = 10 - unos;
    //Calculo la disparidad
    dispari = unos - ceros;
    //Defino mi siguiente disparidad
    running_disparity_nxt = dispari >=0 ;
    case(state)
        LINK_FAILED: begin
            if (receiving == `TRUE) begin
                receiving = `FALSE;
                RX_ER = `TRUE;  // si estaba recibiendo, marca un error
            end else begin
                RX_DV = `FALSE;
                RX_ER = `FALSE;
            end 
            if (data_detected_wire == `TRUE) nxt_state = WAIT_FOR_K; // si detecta datos válidos, pasa a WAIT_FOR_K
        end                                
                                            
        WAIT_FOR_K: begin
            receiving = `FALSE;
            RX_DV = `FALSE;
            RX_ER = `FALSE;
            if (comma_detected_wire == `TRUE && RX_EVEN) begin // espera el carácter K28.5
                nxt_state = RX_K;  // si se detecta y cumple con RX_EVEN, pasa a RX_K
            end
        end

        RX_K: begin
            receiving = `FALSE;
            RX_DV = `FALSE;
            RX_ER = `FALSE;
            if (data_detected_wire == `TRUE && TX_PACKET != `D21p5_10bits && TX_PACKET != `D2p2_10bits) begin 
                nxt_state = IDLE_D; // si detecta datos válidos diferentes a ciertos caracteres especiales, pasa a IDLE_D
            end
        end

        IDLE_D: begin
            receiving = `FALSE;
            RX_DV = `FALSE;
            RX_ER = `FALSE;
            RXD   = 0;
            // maneja datos válidos según las condiciones de carrier_detect
            if (data_detected_wire == `TRUE && carrier_detect == `FALSE || comma_detected_wire == `TRUE) begin // si no se detecta pasa a RX_K 
                nxt_state = RX_K;
            end else if (data_detected_wire == `TRUE && carrier_detect == `TRUE || comma_detected_wire == `FALSE) begin // si se detecta pasa CARRIER_DETECT
                nxt_state = CARRIER_DETECT;
            end
        end
                
        CARRIER_DETECT: begin
            receiving = `TRUE; 
            if (TX_PACKET == `K27p7_10bits) begin // si recibe el carácter K27.7, transita a START_OF_PACKET
                nxt_state = START_OF_PACKET;
            end
        end

        START_OF_PACKET: begin // marca el inicio del paquete
            RX_DV = `TRUE; // activar RX_DV
            RX_ER = `FALSE;
            RXD = 8'b01010101;					
            if (data_detected_wire == `TRUE) begin // si detecta un dato valido pasa a RECEIVE
                nxt_state = RECEIVE;
            end
        end

        RECEIVE: begin // se juntaron los estados de TRI_RRI y RX_DATA para mayor facilidad
            //TRI_RRI STATE
            check_end_nxt = {check_end [19:0], TX_PACKET};
            if (check_end == {`K29p7_10bits, `K23p7_10bits, `K28p5_10bits}) begin // actualiza check_end para detectar la secuencia /T/R/K28.5/
                receiving = `FALSE;
                RX_DV = `FALSE;
                RX_ER = `FALSE;
                //if (comma_detected_wire == `TRUE) begin
                nxt_state = RX_K; 
                //end
             //RX_DATA STATE   
            end else if (data_detected_wire == `TRUE) begin
                RX_ER = `FALSE;
                RXD = salida_decodificada; // decodifica los datos válidos
                if (data_detected_wire == `TRUE) begin
                    nxt_state = RECEIVE;
                end
            end
        end
            
        default: nxt_state = LINK_FAILED; // Estado de inicio por defecto
        endcase

end

endmodule
