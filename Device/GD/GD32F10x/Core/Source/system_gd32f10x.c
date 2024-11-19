/*!
    \file    system_gd32f10x.c
    \brief   CMSIS Cortex-M3 Device Peripheral Access Layer Source File for
             GD32F10x Device Series
*/

#include "gd32f10x.h"

#define VECT_TAB_OFFSET  (uint32_t)0x00 // Vector table base offset

uint32_t SystemCoreClock;

#define RCU_MODIFY(__delay)     do{                                     \
                                    volatile uint32_t i;                \
                                    if(0 != __delay){                   \
                                        RCU_CFG0 |= RCU_AHB_CKSYS_DIV2; \
                                        for(i=0; i<__delay; i++){       \
                                        }                               \
                                        RCU_CFG0 |= RCU_AHB_CKSYS_DIV4; \
                                        for(i=0; i<__delay; i++){       \
                                        }                               \
                                    }                                   \
                                }while(0)

/**
 * @brief Setup the microcontroller system, initialize the system
 */
void SystemInit(void)
{
    // Reset the RCC clock configuration to the default reset state
    // Enable IRC8M
    RCU_CTL |= RCU_CTL_IRC8MEN;
    while (0U == (RCU_CTL & RCU_CTL_IRC8MSTB));
    RCU_MODIFY(0x50);

    RCU_CFG0 &= ~RCU_CFG0_SCS;

    // Reset HXTALEN, CKMEN, PLLEN bits
    RCU_CTL &= ~(RCU_CTL_HXTALEN | RCU_CTL_CKMEN | RCU_CTL_PLLEN);

    // Reset SCS, AHBPSC, APB1PSC, APB2PSC, ADCPSC, CKOUT0SEL bits
    RCU_CFG0 &= ~(RCU_CFG0_SCS | RCU_CFG0_AHBPSC | RCU_CFG0_APB1PSC | RCU_CFG0_APB2PSC |
                  RCU_CFG0_ADCPSC | RCU_CFG0_ADCPSC_2 | RCU_CFG0_CKOUT0SEL);

    // Reset HXTALEN, CKMEN, PLLEN bits
    RCU_CTL &= ~(RCU_CTL_HXTALEN | RCU_CTL_CKMEN | RCU_CTL_PLLEN);

    // Reset HXTALBPS bit
    RCU_CTL &= ~(RCU_CTL_HXTALBPS);

    // Reset PLLSEL, PREDV0_LSB, PLLMF, USBFSPSC bits
#ifdef GD32F10X_CL
    RCU_CFG0 &= ~(RCU_CFG0_PLLSEL | RCU_CFG0_PREDV0_LSB | RCU_CFG0_PLLMF |
                  RCU_CFG0_USBFSPSC | RCU_CFG0_PLLMF_4);
    RCU_CFG1 = 0x00000000U;
#else
    RCU_CFG0 &= ~(RCU_CFG0_PLLSEL | RCU_CFG0_PREDV0 | RCU_CFG0_PLLMF |
                  RCU_CFG0_USBDPSC | RCU_CFG0_PLLMF_4);
#endif /* GD32F10X_CL */

    // Wait until IRC8M is selected as system clock
    while (0U != (RCU_CFG0 & RCU_SCSS_IRC8M));

#if (defined(GD32F10X_MD) || defined(GD32F10X_HD) || defined(GD32F10X_XD))
    // Reset HXTALEN, CKMEN and PLLEN bits
    RCU_CTL &= ~(RCU_CTL_PLLEN | RCU_CTL_CKMEN | RCU_CTL_HXTALEN);
    // Disable all interrupts
    RCU_INT = 0x009F0000U;
#elif defined(GD32F10X_CL)
    // Reset HXTALEN, CKMEN, PLLEN, PLL1EN and PLL2EN bits
    RCU_CTL &= ~(RCU_CTL_PLLEN | RCU_CTL_PLL1EN | RCU_CTL_PLL2EN | RCU_CTL_CKMEN | RCU_CTL_HXTALEN);
    // Disable all interrupts
    RCU_INT = 0x00FF0000U;
#endif

#ifdef VECT_TAB_SRAM
    SCB->VTOR = NVIC_VECTTAB_RAM | (VECT_TAB_OFFSET & NVIC_VECTTAB_OFFSET_MASK);
#else
    SCB->VTOR = NVIC_VECTTAB_FLASH | (VECT_TAB_OFFSET & NVIC_VECTTAB_OFFSET_MASK);
#endif
    __DSB();

    SystemCoreClock = IRC8M_VALUE;
}
