/*!
    \file  system_gd32f4xx.c
    \brief CMSIS Cortex-M4 Device Peripheral Access Layer Source File for
           GD32F4xx Device Series
*/

#include "gd32f4xx.h"

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
    // FPU settings
#if (__FPU_PRESENT == 1) && (__FPU_USED == 1)
    SCB->CPACR |= ((3UL << 10*2) | (3UL << 11*2)); // Set CP10 and CP11 Full Access
#endif

    // Reset the RCU clock configuration to the default reset state
    // Set IRC16MEN bit
    RCU_CTL |= RCU_CTL_IRC16MEN;
    while (0U == (RCU_CTL & RCU_CTL_IRC16MSTB));
    RCU_MODIFY(0x50);

    RCU_CFG0 &= ~RCU_CFG0_SCS;

    // Reset HXTALEN, CKMEN and PLLEN bits
    RCU_CTL &= ~(RCU_CTL_PLLEN | RCU_CTL_CKMEN | RCU_CTL_HXTALEN);

    // Reset HSEBYP bit
    RCU_CTL &= ~(RCU_CTL_HXTALBPS);

    // Reset CFG0 register
    RCU_CFG0 = 0x00000000U;

    // Wait until IRC16M is selected as system clock
    while (0 != (RCU_CFG0 & RCU_SCSS_IRC16M));

    /* Reset PLLCFGR register */
    RCU_PLL = 0x24003010U;

    /* Disable all interrupts */
    RCU_INT = 0x00000000U;

    SystemCoreClock = IRC16M_VALUE;
}
