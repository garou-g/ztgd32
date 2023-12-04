/*!
    \file  system_gd32f4xx.h
    \brief CMSIS Cortex-M4 Device Peripheral Access Layer Header File for
           GD32F4xx Device Series
*/

/* Copyright (c) 2012 ARM LIMITED

   All rights reserved.
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:
   - Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
   - Neither the name of ARM nor the names of its contributors may be used
     to endorse or promote products derived from this software without
     specific prior written permission.
   *
   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS AND CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
   ---------------------------------------------------------------------------*/

/* This file refers the CMSIS standard, some adjustments are made according to GigaDevice chips */

#ifndef SYSTEM_GD32F4XX_H
#define SYSTEM_GD32F4XX_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/* system clock frequency (core clock) */
extern uint32_t SystemCoreClock;

/* function declarations */
/* initialize the system and update the SystemCoreClock variable */
void SystemInit(void);

void system_clock_16m_irc16m(void);
void system_clock_hxtal(void);
void system_clock_120m_irc16m(void);
void system_clock_120m_8m_hxtal(void);
void system_clock_120m_25m_hxtal(void);
void system_clock_168m_irc16m(void);
void system_clock_168m_8m_hxtal(void);
void system_clock_168m_25m_hxtal(void);
void system_clock_200m_irc16m(void);
void system_clock_200m_8m_hxtal(void);
#if defined (GD32F450) || defined (GD32F405) || defined (GD32F407) || defined (GD32F425) || defined (GD32F427)
void system_clock_200m_25m_hxtal(void);
#endif
void system_clock_240m_irc16m(void);
void system_clock_240m_8m_hxtal(void);
#if defined (GD32F470)
void system_clock_240m_25m_hxtal(void);
#endif

#ifdef __cplusplus
}
#endif

#endif /* SYSTEM_GD32F4XX_H */
