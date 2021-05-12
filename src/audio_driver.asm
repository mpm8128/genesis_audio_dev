;   audio_driver.asm

;============================================================================
;   Definitions and Macros
;============================================================================

opn2_addr_1     equ 0x00A04000
opn2_data_1     equ 0x00A04001
opn2_addr_2     equ 0x00A04002
opn2_data_2     equ 0x00A04003
z80_bus_request_addr    equ 0x00A11100

; PSG port address (accessible from 68000)
; The PSG can be accessed from both the 68000 and the Z80, although each has its own
; address from which to do so.
psg_control				equ 0x00C00011

initial_psg_vol			equ 0x08 ; (half volume)
initial_psg_freq		equ 0xFE ; (440hz)


M_wait_for_busy_clear: macro
@wait_for_busy_clear\@:
    btst  #7, (opn2_addr_1)
    bne.b  @wait_for_busy_clear\@
    endm

M_request_Z80_bus: macro
    move.w  #$0100, z80_bus_request_addr
@wait_for_z80_request\@
    btst    #0, z80_bus_request_addr
    bne     @wait_for_z80_request\@
    endm
    
M_return_Z80_bus: macro
    move.w  #0, z80_bus_request_addr
    endm

    include 'instrument_defs.asm'

;==============================================================
; MEMORY MAP
;==============================================================
	RSSET 0x00FF1000			; Map from start of RAM
R_PSG_Frequency:
ram_psg0_frequency		rs.w 1	; Current PSG frequency (2 bytes)
ram_psg1_frequency		rs.w 1	; Current PSG frequency (2 bytes)
ram_psg2_frequency		rs.w 1	; Current PSG frequency (2 bytes)
ram_psg3_frequency		rs.w 1	; Current PSG frequency (2 bytes)

R_PSG_Volume:
ram_psg0_volume			rs.b 1	; Current PSG volume (1 byte)
ram_psg1_volume			rs.b 1	; Current PSG volume (1 byte)
ram_psg2_volume			rs.b 1	; Current PSG volume (1 byte)
ram_psg3_volume			rs.b 1	; Current PSG volume (1 byte)



;============================================================================
;   Entry point -> audio_driver
;============================================================================

    ;top-level function for the audio driver
    ;this is the entry point for this 'module'
audio_driver:
    M_request_Z80_bus
	
    
    
    M_return_Z80_bus
    rts
    
    ; ;ignore this down here
    
    ; lea Inst_test_organ_1, A1
    ; move.b  #0, d2              ;channel 0
    ; jsr load_FM_instrument
    ; jsr set_FM_frequency
    ; jsr keyon_FM_channel
    
    ; lea Inst_test_organ_1, A1
    ; move.b  #1, d2              ;channel 0
    ; jsr load_FM_instrument
    ; jsr set_FM_frequency
    ; jsr keyon_FM_channel

    ; lea Inst_test_organ_0, A1
    ; move.b  #6, d2              ;channel 0
    ; jsr load_FM_instrument
    ; jsr set_FM_frequency
    ; jsr keyon_FM_channel


    
; ; @loop_forever
    ; ; jmp @loop_forever
    ; M_return_Z80_bus
    ; rts
    
;============================================================================
;   PSG Functions
;============================================================================

    include 'psg_helper_functions.asm'

;============================================================================
;   FM Functions
;============================================================================
  
;============================================================================
;   demo_fm_init
;============================================================================
demo_fm_init:
    lea Inst_test_organ_1, A1
    move.b  #0, d2              ;channel 0
    jsr load_FM_instrument
    
    jsr set_FM_frequency
    jsr keyon_FM_channel

    rts
  
;============================================================================
;   FM_init
    ;initializes the 2612 by writing a keyoff for every channel
;============================================================================

FM_init:
    move.b  #0, d2
    jsr keyoff_FM_channel
    move.b  #1, d2
    jsr keyoff_FM_channel
    move.b  #2, d2
    jsr keyoff_FM_channel
    move.b  #4, d2
    jsr keyoff_FM_channel
    move.b  #5, d2
    jsr keyoff_FM_channel
    move.b  #6, d2
    jsr keyoff_FM_channel

    rts
  
