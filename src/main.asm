    include 'vector_table.asm'
    include 'header.asm'
    
    ;include 'defines.asm'

flag_DEBUG equ 0

;==============================================================
; VRAM WRITE MACROS
;==============================================================
; Some utility macros to help generate addresses and commands for
; writing data to video memory, since they're tricky (and
; error prone) to calculate manually.
; The resulting command and address is written to the VDP's
; control port, ready to accept data in the data port.
;==============================================================
	
; Set the VRAM (video RAM) address to write to next
SetVRAMWrite: macro addr
	move.l  #(vdp_cmd_vram_write)|((\addr)&$3FFF)<<16|(\addr)>>14, vdp_control
	endm

SetVRAMWrite_xy: macro plane, x, y
addr = ((\plane)+((((\y)*vdp_plane_width)+(\x))*size_word))

    move.l  #(vdp_cmd_vram_write)|((addr)&$3FFF)<<16|(addr)>>14, vdp_control
    endm

SetVRAMDMA: macro addr
	move.l  #(vdp_cmd_vram_dma)|((\addr)&$3FFF)<<16|(\addr)>>14, vdp_control
	endm

; Set the CRAM (colour RAM) address to write to next
SetCRAMWrite: macro addr
	move.l  #(vdp_cmd_cram_write)|((\addr)&$3FFF)<<16|(\addr)>>14, vdp_control
	endm
	
; Set the VSRAM (vertical scroll RAM) address to write to next
SetVSRAMWrite: macro addr
	move.l  #(vdp_cmd_vsram_write)|((\addr)&$3FFF)<<16|(\addr)>>14, vdp_control
	endm

M_Write_Tile: macro layer, palette, hflip, vflip, tilenum
    move.w  #((((\layer)&$1)<<15)|(((\palette)&$3)<<13)|(((\hflip)&$1)<<12)|(((\vflip)&$1)<<11)|((\tilenum)&$7FF)), vdp_data
    endm

M_enable_interrupts: macro
    move.w  #0x2300, sr
    endm

M_disable_interrupts: macro
    move.w  #0x2700, sr 
    endm
    
;==============================================================
; CODE ENTRY POINT
;==============================================================
code_start:
    M_disable_interrupts    
    jsr setup_poweron       ;do setup
    
    jsr demo_init           ;initialize demo code

@loop_forever
    M_enable_interrupts    
    jmp @loop_forever       ;loop forever
    
;==============================================================
;   Power-on Setup subroutine  
;==============================================================
setup_poweron:
	jsr     VDP_WriteTMSS       ; Write the TMSS signature (for hardware rev 1+ Mega Drive)
	jsr     VDP_LoadRegisters   ; Load the initial VDP registers
	;jsr    PAD_InitPads        ; Initialise gamepads
	jsr     PSG_Init            ; Initialise the PSG (mutes all channels)
    jsr     clear_vram          ;zero'es out VRAM
    jsr     init_z80
    rts  

;==============================================================
;   init z80
;==============================================================
Z80_RAM_start   equ $00A00000
Z80_bus_req     equ $00A11100
Z80_reset       equ $00A11200
;Z80_driver_length equ 0x187A
Z80_driver_length equ z80_driver_end-z80_driver_start
;Z80_driver_length equ 0

init_z80:
    move.w  #$0,   (Z80_reset)      ;reset the z80    
    move.w  #$100, (Z80_bus_req)    ;get the z80 bus
    move.w  #$100, (Z80_reset)      ;release the reset line
    
    ;copy z80 code to the z80
    LEA     Z80_RAM_start, a0
    LEA     z80_driver_start, a1      ;a0 = pointer to z80 code on ROM
    move.w  #Z80_driver_length-1, d7
@loop_copy_to_z80:
    move.b  (a1)+, (a0)+
    dbf     d7, @loop_copy_to_z80
    
    move.w  #$0, (Z80_reset)        ;assert reset again
    ;cycle count
    move.w  0x200, d7                ;wait for z80 to be ready
@cycle_count:
    dbf     d7, @cycle_count
    
    move.w  #$100,  (Z80_reset)      ;release reset    
    move.w  #$0,    (Z80_bus_req)    ;release bus    
    rts

;============================================================================
;   Z80 driver
;============================================================================
    even
z80_driver_start:
    incbin  '../build/pcm_driver.cim'
z80_driver_end:
    even
  
;==============================================================
;   Demo initialization
;==============================================================
demo_init:
    lea test_palette, a0        ;
    jsr Copy_Palette_to_CRAM    ;copy test_palette to CRAM
    
	; Write the font glyph tiles to VRAM
	lea     Tiles_ctrl_char, a0    ; Move the address of the first graphics tile into a0
    jsr Copy_Tiles_to_VRAM
    
    ;init sound test
    ;move.b  #1, st_flag_display_changed
    ;move.w  2, debug
    
    rts
    
    
;==============================================================
; INTERRUPT ROUTINES
;==============================================================

; Vertical interrupt - run once per frame (50hz in PAL, 60hz in NTSC)
    even
INT_VInterrupt:
    M_disable_interrupts
    
    addi.l  #1, frame_counter
    jsr get_controller_inputs
    
    jsr debug_menu
    
    jsr audio_driver
        
    M_enable_interrupts
    rte

; Horizontal interrupt - run once per N scanlines (N = specified in VDP register 0xA)
INT_HInterrupt:
	; Doesn't do anything in this demo
	rte

Int_Bus_Error:
	stop #0x2700
	rte
	
Int_Addr_Error:
	stop #0x2700
	rte

Int_Illegal_Inst:
	stop #0x2700
	rte
	
Int_Div_Zero:
	stop #0x2700
	rte

; Exception interrupt - called if an error has occured
CPU_Exception:
	; Just halt the CPU if an error occurred
	stop   #0x2700
    rte
	
; NULL interrupt - for interrupts we don't care about
INT_Null:
	rte
    
    include 'defs.asm'
    include 'tiles/ascii_tiles.asm'
    include 'tiles/garbage_tiles.asm'
    include 'mem_map.asm'

;==============================================================
;   Copy_Tiles_to_VRAM
;parameters:    a0 - pointer to tiles   
;   copies tiles in A0 to vram
;==============================================================
Copy_Tiles_to_VRAM:
    SetVRAMWrite vram_addr_tiles
	move.w #(size_tile_l*tile_count)-1, d0		; Loop counter = 8 longwords per tile * num tiles (-1 for DBRA loop)
@loop:
	move.l (a0)+, vdp_data			; Write tile line (4 bytes per line), and post-increment address
	dbf d0, @loop	                ; Decrement d0 and loop until finished (when d0 reaches -1)
    rts
    
;==============================================================
;   Copy_Palette_to_CRAM
;parameters:    a0 - pointer to tiles   
;   copies palette in A0 to cram
;==============================================================
Copy_Palette_to_CRAM:
    SetCRAMWrite    0x0000          ;write to CRAM address 0x0000
    move.w #size_palette_w-1, d0    ;d0 = (size of palette in words)-1
@loop:                      ;loop top
    move.w (a0)+, vdp_data  ;copy palette data to CRAM
    dbf d0, @loop           ;next item
    rts
    
;==============================================================
; Clear VRAM (video memory)
;==============================================================
clear_vram:
	; Setup the VDP to write to VRAM address 0x0000 (start of VRAM)
	SetVRAMWrite 0x0000

	; Write 0's across all of VRAM
	move.w #(0x00010000/size_word)-1, d0	; Loop counter = 64kb, in words (-1 for DBRA loop)
	@ClrVramLp:								; Start of loop
	move.w #0x0, vdp_data					; Write a 0x0000 (word size) to VRAM
	dbra   d0, @ClrVramLp					; Decrement d0 and loop until finished (when d0 reaches -1)
    rts

;==============================================================
;   VDP_WriteTMSS
	; Poke the TMSS to show "LICENSED BY SEGA..." message and allow us to
	; access the VDP (or it will lock up on first access).
;==============================================================
VDP_WriteTMSS:
	move.b hardware_ver_address, d0			; Move Megadrive hardware version to d0
	andi.b #0x0F, d0						; The version is stored in last four bits, so mask it with 0F
	beq    @SkipTMSS						; If version is equal to 0, skip TMSS signature
	move.l #tmss_signature, tmss_address	; Move the string "SEGA" to 0xA14000
@SkipTMSS:
	; Check VDP
	move.w vdp_control, d0					; Read VDP status register (hangs if no access)
	rts

;==============================================================
;   VDP_LoadRegisters
;==============================================================
VDP_LoadRegisters:
	; Set VDP registers
	lea    VDPRegisters, a0		; Load address of register table into a0
	move.w #0x18-1, d0			; 24 registers to write (-1 for loop counter)
	move.w #0x8000, d1			; 'Set register 0' command to d1
@CopyRegLp:
	move.b (a0)+, d1			; Move register value from table to lower byte of d1 (and post-increment the table address for next time)
	move.w d1, vdp_control		; Write command and value to VDP control port
	addi.w #0x0100, d1			; Increment register #
	dbra   d0, @CopyRegLp		; Decrement d0, and jump back to top of loop if d0 is still >= 0
	rts
    
    include 'tile_printing.asm'
    include 'audio_driver.asm'
    
    ;debug menus
    include 'debug_menu.asm'
    include 'controller_driver.asm' ;also controller driver
    include 'sound_test.asm'
    include 'tile_test.asm'
    
;    org 0x08000
test_sample_addr:
    incbin 'samples/testing.wav',0x40 ;start address
    dc.w    0xFFFF
    
; A label defining the end of ROM so we can compute the total size.
ROM_End: