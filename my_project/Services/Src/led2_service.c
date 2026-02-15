/*
 * led2_service.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "cmsis_os.h"
#include "led2_service.h"
#include "bsp_led2.h"

void LED2_Service_ON(void) {
	BSP_LED2_On();
}

void LED2_Service_OFF(void) {
	BSP_LED2_Off();
}
