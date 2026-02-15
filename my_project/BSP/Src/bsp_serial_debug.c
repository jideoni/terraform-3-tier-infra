/*
 * bsp_serial_debug.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "main.h"
#include "bsp_serial_debug.h"

extern UART_HandleTypeDef huart2;

void print_message(const char *msg) {
	HAL_UART_Transmit(&huart2, (uint8_t*) msg, strlen(msg), 100);
}
