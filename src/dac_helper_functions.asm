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
z80_mailbox_addr equ 0x00A00020


dac_init_dac:
    ;enable dac
    rts

dac_send_signal_code:
    ;M_request_Z80_bus
    move.b  d0, (z80_mailbox_addr)
    ;M_return_Z80_bus
    rts