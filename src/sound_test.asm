;sound test


    RSSET   0xFF0010
sound_test_song_offset              rs.w    1
sound_test_flag_display_changed     rs.b    1
sound_test_menu_state               rs.w    1

sound_test_channel_picker           rs.w    1


    module
    even
    
@state_table:
    dc.l    @init
    dc.l    @normal
    dc.l    @submenu
    dc.l    @cleanup
    
@init:
    jsr clear_screen
    move.w  #st_normal, sound_test_menu_state
    move.w  #0, d0
    rts
    
@normal:
    jsr @handle_input
    jsr @update_display
    move.w  #0, d0
    rts
    
@submenu:
    ;
    move.w  #0, d0
    rts
    
@cleanup:
    move.w  #0, sound_test_song_offset
    move.w  #st_init, sound_test_menu_state
    move.w  #-1, d0
    rts
    
sound_test_menu:    
    move.w  sound_test_menu_state, d0
    lea     @state_table, a0
    adda.w  d0, a0
    movea.l (a0), a0
    jmp     (a0)
             
             
             
             
M_mark_display_changed: macro
    move.b  #1, sound_test_flag_display_changed
    endm




;==================================== 
; handle input
;       SACB RLDU 
;====================================
@handle_input:
    M_menu_handle_input sound_test_song_offset, (num_songs-song_record_size_bytes), song_record_size_bytes, &
                        sound_test_channel_picker, 0, 1, &
                        @exit_submenu, @play_song, @play_silence, @play_song
    rts

 
@exit_submenu:
    move.w  #st_cleanup, sound_test_menu_state
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
    jsr @display_table_header
    jsr @display_fm_channel_data
    jsr @display_psg_channel_data

    rts
    
;--------------------------
@display_song_number
    clr.l   d6
    move.w  (sound_test_song_offset), d6     ;d6 = song table offset

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

    move.w  #'0', d0          ;
    moveq   #(num_st_digits-1), d7  ;loop counter
    moveq   #0, d6                  ;index
        
    SetVRAMWrite_xy vram_addr_plane_a, 0, 0

@loop_write_number:
    move.w  (a0, d6), d1        ;d1 = digit
    add.w   d0, d1              ;d1 = tile number
    move.w  d1, vdp_data
    addi.w  #size_word, d6
    dbf d7, @loop_write_number
 
    rts
    
@display_table_header:   
    SetVRAMWrite_xy vram_addr_plane_a, 0, 4
    M_print_string "chan seq fq note oct wt "
    rts
    
    
;-------------------------
@display_psg_channel_data:
    move.w  #'0', d0
    move.w  #' ', d2
    move.w  d0, d3
    lea     ch_psg_0, a5
    
    moveq  #3, d5   ;loop counter
    @loop_each_psg_channel:
    jsr     @display_single_psg_channel
    adda.w  #psg_ch_size, a5
    dbf d5, @loop_each_psg_channel
    rts

@display_single_psg_channel:
    ;Write "PSG# "
    M_print_string "psg"
    addq    #1, d3
    move.w  d3, vdp_data
    move.w  d2, vdp_data

    jmp @display_single_channel_common

    
@display_fm_channel_data:
    move.w  #'0', d0
    move.w  #' ', d2
    move.w  d0, d3
    lea     ch_fm_1, a5
    
    SetVRAMWrite_xy vram_addr_plane_a, 0, 5
    
    moveq  #5, d5   ;loop counter
    @loop_each_fm_channel:
    jsr     @display_single_fm_channel
    adda.w  #fm_ch_size, a5
    dbf d5, @loop_each_fm_channel
    rts

@display_single_fm_channel:
    
    ;Write "FM#  "
    M_print_string "FM"
    addq    #1, d3
    move.w  d3, vdp_data
    move.w  d2, vdp_data
    move.w  d2, vdp_data

@display_single_channel_common:
    ;Write seqeuence index
    clr.l   d6
    move.w  ch_sequence_idx(a5), d4
    move.l  ch_sequence_ptr(a5), a4
    move.b  (a4, d4), d6    ;d6 = current entry of seq table
    M_buffer_as_BCD    d6, 2
    M_write_buffer_to_display 2
    move.w  d2, vdp_data
    move.w  d2, vdp_data

    ;write freq reg:
    clr.l   d6
    move.w  ch_adj_freq(a5), d6
    M_buffer_as_hex         d6, 3
    M_write_buffer_to_display   3
    move.w  d2, vdp_data
    
    ;write note number:
    clr.l   d6
    move.b  ch_note_name(a5), d6
    M_buffer_as_BCD         d6, 2
    M_write_buffer_to_display   2
    move.w  d2, vdp_data
    move.w  d2, vdp_data

    ;write octave:
    clr.l   d6
    move.b  ch_note_octave(a5), d6
    M_buffer_as_BCD         d6, 2
    M_write_buffer_to_display   2
    move.w  d2, vdp_data
    move.w  d2, vdp_data

    ;write wait time
    clr.l   d6
    move.b  ch_wait_time(a5), d6
    M_buffer_as_hex         d6, 2
    M_write_buffer_to_display   2
    move.w  d2, vdp_data

    ;fill empty space
    move.w  #(15-1), d7
    @loop_empty_space1:
    move.w  d2, vdp_data
    dbf d7, @loop_empty_space1
    
    ;mark the last visible tile
    move.w  d0, vdp_data
    
    ;fill up the overscan
    move.w  #(24-1), d7
    @loop_empty_space2:
    move.w  d2, vdp_data
    dbf d7, @loop_empty_space2
    
    ;add an extra line
    move.w  #(64-1), d7
    @loop_empty_space3:
    move.w  d2, vdp_data
    dbf d7, @loop_empty_space3
    rts
    
    modend