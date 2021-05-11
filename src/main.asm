    include 'vector_table.asm'
    include 'header.asm'
    
code_start:                 ;entry point
    jsr VDP_WriteTMSS       ;Write the TMSS signature for rev1+ hardware
    jsr VDP_LoadRegisters   ;Setup initial VDP state
    jsr Clear_VRAM          ;wipe VRAM
    
    ;   "hello world" section
    jsr test_tiles          ;testing tile printing

@loop_forever
    move.w  #0x2300, sr     ;enable interrupts
    jmp @loop_forever       ;loop forever
    
    
    ;
    ;
    ;
INT_Null:                   ;
CPU_Exception:              ;halt for unhandled exceptions
    stop    #0x2700
    
INT_HInterrupt:             ;HBLANK interrupt - just return for now    
    rte
    
INT_VInterrupt:             
    move.w  #2700, sr       ;disable interrupts
    MOVEM.l A6/A5/A4/A3/A2/A1/A0/D7/D6/D5/D4/D3/D2/D1/D0, -(A7) ;push everything to the stack
    
    jsr indirect_audio_driver
    
    MOVEM.l	(A7)+, D0/D1/D2/D3/D4/D5/D6/D7/A0/A1/A2/A3/A4/A5
    move.w  #2300, sr
    rte
    
    include 'defs.asm'
    include 'tile_test.asm'
    
test_tiles:
    lea test_palette, a0        ;
    jsr Copy_Palette_to_CRAM    ;copy test_palette to CRAM

	; Write the font glyph tiles to VRAM
	lea     TileBlank, a0    ; Move the address of the first graphics tile into a0
    jsr Copy_Tiles_to_VRAM

    ; Write tile positions to plane A VRAM
	SetVRAMWrite vram_addr_plane_a+(((text_pos_y*vdp_plane_width)+text_pos_x)*size_word)
	move.w #tile_id_blank, vdp_data		; 
	move.w #tile_id_garb, vdp_data		; 

    rts
    
    ;copies tile in A0 to VRAM
Copy_Tiles_to_VRAM:
    SetVRAMWrite vram_addr_tiles
	move.w #(size_tile_l*tile_count)-1, d0		; Loop counter = 8 longwords per tile * num tiles (-1 for DBRA loop)
@loop:
	move.l (a0)+, vdp_data			; Write tile line (4 bytes per line), and post-increment address
	dbf d0, @loop	                ; Decrement d0 and loop until finished (when d0 reaches -1)
    rts
    
    ;copies palette in A0 to VRAM
Copy_Palette_to_CRAM:
    SetCRAMWrite    0x0000          ;write to CRAM address 0x0000
    move.w #size_palette_w-1, d0    ;d0 = (size of palette in words)-1
@loop:                      ;loop top
    move.w (a0)+, vdp_data  ;copy palette data to CRAM
    dbf d0, @loop           ;next item
    rts
    
    ;wipes all of VRAM
Clear_VRAM:
    SetVRAMWrite    0x0000                  ;write to VRAM address 0x0000
    move.w #(0x00010000/size_word)-1, d0    ;D0 = (size of VRAM in words)-1
@loop:                      ;loop top
    move.w  #0x0, vdp_data  ;zero this word
    dbf d0, @loop           ;next word
    rts                     
    
    ;
VDP_WriteTMSS:

	; The TMSS (Trademark Security System) locks up the VDP if we don't
	; write the string 'SEGA' to a special address. This was to discourage
	; unlicensed developers, since doing this displays the "LICENSED BY SEGA
	; ENTERPRISES LTD" message to screen (on Mega Drive models 1 and higher).
	;
	; First, we need to check if we're running on a model 1+, then write
	; 'SEGA' to hardware address 0xA14000.

	move.b hardware_ver_address, d0			; Move Megadrive hardware version to d0
	andi.b #0x0F, d0						; The version is stored in last four bits, so mask it with 0F
	beq    @SkipTMSS						; If version is equal to 0, skip TMSS signature
	move.l #tmss_signature, tmss_address	; Move the string "SEGA" to 0xA14000
	@SkipTMSS:

	; Check VDP
	move.w vdp_control, d0					; Read VDP status register (hangs if no access)
	
	rts
    
VDP_LoadRegisters:

	; To initialise the VDP, we write all of its initial register values from
	; the table at the top of the file, using a loop.
	;
	; To write a register, we write a word to the control port.
	; The top bit must be set to 1 (so 0x8000), bits 8-12 specify the register
	; number to write to, and the bottom byte is the value to set.
	;
	; In binary:
	;   100X XXXX YYYY YYYY
	;   X = register number
	;   Y = value to write

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
    
indirect_audio_driver:
    jmp audio_driver
    
    include 'audio_driver.asm'

; A label defining the end of ROM so we can compute the total size.
ROM_End: