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
;   halts the z80 so we can use the FM chip
;==============================================================
init_z80:
    move.w	#$100,($A11100).l	;Stop the Z80
    move.w	#$100,($A11200).l	;Reset the Z80
@wait_for_z80:
    btst	#0,($A11100).l
    bne	@wait_for_z80           ;Wait for z80 to halt
    rts
  
;==============================================================
;   Demo initialization
;==============================================================
demo_init:
    ;move.w  #offset_demo, d0
    ;jsr load_song_from_parts_table
    ;jsr demo_tiles_init
    rts
    
;==============================================================
;   demo_tiles_init
;   demonstrates basic tile display
;==============================================================
demo_tiles_init:
    lea test_palette, a0        ;
    jsr Copy_Palette_to_CRAM    ;copy test_palette to CRAM
    
	; Write the font glyph tiles to VRAM
	lea     TileBlank, a0    ; Move the address of the first graphics tile into a0
    jsr Copy_Tiles_to_VRAM
    
    ; Write tile positions to plane A VRAM
	SetVRAMWrite vram_addr_plane_a+(((text_pos_y*vdp_plane_width)+text_pos_x)*size_word)
	move.w #tile_id_blank, vdp_data		; 
    ; move.w #tile_id_a, vdp_data		
    ; move.w #tile_id_g, vdp_data		
    ; move.w #tile_id_r, vdp_data		
    ; move.w #tile_id_blank, vdp_data		
    ; move.w #tile_id_1, vdp_data
    ; move.w #tile_id_4, vdp_data
    move.w #tile_id_a, vdp_data		; 
    move.w #tile_id_blank, vdp_data		; 
    move.w #tile_id_m, vdp_data		; 
    move.w #tile_id_y, vdp_data		; 
    move.w #tile_id_s, vdp_data		; 
    move.w #tile_id_t, vdp_data		; 
    move.w #tile_id_e, vdp_data		; 
    move.w #tile_id_r, vdp_data		; 
    move.w #tile_id_y, vdp_data		; 

    rts
    

    
;==============================================================
; INTERRUPT ROUTINES
;==============================================================

; Vertical interrupt - run once per frame (50hz in PAL, 60hz in NTSC)
INT_VInterrupt:
    M_disable_interrupts
    
    addi.l  #1, frame_counter
    jsr get_controller_inputs
    
    if  flag_DEBUG
    jsr DEBUG_controller
    endif
    
    jsr sound_test_menu
    
    jsr audio_driver
    
    
    
    M_enable_interrupts
    rte

; Horizontal interrupt - run once per N scanlines (N = specified in VDP register 0xA)
INT_HInterrupt:
	; Doesn't do anything in this demo
	rte

; Exception interrupt - called if an error has occured
CPU_Exception:
	; Just halt the CPU if an error occurred
	stop   #0x2700
    
; NULL interrupt - for interrupts we don't care about
INT_Null:
	rte
    
    include 'defs.asm'
    include 'tile_test.asm'
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
    
    include 'audio_driver.asm'
    include 'controller_driver.asm'
    include 'sound_test.asm'
; A label defining the end of ROM so we can compute the total size.
ROM_End: