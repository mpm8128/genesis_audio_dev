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

    .z80
    org 0000h
    
;======================================================
;   reset code and other miscellaneous initialization
;======================================================
code_start:
reset_0:
    DI                  ;disable interrupts
    LD  A, 0x00         ;clear accumulator
    LD  (mailbox), A    ;clear mailbox
    LD  sp, 0x2000      ;initialize the stack pointer
    LD  IX, opn2_ctrl   ;IX = 0x4000
    ;fallthrough to "paused" state

;======================================================
;   idles waiting for a signal from the main processor
;======================================================
pause_dac:
    LD  A, (mailbox)     ;get value in mailbox
    OR  A                ;   set status register
    JR  z, pause_dac     ;if zero, keep waiting
    JR  playback_setup   ;else do some playback
    
    
    
playback_ptr:
    defw 0x500

    org 0020h
mailbox:
    defb 0x00
   
opn2_ctrl   equ 0x4000
    
;    org 0038h
;reset_38:
;vblank_isr:
;    DI
;    EI
;    RETI

    org 0030h
playback_setup:
    ;load playback_ptr into a register
    LD  HL, test_wav
    LD  (IX), 0x2A      ;select DAC register
playback_loop:

    ;LD  A, 0x01
;timing_adjust:
;    INC A
;    JR  z, timing_adjust
    
    LD  E, (HL)     ;get current byte
    LD (IX+1), E    ;write data
   
    ;compare A to the byte at address HL, 
    ;   increment HL, decrement BC
    ;if byte == 0xFF (the value stored in A),
    ;   branch to setup
    LD  A, 0xFF
    CPI 
    JR  z, sample_finished
    
    ;check mailbox every cycle
    LD  A, (mailbox)     ;get value in mailbox
    OR  A                ;   set status register
    JR  z, pause_dac     ;if zero, keep waiting
    
    ;else keep playing
    JR playback_loop
    
sample_finished:
    LD  A, 0x00
    LD  (mailbox), A    ;write "done" to the mailbox
    JR  pause_dac       ;wait for instructions
    
    org 500h
test_wav:
    incbin  "songs/test.wav"
