;controller_driver.asm
;================================================
;   Memory Map
;================================================
    RSSET   0xFF0000

p1_buttons_held         rs.b    1
p1_buttons_pressed      rs.b    1
p1_buttons_released     rs.b    1

p2_buttons_held         rs.b    1
p2_buttons_pressed      rs.b    1
p2_buttons_released     rs.b    1

;================================================
;   Parallel ports
;================================================
pad1_data   equ $A10003
pad2_data   equ $A10005
;pad3_data   equ $A10006

pad1_ctrl   equ $A10009
pad2_ctrl   equ $A1000B
;pad3_ctrl   equ $A1000D

;================================================
;   Serial ports
;================================================
; pad1_s_tx   equ $A1000F
; pad1_s_rx   equ $A10011
; pad1_s_ct   equ $A10013

; pad2_s_tx   equ $A10015
; pad2_s_rx   equ $A10017
; pad2_s_ct   equ $A10019

; pad3_s_tx   equ $A1000B
; pad3_s_rx   equ $A1001D
; pad3_s_ct   equ $A1001F


    even
;================================================
;   Get Controller Inputs
;       - reads from both controllers
;================================================
get_controller_inputs:
    lea pad1_ctrl, a0
    lea pad1_data, a1
    lea p1_buttons_held, a2
    jsr read_single_controller      
    
    lea pad2_ctrl, a0
    lea pad2_data, a1
    lea p2_buttons_held, a2
    jsr read_single_controller
    rts
    
;================================================
;   Read Single Controller
;   - reads input from a single controller
;       and saves buttons held/pressed/released
;       to RAM
;
;   https://wiki.megadrive.org/index.php?title=Reading_MD3_Joypad
;
;Parameters:
;   - a0: control port 
;   - a1: data port
;   - a2: pX_buttons_held
;
;Returns:
;   - d0.b = S | A | C | B | R | L | D | U 
;================================================
read_single_controller:
    ;clear working registers
    moveq   #0, d0
    moveq   #0, d1
    moveq   #0, d2
    moveq   #0, d3
    
    ;--------------------
    ;read from controller
    
    ;get first half
    move.b  #0x40, (a0)         ;request read
    move.b  #0x40, (a1)         ;TH = 1
    nop                         ;cycle counting
    nop                         
    move.b  (a1), d0            ;d0.b = X | 1 | C | B | R | L | D | U
    andi.b  #0x3F, d0           ;d0.b = 0 | 0 | C | B | R | L | D | U

    ;get second half
    move.b  #0x00, (a1)         ;TH = 0
    nop                         ;cycle counting
    nop
    move.b  (a1), d1            ;d1.b = X | 0 | S | A | 0 | 0 | D | U 
    andi.b  #0x30, d1           ;d1.b = 0 | 0 | S | A | 0 | 0 | 0 | 0 
    
    ;combine the two halves in d0
    lsl.b   #2, d1              ;d1.b = S | A | 0 | 0 | 0 | 0 | 0 | 0
    or.b    d1, d0              ;d0.b = S | A | C | B | R | L | D | U
    
    ;----------------------------------
    ;Determine buttons pressed/released
    
    ;d0 = inputs this frame
    not.b   d0          ;invert d0 so everything makes sense
    
    move.b  (a2), d1    ;d1 = inputs last frame
    
    move.b  d1, d2  ;d2 = (this frame) XOR (last frame)
    eor.b   d0, d2  ;d2 = inputs that changed between frames
    move.b  d2, d3  ;d3 = copy of d2
    
    ;d2 = buttons pressed this frame
    and.b   d0, d2  ;d2 = (true this frame) AND (different from last frame)
    
    ;d3 = buttons released this frame
    and.b   d1, d3  ;d3 = (true last frame) AND (different from last frame)
    
    ;---------------------------------
    ;Write to controller RAM and return
    
    move.b  d0, $0(a2)  ;held
    move.b  d2, $1(a2)  ;pressed
    move.b  d3, $2(a2)  ;released

    rts
    
    
;================================================
;   Debug Controller
;S | A | C | B | R | L | D | U
;================================================
DEBUG_ctrl_1_xpos   equ     0x04
DEBUG_ctrl_2_xpos   equ     0x14
DEBUG_ctrl_ypos     equ     0x04

    even
DEBUG_ctrl_string:
    dc.w    's',  'a',  'c',  'b'
    dc.w    'r',  'l',  'd',  'u'

DEBUG_controller:
    ;----------------
    ;DEBUG controller init
    
    lea test_palette, a0        ;
    jsr Copy_Palette_to_CRAM    ;copy test_palette to CRAM
    
	; Write the font glyph tiles to VRAM
	lea     TileBlank, a0    ; Move the address of the first graphics tile into a0
    jsr Copy_Tiles_to_VRAM
    
    ;get ready to write to vdp
    lea     DEBUG_ctrl_string, a0   ;a0 = string start
    
    ;p1 held
    SetVRAMWrite vram_addr_plane_a+((((DEBUG_ctrl_ypos+0)*vdp_plane_width)+DEBUG_ctrl_1_xpos)*size_word)
    lea p1_buttons_held, a1
    jsr DEBUG_controller_output_loop
    
    ;p1 pressed
    SetVRAMWrite vram_addr_plane_a+((((DEBUG_ctrl_ypos+1)*vdp_plane_width)+DEBUG_ctrl_1_xpos)*size_word)
    lea p1_buttons_pressed, a1
    jsr DEBUG_controller_output_loop
    
    ;p1 released
    SetVRAMWrite vram_addr_plane_a+((((DEBUG_ctrl_ypos+2)*vdp_plane_width)+DEBUG_ctrl_1_xpos)*size_word)
    lea p1_buttons_released, a1
    jsr DEBUG_controller_output_loop

    ;p2 held
    SetVRAMWrite vram_addr_plane_a+((((DEBUG_ctrl_ypos+0)*vdp_plane_width)+DEBUG_ctrl_2_xpos)*size_word)
    lea p2_buttons_held, a1
    jsr DEBUG_controller_output_loop
    
    ;p2 pressed
    SetVRAMWrite vram_addr_plane_a+((((DEBUG_ctrl_ypos+1)*vdp_plane_width)+DEBUG_ctrl_2_xpos)*size_word)
    lea p2_buttons_pressed, a1
    jsr DEBUG_controller_output_loop
    
    ;p2 released
    SetVRAMWrite vram_addr_plane_a+((((DEBUG_ctrl_ypos+2)*vdp_plane_width)+DEBUG_ctrl_2_xpos)*size_word)
    lea p2_buttons_released, a1
    jsr DEBUG_controller_output_loop

    rts
    
;expects address of button data in a1
DEBUG_controller_output_loop:
    ;-----------
    ;check bits
    moveq   #7, d7                  ;loop counter, pre-decremented
    move.b  (a1), d0   ;d0 = held buttons
    
    
@loop_top:
    btst    #0, d0                  ;check LSB of held buttons
    beq @write_nothing              ;if bit == 0, write a blank tile
                                    ;   else write tile in string
    lsl.w   #1, d7                  ;word-align index
    move.w  (a0, d7.w), vdp_data    ;write a0[d7] to vdp
    lsr.w   #1, d7                  ;un-word-align counter
    bra @loop_continue
    
@write_nothing:
    move.w  #' ', vdp_data    ;write blank to vdp
    ;M_Write_Tile 0, 0, 0, 0, 'b'lank
    
@loop_continue:
    lsr.b   #1, d0                  ;shift to next bit
    dbf d7, @loop_top               ;repeat
    
    rts
    
    
    
    
    
    
    