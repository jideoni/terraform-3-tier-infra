/*
 * LED2_Thread.c
 *
 *  Created on: Feb 12, 2026
 *      Author: Jyde
 */

#include "main.h"
#include "cmsis_os.h"
#include "LED2_Thread.h"
#include "led2_driver.h"
#include "led2_service.h"
#include "thread_notification_flags.h"
#include "bsp_serial_debug.h"
#include "ldr_service.h"
#include "bsp_ldr.h"

/* Definitions for LED2Thread */
osThreadId_t LED2ThreadHandle;

uint16_t adc_buf[ADC_BUF_LEN];
static uint16_t LDR_Value;

const osThreadAttr_t LED2Thread_attributes = { .name = "LED2Thread",
		.stack_size = 128 * 4, .priority = (osPriority_t) osPriorityNormal, };
static void StartLED2Thread(void *argument);

void LED2_Thread_Init(void) {
	/* creation of LED2Thread */
	LED2ThreadHandle = osThreadNew(StartLED2Thread, NULL,
			&LED2Thread_attributes);
}
/* USER CODE END Header_StartLED2Thread */
static void StartLED2Thread(void *argument) {
	/* USER CODE BEGIN 5 */
	/* Infinite loop */
	for (;;) {
		osThreadFlagsWait(LED2_THREAD_FLAG, osFlagsWaitAny, osWaitForever);
		LDR_Value = (uint16_t) adc_buf[0];
		if (LDR_Value <= 1000) {
			LED2_Service_ON();
			print_message("Dark!\r\n");
		} else {
			LED2_Service_OFF();
			print_message("Bright!\r\n");
		}
		osDelay(1000);
	}
	/* USER CODE END 5 */
}
