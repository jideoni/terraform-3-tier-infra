/*
 * button_service.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "cmsis_os.h"
#include "led1_service.h"
#include "bsp_led1.h"
#include "thread_handles.h"
#include "thread_notification_flags.h"
#include "button_service.h"

void BUTTON_Service_ISR(void) {
	osThreadFlagsSet(LED1ThreadHandle, LED1_THREAD_BUTTON_FLAG);
}
