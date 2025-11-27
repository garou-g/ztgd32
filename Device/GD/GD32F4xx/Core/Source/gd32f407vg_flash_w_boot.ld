/* Generate a link error if heap and stack don't fit into RAM */
_Min_Heap_Size = 0x4000;    /* Required amount of heap  */
_Min_Stack_Size = 0x4000;   /* Required amount of stack */

/* Specify the memory areas */
MEMORY
{
    RAM (xrw)   : ORIGIN = 0x20000000, LENGTH = 128K
    CCMRAM (xrw): ORIGIN = 0x10000000, LENGTH = 64K
    FLASH (rx)  : ORIGIN = 0x8004000, LENGTH = 1008K
}

INCLUDE gd32f4xx.ld
