/*
 * bsp_ble.h
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#ifndef INC_BSP_BLE_H_
#define INC_BSP_BLE_H_

#include "main.h"
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <string.h>

#define RX_SIZE 1	//size for 1 data element

extern UART_HandleTypeDef huart1;

void BLE_Driver_Ready_To_RX(void);

#endif /* INC_BSP_BLE_H_ */
