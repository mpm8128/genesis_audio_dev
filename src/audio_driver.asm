;   audio_driver.asm

;============================================================================
;   Definitions and Macros
;============================================================================

opn2_addr_1     equ 0x00A04000
opn2_data_1     equ 0x00A04001
opn2_addr_2     equ 0x00A04002
opn2_data_2     equ 0x00A04003
z80_bus_request_addr    equ 0x00A11100

; PSG port address (accessible from 68000)
; The PSG can be accessed from both the 68000 and the Z80, although each has its own
; address from which to do so.
psg_control				equ 0x00C00011

M_wait_for_busy_clear: macro
@wait_for_busy_clear\@:
    btst  #7, (a0)
    bne.b  @wait_for_busy_clear\@
    endm

M_request_Z80_bus: macro
    move.w  #$0100, z80_bus_request_addr
@wait_for_z80_request\@
    btst    #0, z80_bus_request_addr
    bne     @wait_for_z80_request\@
    endm
    
M_return_Z80_bus: macro
    move.w  #0, z80_bus_request_addr
    endm

    include 'instrument_defs.asm'

;============================================================================
;   Entry point -> audio_driver
;============================================================================

    ;top-level function for the audio driver
    ;this is the entry point for this 'module'
audio_driver:
    rts
    
;==============================================================
;   PSG Channel Structure
;==============================================================
    RSRESET
;PSG channel instrument information
psg_ch_is_enabled       rs.b    1   ;0 (disabled) or !0 (enabled)
psg_ch_channel          rs.b    1   ;channel id (0-3)
psg_ch_note_time        rs.w    1   ;number of frames to hold the note for

psg_ch_stream_ptr       rs.l    1   ;pointer to stream of audio data

psg_ch_base_vol         rs.b    1   ;"base" volume (pre-trem/envelope)
psg_ch_note_name        rs.b    1   ;current note (pre-vibr/envelope)
psg_ch_note_octave      rs.b    1   ;current octave (pre-vibr/envelope)
psg_ch_noise_mode       rs.b    1   ;0-3

;psg_ch_inst_ptr         rs.l    1 ;unused

;PSG channel automation information
psg_ch_freq_auto_idx    rs.b    1   ;index into pitchbend envelope
psg_ch_freq_auto_time   rs.b    1   ;number of frames on each index
psg_ch_freq_auto_ptr    rs.l    1   ;pointer to the envelope

psg_ch_vol_auto_idx     rs.b    1   ;index into volume envelope
psg_ch_vol_auto_time    rs.b    1   ;number of frames on each index
psg_ch_vol_auto_ptr     rs.l    1   ;pointer to the envelope

psg_ch_vibrato_time     rs.b    1   ;number of frames before increment/decrement
psg_ch_vibrato_size     rs.b    1   ;max deviation from base frequency

psg_ch_tremelo_time     rs.b    1   ;number of frames before increment/decrement
psg_ch_tremelo_size     rs.b    1   ;max deviation from base volume

psg_ch_auto_flags       rs.b    1   ;xYZx LPTV
                                    ;bit 0 - "V" - vibrato enable
                                    ;bit 1 - "T" - tremelo enable
                                    ;bit 2 - "P" - pitch envelope enable
                                    ;bit 3 - "L" - volume envelope enable
                                    ;bit 4 - unused
                                    ;bit 5 - "Z" - pitch envelope mode (0 - one-shot, 1 - loop)
                                    ;bit 6 - "Y" - volume envelope mode (0 - one-shot, 1 - loop)
                                    ;bit 7 - unused

psg_ch_size             rs.b    0   ;size of the struct


;==============================================================
;   FM Channel Structure
;==============================================================
    RSRESET
;fm channel instrument information
fm_ch_is_enabled        rs.b    1   ;0 (disabled) or !0 (enabled)
fm_ch_channel           rs.b    1   ;channel id (0-3)
fm_ch_note_time         rs.w    1   ;number of frames to hold the note for

fm_ch_stream_ptr        rs.l    1   ;pointer to stream of audio data

fm_ch_base_vol          rs.b    1   ;"base" volume (pre-trem/envelope)
fm_ch_note_name         rs.b    1   ;current note (pre-vibr/envelope)
fm_ch_note_octave       rs.b    1   ;current octave (pre-vibr/envelope)
fm_ch_algorithm         rs.b    1   ;algorithm (0-8)

fm_ch_inst_ptr          rs.l    1   ;pointer to "base" instrument data

;fm channel automation information
fm_ch_freq_auto_idx     rs.b    1   ;index into pitchbend envelope
fm_ch_freq_auto_time    rs.b    1   ;number of frames on each index
fm_ch_freq_auto_ptr     rs.l    1   ;pointer to the envelope

fm_ch_vol_auto_idx      rs.b    1   ;index into volume envelope
fm_ch_vol_auto_time     rs.b    1   ;number of frames on each index
fm_ch_vol_auto_ptr      rs.l    1   ;pointer to the envelope

fm_ch_st_auto_idx       rs.b    1   ;index into stereo envelope
fm_ch_st_auto_time      rs.b    1   ;number of frames on each index
fm_ch_st_auto_ptr       rs.l    1   ;pointer to the envelope

fm_ch_vibrato_time      rs.b    1   ;number of frames before increment/decrement
fm_ch_vibrato_size      rs.b    1   ;max deviation from base frequency

fm_ch_tremelo_time      rs.b    1   ;number of frames before increment/decrement
fm_ch_tremelo_size      rs.b    1   ;max deviation from base volume

fm_ch_auto_flags        rs.b    1   ;XYZS LPTV
                                    ;bit 0 - "V" - vibrato enable
                                    ;bit 1 - "T" - tremelo enable
                                    ;bit 2 - "P" - pitch envelope enable
                                    ;bit 3 - "L" - volume envelope enable
                                    ;bit 4 - "S" - stereo envelope enable
                                    ;bit 5 - "Z" - pitch envelope mode (0 - one-shot, 1 - loop)
                                    ;bit 6 - "Y" - volume envelope mode (0 - one-shot, 1 - loop)
                                    ;bit 7 - "X" - stereo envelope mode (0 - one-shot, 1 - loop)


fm_ch_size              rs.b    0   ;size of the struct


;==============================================================
; MEMORY MAP
;==============================================================
	RSSET 0x00FF1000    
; PSG Channel Headers:
ch_psg_0                    rs.b    psg_ch_size
ch_psg_1                    rs.b    psg_ch_size
ch_psg_2                    rs.b    psg_ch_size
ch_psg_noise                rs.b    psg_ch_size

;============================================================================
;   PSG Functions
;============================================================================

    include 'psg_helper_functions.asm'

;============================================================================
;   FM Functions
;============================================================================
  
    include 'fm_helper_functions.asm'