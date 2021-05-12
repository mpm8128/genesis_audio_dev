; psg_helper_functions

;==============================================================
;   PSG_Init
	; Initialises the PSG - sets volumes of all channels to 0
	; Writing one byte per channel
    
    ; Latch bit = 1 (this is the only byte written)
	; Channel = 0-3
	; Data type = 1 (attenuation)
	; Data = 0xF (fully attenuated)

;==============================================================
PSG_Init:
	move.b #0x9F, psg_control   ;ch0
	move.b #0xBF, psg_control   ;ch1
	move.b #0xDF, psg_control   ;ch2
	move.b #0xFF, psg_control   ;noise
	rts

;==============================================================
;   PSG_SetVolume
	; d0.b - Channel index (0 - 3)
	; d1.b - Volume (0 - 15)

	; This is a slow and naive approach, and would be better wrapped up in
	; a macro, but as a teaching tool it's better to be verbose about
	; what's happening.

	; ABBCDDDD
	; A = Latch (1)
	; B = Channel ID (0-3)
	; C = Data type (1=attenuation)
	; D - Attenuation (1 nybble)
;==============================================================
PSG_SetVolume:
	move.b #0x0F, d2	; Invert the volume to convert it to an attenuation
	sub.b  d1, d2
	lsl.b  #0x5, d0     ; Shift channel index to bits 6-5
	or.b   d2, d0       ; OR in the attenuation
	ori.b  #0x10, d0    ; Set the type bit (1=attenuation)
	ori.b  #0x80, d0    ; Set the latch bit (only writing 1 byte)
	move.b d0, psg_control  ; Write to PSG
	rts

;==============================================================
;   PSG_SetFrequency
	; d0.b - Channel index (0 - 3)
	; d1.w - Frequency (as timer value, 0x1 - 0x3FF)

	; This is a slow and naive approach, and would be better wrapped up in
	; a macro, but as a teaching tool it's better to be verbose about
	; what's happening.

	; First byte (latch bit ON):
	; ABBCDDDD
	; A = Latch (1)
	; B = Channel ID (0-3)
	; C = Data type (0=frequency)
	; D - Frequency bits 0-3
	;
	; Second byte (latch bit OFF):
	; A0BBBBBB
	; A = Latch (0)
	; 0 = Unused
	; B = Frequency bits 4-9
;==============================================================
PSG_SetFrequency:
	move.w d1, d2	        ; Split the frequency into two bytes
	andi.b #0x0F, d1        ; Mask low byte to 4 bits (and sets type bit for 1st byte to 0=frequency)
	lsr.w  #0x4, d2 	    ; Shift upper 6 bits down, mask unused bytes (and sets latch bit for 2nd byte to 0)
	andi.b #0x1F, d2
	lsl.b  #0x5, d0	        ; Shift channel index to bits 6-5
	or.b   d1, d0           ; OR in the low bits
	ori.b  #0x80, d0        ; Set latch bit on 1st byte
	move.b d0, psg_control  ; Write byte 1 to PSG (channel ID and lower 4 bits of frequency)
	move.b d2, psg_control  ; Write byte 2 to PSG (upper 6 bits of frequency)
	rts

    include 'psg_frequency_table.asm'
