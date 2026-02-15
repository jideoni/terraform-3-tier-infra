/*
 * ldr_service.h
 *
 *  Created on: Feb 13, 2026
 *      Author: Jyde
 */

#ifndef INC_LDR_SERVICE_H_
#define INC_LDR_SERVICE_H_

#include <stdint.h>

extern uint16_t adc_buf[];		//originally defined in LED2_Thread.c

void LDR_Service_DMA(void);

#endif /* INC_LDR_SERVICE_H_ */
