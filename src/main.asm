    include 'vector_table.asm'
    include 'header.asm'
    
code_start:
    jmp code_start          ;loop, do nothing
    
INT_Null:                   ;
CPU_Exception:              ;halt for unhandled exceptions
    stop    #0x2700
    
INT_HInterrupt:             ;HBLANK interrupt - just return for now    
    rte
    
INT_VInterrupt:             ;VBLANK interrupt - just return for now
    rte