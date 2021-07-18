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
    
    
    
    
    
    
    
    
    