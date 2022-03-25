;sound test

    RSSET   0xFF0010
st_offset   rs.w    1
st_flag_display_changed     rs.b    1

debug_space_num_words       rs.b    1
debug_scratch_space         rs.w    4


    ;trashes a0, d7, and input reg
M_convert_to_BCD: macro reg, num_digits
    lea     debug_scratch_space, a0
    move.b  #\num_digits, debug_space_num_words  ;save to memory
    move.w  #\num_digits-1, d7                   ;loop counter
    
@convert_bcd_loop\@:
    divu    #10, \reg        ;reg = r(16), q(16)
    swap    \reg             ;reg = q(16), r(16)
    lsl.w   #1, d7          ;word-align index
    move.w  \reg, (a0, d7.w) ;write to memory
    lsr.w   #1, d7          ;un-word-align

    move.w  #0, \reg         ;clear remainder
    swap    \reg             ;restore quotient
    dbf d7, @convert_bcd_loop\@
    endm

    ;trashes a0, d0, d1, d6, and d7
M_write_out_BCD_to_display: macro num_digits
    lea     debug_scratch_space, a0
    move.w  #tile_id_0, d0          ;
    moveq   #\num_digits-1, d7  ;loop counter
    
    moveq   #0, d6                          ;index
@loop_write_number\@:
    move.w  (a0, d6.w), d1        ;d1 = digit
    add.w   d0, d1                 ;d1 = tile number
    move.w  d1, vdp_data
    addi.w  #size_word, d6
    dbf d7, @loop_write_number\@

    endm


    module

    even
sound_test_menu:    
    jsr @handle_input
    ;tst.w   (st_flag_display_changed)
    jmp @update_display
    
    ;rts
     
;==================================== 
; handle input
;       SACB RLDU 
;====================================
@handle_input:
    move.b  (p1_buttons_pressed), d7
    or.b    (p2_buttons_pressed), d7
    
    move.w  (st_offset), d0
    move.w  #(num_songs-song_record_size_bytes), d2
    
; @check_up:
    ; btst    0x0, d7
    ; beq     @check_down:
; @check_down:
    ; btst    0x1, d7
    ; beq     @check_left:
@check_left:
    btst    #pad_button_left, d7
    beq     @check_right
    ;handle left
    move.b  #1, st_flag_display_changed
    subi.w  #8, d0     ;decrement offset
    bpl     @song_selected
    moveq   #0, d0     ;clip to 0
    
@check_right:
    btst    #pad_button_right, d7
    beq     @song_selected
    ;handle right
    move.b  #1, st_flag_display_changed
    addi.w  #8, d0      ;increment offset
    cmp.w   d2, d0      ;d6 - num_songs
    ble     @song_selected
    move.w  d2, d0      ;clip to num_songs
    
@song_selected:    
    move.w  d0, (st_offset)
    
;@check_start
    ; btst    0x7, d7
;@check_a:
    btst    #pad_button_a, d7
    bne     @play_song
;@check_b
    btst    #pad_button_b, d7
    bne     @play_silence
;@check_c
    btst    #pad_button_c, d7
    bne     @play_song
    rts
 
@play_silence:
    move.w  #offset_silence, d0
@play_song:
    jsr load_song_from_parts_table    
    rts
    
;==================================
;   update display
;==================================
sound_test_xpos equ 0
sound_test_ypos equ 0

num_st_digits   equ 2
    even
st_digits   rs.w    num_st_digits





@update_display:
    jsr @display_song_number
    jsr @display_fm_channel_data

    rts
    
;--------------------------
@display_song_number
    clr.l   d6
    move.w  (st_offset), d6     ;d6 = song table offset

    lsr.w   #3, d6              ;song table offsets are multiples of 8
                                ;d6/8 gives us the song's number
    lea     st_digits, a0
    moveq   #(num_st_digits-1), d7 ; loop counter

;convert binary to BCD
@loop_BCD:    
    divu    #10, d6 ;d6 / 10
                    ;d6 = r(16), q(16)
                    
    swap    d6      ;d6 = q(16), r(16)
    lsl.w   #1, d7          ;word-align
    move.w  d6, (a0, d7.w)  ;save to RAM
    lsr.w   #1, d7          ;un-word-align
    
    move.w  #0, d6  ;clear remainder
    swap    d6      ;d6 = 0(16), q(16)
    dbf     d7, @loop_BCD

    ;M_save_SR
    ;M_disable_interrupts
    move.w  #tile_id_0, d0          ;
    moveq   #(num_st_digits-1), d7  ;loop counter
    moveq   #0, d6                  ;index
    
    SetVRAMWrite vram_addr_plane_a+((((sound_test_ypos+0)*vdp_plane_width)+sound_test_xpos+0)*size_word)
    
    ;in a1
    ;lea     plane_A_buffer_start+((((sound_test_ypos+0)*vdp_plane_width)+sound_test_xpos+0)*size_word), a1

@loop_write_number:
    move.w  (a0, d6), d1        ;d1 = digit
    add.w   d0, d1              ;d1 = tile number
    ;move.w  d1, (a1)+           ;write to plane a buffer
    move.w  d1, vdp_data
    addi.w  #size_word, d6
    dbf d7, @loop_write_number
 
    rts
;-------------------------
@display_fm_channel_data
    SetVRAMWrite vram_addr_plane_a+((((sound_test_ypos+5)*vdp_plane_width)+sound_test_xpos+0)*size_word)
    move.w  #tile_id_1, d0
    move.w  #tile_id_blank, d2
    
    move.w  #5, d7
    
    move.w  d2, vdp_data
@write_channel_numbers_FM:
    move.w  d2, vdp_data
    move.w  d2, vdp_data
    move.w  d2, vdp_data
    move.w  d0, vdp_data
    addi.w  #1, d0
    dbf     d7, @write_channel_numbers_FM

   
    SetVRAMWrite vram_addr_plane_a+((((sound_test_ypos+6)*vdp_plane_width)+sound_test_xpos+0)*size_word)
    move.w  #tile_id_s, vdp_data
    move.w  #tile_id_e, vdp_data
    move.w  #tile_id_q, vdp_data
    move.w  d2, vdp_data
    
    move.w  #5, d3              ;loop counter
    lea     ch_fm_1, a5
    move.w  #tile_id_0, d0
@write_sequence_indexes:
    clr.l   d6
    move.w  ch_sequence_idx(a5), d4
    move.l  ch_sequence_ptr(a5), a4
    
    move.b  (a4, d4), d6    ;d6 = current entry of seq table
    M_convert_to_BCD    d6, 2
    M_write_out_BCD_to_display 2
    
    ; move.b  (a4, d4), d6    ;d6 = current entry of seq table

    ; ror.l   #4, d6              ;get second nybble
    ; move.w  d6, d1              ;copy to d1
    
    ; add.w   d0, d1
    ; move.w  d1, vdp_data        ;write to screen
    
    ; rol.l   #4, d6
    ; andi.w  #0x0F, d6           ;get first nybble
    ; move.w  d6, d1              ;copy to d1
    
    ; add.w   d0, d1
    ; move.w  d1, vdp_data        ;write to screen
    
    
    move.w  d2, vdp_data
    move.w  d2, vdp_data
    adda.w  #fm_ch_size, a5
    dbf d3, @write_sequence_indexes
    
    
    ;M_restore_interrupt_level
    move.b  #1, st_flag_display_changed
    rts
    
    modend