/*
 * bsp_ble.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "main.h"
#include "bsp_ble.h"
#include "ble_driver.h"
#include "bsp_led1.h"
#include "led1_service.h"
#include "ble_service.h"

uint8_t rx_buf[1];	//buffer to hold 1 byte of data

void BLE_Driver_Ready_To_RX(void){
	HAL_UART_Receive_IT(&huart1, (uint8_t*) rx_buf, RX_SIZE);
}
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
	BLE_Service_ISR();		//call function to set thread flags
}
