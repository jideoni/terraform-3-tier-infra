/*
 * gpio_map.h
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

// for Nucleo-F070RB
#ifndef GPIO_DRIVER_INC_GPIO_MAP_H_
#define GPIO_DRIVER_INC_GPIO_MAP_H_

#include <stdint.h>
#include <stdbool.h>

#define BUTTON_GPIO_PORT   GPIOC
#define BUTTON_PIN         GPIO_PIN_13
#define LED1_GPIO_PORT   GPIOA
#define LED1_PIN         GPIO_PIN_5
#define LED2_GPIO_PORT   GPIOB
#define LED2_PIN         GPIO_PIN_2

#endif /* GPIO_DRIVER_INC_GPIO_MAP_H_ */
