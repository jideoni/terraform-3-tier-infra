/*
 * led1_service.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "cmsis_os.h"
#include "led1_service.h"
#include "bsp_led1.h"
#include "thread_handles.h"
#include "thread_notification_flags.h"

void LED1_Service_Toggle(void) {
	BSP_LED1_Toggle(); // Toggle The Output (LED) Pin
}
