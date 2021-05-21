; psg_helper_functions

psg_frequency_table:
;                0    1    2    3    4    5    6    7    8    9    10   11    
;                C    C#   D    D#   E    F    F#   G    G#   A    A#   B    
    dc.w          0,   1,   2,   3,   4,   5,   6,   7,  0, 1017, 960, 906, &   ;A2 -> B2
                855, 807, 762, 719, 679, 641, 605, 571, 539, 508, 480, 453, &   ;C3 -> B3
                428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, &   ;C4 -> B4
                214, 202, 190, 180, 170, 160, 151, 143, 135, 127, 120, 113, &   ;C5 -> B5
                107, 101,  95,  90,  85,  80,  76,  71,  67,  64,  60,  57, &   ;C6 -> B6
                 53,  50,  48,  45,  42,  40,  38,  36,  34,  32,  30,  28, &   ;C7 -> B7
                 27,  25,  24,  22,  21,  20,  19,  18,  17,  16,  15,  14      ;C8 -> B8
      
;============================================================================
;   load_PSG_instrument
;
;   a1 = pointer to instrument data
;   a5 - pointer to channel struct
;   d2 = channel (0-3)
;============================================================================
load_PSG_instrument:
    move.l  a1, psg_ch_inst_ptr(a5)
    move.b  (a1)+, psg_ch_attack_rate(a5)
    move.b  (a1)+, psg_ch_max_level(a5)
    move.b  (a1)+, psg_ch_decay_rate(a5)
    move.b  (a1)+, psg_ch_sus_level(a5)
    move.b  (a1)+, psg_ch_release_rate(a5)
    move.b  (a1)+, psg_ch_noise_mode(a5)
    move.b  (a1)+, psg_ch_attack_scaling(a5)
    move.b  (a1)+, psg_ch_decay_scaling(a5)
    move.b  (a1)+, psg_ch_release_scaling(a5)
    
    move.b  #0, psg_ch_adsr_counter(a5) ;reset this when we reload the instrument
    rts
      
;==============================================================
;   get_psg_freq_from_note_name_and_octave
;parameters:
    ;   d6.w -> note name (0-11)
    ;   d5.w -> octave (2-8)
;returns:
    ;   d1 -> register value
;==============================================================
get_psg_freq_from_note_name_and_octave:
    lea     (psg_frequency_table), a0
    subi.w  #1, d5                          ;octave# -> row offset
    subi.w  #12, d6                         ;
@calc_octave_offset:                        ;
    addi.w  #12, d6                         ;note_offset = note_name + 12(octave - 2)
    dbf     d5, @calc_octave_offset         ;
    asl.w   #1, d6                          ;word-align
    move.w  (a0, d6.w), d1 ;d1 = psg_frequency_table[note_offset]
    rts

;==============================================================
;   get_psg_freq_from_table_offset
;parameters:
    ;   d1.w -> note offset (9-84)
;returns:
    ;   d0 -> register value
;==============================================================
get_psg_freq_from_table_offset:
    lea     (psg_frequency_table), a0
    asl.w   #1, d1                          ;word-align
    move.w  (a0,d1.w), d0  ;d0 = psg_frequency_table[note_offset]
    rts

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
    
    ;"disable" all psg channels
    lea ch_psg_0, a5
    moveq   #3, d7
@loop_disable_psg_ch:
    clr.b   psg_ch_inst_flags(a5)
    bset.b  #2, psg_ch_inst_flags(a5)
    adda.w  #psg_ch_size, a5
    dbf d7, @loop_disable_psg_ch
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
    cmp.b   #3, d0          ;if noise channel
    beq     PSG_set_noise_mode
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
    
;==============================================================
;   PSG_set_noise_mode
	; d0.b - Channel index (3)
	; d1.w - noise mode (0-7)
;==============================================================
PSG_set_noise_mode:
    ori.b   #0xE0, d1
    move.b  d1, psg_control
    rts