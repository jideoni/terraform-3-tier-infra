//Pushed to GitHub
/*
 * app.c
 *
 *  Created on: Feb 12, 2026
 *      Author: Jyde
 */
// everything that should happen before the main loop
#include <button_driver.h>
#include "app.h"
#include "led1_driver.h"
#include "led2_driver.h"
#include "serial_debug_driver.h"
#include "bsp_serial_debug.h"
#include "ble_driver.h"
#include "LED1_Thread.h"
#include "LED2_Thread.h"
#include "bsp_ble.h"
#include "bsp_ldr.h"
#include "ldr_driver.h"

void App_Init(void){
	LED1_Init();
	LED2_Init();
	Serial_Debugger_Init();
	BLE_Init();
	BLE_Driver_Ready_To_RX();
	LDR_DMA_Init();
	LDR_Init();
	LDR_Start_DMA();
	button_Init();
	LED1_Thread_Init();
	LED2_Thread_Init();

	print_message("Ready to roll...\r\n");
}
