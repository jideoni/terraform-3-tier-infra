/*
 * LED1_Thread.h
 *
 *  Created on: Feb 12, 2026
 *      Author: Jyde
 */

#ifndef INC_LED1_THREAD_H_
#define INC_LED1_THREAD_H_

#include <stdint.h>

extern uint8_t rx_buf[];	//originally defined in bsp_ble.c

void LED1_Thread_Init(void);

#endif /* INC_LED1_THREAD_H_ */
