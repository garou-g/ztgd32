/* Generate a link error if heap and stack don't fit into RAM */
_Min_Heap_Size = 0x1000;    /* Required amount of heap  */
_Min_Stack_Size = 0x1000;   /* Required amount of stack */

/* Specify the memory areas */
MEMORY
{
    RAM (xrw)   : ORIGIN = 0x20000000, LENGTH = 48K
    FLASH (rx)  : ORIGIN = 0x8000000, LENGTH = 256K
}

INCLUDE gd32f30x.ld
