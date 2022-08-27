;tile_printing.asm

    module
    RSSET   0x00FF2000
    
cursor_plane    rs.w    1

;for reference    
;cursor_x        rs.w    1
;cursor_y        rs.w    1
    
    even

;==============================
;   set_cursor_plane(d0.b)
;    
;   d0.b - accepts 0 or 1
;       0 - plane a
;       1 - plane b
;==============================
set_cursor_plane:
    tst.b   d0
    bne     @plane_b
    ;else @plane_a
    move.w  #vram_addr_plane_a, cursor_plane
    rts
@plane_b:
    move.w  #vram_addr_plane_b, cursor_plane
    rts
    
    
;trashes d0
;x in d1.1
;y in d2.1
set_cursor_to_xy:
    ;d0 - output command to vdp
    move.l  #vdp_cmd_vram_write, d0
    
    ;calculate VRAM address
    lsl.l   #6, d2  ;addr = y<<6
    add.l   d1, d2  ;addr = (y<<6) + x
    lsl.l   #1, d2  ;addr = ((y<<6)+x)<<1
    clr.l   d1    
    move.w  cursor_plane, d1
    add.l   d1, d2  ;addr = (plane addr) + ((y<<6)+x)<<1
    
    ;copy addr to d1
    move.l  d2, d1  
    
    ;load low bits of plane into d0
    andi.w  #0x3FFF, d1
    swap    d1      ; d1 << 16    
    or.l    d1, d0
    
    ;load high bits of plane into d0
    andi.w  #0xE000, d2
    lsr.l   #7, d2  ;have to do this twice because
    lsr.l   #7, d2  ;maximum shift is 8
    or.l    d2, d0
    
    ;write to vdp
    move.l  d0, vdp_control
    rts

;prints at cursor
M_print_char: macro char
    move.w  \char, vdp_data
    endm
    
    ;d1 - x
    ;d2 - y
    ;d3 - char
print_char_at_xy:
    jsr set_cursor_to_xy
    M_print_char d3
    rts

;trashes a0, d0, d1
;string in a1
;prints at cursor
M_print_string: macro string
idx = 0
    rept    strlen(\string)
cc  substr  idx+1, idx+1, \string
    M_print_char #'\cc'
idx = idx+1
    endr
    
    endm
    
    
;trashes a0, d0, d1
;string in a1
;x in d2
;y in d3
print_string_at_xy:
    jsr set_cursor_to_xy

    rts
    
    modend