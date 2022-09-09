;tile_test.asm

tile_test_menu_state    rs.w    1

    module
    even


@state_table:
    dc.l    @init
    dc.l    @normal
    dc.l    @submenu
    dc.l    @cleanup
    
@init:
    jsr clear_screen
    
    ; Write the font glyph tiles to VRAM
	lea     Tiles_ctrl_char, a0    ; Move the address of the first graphics tile into a0
    jsr Copy_Tiles_to_VRAM
    
    lea test_palette, a0        ;
    jsr Copy_Palette_to_CRAM    ;copy test_palette to CRAM

    
    
    move.w  #st_normal, tile_test_menu_state
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
    ;move.w  #0, sound_test_song_offset
    move.w  #st_init, tile_test_menu_state
    move.w  #-1, d0
    rts
    
tile_test_menu:    
    move.w  tile_test_menu_state, d0
    lea     @state_table, a0
    adda.w  d0, a0
    movea.l (a0), a0
    jmp     (a0)


@handle_input:
    M_menu_handle_input empty, 0, 1, &
                        empty, 0, 1, &
                        null, null, @exit_submenu, null
    rts
    
@update_display:
    moveq   #0, d0  ;plane a
    jsr set_cursor_plane
    
    moveq   #0, d5      ;counter
    move.w  #128, d7    ;total tiles to print
    
    
    move.l  #0, d2  ;y
@loop_all_tiles:
    move.l  #1, d1  ;x
    addi.l  #1, d2  ;y
    
    jsr set_cursor_to_xy
    move.w  #7, d6
@loop_one_row:
    M_print_char    d5
    
    addi.w  #1, d5
    dbf d6, @loop_one_row

    cmp.w   d5, d7
    bne @loop_all_tiles
    
    rts

@exit_submenu:
    move.w  #st_cleanup, tile_test_menu_state
    rts
    modend