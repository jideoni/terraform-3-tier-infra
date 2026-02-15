/*
 * bsp_led1.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "main.h"
#include "led1_driver.h"	//to access port and pin
#include "bsp_led1.h"

void BSP_LED1_Toggle(void) {
	HAL_GPIO_TogglePin(LED1_GPIO_PORT, LED1_PIN);
}
