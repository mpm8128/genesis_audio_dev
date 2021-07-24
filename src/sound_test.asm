;sound test

    RSSET   0xFF0010
st_offset   rs.w    1


module

    even
sound_test_menu:    
    jsr @handle_input
    jsr @update_display
    rts
     
;==================================== 
; handle input
;       SACB RLDU 
;====================================
@handle_input:
    move.b  (p1_buttons_pressed), d7
    or.b    (p2_buttons_pressed), d7
    
    move.w  (st_offset), d0
    move.w  #(num_songs-8), d2
    
; @check_up:
    ; btst    0x0, d7
    ; beq     @check_down:
; @check_down:
    ; btst    0x1, d7
    ; beq     @check_left:
@check_left:
    btst    #2, d7
    beq     @check_right
    ;handle left
    subi.w  #8, d0     ;decrement offset
    bpl     @song_selected
    moveq   #0, d0     ;clip to 0
    
@check_right:
    btst    #3, d7
    beq     @song_selected
    ;handle right
    addi.w  #8, d0      ;increment offset
    cmp.w   d2, d0      ;d6 - num_songs
    ble     @song_selected
    move.w  d2, d0      ;clip to num_songs
    
@song_selected:    
    move.w  d0, (st_offset)
    
;@check_start
    ; btst    0x7, d7
;@check_a:
    btst    #6, d7
    bne     @play_song
;@check_b
    btst    #4, d7
    bne     @play_silence
;@check_c
    btst    #5, d7
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
@update_display:
    rts
    
endmodule