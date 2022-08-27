;==============================================================
; INITIAL VDP REGISTER VALUES
;==============================================================
; 24 register values to be copied to the VDP during initialisation.
; These specify things like initial width/height of the planes,
; addresses within VRAM to find scroll/sprite data, the
; background palette/colour index, whether or not the display
; is on, and clears initial values for things like DMA.
;==============================================================
VDPRegisters:
	dc.b 0x14 ; 0x00:  H interrupt on, palettes on
	dc.b 0x74 ; 0x01:  V interrupt on, display on, DMA on, Genesis mode on
	dc.b 0x30 ; 0x02:  Pattern table for Scroll Plane A at VRAM 0xC000 (bits 3-5 = bits 13-15)
	dc.b 0x00 ; 0x03:  Pattern table for Window Plane at VRAM 0x0000 (disabled) (bits 1-5 = bits 11-15)
	dc.b 0x07 ; 0x04:  Pattern table for Scroll Plane B at VRAM 0xE000 (bits 0-2 = bits 11-15)
	dc.b 0x78 ; 0x05:  Sprite table at VRAM 0xF000 (bits 0-6 = bits 9-15)
	dc.b 0x00 ; 0x06:  Unused
	dc.b 0x00 ; 0x07:  Background colour: bits 0-3 = colour, bits 4-5 = palette
	dc.b 0x00 ; 0x08:  Unused
	dc.b 0x00 ; 0x09:  Unused
	dc.b 0x08 ; 0x0A: Frequency of Horiz. interrupt in Rasters (number of lines travelled by the beam)
	dc.b 0x00 ; 0x0B: External interrupts off, V scroll fullscreen, H scroll fullscreen
	dc.b 0x81 ; 0x0C: Shadows and highlights off, interlace off, H40 mode (320 x 224 screen res)
	dc.b 0x3F ; 0x0D: Horiz. scroll table at VRAM 0xFC00 (bits 0-5)
	dc.b 0x00 ; 0x0E: Unused
	dc.b 0x02 ; 0x0F: Autoincrement 2 bytes
	dc.b 0x01 ; 0x10: Scroll plane size: 64x32 tiles
	dc.b 0x00 ; 0x11: Window Plane X pos 0 left (pos in bits 0-4, left/right in bit 7)
	dc.b 0x00 ; 0x12: Window Plane Y pos 0 up (pos in bits 0-4, up/down in bit 7)
	dc.b 0xFF ; 0x13: DMA length lo byte
	dc.b 0xFF ; 0x14: DMA length hi byte
	dc.b 0x00 ; 0x15: DMA source address lo byte
	dc.b 0x00 ; 0x16: DMA source address mid byte
	dc.b 0x80 ; 0x17: DMA source address hi byte, memory-to-VRAM mode (bits 6-7)
	
	even
	
;==============================================================
; CONSTANTS
;==============================================================
	
; VDP port addresses
vdp_control				equ 0x00C00004
vdp_data				equ 0x00C00000

; VDP commands
vdp_cmd_vram_dma        equ 0x40000080
vdp_cmd_vram_write		equ 0x40000000
vdp_cmd_cram_write		equ 0xC0000000
vdp_cmd_vsram_write		equ 0x40000010

; VDP memory addresses
; according to VDP registers 0x2, 0x4, 0x5, and 0xD (see table above)
vram_addr_tiles			equ 0x0000
vram_addr_plane_a		equ 0xC000
vram_addr_plane_b		equ 0xE000
vram_addr_sprite_table	equ 0xF000
vram_addr_hscroll		equ 0xFC00

; PSG port address (accessible from 68000)
; The PSG can be accessed from both the 68000 and the Z80, although each has its own
; address from which to do so.
; We'll be accessing the PSG from the 68000 only in this demo for simplicity.
psg_control				equ 0x00C00011	; NEW in this demo - address of PSG control port

; Screen width and height (in pixels)
vdp_screen_width		equ 0x0140
vdp_screen_height		equ 0x00F0

; The plane width and height (in tiles)
; according to VDP register 0x10 (see table above)
vdp_plane_width			equ 0x40
vdp_plane_height		equ 0x20

; The size of the sprite plane (512x512 pixels)
vdp_sprite_plane_width	equ 0x0200
vdp_sprite_plane_height	equ 0x0200

; The sprite border (invisible area left + top) size
vdp_sprite_border_x		equ 0x80
vdp_sprite_border_y		equ 0x80

; Hardware version address
hardware_ver_address	equ 0x00A10001

; TMSS
tmss_address			equ 0x00A14000
tmss_signature			equ 'SEGA'

; Gamepad/IO port addresses
pad_ctrl_a				equ 0x00A10009	; IO port A control port
pad_ctrl_b				equ 0x00A1000B	; IO port B control port
pad_data_a				equ 0x00A10003	; IO port A data port
pad_data_b				equ 0x00A10005	; IO port B data port

; Pad read latch, for fetching second byte from data port
pad_byte_latch			equ 0x40

; Gamepad button bits
pad_button_up			equ 0x0
pad_button_down			equ 0x1
pad_button_left			equ 0x2
pad_button_right		equ 0x3
pad_button_a			equ 0x6
pad_button_b			equ 0x4
pad_button_c			equ 0x5
pad_button_start		equ 0x7

; The size of a word and longword
size_word				equ 2
size_long				equ 4

; The size of one palette (in bytes, words, and longwords)
size_palette_b			equ 0x20
size_palette_w			equ size_palette_b/size_word
size_palette_l			equ size_palette_b/size_long

; The size of one graphics tile (in bytes, words, and longwords)
size_tile_b				equ 0x20
size_tile_w				equ size_tile_b/size_word
size_tile_l				equ size_tile_b/size_long

test_palette:
	dc.w 0x0000	; Colour 0 = Transparent
	dc.w 0x0EEE	; Colour 1 = White
	dc.w 0x0EEE	; Colour 2 = White
	dc.w 0x000E	; Colour 3 = Red
	dc.w 0x00E0	; Colour 4 = Blue
	dc.w 0x0E00	; Colour 5 = Green
	dc.w 0x0E0E	; Colour 6 = Pink
	dc.w 0x0000
	dc.w 0x0E00
	dc.w 0x00E0
	dc.w 0x000E
	dc.w 0x0EEE
	dc.w 0x0A0A
	dc.w 0x030A
	dc.w 0x003A
	dc.w 0x0A30

;==============================================================
; TILE IDs
;==============================================================
; The indices of each tile above. Once the tiles have been
; written to VRAM, the VDP refers to each tile by its index.
;==============================================================
;tile_id_blank	equ 0x20

;tile_id_0       equ 0x21
;tile_id_a       equ 0x41
;tile_id_a_lower equ 0x61

tile_count		equ 0x80	; Last entry is just the count