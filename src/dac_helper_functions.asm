;DAC helper functions

;DO NOT REQUEST/RELEASE THE Z80 BUS IN THIS CODE
; this is run from the main audio driver, which
;   already has the z80's bus. 

z80_mailbox_addr    equ 0x00A00020
z80_sample_bank     equ 0x00A00024
z80_sample_offset   equ 0x00A00026


;====================================
;
;   initialize the DAC. Currently unused
;
;====================================

dac_init_dac:
    ;enable dac
    rts

;====================================
;   send signal code to the z80
;
; parameters:
;   d0.b -  one-byte signal code
;====================================
dac_send_signal_code:
    move.b  d0, (z80_mailbox_addr)
    rts

;====================================
;   send sample address
;
; parameters:
;   d0.l -  4-byte address of the 
;           sample to point the z80 at
;====================================
dac_send_sample_address:
    ;extract bank number and write to z80
    lsl.l   #1, d0  ;move bit 15 into upper word
    swap    d0      ;swap upper/lower words
    andi.w  #0xFF, d0  ;mask bottom 8 bits (15-22 of original address)
                    ;technically bank selection
                    ;   is 9 bits, but we trash
                    ;   the MSB because it makes
                    ;   everything much more complicated
                    ;   and we're not planning to
                    ;   work on samples in RAM anyway
    move.b  d0, (z80_sample_bank)
    
    ;fix address endian-ness
    swap    d0      ;swap it back 
    lsr.w   #1, d0  ;shift back down
            ;bits 0-14 in the right place
            ;bit 15 gets trashed by the z80
            
    ;write low-byte first, then high-byte
    move.b  d0, (z80_sample_offset)
    lsr.w   #8, d0
    move.b  d0, (z80_sample_offset+1)
    
    rts
    
    
    