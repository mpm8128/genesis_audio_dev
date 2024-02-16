;tile_test.asm

tile_test_menu_state            rs.w    1
tile_test_tileset_table_offset  rs.w    1
tile_test_old_offset			rs.w	1

palette_test_which_palette      rs.w    1
palette_test_old_palette		rs.w	1


tile_test_tile_set      rs.l    1

test_palette_0      rs.w    16
test_palette_1      rs.w    16
test_palette_2      rs.w    16
test_palette_3      rs.w    16


    module
    even
    
num_tilesets    equ     (@tileset_table_end-@tileset_table)/size_long

@tileset_table:
	dc.l    garbage_tiles
    dc.l    Tile_ascii_start
@tileset_table_end

;=========================================================
;       tile_test_menu
;
;	entry point to this module
;
;=========================================================
tile_test_menu:    
    move.w  tile_test_menu_state, d0
    lea     @state_table, a0
    adda.w  d0, a0
    movea.l (a0), a0
    jmp     (a0)

@state_table:
    dc.l    @init
    dc.l    @normal
    dc.l    @submenu
    dc.l    @cleanup

;=========================================================
;
;	@init
;		loads some tiles to VRAM (does it need to?)
;		then clears the screen
;
;		then sets up the menus and sets the menu state to "normal"
;
;=========================================================  
@init:
    ; Write the font glyph tiles to VRAM
    ;move.l  Tile_ascii_start, tile_test_tile_set
    
    jsr clear_screen

    move.w  #0, tile_test_tileset_table_offset
    move.w  #-1, tile_test_old_offset
    move.w  #0, palette_test_which_palette
    move.w  #-1, palette_test_old_palette
	move.w  #st_normal, tile_test_menu_state
    move.w  #0, d0	;return 0
    rts
    
;=========================================================
;	@normal
;		normal operation of this menu
;=========================================================
@normal:
    jsr @handle_input

	;check if something changed (do we need to clear the screen?)
	move.w (tile_test_tileset_table_offset), d0
	cmp.w  (tile_test_old_offset), d0
	bne		@need_to_clear_screen
	
	move.w (palette_test_which_palette), d0
	cmp.w  (palette_test_old_palette), d0
	beq		@no_changes
	
	@need_to_clear_screen:	;something changed, so we clear the screen
	jsr clear_screen
	
	;mark the current palette and tileset in memory so we don't have to clear the screen
	move.w (tile_test_tileset_table_offset), (tile_test_old_offset)
	move.w (palette_test_which_palette), (palette_test_old_palette)

    jsr @update_display
	
	@no_changes:
    move.w  #0, d0	;return 0
    rts
    
;=========================================================
@submenu:
    ;no submenus here, just return 0
    move.w  #0, d0
    rts
	
;=========================================================
;	@exit_submenu
;		we've received a command to exit this menu
;=========================================================
@exit_submenu:
    move.w  #st_cleanup, tile_test_menu_state
    rts
	
;=========================================================
;	@cleanup
;		we're leaving this menu, so clear the screen and
;		re-set the state to the initial state so we can
;		re-init if we come back here.
;=========================================================
@cleanup:
    jsr clear_screen
    move.w  #st_init, tile_test_menu_state
    move.w  #-1, d0	;return -1, indicate we're backing out
    rts

;=========================================================
;	@handle_input
;		uses a macro to control the menu
;=========================================================
@handle_input:
	;					h_offset						h_max			h_size
    ;					v_offset						v_max			v_size
	;Callbacks			start	a		b 				c
	M_menu_handle_input tile_test_tileset_table_offset, ((num_tilesets-1)*size_long), size_long, &
						empty, 							0, 				1, &
                        null, 	null, 	@exit_submenu, 	null
    rts

;=========================================================
;	@update_display
;=========================================================
@update_display:	
    ;set tile plane (a)
    moveq   #0, d0      	;plane a
    jsr set_cursor_plane
    
	;dynamically load palette
    lea test_palette, a0        ;
    jsr Copy_Palette_to_CRAM    ;

	;dynamically load tileset
    lea @tileset_table, a0		;
    move.w  (tile_test_tileset_table_offset), d0
    ext.l   d0					;
    adda.l  d0, a0				;
    movea.l (a0), a0    ;pointer to tileset to use this frame
    
    movea.l a0, a1
    adda.l  #-2, a1     ;a1 = pointer to number of tiles
    move.w  (a1), d0    ;d0 = number of tiles
	jsr @load_tileset	;trashes d0
    
    ;copy tiles to the display
	move.w  (a1), d7    ;d7 = number of tiles    
	move.w 	#0, d5		;d5 = tile index
	move.l  #0, d2      ;d2 = y coord on screen
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

;=========================================================
;       @load_tileset
;   a0  - pointer to tiles
;   d0  - number of tiles to load
;
;=========================================================
@load_tileset:
    SetVRAMWrite 0x0000
	lsl.w   #3, d0  ;8x - size of each tile
    subi.w  #1, d0  ;set up d0 as a loop counter
@loop:
	move.l (a0)+, vdp_data
	dbf d0, @loop
    rts
	
	modend
