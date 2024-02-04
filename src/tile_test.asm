;tile_test.asm

tile_test_menu_state            rs.w    1
tile_test_tileset_table_offset  rs.w    1
palette_test_which_palette      rs.w    1

tile_test_tile_set      rs.l    1

test_palette_0      rs.w    16
test_palette_1      rs.w    16
test_palette_2      rs.w    16
test_palette_3      rs.w    16


    module
    even
    
;=========================================================
;       @load_tileset
;   a0  - pointer to tiles
;   d0  - number of tiles to load
;
;=========================================================
@load_tileset:
    SetVRAMWrite 0x0080
    move.l  #0x40800000, vdp_control
	lsl.w   #3, d0  ;8x - size of each tile
    subi.w  #1, d0  ;set up d0 as a loop counter
@loop:
	move.l (a0)+, vdp_data
	dbf d0, @loop
    rts

;
num_tilesets    equ     (@tileset_table_end-@tileset_table)

@tileset_table:
    dc.l    garbage_tiles
    dc.l    Tile_ascii_start
@tileset_table_end


@state_table:
    dc.l    @init
    dc.l    @normal
    dc.l    @submenu
    dc.l    @cleanup
    
@init:
    ; Write the font glyph tiles to VRAM
    move.l  Tile_ascii_start, tile_test_tile_set
    move.w  #0, palette_test_which_palette
    
    
	lea Tile_ascii_start, a0
    jsr Copy_Tiles_to_VRAM
    
    lea test_palette, a0        ;
    jsr Copy_Palette_to_CRAM    ;copy test_palette to CRAM

    
    jsr clear_screen


    
    move.w  #0, tile_test_tileset_table_offset
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
    jsr clear_screen
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
    M_menu_handle_input tile_test_tileset_table_offset, num_tilesets, size_long, &
                        empty, 0, 1, &
                        null, null, @exit_submenu, null
    rts
    
@update_display:
    ;dynamically load tileset
    lea @tileset_table, a0
    move.w  (tile_test_tileset_table_offset), d0
    ext.l   d0
    adda.l  d0, a0
    movea.l (a0), a0    ;pointer to tileset
    
    movea.l a0, a1
    adda.l  #-2, a1     ;a1 = pointer to number of tiles
    move.w  (a1), d0    ;number of tiles
    jsr @load_tileset
    
    ;dynamically load palette
    lea test_palette, a0        ;
    jsr Copy_Palette_to_CRAM    ;copy test_palette to CRAM

    ;set tile plane (a)
    moveq   #0, d0      ;plane a
    jsr set_cursor_plane
    
    ;copy tiles to the display
    move.w   (Tile_ascii_num), d5   ;d5 = tile number to print
    move.w  (a1), d7                ;number of tiles
    add.w   d5, d7                  ;d7 = target number to break out of the outer loop

    move.l  #0, d2      ;initialize y
@loop_all_tiles:        ;at the start of each line: 
    move.l  #1, d1      ;   reset x to 1
    addi.l  #1, d2      ;   increment y
    jsr set_cursor_to_xy
    move.w  #7, d6      ;d6 = inner loop counter
@loop_one_row:
    M_print_char    d5  ;print current tile
    addi.w  #1, d5      ;increment "current tile"
    cmp.w   d5, d7      ;break when we reach the correct number of tiles
    beq @loop_exit
    dbf d6, @loop_one_row   ;otherwise keep printing

    ;dbf d7, @loop_all_tiles
    cmp.w   d5, d7      ;break when we reach the correct number of tiles
    bne @loop_all_tiles     ;otherwise keep printing
@loop_exit:
    
    rts

@exit_submenu:
    move.w  #st_cleanup, tile_test_menu_state
    rts
    modend