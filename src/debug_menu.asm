;debug_menu.asm


    RSSET 0x00FF3000
    
debug_menu_state        rs.w    1
debug_menu_v_offset     rs.w    1
    
    module
    even

@state_table:
    dc.l    @init
    dc.l    @normal
    dc.l    @submenu
    dc.l    @cleanup

@menu_table:
    dc.l    sound_test_menu
    dc.l    DEBUG_controller


clear_screen:
    move.w  ' ', d2
    SetVRAMWrite_xy vram_addr_plane_a, 0, 0
    move.w  #vdp_plane_height-1, d7
@clear_row:
    move.w  #vdp_plane_width-1, d6
@write_blank:    
    M_print_char ' '
    dbf d6, @write_blank
    dbf d7, @clear_row
    rts
    
@init:
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
    ;else set state to cleanup
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
    
    ;SetVRAMWrite_xy vram_addr_plane_a, 2, 6
    ;M_print_string "Palette Test"
    
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
                        debug_menu_v_offset,(size_long*(2-1)),size_long, &
                        null,@mark_submenu,null,@mark_submenu

    rts

;main fn for debug main menu
debug_menu:
    move.w  debug_menu_state, d0
    lea     @state_table, a0
    adda.w  d0, a0
    movea.l (a0), a0
    jmp     (a0)
        
    modend