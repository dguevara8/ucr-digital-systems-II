// Includes
`include "src/GLOBALS/globals.vh"
`include "src/SYNCRO/data_detect.v"

module sincronizador (
    input GTX_CLK,                           // declaración de las entradas
    input mr_main_reset,
    input [9:0] PUDI,               
    input mr_loopback,            
    input signal_detect,   
    output reg RX_EVEN, CODE_SYNC_STATUS,    // declaración de las salidas
    output reg [10:0] SUDI
    
    );

// Codificación de estados
localparam LOSS_OF_SYNC     = 4'b0000;
localparam COMMA_DETECT_1   = 4'b0001;
localparam ACQUIRE_SYNC_1   = 4'b0010;
localparam COMMA_DETECT_2   = 4'b0011;
localparam ACQUIRE_SYNC_2   = 4'b0100;
localparam COMMA_DETECT_3   = 4'b0101;
localparam SYNC_ACQUIRED_1  = 4'b0110;
localparam SYNC_ACQUIRED_2  = 4'b0111;
localparam SYNC_ACQUIRED_2A = 4'b1000;

// Registros
reg [3:0] state, nxt_state;
reg [2:0] good_cg_count, nxt_good_cg_count; // contadores para contar hasta 4 veces y decidir si reconectar o desconectar la sincronización
reg       rx_even_ff, nxt_rx_even_ff;       // flip-flop para la señal intermedia que determina si RX es par

//Wires
wire data_detected_wire;   // indica si PUDI contiene datos válidos
wire comma_detected_wire;  // detecta si PUDI corresponde al carácter especial K28.5
wire bad_cgs, good_cgs;    // identifican los code-grous malos y buenos, respectivamente
assign comma_detected_wire = (PUDI == `K28p5_10bits);

// modulo que analiza PUDI y genera data_detected_wire, indicando si contiene un dato válido, de igual manera si se identifican  identifican los code-grous malos y buenos
data_detect DETECTOR (
    .PUDI(PUDI),
    .data_value(data_detected_wire),
    .good_cgs(good_cgs),
    .bad_cgs(bad_cgs)
);



//Logica secuencial
always @(posedge GTX_CLK) begin
    if (!mr_main_reset) begin
        state <= LOSS_OF_SYNC;
        RX_EVEN <= 0;
        good_cg_count <= 0;

    end else begin
        state <= nxt_state;
        RX_EVEN <= !RX_EVEN;  // alterna el estado de RX_EVEN
        good_cg_count <= nxt_good_cg_count;
        SUDI <= {PUDI,RX_EVEN};
    end
end


//Logica combinacional

always @(*) begin
    nxt_state = state;
    nxt_good_cg_count = good_cg_count;
    CODE_SYNC_STATUS = `FAIL;

    case(state)
        LOSS_OF_SYNC: begin
            CODE_SYNC_STATUS = `FAIL;
            if ( (signal_detect == `FAIL && mr_loopback == `FALSE) || (comma_detected_wire == `FALSE))begin
                nxt_state = LOSS_OF_SYNC;
            end else if ((signal_detect == `OK || mr_loopback == `TRUE) && (comma_detected_wire == `TRUE) )begin
                nxt_state = COMMA_DETECT_1; // si la señal es válida o está en modo mr_loopback, y se detecta un carácter K28.5 , pasa a COMMA_DETECT_1
            end

        end

        COMMA_DETECT_1: begin
            RX_EVEN = `TRUE;
            if (!data_detected_wire) begin
                 nxt_state = LOSS_OF_SYNC; // si no hay datos, regresa a LOSS_OF_SYNC
            end else begin
                nxt_state = ACQUIRE_SYNC_1; // si los datos son válidos, pasa a ACQUIRE_SYNC_1
            end

        end

        ACQUIRE_SYNC_1: begin
            if (bad_cgs) nxt_state = LOSS_OF_SYNC;  // si detecta un code-group invalida, pierde sincronización
            else if (RX_EVEN == `FALSE && comma_detected_wire == `TRUE) nxt_state = COMMA_DETECT_2; // si detecta K28.5 y RX_EVEN es falso, pasa a COMMA_DETECT_2
            else if (comma_detected_wire == `FALSE) nxt_state = ACQUIRE_SYNC_1; // sino se mantiene
            
        end

        COMMA_DETECT_2: begin
            RX_EVEN = `TRUE;
            if (!data_detected_wire) begin
                 nxt_state = LOSS_OF_SYNC; // si no hay datos, regresa a LOSS_OF_SYNC
            end else begin
                nxt_state = ACQUIRE_SYNC_2; // si los datos son válidos, pasa a ACQUIRE_SYNC_2
            end

        end

        ACQUIRE_SYNC_2:begin
            if (bad_cgs) nxt_state = LOSS_OF_SYNC; // si detecta un code-group invalida, pierde sincronización

            if (RX_EVEN == `FALSE && comma_detected_wire == `TRUE) nxt_state = COMMA_DETECT_3; // si detecta K28.5 y RX_EVEN es falso, pasa a COMMA_DETECT_3

            if (comma_detected_wire == `FALSE) nxt_state = ACQUIRE_SYNC_2; // sino se mantiene

        end

        COMMA_DETECT_3: begin
            RX_EVEN = `TRUE;
            if (!data_detected_wire) begin
                 nxt_state = LOSS_OF_SYNC; // si no hay datos, regresa a LOSS_OF_SYNC
            end else begin
                nxt_state = SYNC_ACQUIRED_1; // si los datos son válidos, pasa a SYNC_ACQUIRED_1
            end

        end

        SYNC_ACQUIRED_1:begin
            CODE_SYNC_STATUS = `OK;
            if (bad_cgs) begin
                nxt_state = SYNC_ACQUIRED_2; // si detecta code-groups invalidos, pasa a SYNC_ACQUIRED_2
            end else if (good_cgs) begin
                nxt_state = SYNC_ACQUIRED_1;
            end
            
        end

        // verifican estabilidad de sincronización aumentando el contador good_cg_count
        // si detectan 3 code-groups validos consecutivps, regresan a SYNC_ACQUIRED_1
        SYNC_ACQUIRED_2:begin
            nxt_good_cg_count = 0;
            if (bad_cgs) begin
                nxt_state = LOSS_OF_SYNC;
            end else if (good_cgs) begin
                nxt_state = SYNC_ACQUIRED_2A;
            end

        end

        SYNC_ACQUIRED_2A:begin
            nxt_good_cg_count = good_cg_count + 1;
            if (bad_cgs) begin
                nxt_state = LOSS_OF_SYNC;
            end else if (good_cg_count == 3 && good_cgs) begin
                nxt_state = SYNC_ACQUIRED_1;
            end else if (good_cg_count != 3 && good_cgs) begin
                nxt_state = SYNC_ACQUIRED_2A;
            end

        end

        default: nxt_state = LOSS_OF_SYNC;
    endcase

end




endmodule
