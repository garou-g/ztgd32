.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.global g_pfnVectors
.global Default_Handler

/* Start address for the initialization values of the .data section.
defined in linker script */
.word _sidata

/* Start and end  address for the .data section. defined in linker script */
.word _sdata
.word _edata

/* Start and end address for the .bss section. defined in linker script */
.word _sbss
.word _ebss

/**
 * @brief This is the code that gets called when the processor first
 *          starts execution following a reset event. Only the absolutely
 *          necessary set is performed, after which the application
 *          supplied main() routine is called
*/
    .section .text.Reset_Handler
    .weak Reset_Handler
    .type Reset_Handler, %function
Reset_Handler:
    /* Set stack pointer */
    ldr  sp, =_estack

    /* Copy the data segment initializers from flash to SRAM */
    ldr  r0, =_sdata
    ldr  r1, =_edata
    ldr  r2, =_sidata
    movs r3, #0
    b LoopCopyDataInit

CopyDataInit:
    ldr  r4, [r2, r3]
    str  r4, [r0, r3]
    adds r3, r3, #4

LoopCopyDataInit:
    adds r4, r0, r3
    cmp  r4, r1
    bcc CopyDataInit

    /* Zero fill the bss segment */
    ldr  r2, =_sbss
    ldr  r4, =_ebss
    movs r3, #0
    b LoopFillZerobss

FillZerobss:
    str  r3, [r2]
    adds r2, r2, #4

LoopFillZerobss:
    cmp  r2, r4
    bcc  FillZerobss

    /* Call the clock system intitialization function */
    bl SystemInit
    /* Call static constructors */
    bl __libc_init_array
    /* Call the application's entry point */
    bl main

LoopForever:
    b LoopForever
    .size Reset_Handler, .-Reset_Handler

/**
 * @brief This is the code that gets called when the processor receives an
 *         unexpected interrupt. This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger
*/
    .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
    b Infinite_Loop
    .size Default_Handler, .-Default_Handler

/******************************************************************************
* The minimal vector table for a Cortex-M. Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000_0000.
******************************************************************************/

    .section .isr_vector,"a",%progbits
    .type g_pfnVectors, %object
    .size g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
    .word   _estack
    .word   Reset_Handler
    .word   NMI_Handler
    .word   HardFault_Handler
    .word   MemManage_Handler
    .word   BusFault_Handler
    .word   UsageFault_Handler
    .word   0
    .word   0
    .word   0
    .word   0
    .word   SVC_Handler
    .word   DebugMon_Handler
    .word   0
    .word   PendSV_Handler
    .word   SysTick_Handler

    /* External interrupts handler */
    .word   WWDGT_IRQHandler
    .word   LVD_IRQHandler
    .word   TAMPER_IRQHandler
    .word   RTC_IRQHandler
    .word   FMC_IRQHandler
    .word   RCU_IRQHandler
    .word   EXTI0_IRQHandler
    .word   EXTI1_IRQHandler
    .word   EXTI2_IRQHandler
    .word   EXTI3_IRQHandler
    .word   EXTI4_IRQHandler
    .word   DMA0_Channel0_IRQHandler
    .word   DMA0_Channel1_IRQHandler
    .word   DMA0_Channel2_IRQHandler
    .word   DMA0_Channel3_IRQHandler
    .word   DMA0_Channel4_IRQHandler
    .word   DMA0_Channel5_IRQHandler
    .word   DMA0_Channel6_IRQHandler
    .word   ADC0_1_IRQHandler
    .word   USBD_HP_CAN0_TX_IRQHandler
    .word   USBD_LP_CAN0_RX0_IRQHandler
    .word   CAN0_RX1_IRQHandler
    .word   CAN0_EWMC_IRQHandler
    .word   EXTI5_9_IRQHandler
    .word   TIMER0_BRK_IRQHandler
    .word   TIMER0_UP_IRQHandler
    .word   TIMER0_TRG_CMT_IRQHandler
    .word   TIMER0_Channel_IRQHandler
    .word   TIMER1_IRQHandler
    .word   TIMER2_IRQHandler
    .word   TIMER3_IRQHandler
    .word   I2C0_EV_IRQHandler
    .word   I2C0_ER_IRQHandler
    .word   I2C1_EV_IRQHandler
    .word   I2C1_ER_IRQHandler
    .word   SPI0_IRQHandler
    .word   SPI1_IRQHandler
    .word   USART0_IRQHandler
    .word   USART1_IRQHandler
    .word   USART2_IRQHandler
    .word   EXTI10_15_IRQHandler
    .word   RTC_Alarm_IRQHandler
    .word   USBD_WKUP_IRQHandler
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   EXMC_IRQHandler

