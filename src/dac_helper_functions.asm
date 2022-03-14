;DAC helper functions

;====================================
;   load new sample into z80 RAM
;====================================

;====================================
;   load sample bank into 68k RAM
;====================================

;====================================
;   send signal code to the z80
;
; parameters:
;   d0.b -  one-byte signal code
;====================================
z80_mailbox_addr    equ 0x00A00020
z80_sample_bank     equ 0x00A00024
z80_sample_offset   equ 0x00A00026

dac_init_dac:
    ;enable dac
    rts


;DO NOT REQUEST/RELEASE THE Z80 BUS IN THIS CODE
; this is run from the main audio driver, which
;   already has the z80's bus. 

dac_send_signal_code:
    move.b  d0, (z80_mailbox_addr)
    rts
    
dac_send_sample_address:
    move.l  d0, d1  ;copy address to d1
    
    ;calculate bank number and write to z80
    lsl.l   #1, d0  ;move bit 15 into upper word
    swap    d0      ;swap upper/lower words
    andi.w  #0x01FF, d0  ;mask bottom 9 bits (15-23 of original address)
    move.w  d0, (z80_sample_bank)
    
    ;mask off offset and write to z80
    ;andi.w  0x7FFF, d1 ;mask off bit 15
    bset    #15, d1     ;set bit 15 so we don't have to on the z80
    move.w  d1, (z80_sample_offset)
    
    rts
    
    
    