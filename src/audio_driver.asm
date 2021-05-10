;   audio_driver.asm

opn2_addr_1     equ 0x00A04000
opn2_data_1     equ 0x00A04001
opn2_addr_2     equ 0x00A04002
opn2_data_2     equ 0x00A04003

M_wait_for_busy_clear: macro
@wait_for_busy_clear\@
    btst.b  #7, (a0)
    bne.b  @wait_for_busy_clear\@
    endm

    include 'instrument_defs.asm'

    ;top-level function for the audio driver
    ;this is the entry point for this 'module'
audio_driver:
    rts
    
    ;a1 = pointer to instrument data
    ;d2 = channel (0-2, 4-6)
load_FM_instrument:
    rts
    
    
    ;d0 = register
    ;d1 = data
    ;d2 = channel (0-2 = side 1, 4-6 = side 2. CTRL uses channel 0)
write_register_opn2:
    btst	#2, d2      ;check bit to see which side of the 2612 to write to
	bne.b	write_register_opn2_side2
	add.b	d2, d0      ;Channel select. 
    ;fallthrough to side 1

    ;d0 = register
    ;d1 = data
write_register_opn2_side1:
    lea opn2_addr_1, a0
    M_wait_for_busy_clear
    move.b  d0, (A0)
    nop
    M_wait_for_busy_clear
    move.b  d0, $1(A0)
    rts
    
    ;d0 = register
    ;d1 = data
write_register_opn2_side2:
    lea opn2_addr_1, a0
    M_wait_for_busy_clear
    move.b  d0, $2(A0)
    nop
    M_wait_for_busy_clear
    move.b  d0, $3(A0)
    rts