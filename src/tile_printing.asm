;print tiles
plane_A_buffer_start    equ     0xFFFFC000
plane_A_buffer_size_b   equ     0x2000
plane_A_buffer_size_w   equ     (plane_A_buffer_size_b/size_word)
plane_A_buffer_size_l   equ     (plane_A_buffer_size_b/size_long)

    even
DMA_plane_A:
    ;;save SR
    ;;disable interrupts
    lea     vdp_control, a1
    
    ;---------
    ;enable DMA
    lea     VDPRegisters, a0
    move.b  $0(a0), d0
    bset.l  #4, d0
    move.w  d0, (a1)
    
    ;---------------------------
    ;Set VDP auto-increment to 2
    move.w  #0x8F02, (a1)
    
    ;---------------
    ;Set DMA length == 0x20 00
    move.w  #0x9300, (a1)   ;low byte
    move.w  #0x9401, (a1)   ;high byte
    
    ;----------------------
    ;Set DMA source address == 0xFF C0 00
    move.w  #0x9500, (a1)   ;low byte
    move.w  #0x96E0, (a1)   ;middle byte
    move.w  #0x977F, (a1)   ;high byte
    
    ;------------------------
    ;Set destination address = 0xC000
    SetVRAMDMA 0xC000
    
    ;-----------
    ;disable DMA
    bclr.l  #4, d0
    move.w  d0, (a1)

    ;;restore SR
    rts








; Write_Tile:
    ; rts

; ;================================================
; ;   Plane A Write Tile
; ;       - Writes a tile to Plane A, following the
; ;           last tile written
; ;    
; ;Parameters:
; ;   -   d0: tilenum
; ;   -   d1: flags
; ;================================================
; PlaneA_Write_Tile:
    
    ; rts
    
; PlaneB_Write_Tile:
    ; rts
    
; ;Sprite_Write_Tile:
; ;    rts