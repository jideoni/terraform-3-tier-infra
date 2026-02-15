/*
 * LED1_Thread.c
 *
 *  Created on: Feb 12, 2026
 *      Author: Jyde
 */

#include "main.h"
#include "cmsis_os.h"
#include "LED1_Thread.h"
#include "thread_notification_flags.h"
#include "led1_service.h"
#include "bsp_serial_debug.h"
#include "bsp_ble.h"

/* Definitions for LED1Thread */
osThreadId_t LED1ThreadHandle;

const osThreadAttr_t LED1Thread_attributes = { .name = "LED1Thread",
		.stack_size = 128 * 4, .priority = (osPriority_t) osPriorityNormal, };
static void StartLED1Thread(void *argument);

void LED1_Thread_Init(void) {
	/* creation of LED1Thread */
	LED1ThreadHandle = osThreadNew(StartLED1Thread, NULL,
			&LED1Thread_attributes);
}
/* USER CODE END Header_StartLED1Thread */
static void StartLED1Thread(void *argument) {
	/* USER CODE BEGIN 5 */
	/* Infinite loop */
	for (;;) {
		uint32_t flags = osThreadFlagsWait(
				LED1_THREAD_BUTTON_FLAG | LED1_THREAD_BLE_RX_FLAG,
				osFlagsWaitAny,
				osWaitForever);

		if (flags & LED1_THREAD_BUTTON_FLAG) {
			LED1_Service_Toggle();
			print_message("Button Signal Received\r\n");
		}
		else if (flags & LED1_THREAD_BLE_RX_FLAG) {
			HAL_UART_Receive_IT(&huart1, (uint8_t*) rx_buf, RX_SIZE);	//prepare for next RX
			LED1_Service_Toggle(); // Toggle The Output (LED) Pin
			print_message("Bluetooth Control\r\n");
		}
		osDelay(1);
	}
	/* USER CODE END 5 */
}