/*******************************************************************************
* Provide weak aliases for each Exception handler to the Default_Handler.
* As they are weak aliases, any function with the same name will override
* this definition.
*******************************************************************************/

    .weak NMI_Handler
        .thumb_set NMI_Handler,Default_Handler
    .weak HardFault_Handler
        .thumb_set HardFault_Handler,Default_Handler
    .weak MemManage_Handler
        .thumb_set MemManage_Handler,Default_Handler
    .weak BusFault_Handler
        .thumb_set BusFault_Handler,Default_Handler
    .weak UsageFault_Handler
        .thumb_set UsageFault_Handler,Default_Handler
    .weak SVC_Handler
        .thumb_set SVC_Handler,Default_Handler
    .weak DebugMon_Handler
        .thumb_set DebugMon_Handler,Default_Handler
    .weak PendSV_Handler
        .thumb_set PendSV_Handler,Default_Handler
    .weak SysTick_Handler
        .thumb_set SysTick_Handler,Default_Handler

    /* External interrupts handler */
    .weak WWDGT_IRQHandler
        .thumb_set WWDGT_IRQHandler,Default_Handler
    .weak LVD_IRQHandler
        .thumb_set LVD_IRQHandler,Default_Handler
    .weak TAMPER_IRQHandler
        .thumb_set TAMPER_IRQHandler,Default_Handler
    .weak RTC_IRQHandler
        .thumb_set RTC_IRQHandler,Default_Handler
    .weak FMC_IRQHandler
        .thumb_set FMC_IRQHandler,Default_Handler
    .weak RCU_IRQHandler
        .thumb_set RCU_IRQHandler,Default_Handler
    .weak EXTI0_IRQHandler
        .thumb_set EXTI0_IRQHandler,Default_Handler
    .weak EXTI1_IRQHandler
        .thumb_set EXTI1_IRQHandler,Default_Handler
    .weak EXTI2_IRQHandler
        .thumb_set EXTI2_IRQHandler,Default_Handler
    .weak EXTI3_IRQHandler
        .thumb_set EXTI3_IRQHandler,Default_Handler
    .weak EXTI4_IRQHandler
        .thumb_set EXTI4_IRQHandler,Default_Handler
    .weak DMA0_Channel0_IRQHandler
        .thumb_set DMA0_Channel0_IRQHandler,Default_Handler
    .weak DMA0_Channel1_IRQHandler
        .thumb_set DMA0_Channel1_IRQHandler,Default_Handler
    .weak DMA0_Channel2_IRQHandler
        .thumb_set DMA0_Channel2_IRQHandler,Default_Handler
    .weak DMA0_Channel3_IRQHandler
        .thumb_set DMA0_Channel3_IRQHandler,Default_Handler
    .weak DMA0_Channel4_IRQHandler
        .thumb_set DMA0_Channel4_IRQHandler,Default_Handler
    .weak DMA0_Channel5_IRQHandler
        .thumb_set DMA0_Channel5_IRQHandler,Default_Handler
    .weak DMA0_Channel6_IRQHandler
        .thumb_set DMA0_Channel6_IRQHandler,Default_Handler
    .weak ADC0_1_IRQHandler
        .thumb_set ADC0_1_IRQHandler,Default_Handler
    .weak USBD_HP_CAN0_TX_IRQHandler
        .thumb_set USBD_HP_CAN0_TX_IRQHandler,Default_Handler
    .weak USBD_LP_CAN0_RX0_IRQHandler
        .thumb_set USBD_LP_CAN0_RX0_IRQHandler,Default_Handler
    .weak CAN0_RX1_IRQHandler
        .thumb_set CAN0_RX1_IRQHandler,Default_Handler
    .weak CAN0_EWMC_IRQHandler
        .thumb_set CAN0_EWMC_IRQHandler,Default_Handler
    .weak EXTI5_9_IRQHandler
        .thumb_set EXTI5_9_IRQHandler,Default_Handler
    .weak TIMER0_BRK_IRQHandler
        .thumb_set TIMER0_BRK_IRQHandler,Default_Handler
    .weak TIMER0_UP_IRQHandler
        .thumb_set TIMER0_UP_IRQHandler,Default_Handler
    .weak TIMER0_TRG_CMT_IRQHandler
        .thumb_set TIMER0_TRG_CMT_IRQHandler,Default_Handler
    .weak TIMER0_Channel_IRQHandler
        .thumb_set TIMER0_Channel_IRQHandler,Default_Handler
    .weak TIMER1_IRQHandler
        .thumb_set TIMER1_IRQHandler,Default_Handler
    .weak TIMER2_IRQHandler
        .thumb_set TIMER2_IRQHandler,Default_Handler
    .weak TIMER3_IRQHandler
        .thumb_set TIMER3_IRQHandler,Default_Handler
    .weak I2C0_EV_IRQHandler
        .thumb_set I2C0_EV_IRQHandler,Default_Handler
    .weak I2C0_ER_IRQHandler
        .thumb_set I2C0_ER_IRQHandler,Default_Handler
    .weak I2C1_EV_IRQHandler
        .thumb_set I2C1_EV_IRQHandler,Default_Handler
    .weak I2C1_ER_IRQHandler
        .thumb_set I2C1_ER_IRQHandler,Default_Handler
    .weak SPI0_IRQHandler
        .thumb_set SPI0_IRQHandler,Default_Handler
    .weak SPI1_IRQHandler
        .thumb_set SPI1_IRQHandler,Default_Handler
    .weak USART0_IRQHandler
        .thumb_set USART0_IRQHandler,Default_Handler
    .weak USART1_IRQHandler
        .thumb_set USART1_IRQHandler,Default_Handler
    .weak USART2_IRQHandler
        .thumb_set USART2_IRQHandler,Default_Handler
    .weak EXTI10_15_IRQHandler
        .thumb_set EXTI10_15_IRQHandler,Default_Handler
    .weak RTC_Alarm_IRQHandler
        .thumb_set RTC_Alarm_IRQHandler,Default_Handler
    .weak USBD_WKUP_IRQHandler
        .thumb_set USBD_WKUP_IRQHandler,Default_Handler
    .weak EXMC_IRQHandler
        .thumb_set EXMC_IRQHandler,Default_Handler

/***************************** END OF FILE ************************************/
