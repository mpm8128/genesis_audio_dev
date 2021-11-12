
fm_frequency_table:
;            0    1    2    3    4    5    6    7    8     9    10    11
;            C    C#   D    D#   E    F    F#   G    G#    A    A#     B
;    dc.w    617, 653, 692, 733, 777, 823, 872, 924, 979, 1037, 1099, 1164
    dc.w    644, 682, 723, 766, 811, 859, 910, 965, 1022, 1083, 1147, 1215

max_fm_freq     equ     2047
min_fm_freq    equ     1


    even
;============================================================================
;   FM_init
    ;initializes the 2612 by writing a keyoff for every channel
;============================================================================

FM_init:
    movea.l 0, a5
    
    move.b  #0, d2
    jsr keyoff_FM_channel
    jsr quick_mute_FM_channel
    move.b  #1, d2
    jsr keyoff_FM_channel
    jsr quick_mute_FM_channel

    move.b  #2, d2
    jsr keyoff_FM_channel
    jsr quick_mute_FM_channel

    move.b  #4, d2
    jsr keyoff_FM_channel
    jsr quick_mute_FM_channel

    move.b  #5, d2
    jsr keyoff_FM_channel
    jsr quick_mute_FM_channel

    move.b  #6, d2
    jsr keyoff_FM_channel
    jsr quick_mute_FM_channel

    rts
  
;============================================================================
;   quick_mute_FM_channel
;       disables both stereo outputs
;parameters:
;   a5 - pointer to struct (optional)
;   d2.b - channel (0-2, 4-6)
;============================================================================
quick_mute_FM_channel:
    move.l  a5, d6                  ;copy a5 to d6
    tst.l   d6                      ;null check
    beq     @skip_mod_data          ;if null, don't do this
    move.b  fm_ch_lr_amfm(a5), d1   ;load mod data from struct
    
@skip_mod_data:
    move.b  #0xB4, d0               ;stereo/am/fm mod register
    andi.b  #0x3F, d1               ;mask off stereo bits
    jsr write_register_opn2
    rts
    
    
;============================================================================
;   quick_unmute_FM_channel
;       disables both stereo outputs
;parameters:
;   a5 - pointer to struct (optional)
;   d2.b - channel (0-2, 4-6)
;============================================================================
quick_unmute_FM_channel:
    move.l  a5, d6                  ;copy a5 to d6
    tst.l   d6                      ;null check
    beq     @skip_mod_data          ;if null, don't do this
    move.b  fm_ch_lr_amfm(a5), d1   ;load mod data from struct
    
@skip_mod_data:
    move.b  #0xB4, d0               ;stereo/am/fm mod register
    ;ori.b   #0xC0, d1               ;turn on both stereo bits
    jsr write_register_opn2
    rts
    
;============================================================================
;   set_FM_frequency
;
;   d0.b = octave/block (0-7)
;   d1.w = frequency (split up in function) 
;   d2.b = channel  (0-2, 4-6)
;============================================================================
set_FM_frequency:
    move.b  d1, d3          ;save lsb in d3
    lsr.w   #8, d1          ;shift msb down
    lsl.b   #3, d0          ;shift octave/block into place
    or.b    d0, d1          ;OR in octave/block
    move.b  #0xA4, d0       ;d0 = freq_msb reg
    jsr write_register_opn2

    move.b  d3, d1          ;d1 = freq_lsb
    move.b  #0xA0, d0       ;d0 = freq_lsb reg
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
    jsr write_register_opn2_ctrl
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
    jsr write_register_opn2_ctrl   ;write_register_opn2(d0, d1, d2) (register, data, channel)
    rts
    
;============================================================================
;   load_FM_instrument
;
;   a1 = pointer to instrument data
;   a5 - pointer to channel struct
;   d2 = channel (0-2, 4-6)
;============================================================================
load_FM_instrument:
    move.w  #0x30, d0           ;d0 = start register for instrument parameters
    move.w  #23, d3             ;d3 = num_parameters - 1
@loop_each_parameter:               ;for each parameter (det_mul, tl, rs_ar, am_d1r, d2r, sl_rr)
    move.b  (a1)+, d1           ;d1 = data
    jsr write_register_opn2     ;write_register_opn2(d0, d1, d2) (register, data, channel)
    addi.b  #4, d0              ;next operator
    andi.b  #0xFC, d0
    dbf d3, @loop_each_parameter    ;end loop
    move.b #$B0, d0             ;d0 = register for feedback/algorithm
    move.b (a1)+, d1
    jsr write_register_opn2     ;write_register_opn2(d0, d1, d2) (register, data)
    move.b #$B4, d0             ;d0 = register for stereo/AM/FM sensitivity
    move.b (a1)+, d1
    jsr write_register_opn2     ;write_register_opn2(d0, d1, d2) (register, data, channel)
    rts
    
;============================================================================
;   write_register_opn2(_side1/_side2)
;
;   d0 = register
;   d1 = data
;   A5 = pointer to channel struct
;   ;;;;d2 = channel (0-2 = side 1, 4-6 = side 2. CTRL uses channel 0)
;============================================================================
write_register_opn2:
    move.b  ch_channel_num(a5), d2   ;d2 = channel number

    btst	#2, d2          ;check bit to see which side of the 2612 to write to
    bne.b	setup_write_register_opn2_side2
    ;else fallthrough to side 1/ctrl
write_register_opn2_side1:
    ;subi.b  #1, d2          ;zero-index for the chip
    add.b	d2, d0          ;Channel select. 
write_register_opn2_ctrl:
    ;M_request_Z80_bus
    lea opn2_addr_1, a0
    M_wait_for_busy_clear
    move.b  d0, (a0)
    nop
    M_wait_for_busy_clear
    move.b  d1, $1(a0)
    ;M_return_Z80_bus
    rts
    
    ;d0 = register
    ;d1 = data
    ;d2 = channel (4, 5, 6)
setup_write_register_opn2_side2:
    bclr.l	#2, D2                          ;wipe the "top" bit (leaving just the bottom 2 bits)
	add.b	D2, D0                          ;Channel select. 
    ;fallthrough to side 2
    
write_register_opn2_side2:
    ;M_request_Z80_bus
    lea opn2_addr_1, a0
    M_wait_for_busy_clear
    move.b  d0, $2(a0)
    nop
    M_wait_for_busy_clear
    move.b  d1, $3(a0)
    ;M_return_Z80_bus
    rts
    
;;
set_address_opn2:
    lea opn2_addr_1, a0
    M_wait_for_busy_clear
    move.b  d0, (a0)
    rts