;debug_menu.asm

    RSSET 0x00FF3000

debug_menu_cursor   rs.b    1

;   Debug menu
;
;   -   sound test
;   -   controller test
;   -   tile and palette test
;


;main fn for debug main menu
debug_menu:
    
    rts