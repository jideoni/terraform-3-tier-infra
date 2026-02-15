/*
 * bsp_led2.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "main.h"
#include "led2_driver.h"	//to access port and pin
#include "bsp_led2.h"

void BSP_LED2_On(void){
	HAL_GPIO_WritePin(LED2_GPIO_Port, LED2_Pin, 1);
}
void BSP_LED2_Off(void){
	HAL_GPIO_WritePin(LED2_GPIO_Port, LED2_Pin, 0);
}
