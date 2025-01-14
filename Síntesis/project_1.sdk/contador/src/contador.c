/*
 * contador.c
 *
 *  Created on: 9 dic. 2024
 *      Author: jrcd_
 */
#include "xparameters.h"
#include "xil_io.h"
#include "contadorip.h"

/*
entity contador_asc_desc is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        control : in STD_LOGIC; -- '0' para ascendente, '1' para descendente
        count_out : out STD_LOGIC_VECTOR(3 downto 0)
    );
end contador_asc_desc;
 */

#define CONTADOR_BASE_ADDR XPAR_CONTADORIP_0_S00_AXI_BASEADDR
#define REG_RESET_OFFSET 0x00
#define REG_CONTROL_OFFSET 0x04
#define REG_COUNT_OUT_OFFSET 0x08

// Configuracion y estado del contador
typedef struct {
    int32_t base_addr;
    int32_t reset;        // Estado de reset (0: no activo, 1: activo)
    int32_t control;      // Modo del contador (0: ascendente, 1: descendente)
} Contador_Config;

void Contador_Init(Contador_Config *contador, int32_t base_addr) {
    contador->base_addr = base_addr;
    contador->reset = 0x01;
    contador->control = 0x00;  // Modo predeterminado: ascendente
}

void Contador_SetReset(Contador_Config *contador, int32_t reset) {
    contador->reset = reset;
    Xil_Out32(contador->base_addr + REG_RESET_OFFSET, contador->reset);
    xil_printf("Reset set to: %d\r\n", contador->reset);
}

void Contador_SetControl(Contador_Config *contador, int32_t control) {
    contador->control = control;
    Xil_Out32(contador->base_addr + REG_CONTROL_OFFSET, contador->control);
    xil_printf("Control mode set to: %s\r\n", control == 0 ? "Ascending" : "Descending");
}

int32_t Contador_ReadCount(Contador_Config *contador) {
    int32_t count = Xil_In32(contador->base_addr + REG_COUNT_OUT_OFFSET);
    xil_printf("Current count value: 0x%02X\r\n", count & 0xF); // Solo los 4 bits
    return count & 0xF;
}

int main(void) {
    xil_printf("-- Inicio del Contador IP Core --\r\n");

    Contador_Config contador;

    // Inicializar el contador
    Contador_Init(&contador, CONTADOR_BASE_ADDR);

    // Configurar el contador
    Contador_SetReset(&contador, 0x00); // Desactiva reset
    Contador_SetControl(&contador, 0x00); // Configura modo ascendente

    while (1) {
        // Leer y mostrar el valor del contador
        Contador_ReadCount(&contador);

        // Simular cambio de modo cada cierto tiempo
        for (volatile int i = 0; i < 9999999; i++); // Retardo

        Contador_SetControl(&contador, contador.control ^ 0x01); // Cambiar modo (ascendente/descendente)
    }

    xil_printf("-- Fin del Contador IP Core --\r\n");
    return 0;
}
