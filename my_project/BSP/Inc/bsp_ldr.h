/*
 * bsp_ldr.h
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#ifndef INC_BSP_LDR_H_
#define INC_BSP_LDR_H_

#include "main.h"
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>

#define ADC_BUF_LEN 1

extern ADC_HandleTypeDef hadc;		//originally defined in ldr_driver.c

void LDR_Start_DMA(void);	//Start ADC in DMA Mode

#endif /* INC_BSP_LDR_H_ */
