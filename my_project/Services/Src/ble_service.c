/*
 * ble_service.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "cmsis_os.h"
#include "thread_handles.h"
#include "thread_notification_flags.h"
#include "ble_service.h"

void BLE_Service_ISR(void) {
	osThreadFlagsSet(LED1ThreadHandle, LED1_THREAD_BLE_RX_FLAG);
}
