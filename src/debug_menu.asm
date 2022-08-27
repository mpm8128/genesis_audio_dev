;debug_menu.asm

    RSSET 0x00FF3000
    
    module
    even
debug_menu_cursor   rs.b    1

;   Debug menu
;
;   -   sound test
;   -   controller test
;   -   tile and palette test
;

@handle_input:
    M_menu_handle_input 0,0,0, &
                        0,0,0, &
                        0,0,0,0

    rts

;main fn for debug main menu
debug_menu:
    ;jsr @handle_submenus ;?
    jsr @handle_input
    ;jsr @update_display
    
    rts
    
    modend