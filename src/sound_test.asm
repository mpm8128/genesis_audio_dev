;sound test

    RSSET   0xFF0010
st_offset   rs.w    1
st_flag_display_changed     rs.b    1

module

    even
sound_test_menu:    
    jsr @handle_input
    tst.w   (st_flag_display_changed)
    bne @update_display
    rts
     
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

    clr.l   d6
    move.w  (st_offset), d6
    lsr.w   #3, d6
    lea     st_digits, a0
    moveq   #(num_st_digits-1), d7  ;loop counter for 3 digits

;convert binary to BCD
@loop_BCD:    
    divu.w  #10, d6 ;d6 / 10
                    ;d6 = r(16), q(16)
    swap    d6      ;d6 = r(16), q(16)
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
    
    
    ;M_restore_interrupt_level
    clr.b   st_flag_display_changed
    rts
    
endmodule