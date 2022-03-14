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
    JP  play_dac
    

 
    org 0020h
mailbox:
    defb 0x00   ;[0]
    defb 0x00   ;[1]
    defb 0x00   ;[2]
    defb 0x00   ;[3]

sample_bank:
    defb 0x00   ;[0]
    defb 0x00
sample_offset:
    defw 0x0000
playback_ptr:
    defw 0x0000   
   
opn2_ctrl   equ 0x4000
bank_reg    equ 0x6000
bank_start  equ 0x8000
    
    org 0x0040
    ;received "play" signal
play_dac:    
    ;copy starting sample offset to playback ptr

    ;LD  (playback_ptr), DE

    LD  HL, (sample_offset)
    SET 7, H    ;set bit 15 in playback_ptr
    LD  HL, playback_ptr

load_sample:
    EXX ;swap register banks to swap memory banks   
    
    ;get current bank# into B
    LD  A, (sample_bank)
    LD  B, A    
    
    JR  load_page_from_68k  ;else go load our sample
                            ;and start playback


load_next_page:
    SET 7, H    ;set bit 15 in playback_ptr
                ;HL should == 0x8000 if we're here
    LD  (playback_ptr), HL

    EXX 
    INC B       ;increment bank
    
    ;must EXX before calling this label
load_page_from_68k:

    LD  A, B    ;move to accumulator
    LD  HL, bank_reg     ;HL' = 0x6000
    
    ;LD A, (sample_bank+1)  ;get low byte
    ;   8 times
    LD (HL), A     ;a15
    RRA
    LD (HL), A     ;a16
    RRA
    LD (HL), A     ;a17
    RRA
    LD (HL), A     ;a18
    RRA
    LD (HL), A     ;a19
    RRA
    LD (HL), A     ;a20
    RRA
    LD (HL), A     ;a21
    RRA
    LD (HL), A     ;a22
    RRA

    ;trash the high bit - we're not using it
    LD (HL), 0     ;a23
    
    ;in first byte
    ;LD (HL), 1  ;a15
    ;LD (HL), 0  ;a16
    ;LD (HL), 0
    ;LD (HL), 0
    ;LD (HL), 0
    ;LD (HL), 0
    ;LD (HL), 0
    ;LD (HL), 0  
    
    ;in second byte
    ;LD (HL), 0  ;a23
    
    EXX     ;restore from first EXX in this section
    
    
    
playback_setup:
    
    LD  (IX), 0x2A      ;select DAC register
playback_loop:

    LD  A, 0x03         ;magic number for slowing
                        ;down the PCM driver
                        ;TODO - add math to this comment
                        
                        ;3      ~ 22kHz
                        ;7/8    ~  8kHz
                        
timing_adjust:
    DEC A
    JR  nz, timing_adjust
    
    LD  E, (HL)     ;get current byte
    LD (IX+1), E    ;write data
   
    ;compare A to the byte at address HL, 
    ;   increment HL, decrement BC
    ;if byte == 0xFF (the value stored in A),
    ;   branch to setup
    LD  A, 0xFF
    CPI 
    JR  z, sample_finished
    
    ;check overflow every cycle
    BIT 7, H                ;overflow check
    JP  z, load_next_page   ;if we overflowed, load next page

    ;check mailbox every cycle
    LD  A, (mailbox)     ;get value in mailbox
    OR  A                ;   set status register
    JP  z, pause_dac     ;if zero, wait until nonzero
    
    ;else keep playing
    JP playback_loop
    
    
sample_finished:
    ;mute DAC, then enter paused state
    LD (IX+1), 0x80     ;"zero" amplitude
    LD (IX+1), 0x80     ;"zero" amplitude
    LD (IX+1), 0x80     ;"zero" amplitude

    LD  A, 0x00
    LD  (mailbox), A    ;write "done" to the mailbox
    JP  pause_dac       ;wait for instructions
    