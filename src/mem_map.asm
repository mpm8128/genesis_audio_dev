;memory map

;==============================================================
; MEMORY MAP
;==============================================================
	RSSET 0x00FF2000			; Map from start of RAM
frame_counter       rs.l    1   ;
song_menu_index     rs.b    1   ;0-number of songs


; ram_psg0_frequency		rs.w 1	; Current PSG frequency (2 bytes)
; ram_psg1_frequency		rs.w 1	; Current PSG frequency (2 bytes)
; ram_psg2_frequency		rs.w 1	; Current PSG frequency (2 bytes)
; ram_psg3_frequency		rs.w 1	; Current PSG frequency (2 bytes)

; ram_psg0_volume			rs.b 1	; Current PSG volume (1 byte)
; ram_psg1_volume			rs.b 1	; Current PSG volume (1 byte)
; ram_psg2_volume			rs.b 1	; Current PSG volume (1 byte)
; ram_psg3_volume			rs.b 1	; Current PSG volume (1 byte)