/*
 * bsp_button.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include <button_driver.h>	//to access port and pin
#include "main.h"
#include "led1_service.h"
#include "button_service.h"

void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin) {
	if (GPIO_Pin == BUTTON_PIN) // If The INT Source Is Push_Button_Pin (PB5)
	{
		BUTTON_Service_ISR();	//call function to set thread flags
	}
}
