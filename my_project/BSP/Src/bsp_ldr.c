/*
 * bsp_ldr.c
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#include "main.h"
#include "ldr_service.h"
#include "bsp_ldr.h"

void LDR_Start_DMA(void) {
	HAL_ADC_Start_DMA(&hadc, (uint32_t*) adc_buf, ADC_BUF_LEN);		//start ADC in DMA Mode
}
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef *hadc) {
	LDR_Service_DMA();		//call function to set threadflag
}
