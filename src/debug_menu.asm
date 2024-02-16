;debug_menu.asm


debug_menu_options  equ 3

    RSSET 0x00FF3000
empty                               rs.w    1
debug_space_num_words       rs.b    1
debug_scratch_space         rs.w    4

debug_menu_state        rs.w    1
debug_menu_v_offset     rs.w    1
    

;===================
    ;trashes a0, d7, input reg, and d1
M_buffer_as_hex: macro reg, num_digits
    lea     debug_scratch_space, a0
    move.b  #\num_digits, debug_space_num_words  ;save to memory
    move.w  #\num_digits-1, d7                   ;loop counter

@convert_loop\@:
    move.w  \reg, d1        ;copy to d1
    andi.w  #0x0F, d1       ;mask low nybble
    lsl.w   #1, d7          ;word-align index
    move.w  d1, (a0, d7.w) ;write to memory
    lsr.w   #1, d7          ;un-word-align

    lsr.w   #4, \reg
    dbf d7, @convert_loop\@
    endm

    ;trashes a0, d7, and input reg
M_buffer_as_BCD: macro reg, num_digits
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
M_write_buffer_to_display: macro num_digits
    lea     debug_scratch_space, a0
    move.w  #'0', d0          ;
    moveq   #\num_digits-1, d7  ;loop counter
    
    moveq   #0, d6                          ;index
@loop_write_number\@:
    move.w  (a0, d6.w), d1        ;d1 = digit
    add.w   d0, d1                 ;d1 = tile number
    cmpi.w  #'9', d1
    ble     @write_out\@
    ;else (num > '9'), move to uppercase range
    addi.w  #'A'-'9'-1, d1
    
@write_out\@:
    move.w  d1, vdp_data
    addi.w  #size_word, d6
    dbf d7, @loop_write_number\@
    endm

    
    
    
    module
    even

@state_table:
    dc.l    @init
    dc.l    @normal
    dc.l    @submenu
    dc.l    @cleanup

@menu_table:
    dc.l    sound_test_menu
    dc.l    controller_menu
    dc.l    tile_test_menu


clear_screen:
    move.w  0, d2
    SetVRAMWrite_xy vram_addr_plane_a, 0, 0
    move.w  #vdp_plane_height-1, d7
@clear_row:
    move.w  #vdp_plane_width-1, d6
@write_blank:    
    M_print_char 0
    dbf d6, @write_blank
    dbf d7, @clear_row
    rts
    
@init:
    lea Tile_ascii_start, a0
    jsr Copy_Tiles_to_VRAM

    jsr clear_screen
    
    move.w  #st_normal, debug_menu_state
    move.w  #0, d0
    rts
    
@normal:
    jsr @handle_input
    jsr @update_display
    move.w  #0, d0
    rts
        
@submenu:
    move.w  (debug_menu_v_offset), d0
    lea     @menu_table, a0
    adda.l  d0, a0
    movea.l (a0), a0
    jsr     (a0)
    
    tst.w   d0
    beq     @just_return
    ;else set state to init
    move.w  #st_init, debug_menu_state
@just_return:
    move.w  #0, d0
    rts
        
@cleanup:
    move.w  #0, debug_menu_v_offset
    move.w  #st_init, debug_menu_state
    move.w  #-1, d0
    rts
    
    
;   Debug menu
;
;   -   sound test
;   -   controller test
;   -   tile and palette test
;


@mark_submenu:
    move.w  #st_submenu, debug_menu_state
    rts

@update_display:
    SetVRAMWrite_xy vram_addr_plane_a, 1, 2
    M_print_string " Debug Menu"
    
    SetVRAMWrite_xy vram_addr_plane_a, 1, 4
    M_print_string " Sound Test"
    
    SetVRAMWrite_xy vram_addr_plane_a, 1, 5
    M_print_string " Controller Test"
    
    SetVRAMWrite_xy vram_addr_plane_a, 1, 6
    M_print_string " Tile Test"
    
    moveq   #0, d0  ;set plane a
    jsr set_cursor_plane
    
    moveq   #1, d1      ;x offset
    clr.l   d2          ;    
    move.w  (debug_menu_v_offset), d2
    lsr.w   #2, d2      ;byte-size from longword
    addi.w  #4, d2      ;add y offset
    move.w  #'*', d3    ;
    jsr print_char_at_xy
    
    rts

@handle_input:
    M_menu_handle_input empty,0,0, &
                        debug_menu_v_offset,(size_long*(debug_menu_options-1)),size_long, &
                        null, @mark_submenu, null, @mark_submenu

    rts

;main fn for debug main menu
debug_menu:
    move.w  debug_menu_state, d0
    lea     @state_table, a0
    adda.w  d0, a0
    movea.l (a0), a0
    jmp     (a0)
        
    modend