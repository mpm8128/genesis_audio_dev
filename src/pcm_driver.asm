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
    DI                  ;disable interrupts during reset
    IM  1               ;set vblank interrupt to reset_38
    LD  A, 0xFF         ;A = stop code
    LD  sp, $1000       ;initialize the stack pointer
    LD  IX, opn2_ctrl   ;IX = 0x4000
    EI                  ;enable interrupts
    ;JR playback_setup

idle_loop:
    JR idle_loop    ;wait forever
    
playback_ptr:
    defw 0x1000
   
opn2_ctrl   equ 0x4000
opn2_data   equ 0x4001
    
    org 0038h
reset_38:
vblank_isr:
    DI
    EI
    RETI
    
playback_setup:
    ;load playback_ptr into a register
    LD  HL, (playback_ptr)
playback_loop:
    ;get next byte
    LD  E, (HL)
    
    ;write to 2612
wait_for_busy_clear_ctrl:
    LD  A, (IX)             ;B = opn2_ctrl read
    BIT 7, A                ;test bit 7
    ;   if bit 7 clear, get out of here
    JR  Z, write_register_num
    ;   else, keep waiting
    JR  wait_for_busy_clear_ctrl
    
write_register_num:
    LD  A, 0x2A     ;A = DAC register
    LD  (IX), A     ;write reg to opn2
    
    NOP

wait_for_busy_clear_data:
    LD  A, (IX)             ;B = opn2_ctrl read
    BIT 7, A                ;test bit 7
    ;   if bit 7 clear, get out of here
    JR  Z, write_data
    ;   else, keep waiting
    JR  wait_for_busy_clear_data    
    
write_data:
    LD  A, E    ;A = byte of PCM data
    LD (IX+1), A
   
   
    LD  A, 0xFF
    ;compare A to the byte at address HL, 
    ;   increment HL, decrement BC
    ;if byte == 0xFF (the value stored in A),
    ;   branch to setup
    CPI 
    JR Z, playback_setup
    
    ;else keep playing
    JR playback_loop
    
    org 1000h
test_wav:
    incbin  "songs/test.wav"