;============================================================================
;   set_FM_frequency
;
;   d1.w = frequency
;   d2.b = channel
;
;============================================================================
set_FM_frequency:
    move.b  #$22, d1  ;note frequency = C of some kind?
    move.b  #$A4, d0
    add.b   d2, d0
    jsr write_register_opn2
    
    move.b  #$69, d1
    move.b  #$A0, d0
    add.b   d2, d0
    jsr write_register_opn2

    rts
    
;============================================================================
;   keyon_FM_channel
;
;   d2.b = channel
;============================================================================
keyon_FM_channel:
    move.b  #$28, d0            ;d0 = keyon/off register
    move.b  d2, d1              ;d1 = channel
    ori.b   #$F0, d1            ;mask in keyon for all operators
    jsr write_register_opn2_side1   ;write_register_opn2(d0, d1, d2) (register, data, channel)
    rts
    
;============================================================================
;   keyoff_FM_channel
;
;   d2.b = channel
;============================================================================
keyoff_FM_channel:
    moveq   #$28, d0            ;d0 = keyon/off register
    move.b  d2, d1              ;d1 = channel
    andi.b  #$0F, d1            ;mask in keyoff for all operators
    jsr write_register_opn2_side1   ;write_register_opn2(d0, d1, d2) (register, data, channel)
    rts
    
;============================================================================
;   load_FM_instrument
;
;   a1 = pointer to instrument data
;   d2 = channel (0-2, 4-6)
;============================================================================
load_FM_instrument:
    move.b  #$30, d0            ;d0 = start register for instrument parameters
    
    moveq   #5, d3                   ;d3 = number of parameters - 1    
@loop_each_parameter:               ;for each parameter (det_mul, tl, rs_ar, am_d1r, d2r, sl_rr)
    
    moveq   #3, d4               ;d4 = number of operators - 1
@loop_each_operator:            ;for each operator (0xY0, 0xY4, 0xY8, 0xYC)
    
    move.b  (a1)+, d1           ;d1 = data
    jsr write_register_opn2     ;write_register_opn2(d0, d1, d2) (register, data, channel)
    addi.b  #4, d0              ;next operator
    dbf d4, @loop_each_operator ;end loop
    
    
    dbf d3, @loop_each_parameter    ;end loop
    
    move.b #$B0, d0             ;d0 = register for feedback/algorithm
    move.b (a1)+, d1
    jsr write_register_opn2     ;write_register_opn2(d0, d1, d2) (register, data)
    move.b #$B4, d0             ;d0 = register for feedback/algorithm
    move.b (a1)+, d1
    jsr write_register_opn2     ;write_register_opn2(d0, d1, d2) (register, data, channel)

    rts
    
;============================================================================
;   write_register_opn2(_side1/_side2)
;
;   d0 = register
;   d1 = data
;   d2 = channel (0-2 = side 1, 4-6 = side 2. CTRL uses channel 0)
;============================================================================
write_register_opn2:
    lea opn2_addr_1, a0
    btst	#2, d2      ;check bit to see which side of the 2612 to write to
    bne.b	setup_write_register_opn2_side2
    ;cmp.b   #3, d2
    ;bgt setup_write_register_opn2_side2
    add.b	d2, d0      ;Channel select. 
    ;fallthrough to side 1

    ;d0 = register
    ;d1 = data
    ;;;;d2 = channel (0, 1, 2)
write_register_opn2_side1:
    lea opn2_addr_1, a0
    M_wait_for_busy_clear
    move.b  d0, (a0)
    nop
    M_wait_for_busy_clear
    move.b  d1, $1(a0)
    rts
    
    ;d0 = register
    ;d1 = data
    ;d2 = channel (4, 5, 6)
setup_write_register_opn2_side2:
    BCLR.l	#2, D2                          ;wipe the "top" bit (leaving just the bottom 2 bits)
	ADD.b	D2, D0                          ;Channel select. 
    ;fallthrough to side 2
    
write_register_opn2_side2:
    M_wait_for_busy_clear
    move.b  d0, (opn2_addr_2)
    nop
    M_wait_for_busy_clear
    move.b  d1, (opn2_data_2)
    rts