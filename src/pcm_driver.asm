;z80 PCM driver

;write to OPN2 register 2A (8-bit data) 
;                   and 2B (dac enable, bit 7)



;pseudocode

;get pointer to wav sample to play

;get playback rate, convert to "cycles to wait"

;write sample to OPN2 (fixed number of cycles?)
;   register 2A

;fetch next byte - stop if 0xFF

;wait remaining cycles to play next sample

    z80
    org 0000h
code_start:
reset_0:
    DI              ;disable interrupts during reset
    IM  1           ;set vblank interrupt to reset_38
    LD  sp, $2000   ;initialize the stack pointer
    EI              ;enable interrupts
idle_loop:
    JR idle_loop    ;wait for something to do
    
    
    org 0038h
reset_38:
vblank_isr:
    DI
    EI
    RETI
    