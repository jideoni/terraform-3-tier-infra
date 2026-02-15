/*
 * thread_notification_flags.h
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#ifndef INC_THREAD_NOTIFICATION_FLAGS_H_
#define INC_THREAD_NOTIFICATION_FLAGS_H_

#include <stdint.h>

#define LED1_THREAD_BUTTON_FLAG   (1U << 0)	//set bit 0. 1U = 00000001
#define LED1_THREAD_BLE_RX_FLAG   (1U << 1)	//set bit 1. 1U = 00000010

#define LED2_THREAD_ON_FLAG   (1U << 0)	//set bit 1. 1U = 00000001
#define LED2_THREAD_OFF_FLAG   (1U << 1)

#define LED2_THREAD_FLAG   (1U << 2)	//set bit 2. 1U = 00000100

#endif /* INC_THREAD_NOTIFICATION_FLAGS_H_ */
