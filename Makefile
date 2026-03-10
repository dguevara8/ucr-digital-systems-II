# Creo las variables de entorno
# Esta variable me retorna el directoria actual, idealmente el repo
export current_dir = $(shell pwd)
#Esta variable retorna la direccion al src en funcion de la anterior
export SRC=$(current_dir)/src

#Estas tres variables retornan la direccion al transmisor y sus modulos
export TX=$(SRC)/TRANSMIT
export TX_ORDERED=$(TX)/ORDERED
export TX_CODEBLOCKS=$(TX)/CODEBLOCKS

#Esta variable retorna la direccion al receptor 
export RX=$(SRC)/RECEIVER

#Esta variable retorna la direccion al sincronizador
export SYNCRO=$(SRC)/SYNCRO

.PHONY: clean icarus_PCS
####################################################################
#
#                         Reglas para correr
#
#####################################################################

#Correr gtkwave para el PCS
PCS: icarus_PCS
		vvp -v $(SRC)/PCS_salida
		gtkwave $(SRC)/PCS.vcd $(SRC)/pcs_wave_setup.gtkw
#Correr iverilog para el PCS
icarus_PCS: $(SRC)/PCS_testbench.v clean
		iverilog -o $(SRC)/PCS_salida $(SRC)/PCS_testbench.v

# Correr icarus para el transmisor
icarus_TX: $(TX)/transmit_testbench.v clean
		iverilog -o $(TX)/transmit_salida $(TX)/transmit_testbench.v

TX: icarus_TX
		vvp  $(TX)/transmit_salida
		gtkwave $(TX)/transmit.vcd $(TX)/tx_wave_setup.gtkw

# Aca van las reglas para correr el transmisor ordenado
icarus_TX_ordered: $(TX_ORDERED)/transmit_ordered_testbench.v clean
		iverilog -o $(TX_ORDERED)/transmit_ordered_salida $(TX_ORDERED)/transmit_ordered_testbench.v
TX_ordered: icarus_TX_ordered
		vvp -v $(TX_ORDERED)/transmit_ordered_salida
		gtkwave src/TRANSMIT/ORDERED/transmit_ordered.vcd $(TX_ORDERED)/tx_or_wave_setup.gtkw

# Aca van las reglas para correr el transmisor de codigos
icarus_TX_codeblocks: $(TX_CODEBLOCKS)/transmit_codeblocks_testbench.v clean
		iverilog -o $(TX_CODEBLOCKS)/transmit_codeblocks_salida $(TX_CODEBLOCKS)/transmit_codeblocks_testbench.v

TX_codeblocks: icarus_TX_codeblocks
		vvp -v $(TX_CODEBLOCKS)/transmit_codeblocks_salida
		gtkwave $(TX_CODEBLOCKS)//transmit_codeblocks.vcd  $(TX_CODEBLOCKS)/tx_cb_wave_setup.gtkw


# Correr icarus para el receptor
icarus_RX: $(RX)/receiver_testbench.v clean
		iverilog -o $(RX)/receiver_salida $(RX)/receiver_testbench.v

RX: icarus_RX
		vvp -v $(RX)/receiver_salida
		gtkwave $(RX)/receiver.vcd $(RX)/rx_wave_setup.gtkw

# Correr icarus para el sincronizador
icarus_SYNCRO: $(SYNCRO)/sincronizador_testbench.v clean
		iverilog -o $(SYNCRO)/sincronizador_salida $(SYNCRO)/sincronizador_testbench.v

SYNCRO: icarus_SYNCRO
		vvp -v $(SYNCRO)/sincronizador_salida
		gtkwave $(SYNCRO)/sincronizador.vcd $(SYNCRO)/syncro_wave_setup.gtkw	
 

clean:
		find . -name "*.vcd" -delete
		find . -name "*_salida" -delete
